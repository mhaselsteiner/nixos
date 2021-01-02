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

  nixpkgs.overlays = [
    (self: super: with self; {
    python27 = super.python27.override pythonOverrides;
    python27Packages = super.recurseIntoAttrs (python27.pkgs);
    python3Packages = super.recurseIntoAttrs (python3.pkgs);
    python = python27;
    pythonPackages = python27Packages;

    python3 = super.python3.override pythonOverrides;
    pythonOverrides = {
      packageOverrides = python-self: python-super: {
          windlamp = python-super.buildPythonPackage rec {
            name = "windlamp-${version}";
            version = "0.1";
            src = fetchGit {
              url = "git@github.com:mhaselsteiner/windlamp.git";
              rev = "7d105e1e9ddcd8f249a8251c7d77726de794bde5";
            };
            propagatedBuildInputs = with python-self; [
	      requests
              pandas
            ];
            prePatch = with python-self; ''
            '';
            doCheck = false;
          };
          };
          };
		
          })
	];


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
    gnome3.evolution #  Personal information management application that provides integrated mail, calendaring and address book functionality
    gnome3.adwaita-icon-theme
    gqview # lightweight png viewer
    krita #  A free and open source painting application (pressure sensitive)
    skype
    spotify
    jetbrains.pycharm-community
    sublime3
    torbrowser
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
    # Enable cron service
  services.cron = {
    enable = true;
    systemCronJobs = [
      "* * * * *      root    ${pkgs.python3Packages.windlamp}/bin/get_bremen_data >> /home/lena/Programming/PycharmProjects/windlamp/get_data.log 2>&1"
    ];
  };

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
