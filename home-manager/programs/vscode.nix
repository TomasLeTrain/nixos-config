{
  config,
  pkgs,
  ...
}: {
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        asvetliakov.vscode-neovim
        llvm-vs-code-extensions.vscode-clangd

        (pkgs.vscode-utils.extensionFromVscodeMarketplace {
          name = "pros";
          publisher = "sigbots";
          version = "0.8.3";
          sha256 = "sha256-62yX92LfqKMrtidO7UkBz3awDpIArnDP2YUGKGt4oMY=";
        })

        (pkgs.vscode-utils.extensionFromVscodeMarketplace {
          name = "symbolizer-for-vex-v5";
          publisher = "vexide";
          version = "0.1.4";
          sha256 = "sha256-6i61nbcV4/uHdAtqlQSGHajgaJMQxqUKAn6j6BSP8y0=";
        })
      ];
    };
  };
}
