{ pkgs, ... }: {
  imports = [
    ../../features/qtile.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  wsl = {
    enable = true;
    defaultUser = "rade";
    startMenuLaunchers = true;
  };

  programs.fish.enable = true;

  environment.systemPackages = with pkgs; [
    # Core
    fish git curl wget htop
    nodejs_22 wireguard-tools
    openssh tmux neovim
    bitwarden-cli brave

    # Desktop
    alacritty picom dunst
    rofi polybar feh
    xdg-utils xterm
    turbovnc
    nerd-fonts.jetbrains-mono
  ];

  services.xserver = {
    enable = true;
    windowManager.qtile.enable = true;
    displayManager.lightdm.enable = false;
    autorun = false;
  };

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  users.users.rade = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "docker" "wheel" ];
    initialPassword = "changeme";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.rade = { config, pkgs, ... }: {
      home.stateVersion = "24.11";

      programs.fish = {
        enable = true;
        interactiveShellInit = ''set fish_greeting ""'';
        shellAliases = {
          ll   = "ls -la";
          gs   = "git status";
          nrs  = "sudo nixos-rebuild switch --flake .#yoga";
          vnc  = "vncserver :1 -geometry 1472x920 -depth 24";
          kvnc = "vncserver -kill :1";
        };
      };

      programs.alacritty = {
        enable = true;
        settings = {
          window.padding = { x = 12; y = 12; };
          font = {
            normal.family = "JetBrainsMono Nerd Font";
            size = 14.0;
          };
          colors.primary = {
            background = "#1E1E2E";
            foreground = "#CDD6F4";
          };
        };
      };
    };
  };

  time.timeZone = "Europe/Zagreb";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "24.11";
}
