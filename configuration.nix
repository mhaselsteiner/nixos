# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./shell.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.grub.device = "/dev/nvme0n1";
  boot.loader.grub.configurationLimit = 5;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "haselbox"; # Define your hostname.
  networking.networkmanager.enable = true;
  
  powerManagement.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";
 # Manual upgrades
  system.autoUpgrade.enable = false; 


  nixpkgs.config = {
    allowUnfree = true; #allow unfree software like skype
#    allowBroken = true; 
    chromium.enableWideVine = true;

    gnome3 = {
      gnome-keyring.enable = true;
      at-spi2-core.enable = true;
      #gnome-user-share.enable = true;
      gvfs.enable = true;
      };

    #packageOverrides = super: let self = super.pkgs; in {
    #  spotify = super.spotify.overrideAttrs (o: rec {
    #    name = "spotify-${version}";
    #    version = "1.0.80.480.g51b03ac3-13";
    #    src = self.fetchurl {
    #      url = "https://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_${version}_amd64.deb";
    #      sha256 = "e32f4816ae79dbfa0c14086e76df3bc83d526402aac1dbba534127fc00fe50ea";
    #   };
    #  });
    #};
  };



  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget


  environment.systemPackages = with pkgs; [
#system tools
    bash
    enchant
    gitAndTools.gitFull
    gparted # does not work always
    hunspell
    hunspellDicts.de-at
    hunspellDicts.en-gb-ize
    qpdfview
    touchegg #Macro binding for touch surfaces
    unzip
    vim 
    wget 
    zip


#programs
    arduino 
    chromium
    libreoffice
    inkscape
    gqview # lightweight png viewer
    krita #  A free and open source painting application (pressure sensitive)
    python3Packages.mps-youtube #Terminal based YouTube player and downloader
    skype
    spotify
    jetbrains.pycharm-community
    sublime3
    torbrowser

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
  # getting 32bit programs run like 64bit
  hardware.opengl.driSupport32Bit = true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "gb,de";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the gnome Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.lena = {
    extraGroups = [ "wheel" "networkmanager"] ;
    isNormalUser = true;
    uid = 1000;
  };
  users.extraUsers.sepp = {
    extraGroups = [ "networkmanager"] ;
    isNormalUser = true;
    uid = 1001;
  };
  environment.gnome3.excludePackages = with pkgs.gnome3; [
    epiphany
    gnome-music
    gnome-photos
    totem
    accerciser
  ];

 



  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.09"; # Did you read the comment?

}
