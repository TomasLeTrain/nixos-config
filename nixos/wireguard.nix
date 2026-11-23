{
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.wireguard-tools];

  # wireguard config
  networking.wg-quick.interfaces = {
    # lxc in server
    wg0 = {
      autostart = false;

      # Determines the IP address and subnet of the client's end of the tunnel interface.
      address = ["192.168.69.2/32"];
      dns = ["192.168.69.1"];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      # privateKeyFile = "../secrets/lxc_private_key";
      privateKeyFile = config.security.nix-secrets.secrets."wg/lxc_private_key".path;

      peers = [
        # For a client configuration, one peer entry for the server will suffice.

        {
          # Public key of the server (not a file path).
          publicKey = "5G0oRIdxUX8/wUy+vAkMyCOn3Ak4RpXfa9KwBPXj3GY=";
          # presharedKeyFile = "../secrets/lxc_preshared_key";
          presharedKeyFile = config.security.nix-secrets.secrets."wg/lxc_preshared_key".path;

          # Forward all the traffic via VPN.
          allowedIPs = ["0.0.0.0/0" "::/0"];

          # Set this to the server IP and port.
          endpoint = builtins.readFile (config.security.nix-secrets.secrets."wg/home_ip".path) + ":51820";

          # ToDo: route to endpoint not automatically configured
          # https://wiki.archlinux.org/index.php/WireGuard#Loop_routing
          #  https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

          # Send keepalives every 25 seconds. Important to keep NAT tables alive.
          persistentKeepalive = 25;
        }
      ];
    };
  };

  networking.firewall = {
    allowedUDPPorts = [config.networking.wg-quick.interfaces.wg0.listenPort];
  };
}
