#!/run/current-system/sw/bin/bash

set -e

export PATH=@path@:$PATH

umask 0022

MOUNT_POINT=/mnt/root

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <host-name>"
    exit 1
fi

HOST_NAME="$1"
HOST_DIR="./hosts/$HOST_NAME"

if [[ ! -d "$HOST_DIR" ]]; then
    echo "Host '$HOST_NAME' not found under ./hosts/"
    echo "Make sure ./hosts/$HOST_NAME exists."
    exit 1
fi


# The final path to the nix system will need to be
# mounted here, then it is up to whoever uses this flake
# (mainly me) to figure out the setup
# For example, on CH, I mount persist and nix subvol from
# a partition to /mnt/persist and /mnt/nix, then use
# `mount --bind /mnt/persist /mnt/root/persist` to make
# it so the installer treats it correctly.
if [[ ! -d "$MOUNT_POINT" ]]; then
    echo "Mount point $MOUNT_POINT does not exist"
    echo "Please, mount your destination disk to $MOUNT_POINT"
    exit 1
fi

BOOT_DIR="$MOUNT_POINT/boot"

if [[ ! -d "$BOOT_DIR" ]]; then
    echo "$BOOT_DIR does not exist or is not a directory."
    echo "Please ensure /boot is properly mounted at $BOOT_DIR"
    exit 1
fi

if ! mountpoint -q "$BOOT_DIR"; then
    echo "$BOOT_DIR is not a mount point."
    echo "You need to mount your boot partition there before proceeding."
    exit 1
fi

echo "Building system configuration for host '$HOST_NAME'..."

tmpdir=$(mktemp -d)
OUT_LINK="$tmpdir/system"

# Yes, I use the pipe operator
nix --extra-experimental-features 'nix-command flakes pipe-operators' \
    build ".#nixosConfigurations.${HOST_NAME}.config.system.build.toplevel" \
    --store "$MOUNT_POINT" --out-link "$OUT_LINK" --no-update-lock-file \
    --override-input secrets-flake ./secrets

SYSTEM_PATH=$(readlink -f "$OUT_LINK")

mkdir -m 0755 -p "$MOUNT_POINT/etc"
touch "$MOUNT_POINT/etc/NIXOS"

nix-env --store "$MOUNT_POINT" \
        -p "$MOUNT_POINT/nix/var/nix/profiles/system" \
        --set "$SYSTEM_PATH"


echo "Installing the boot loader..."

# Taken from NixOS nixos-install script
ln -sfn /proc/mounts "$MOUNT_POINT/etc/mtab"
export MOUNT_POINT

NIXOS_INSTALL_BOOTLOADER=1 nixos-enter --root "$MOUNT_POINT" -c "$(cat <<'EOF'
  set -e
  # Clear the shell command cache, since chroot changes path
  hash -r
  # Bind mount the entire root so all mounts inside target are visible
  mount --rbind --mkdir / "$MOUNT_POINT"
  mount --make-rslave "$MOUNT_POINT"
  # Run nixos switch-to-configuration boot to install bootloader
  /run/current-system/bin/switch-to-configuration boot
  # Clean up by unmounting the bind mounts
  umount -R "$MOUNT_POINT" && (rmdir "$MOUNT_POINT" 2>/dev/null || true)
EOF
)"


# Password handling because I forgot too many times
PERSIST_DIR="$MOUNT_POINT/persist"

users_json=$(nix --extra-experimental-features 'nix-command flakes pipe-operators' eval --json ".#nixosConfigurations.${HOST_NAME}.config.users.users")

for user_path in ./users/*; do
    user_name=$(basename "$user_path")

    user_info=$(echo "$users_json" | jq -r --arg user "$user_name" '.[$user]?')
    if [[ "$user_info" == "null" || -z "$user_info" ]]; then
        continue
    fi

    hashed_password_file=$(echo "$user_info" | jq -r '.hashedPasswordFile // empty')

    if [[ -z "$hashed_password_file" || "$hashed_password_file" != /persist/* ]]; then
        continue
    fi

    target_file="${hashed_password_file/#\/persist/$PERSIST_DIR}"


    if [[ ! -f "$target_file" ]]; then
        echo "Hashed password file for user '$user_name' missing at $target_file"
        read -rp "Create hashed password file for $user_name now? (y/N) " create_pw
        if [[ "$create_pw" =~ ^[Yy]$ ]]; then
            read -rs -p "Enter password for $user_name: " password
            echo

            if command -v mkpasswd &>/dev/null; then
                hashed=$(mkpasswd -m sha-512 <<< "$password")
            else
                # How did we even end up here? ._.
                echo "Error: mkpasswd command not found. Please install it or create the password file manually."
                exit 1
            fi

            mkdir -p "$(dirname "$target_file")"
            echo "$hashed" > "$target_file"
            chmod 600 "$target_file"
            echo "Created hashed password file at $target_file"
        else
            echo "Skipping hashed password file creation for $user_name."
        fi
    else
        echo "Hashed password file for user '$user_name' already exists at $target_file"
    fi
done

echo "Installation finished!"
