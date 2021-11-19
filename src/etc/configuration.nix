# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan
      ./hardware-configuration.nix
    ];

  # Nix Packages Manager Config
  nixpkgs.config = {
    allowUnfree = true;
  };

  # Use GRUB as boot loader
  boot = {
    loader = {
      grub = {
        enable = true;
        devices = [ "nodev" ];
        efiSupport = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
      timeout = 3;
    };
    kernelParams = [
      "rw"
      "systemd.show_status=error"
    ];
    blacklistedKernelModules = [
      "nouveau"
      "i2c_nvidia_gpu"
    ];
    initrd = {
      compressor = "xz";
      verbose = false;
      kernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
    };
    runSize = "10%";
    tmpOnTmpfs = true;
    devShmSize = "0%";
    cleanTmpDir = true;
  };

  # Microcode Manager
  hardware.cpu.amd.updateMicrocode = true;

  # Set your time zone
  time.timeZone = "Asia/Bangkok";

  # Network/Hostname
  networking = {
    hostName = "computer";
    useDHCP = false;
    interfaces.enp5s0.useDHCP = true;
    # wireless.enable = true;
    # firewall = {
    #     enable = false;
    #     allowedTCPPorts = [ ... ];
    #     allowedUDPPorts = [ ... ];
    # };
    # proxy = { 
    #     default = "http://user:password@proxy:port/";
    #     noProxy = "127.0.0.1,localhost,internal.domain";
    # };
  };

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";
  # Console Settings
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # X11 Settings
  services = {
    xserver = {
      enable = true;
      displayManager = {
        startx.enable = true;
      };
      windowManager = {
        bspwm.enable = true;
      };
      layout = "us";
      videoDrivers = [
        "nvidia"
      ];
      # xkbOptions = "eurosign:e";
      # libinput.enable = true;
    };
    # printing = {
    #   enable = true;
    # };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ides3rt = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "video" ];
  };

  # Mount Options
  fileSystems = {
    "/var" = {
      options = [
        "defaults"
        "nodev"
      ];
    };
    "/home" = {
      options = [
        "defaults"
        "nodev"
      ];
    };
    "/media/sda1" = {
      device = "/dev/disk/by-label/etc0";
      fsType = "exfat";
      options = [
          "defaults"
          "uid=ides3rt"
          "gid=users"
          "nodev"
          "nofail"
      ];
    };
    "/media/sda2" = {
    #   device = "/dev/disk/by-label/extra0";
    #   fsType = "xfs";
      options = [
        "defaults"
        "nofail"
      ];
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Terminal Base System Tools
    man
    htop
    pfetch
    git
    wget
    # Gui Base System Tools
    galculator
    lxappearance
    rofi
    # Text Editor
    vim
    notepadqq
    # Terminal
    alacritty
    # Web Browser
    brave
    # Files Manager
    pcmanfm
    # Xorg and Graphics Driver
    linuxPackages_5_4.nvidia_x11
    xorg.xsetroot
    # GTK
      # Theme
      arc-theme
      gtk-engine-murrine
      gnome.gnome-themes-extra
      # Icons
      tela-icon-theme
    # DE/WM
      # Common Tools
      picom
      feh
      polybar
      sxhkd
      # Bspwm
      bspwm
    # Video/Audio
    mpv
    pulseaudio
    ffmpeg
    # Kernel Relate
    linuxHeaders
    # Files Format Tools
    xfsprogs
    dosfstools
    exfatprogs
  ];

  # Fonts
  fonts.fonts = with pkgs; [
    font-awesome
    siji
    unifont
    terminus_font
    terminus_font_ttf
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
