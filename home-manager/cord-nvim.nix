{
  lib,
  fetchFromGitHub,
  rustPlatform,
  vimUtils,
  nix-update-script,
  versionCheckHook,
}: let
  version = "2.3.25";
  src = fetchFromGitHub {
    owner = "vyfor";
    repo = "cord.nvim";
    tag = "v${version}";
    hash = "sha256-XDHvqytIBzgY1EgVrOx39hFgs8s96uaaMbkzEONzrmk=";
  };
  cord-server = rustPlatform.buildRustPackage {
    pname = "cord";
    inherit src version;

    cargoHash = "sha256-L/rhUwRwHuNWxOGt8uHDCYGJG6iTtdgCz1CtrMmnKQ0=";

    # cord depends on nightly features
    RUSTC_BOOTSTRAP = 1;

    nativeInstallCheckInputs = [
      versionCheckHook
    ];
    doInstallCheck = false;

    meta.mainProgram = "cord";
  };
in
  vimUtils.buildVimPlugin {
    pname = "cord.nvim";
    inherit version src;

    # Patch the logic used to find the path to the cord server
    # This still lets the user set config.advanced.server.executable_path
    # https://github.com/vyfor/cord.nvim/blob/v2.3.25/lua/cord/server/fs/init.lua#L10-L15
    postPatch = ''
      substituteInPlace lua/cord/server/fs/init.lua \
        --replace-fail \
          "or M.get_data_path()" \
          "or '${cord-server}'"
    '';

    passthru = {
      updateScript = nix-update-script {
        attrPath = "vimPlugins.cord-nvim.cord-nvim-rust";
      };

      # needed for the update script
      inherit cord-server;
    };

    nvimSkipModules = [
      # requires env variable, fails nix checks
      "cord.api.log.file"
    ];

    meta = {
      homepage = "https://github.com/vyfor/cord.nvim";
      license = lib.licenses.asl20;
      changelog = "https://github.com/vyfor/cord.nvim/releases/tag/v${version}";
      maintainers = with lib.maintainers; [GaetanLepage];
    };
  }
