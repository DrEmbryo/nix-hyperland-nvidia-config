{ config, pkgs, ... }:

{
  imports =
    [ 
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_6_5;
  boot.kernelParams = [ "intel_pstate=active" ];
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
    };
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
  };

  # network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pl_PL.UTF-8";
    LC_IDENTIFICATION = "pl_PL.UTF-8";
    LC_MEASUREMENT = "pl_PL.UTF-8";
    LC_MONETARY = "pl_PL.UTF-8";
    LC_NAME = "pl_PL.UTF-8";
    LC_NUMERIC = "pl_PL.UTF-8";
    LC_PAPER = "pl_PL.UTF-8";
    LC_TELEPHONE = "pl_PL.UTF-8";
    LC_TIME = "pl_PL.UTF-8";
  };

  # Configure keymap in X11
    services.xserver = {
        exportConfiguration = true;
        layout = "us,ru";
        xkbOptions = "grp:alt_shift_toggle";
        xkbVariant = "qwerty_digits";
    };
  
  # printers
  services.printing.enable = true;
  
  # sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver = {
    videoDrivers = ["nvidia"];
    enable = true;
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };

  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };

  # Enabling hyprlnd on NixOS
  programs.hyprland = {
    enable = true;
    nvidiaPatches = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };


  # user
  users.users.drembryo = {
    isNormalUser = true;
    description = "DrEmbryo";
    extraGroups = [ "networkmanager" "wheel" "kvm" "video"];
    packages = with pkgs; [
      firefox
      kate
    ];
  };

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "drembryo";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # packages
  environment.systemPackages = with pkgs; [
    kitty
    wget
    neofetch
    git
    hyprland
    hyprpaper
    waybar
    dunst
    libnotify
    wofi
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    xdg-utils
    xwayland
  ];

 
  # fonts
  fonts.fontDir.enable = true;
  fonts.fonts = with pkgs; [  
    nerdfonts
    font-awesome
    google-fonts
    font-awesome
    noto-fonts-emoji
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Iosevka"  ]; })
  ];
  services.gollum.emoji = true;


  services.dbus.enable = true;

  # window portals
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # overlays
  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
   ];

  # system
  system.stateVersion = "23.05";
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
