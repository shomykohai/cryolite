{
  description = ''
    What happens when you let someone hyperfixated with autumn and time travel
    make a NixOS config? You'll most likely end up with something overengineered
    like this.
    I mean, look at the name of my devices ;P

    I ditched home manager btw
  '';

  outputs = {
    self,
    nixpkgs,
    nixpkgsUnstable,
    ...
  } @ inputs: let
    mkSystem = hostName: arch: let
      frostix = inputs.frostix.packages.${arch};
      # Shalt thee suffer the wrath of importing nixpkgs,
      # slower evaluations times awaits thee.
      pkgsUnstable = import nixpkgsUnstable {
        system = arch;
        config = {
          allowUnfree = true;
        };
      };
    in
      nixpkgs.lib.nixosSystem {
        system = arch;
        specialArgs = {inherit inputs frostix pkgsUnstable;};
        modules = [
          ./hosts/${hostName}/configuration.nix
          inputs.reflake.nixosModules.default
          inputs.nix-index-database.nixosModules.nix-index
          inputs.sops-nix.nixosModules.sops
        ];
      };
  in {
    nixosConfigurations = {
      temporalcatalyst = mkSystem "temporalcatalyst" "x86_64-linux";
      chronoshaven = mkSystem "chronoshaven" "x86_64-linux";
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgsUnstable.url = "github:nixos/nixpkgs/nixos-unstable";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    secrets-flake.url = "git+ssh://git@gitlab.com/shomy/secrets-flake.git";

    # home-manager = {
    #   url = "github:nix-community/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgsUnstable";
    # };

    # plasma-manager = {
    #   url = "github:nix-community/plasma-manager";
    #   inputs.nixpkgs.follows = "nixpkgsUnstable";
    #   inputs.home-manager.follows = "home-manager";
    # };

    # Third party repos
    frostix = {
      url = "github:shomykohai/frostix";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };

    # chaotic = {
    #   url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    #   inputs.nixpkgs.follows = "nixpkgsUnstable";
    #   # inputs.home-manager.follows = "home-manager";
    # };

    # Stuff
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    reflake = {
      url = "github:shomykohai/reflake";
      inputs.nixpkgs.follows = "nixpkgsUnstable";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.home-manager.follows = "home-manager";
    };
  };
}
