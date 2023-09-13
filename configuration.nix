{ config, pkgs, lib, inputs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "gruffLaptop";
  networking.networkmanager.enable = true;
  time.timeZone = "America/Indiana/Knox";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:backspace";
  services.printing.enable = true;
  services.xserver.libinput.enable = true;
  systemd.network.wait-online.enable = false;


  users.users.gruff = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      home-manager
    ];
  };

  
  environment.systemPackages = with pkgs; [
    vim
    wget
    networkmanager
    inputs.nix-software-center.packages.${system}.nix-software-center
  ];

  programs.sway = {
    enable = true;
    package = null;
    extraPackages = with pkgs; [ swayfx swaybg swayidle ];
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd ${pkgs.swayfx}/bin/sway";
        user = "greeter";
      };
    };
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    wireplumber.enable = true;
  };

  services.blueman.enable = true;

  documentation = {
    enable = true;
    info.enable = true;
    man.enable = true;
    nixos.enable = true;
    doc.enable = true;
    dev.enable = true;
  };

  hardware = {
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
    # cpu.amd.updateMicrocode = true;
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes";
  };

  # virtualization.waydroid.enable = true;
  # virtualization.libvirtd.enable = true;
  # virtualization.docker.enable = true;

  # services.openssh.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # networking.firewall.enable = false;

  system.stateVersion = "23.05"; # DO NOT CHANGE THIS!
}