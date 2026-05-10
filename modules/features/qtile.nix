# Qtile + Rofi — based on husseinhareb/qtile-config
{ config, pkgs, ... }: {

  # Qtile config
  environment.etc."xdg/qtile/config.py".text = ''
    from libqtile import bar, layout, widget, hook
    from libqtile.config import Click, Drag, Group, Key, Match, Screen
    from libqtile.lazy import lazy
    import os, subprocess, time

    mod = "mod4"
    terminal = "alacritty"
    browser = "brave"
    wallpaper_path = os.path.expanduser("~/Pictures/wallpaper.png")

    @hook.subscribe.startup_once
    def autostart():
        home = os.path.expanduser("~/.config/qtile/autostart.sh")
        subprocess.run([home])
        time.sleep(2)
        subprocess.Popen(["picom", "--experimental-backends", "-b"])

    keys = [
        Key([mod], "h", lazy.layout.left()),
        Key([mod], "l", lazy.layout.right()),
        Key([mod], "j", lazy.layout.down()),
        Key([mod], "k", lazy.layout.up()),
        Key([mod, "shift"], "h", lazy.layout.shuffle_left()),
        Key([mod, "shift"], "l", lazy.layout.shuffle_right()),
        Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
        Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
        Key([mod, "control"], "h", lazy.layout.grow_left()),
        Key([mod, "control"], "l", lazy.layout.grow_right()),
        Key([mod, "control"], "j", lazy.layout.grow_down()),
        Key([mod, "control"], "k", lazy.layout.grow_up()),
        Key([mod], "n", lazy.layout.normalize()),
        Key([mod], "v", lazy.window.toggle_floating()),
        Key([mod, "shift"], "Return", lazy.layout.toggle_split()),
        Key([mod], "Return", lazy.spawn(terminal)),
        Key([mod], "b", lazy.spawn(browser)),
        Key([mod], "Tab", lazy.next_layout()),
        Key([mod, "shift"], "q", lazy.window.kill()),
        Key([mod, "control"], "r", lazy.reload_config()),
        Key([mod, "control"], "q", lazy.shutdown()),
        Key([mod], "q", lazy.spawn("rofi -show drun -show-icons")),
        Key([mod], "f", lazy.window.toggle_fullscreen()),
    ]

    groups = [Group(i) for i in "123456789"]
    for i in groups:
        keys.extend([
            Key([mod], i.name, lazy.group[i.name].toscreen()),
            Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True)),
        ])

    layouts = [
        layout.Columns(
            border_focus=["#6790EB", "#6790EB"],
            border_normal=["#4c566a", "#4c566a"],
            border_width=2, margin=4),
        layout.Max(),
        layout.MonadTall(),
    ]

    widget_defaults = dict(
        font="JetBrainsMono Nerd Font",
        fontsize=16,
        padding=3,
    )
    extension_defaults = widget_defaults.copy()

    screens = [
        Screen(
            top=bar.Gap(42),
            wallpaper=wallpaper_path,
            wallpaper_mode="fill",
        ),
    ]

    mouse = [
        Drag([mod], "Button1", lazy.window.set_position_floating(),
             start=lazy.window.get_position()),
        Drag([mod], "Button3", lazy.window.set_size_floating(),
             start=lazy.window.get_size()),
        Click([mod], "Button2", lazy.window.bring_to_front()),
    ]

    floating_layout = layout.Floating(
        float_rules=[
            *layout.Floating.default_float_rules,
            Match(wm_class="confirmreset"),
            Match(wm_class="makebranch"),
            Match(wm_class="maketag"),
            Match(wm_class="ssh-askpass"),
            Match(title="branchdialog"),
            Match(title="pinentry"),
        ],
        border_focus=["#6790EB", "#6790EB"],
        border_normal=["#4c566a", "#4c566a"],
        border_width=2,
    )

    dgroups_key_binder = None
    dgroups_app_rules = []
    follow_mouse_focus = True
    bring_front_click = False
    cursor_warp = False
    auto_fullscreen = True
    focus_on_window_activation = "smart"
    reconfigure_screens = True
    auto_minimize = True
    wmname = "LG3D"
  '';

  # Rofi config — Catppuccin Mocha glass theme
  environment.etc."xdg/rofi/config.rasi".text = ''
    configuration {
      display-drun: "Applications:";
      display-window: "Windows:";
      drun-display-format: "{name}";
      font: "JetBrainsMono Nerd Font Medium 14";
    }

    @theme "/dev/null"

    * {
      bg: #1E1E2E99;
      bg-alt: #585b7066;
      bg-selected: #31324466;
      fg: #cdd6f4;
      fg-alt: #7f849c;
      border: 0;
      margin: 0;
      padding: 0;
      spacing: 0;
    }

    window { width: 30%; background-color: @bg; }
    element { padding: 8 12; background-color: transparent; text-color: @fg-alt; }
    element selected { text-color: @fg; background-color: @bg-selected; }
    element-text { background-color: transparent; text-color: inherit; vertical-align: 0.5; }
    element-icon { size: 40; padding: 0 10 0 0; background-color: transparent; }
    entry { padding: 12; background-color: @bg-alt; text-color: @fg; }
    inputbar { children: [prompt, entry]; background-color: @bg; }
    listview { background-color: @bg; columns: 1; lines: 6; }
    mainbox { children: [inputbar, listview]; background-color: @bg; }
    prompt { enabled: true; padding: 12 0 0 12; background-color: @bg-alt; text-color: @fg; }
  '';

  # Deploy autostart.sh via home-manager
  home-manager.users.rade = { ... }: {
    xdg.configFile."qtile/autostart.sh" = {
      source = ./autostart.sh;
      executable = true;
    };
  };
}
