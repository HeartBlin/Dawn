{ config, dawn, lib, pkgs, ... }:

let
  inherit (lib) mkIf;
  inherit (config.dawn) hyprland;
  inherit (dawn.functions) mkHyprMonitors;

  terminal = if config.dawn.foot.enable 
             then "foot"
             else "";

  browser = "zen";
  launcher = "${lib.getExe pkgs.rofi-wayland} -show drun";
  editor = if config.dawn.vscode.enable
           then "code"
           else "";

  volume = {
    raise = "wpctl set-volume -l 1.5 @DEFAULT_SINK@ 5%+";
    lower = "wpctl set-volume @DEFAULT_SINK@ 5%-";
    mute = "wpctl set-mute @DEFAULT_SINK@ toggle";
    micMute = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
  };

  brightness = {
    up = "${lib.getExe pkgs.brightnessctl} -q set +5%";
    down = "${lib.getExe pkgs.brightnessctl} -q set 5%-";
  };

  playerCtl = {
    playPause = "playerctl play-pause";
    stop = "playerctl stop";
    next = "playerctl next";
    prev = "playerctl previous";
  };

  settings = ''
    ### Monitor settings
    ${mkHyprMonitors hyprland.monitors}

    ### Startup
    exec-once = uwsm finalize
    exec-once = hyprpaper

    ### Look and feel
    general {
      border_size = 2
      gaps_in = 5
      gaps_out = 20

      col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
      col.inactive_border = rgba(595959aa)

      resize_on_border = true
      allow_tearing = true
      layout = dwindle
    }

    decoration {
      rounding = 5
      rounding_power = 2.0

      blur {
        enabled = true
        size = 3
        passes = 1
      }

      shadow {
        enabled = true
        range = 3
        render_power = 3
        color = rgba(1a1a1aee)
      }
    }

    animations {
      enabled = true
      first_launch_animation = false
    }

    dwindle {
      preserve_split = true
    }

    master {
      new_status = master
    }

    misc {
      disable_hyprland_logo = true
      disable_splash_rendering = true
      mouse_move_enables_dpms = true
      key_press_enables_dpms = true
    }

    render {
      direct_scanout = 1
    }

    ### Input
    input {
      kb_layout = ro
      follow_mouse = 1

      touchpad {
        disable_while_typing = true
        clickfinger_behavior = true
      }
    }

    gestures {
      workspace_swipe = true
    }

    ### Keybindings
    $mod = SUPER

    # Programs & Actions
    bind = $mod, Return, exec, ${terminal}
    bind = $mod, W, exec, ${browser}
    bind = $mod, Space, exec, ${launcher}
    bind = $mod, C, exec, ${editor}
    bind = $mod, Q, killactive
    bind = $mod, F, togglefloating
    bind = $mod Shift, F, fullscreen 
    bind = $mod Shift, Q, exit

    # Switch workspaces
    bind = $mod, 1, workspace, 1
    bind = $mod, 2, workspace, 2
    bind = $mod, 3, workspace, 3
    bind = $mod, 4, workspace, 4
    bind = $mod, 5, workspace, 5
    bind = $mod, 6, workspace, 6
    bind = $mod, 7, workspace, 7
    bind = $mod, 8, workspace, 8
    bind = $mod, 9, workspace, 9
    bind = $mod, 0, workspace, 10

    # Move active window to workspace
    bind = $mod Shift, 1, movetoworkspace, 1
    bind = $mod Shift, 2, movetoworkspace, 2
    bind = $mod Shift, 3, movetoworkspace, 3
    bind = $mod Shift, 4, movetoworkspace, 4
    bind = $mod Shift, 5, movetoworkspace, 5
    bind = $mod Shift, 6, movetoworkspace, 6
    bind = $mod Shift, 7, movetoworkspace, 7
    bind = $mod Shift, 8, movetoworkspace, 8
    bind = $mod Shift, 9, movetoworkspace, 9
    bind = $mod Shift, 0, movetoworkspace, 10

    # Move/resize with mouse
    bindm = $mod, mouse:272, movewindow
    bindm = $mod, mouse:273, resizewindow

    # Laptop multimedia, brightness, and volume keys
    bindel = ,XF86AudioRaiseVolume, exec, ${volume.raise}
    bindel = ,XF86AudioLowerVolume, exec, ${volume.lower}
    bindel = ,XF86AudioMute, exec, ${volume.mute}
    bindel = ,XF86AudioMicMute, exec, ${volume.micMute}
    bindel = ,XF86MonBrightnessUp, exec, ${brightness.up}
    bindel = ,XF86MonBrightnessDown, exec, ${brightness.down}
    bindel = ,XF86AudioPlay, exec, ${playerCtl.playPause}
    bindel = ,XF86AudioStop, exec, ${playerCtl.stop}
    bindel = ,XF86AudioNext, exec, ${playerCtl.next}
    bindel = ,XF86AudioPrev, exec, ${playerCtl.prev}

    ### Window rules
    windowrule = suppressevent maximize, class:.*
  '';
in {
  config = mkIf hyprland.enable {
    homix.".config/hypr/hyprland.conf".text = settings;
  };
}