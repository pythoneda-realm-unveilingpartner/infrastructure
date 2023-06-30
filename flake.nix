{
  description = "Infrastructure layer for UnveilingPartner's PythonEDA realm";

  inputs = rec {
    nixos.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils.url = "github:numtide/flake-utils/v1.0.0";
    pythoneda-base = {
      url = "github:pythoneda/base/0.0.1a15";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
    };
    pythoneda-artifact-event-git-tagging = {
      url = "github:pythoneda-artifact-event/git-tagging/0.0.1a1";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
    pythoneda-realm-unveilingpartner = {
      url = "github:pythoneda-realm/unveilingpartner/0.0.1a2";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
    pythoneda-infrastructure-base = {
      url = "github:pythoneda-infrastructure/base/0.0.1a11";
      inputs.nixos.follows = "nixos";
      inputs.flake-utils.follows = "flake-utils";
      inputs.pythoneda-base.follows = "pythoneda-base";
    };
  };
  outputs = inputs:
    with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixos { inherit system; };
        description =
          "Infrastructure layer for UnveilingPartner's PythonEDA realm";
        license = pkgs.lib.licenses.gpl3;
        homepage =
          "https://github.com/pythoneda-realm-infrastructure/unveilingpartner";
        maintainers = with pkgs.lib.maintainers; [ ];
        nixpkgsRelease = "nixos-23.05";
        shared = import ./nix/devShells.nix;
        pythoneda-realm-infrastructure-unveilingpartner-for = { version
          , pythoneda-base, pythoneda-artifact-event-git-tagging
          , pythoneda-realm-unveilingpartner, pythoneda-infrastructure-base
          , python }:
          let
            pname = "pythoneda-realm-infrastructure-unveilingpartner";
            pythonVersionParts = builtins.splitVersion python.version;
            pythonMajorVersion = builtins.head pythonVersionParts;
            pythonMajorMinorVersion =
              "${pythonMajorVersion}.${builtins.elemAt pythonVersionParts 1}";
            pnameWithUnderscores =
              builtins.replaceStrings [ "-" ] [ "_" ] pname;
            wheelName =
              "${pnameWithUnderscores}-${version}-py${pythonMajorVersion}-none-any.whl";
          in python.pkgs.buildPythonPackage rec {
            inherit pname version;
            projectDir = ./.;
            src = ./.;
            format = "pyproject";

            nativeBuildInputs = with python.pkgs; [ pip pkgs.jq poetry-core ];
            propagatedBuildInputs = with python.pkgs; [
              dbus-next
              grpcio
              oauth2
              pythoneda-artifact-event-git-tagging
              pythoneda-base
              pythoneda-infrastructure-base
              pythoneda-realm-unveilingpartner
              requests
              requests-oauthlib
            ];

            checkInputs = with python.pkgs; [ pytest ];

            pythonImportsCheck =
              [ "pythonedarealminfrastructureunveilingpartner" ];

            preBuild = ''
              python -m venv .env
              source .env/bin/activate
              pip install ${pythoneda-base}/dist/pythoneda_base-${pythoneda-base.version}-py3-none-any.whl
              pip install ${pythoneda-artifact-event-git-tagging}/dist/pythoneda_artifact_event_git_tagging-${pythoneda-artifact-event-git-tagging.version}-py3-none-any.whl
              pip install ${pythoneda-infrastructure-base}/dist/pythoneda_infrastructure_base-${pythoneda-infrastructure-base.version}-py3-none-any.whl
              pip install ${pythoneda-realm-unveilingpartner}/dist/pythoneda_realm_unveilingpartner-${pythoneda-realm-unveilingpartner.version}-py3-none-any.whl
              rm -rf .env
            '';

            postInstall = ''
              mkdir $out/dist
              cp dist/${wheelName} $out/dist
              jq ".url = \"$out/dist/${wheelName}\"" $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json > temp.json && mv temp.json $out/lib/python${pythonMajorMinorVersion}/site-packages/${pnameWithUnderscores}-${version}.dist-info/direct_url.json
            '';

            meta = with pkgs.lib; {
              inherit description license homepage maintainers;
            };
          };
        pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-for =
          { pythoneda-base, pythoneda-artifact-event-git-tagging
          , pythoneda-infrastructure-base, pythoneda-realm-unveilingpartner
          , python }:
          pythoneda-realm-infrastructure-unveilingpartner-for {
            version = "0.0.1a3";
            inherit pythoneda-base pythoneda-artifact-event-git-tagging
              pythoneda-infrastructure-base pythoneda-realm-unveilingpartner
              python;
          };
      in rec {
        packages = rec {
          pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-python39 =
            pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-for {
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python39;
              pythoneda-artifact-event-git-tagging =
                pythoneda-artifact-event-git-tagging.packages.${system}.pythoneda-artifact-event-git-tagging-latest-python39;
              pythoneda-infrastructure-base =
                pythoneda-infrastructure-base.packages.${system}.pythoneda-infrastructure-base-latest-python39;
              pythoneda-realm-unveilingpartner =
                pythoneda-realm-unveilingpartner.packages.${system}.pythoneda-realm-unveilingpartner-latest-python39;
              python = pkgs.python39;
            };
          pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-python310 =
            pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-for {
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python310;
              pythoneda-artifact-event-git-tagging =
                pythoneda-artifact-event-git-tagging.packages.${system}.pythoneda-artifact-event-git-tagging-latest-python310;
              pythoneda-infrastructure-base =
                pythoneda-infrastructure-base.packages.${system}.pythoneda-infrastructure-base-latest-python310;
              pythoneda-realm-unveilingpartner =
                pythoneda-realm-unveilingpartner.packages.${system}.pythoneda-realm-unveilingpartner-latest-python310;
              python = pkgs.python310;
            };
          pythoneda-realm-infrastructure-unveilingpartner-latest-python39 =
            pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-python39;
          pythoneda-realm-infrastructure-unveilingpartner-latest-python310 =
            pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-python310;
          pythoneda-realm-infrastructure-unveilingpartner-latest =
            pythoneda-realm-infrastructure-unveilingpartner-latest-python310;
          default = pythoneda-realm-infrastructure-unveilingpartner-latest;
        };
        defaultPackage = packages.default;
        devShells = rec {
          pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-python39 =
            shared.devShell-for {
              package =
                packages.pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-python39;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python39;
              python = pkgs.python39;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-python310 =
            shared.devShell-for {
              package =
                packages.pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-python310;
              pythoneda-base =
                pythoneda-base.packages.${system}.pythoneda-base-latest-python310;
              python = pkgs.python310;
              inherit pkgs nixpkgsRelease;
            };
          pythoneda-realm-infrastructure-unveilingpartner-latest-python39 =
            pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-python39;
          pythoneda-realm-infrastructure-unveilingpartner-latest-python310 =
            pythoneda-realm-infrastructure-unveilingpartner-0_0_1a3-python310;
          pythoneda-realm-infrastructure-unveilingpartner-latest =
            pythoneda-realm-infrastructure-unveilingpartner-latest-python310;
          default = pythoneda-realm-infrastructure-unveilingpartner-latest;

        };
      });
}
