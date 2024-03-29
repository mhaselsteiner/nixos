# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, options, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./shell.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.supportedFilesystems = [ "ntfs" ];
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.configurationLimit = 5;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "haselbox"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.networkmanager.insertNameservers = [ "8.8.8.8" ]; #dns
  
  powerManagement.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";
 # Manual upgrades
  system.autoUpgrade.enable = false; 

#  nix.nixPath =
#    # Prepend default nixPath values.
#    options.nix.nixPath.default ++ 
#    # Append our nixpkgs-overlays.
#    [ "nixpkgs-overlays=/etc/nixos/overlays-compat/" ]
#  ;



  nixpkgs.config = {
    allowUnfree = true; #allow unfree software like skype
    chromium.enableWideVine = true;

    gnome = {
      gnome-keyring.enable = true;
      at-spi2-core.enable = true;
      gvfs.enable = true;
      };
  };


  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget


  environment.systemPackages = with pkgs; [
#system tools
    bash
    cron
    enchant
    gitAndTools.gitFull
    gparted # does not work always
    htop
    hunspell # Spell checker
    hunspellDicts.de-at # German (Austria)
    hunspellDicts.en-gb-ize # Hunspell dictionary for English (United Kingdom, 'ize' ending) from Wordlist
    intel-gpu-tools # For intel_gpu_top
    ntfs3g # FUSE-based NTFS driver with full write support
    nfs-utils # Linux user-space NFS utilities
    qpdfview # A tabbed document viewer
    touchegg #Macro binding for touch surfaces
    unzip # An extraction utility for archives compressed in .zip format
    vim 
    wget 
    zip

#programs
    arduino # Open-source electronics prototyping platform 
    chromium # An open source web browser from Google
    libreoffice # Comprehensive, professional-quality productivity suite (Still/Stable release)
    inkscape # Vector graphics editor
    evolution #  Personal information management application that provides integrated mail, calendaring and address book functionality
    gnome.adwaita-icon-theme
    gqview # lightweight png viewer
    hue-cli # cli for philipps hue lamp
    krita #  A free and open source painting application (pressure sensitive)
    okular # taking notes on pdf
    mpv # A media player that supports many video formats (MPlayer and mplayer2 fork)
    vlc # Cross-platform media player and streaming server
    ktorrent # KDE integrated BtTorrent client 
    spotify # Play music from the Spotify music service
    jetbrains.pycharm-community # PyCharm Community Edition
    sqlitebrowser # DB Browser for SQLite
    zoom-us #chattool

#programming: compiler, interpreter, IDEs
    #android-studio
    gcc
    netbeans
    (python3.withPackages(ps: with ps; [numpy pytest matplotlib protobuf seaborn pylint jupyter pygame yapf pandas scikitlearn]))
    #adb-sync #to control android devise frome pc via usb (Debuging, Fastboot)
    #adbfs-rootless#	Mount Android phones on Linux with adb, no root required
    #androidsdk should be in adroid studio	
    
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  programs.steam.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ gutenprint gutenprintBin hplipWithPlugin ]; 

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.enableAllFirmware = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i963 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "gb,de";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;
  # Enable the gnome Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xserver.videoDrivers = [ "intel" "modesetting" ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.lena = {
    extraGroups = [ "wheel" "networkmanager"] ;
    isNormalUser = true;
    uid = 1000;
  };
  users.extraUsers.sepp = {
    extraGroups = [ "wheel" "networkmanager"] ;
    isNormalUser = true;
    uid = 1001;
  };
  environment.gnome.excludePackages = with pkgs.gnome; [
    epiphany
    gnome-music
    pkgs.gnome-photos
    totem
    accerciser
  ];

 #boot.extraModulePackages = [ config.boot.kernelPackages.exfat-nofuse ];



  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
