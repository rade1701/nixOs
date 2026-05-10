# Niri — Wayland compositor
# Enable when on native boot or VM with GPU support
# Import in hosts/*/configuration.nix when ready
{ pkgs, ... }: {
  programs.niri.enable = true;
  environment.systemPackages = with pkgs; [
    niri
    xwayland-satellite
    waybar
    fuzzel
    mako
  ];
}
