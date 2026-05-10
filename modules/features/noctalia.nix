# Noctalia — desktop shell for Wayland compositors
# Enable alongside niri.nix when on native/VM setup
# Track: https://github.com/noctalia/noctalia
{ pkgs, ... }: {
  # Not yet in nixpkgs — add package derivation when available
  environment.systemPackages = with pkgs; [
    gtk4
    libadwaita
  ];
}
