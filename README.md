These are my nixos dotfiles.

They're a bit messy for now, but improvements are to come

## Some style guides

Avoid with!!
https://nix.dev/guides/best-practices#with-scopes

Avoid (at all costs) home manager for speed points

When possible, avoid adding more inputs

Better setup symlinks for my dotfiles instead of configuring them with nix,
so no need to worry about rebuilding the OS every time (I don't need a 100% reproducible setup when
dotfiles are stored in git anyway)

# License

Licensed under the GPLv3-or-later license, see [LICENSE](LICENSE) for more details.
