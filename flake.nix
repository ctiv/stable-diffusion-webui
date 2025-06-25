{
  description = "A development environment for the Stable Diffusion Web UI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        python = pkgs.python310;

      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            git
            wget

            python
            python.pkgs.pip
            python.pkgs.venvShellHook

            cmake
            protobuf
            rustc
            cargo
          ];

          shellHook = ''
            GREEN='\033[0;32m'
            NC='\033[0m'

            echo -e "$GREEN--- Entering Stable Diffusion Web UI Environment ---$NC"

            export PYTHONPATH=$PWD/.venv/${python.sitePackages}/:$PYTHONPATH
            export SOURCE_DATE_EPOCH=$(date +%s)
            export PYTORCH_ENABLE_MPS_FALLBACK=1

            echo ""
            echo "Environment is ready."
            echo "To start the application, run the project's setup script:"
            echo -e "$GREEN./webui.sh$NC"
            echo ""
          '';
        };
      }
    );
}
