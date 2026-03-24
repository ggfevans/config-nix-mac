{ config, pkgs, ... }:

{
  # --- Nix Settings ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "broadcom-sta-6.30.223.271-59-6.12.77"
  ];

  # --- Bootloader ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;

  # --- Networking ---
  networking.hostName = "nix-mac";
  networking.networkmanager.enable = true;

  # --- Firewall ---
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 42042 ];
    trustedInterfaces = [ "tailscale0" ];
  };

  # --- Tailscale ---
  services.tailscale.enable = true;

  # --- Timezone & Locale ---
  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- SSH ---
  services.openssh = {
    enable = true;
    ports = [ 42042 ];
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
    };
  };

  # --- Users ---
  users.users.gvns = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBWeFss2mjIFdz+dRfUYardiiWiza0IqxWmBAy9DQdiy"
    ];
  };

  security.sudo.extraRules = [
    {
      users = [ "gvns" ];
      commands = [
        { command = "/run/current-system/sw/bin/nixos-rebuild"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/nix-collect-garbage"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  # --- Git ---
  programs.git = {
    enable = true;
    config = {
      user.name = "ggfevans";
      user.email = "hi@gvns.ca";
      init.defaultBranch = "main";
    };
  };

  # --- Tmux ---
  programs.tmux.enable = true;

  # --- nix-ld (Zed remote server support) ---
  programs.nix-ld.enable = true;

  # --- Power Management ---
  powerManagement.powertop.enable = true;

  # --- Btrfs maintenance ---
  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    fileSystems = [ "/" "/data" ];
  };

  # --- System Packages ---
  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    git
    gh
    htop
    fastfetch
    efibootmgr
    btrfs-progs
    compsize
    smartmontools
    powertop
  ];

  # --- Auto-upgrade ---
  system.autoUpgrade = {
    enable = true;
    flake = "github:ggfevans/config-nix-sunny#nix-mac";
    dates = "04:00";
    allowReboot = false;
  };

  # --- Firmware ---
  hardware.enableRedistributableFirmware = true;

  system.stateVersion = "25.11";
}
