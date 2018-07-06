# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "haselbox"; # Define your hostname.
  networking.networkmanager.enable = true;
  
  powerManagement.enable = true;




  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Vienna";
 # Manual upgrades
  system.autoUpgrade.enable = false; 


  nixpkgs.config = {
    allowUnfree = true; #allow unfree software like skype
    firefox = {
      enableAdobeFlash = true;
      enableGnomeExtensions = true;
      enableAdobeReader  = true;
      enableVLC = true;};
#    allowBroken = true; 

    gnome3 = {
      gnome-keyring.enable = true;
      at-spi2-core.enable = true;
      #gnome-user-share.enable = true;
      gvfs.enable = true;
      };

    packageOverrides = super: let self = super.pkgs; in {
      spotify = super.spotify.overrideAttrs (o: rec {
        name = "spotify-${version}";
        version = "1.0.80.480.g51b03ac3-13";
        src = self.fetchurl {
          url = "https://repository-origin.spotify.com/pool/non-free/s/spotify-client/spotify-client_${version}_amd64.deb";
          sha256 = "e32f4816ae79dbfa0c14086e76df3bc83d526402aac1dbba534127fc00fe50ea";
        };
      });
    };
  };



  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget


  environment.systemPackages = with pkgs; [
#system tools
    bash
    zip
    unzip
    gitAndTools.gitFull
    wget 
    vim 
    gparted
    qpdfview
    aspellDicts.de # dictionary
    aspellDicts.en

#programs
    firefox
    libreoffice
    inkscape
    skype
    spotify
    jetbrains.pycharm-community
    sublime3
    tor

#programming: compiler, interpreter, IDEs
    android-studio
    gcc
    netbeans
    (python35.withPackages(ps: with ps; [numpy toolz jupyter pygame yapf pandas]))
    adb-sync #to control android devise frome pc via usb (Debuging, Fastboot)
    adbfs-rootless#	Mount Android phones on Linux with adb, no root required
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
  services.xserver.layout = "us,de";
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
  system.stateVersion = "17.09"; # Did you read the comment?

}
