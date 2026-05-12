complete -c wsg -e
complete -c wsg -x -a "(command ls -F /mnt/workspace/GitHub/ 2>/dev/null | string match '*/*' | string trim -r -c '/')"
