{flake-secrets, ...}: {
  security.nix-secrets = {
    enable = true;

    storage = "${flake-secrets}";

    identityPaths = [
      "/home/tomas/.config/nix-secrets/keys.txt"
    ];
    recipientAliases = {
      laptop = "age1tzz8w7hmtastaah2fe9932qlq03wnlvxuptyj4dcgm8rnf84mu3s4waehu";
      all = ["laptop"];
    };
    defaultRecipients = ["all"];

    secrets = {
      "wg/lxc_preshared_key" = {enable = true;};
      "wg/lxc_private_key" = {enable = true;};
      "wg/home_ip" = {enable = true;};
    };
  };
}
