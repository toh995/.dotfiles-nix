import os

from libqtile import bar, hook, layout, qtile, widget
from libqtile.backend.wayland import InputConfig
from libqtile.config import Group, Key, Screen
from libqtile.lazy import lazy

import colors
from screens_groups import (
    GROUP_NAMES,
    Direction,
    focus_group,
    focus_screen,
    group_names_for_screen_id,
    initial_group_name_for_screen_id,
    move_to_screen,
    move_to_group,
    SCREEN_IDS,
)
from user_config import (
    BAR_FONT_SIZE,
    VOLUME_NOTIFY_EXPIRE_TIME,
    VOLUME_STEP_PERCENT,
    WALLPAPER_PATH,
)

# from libqtile.log_utils import logger


#############
# Key Names #
#############
ALT = "mod1"
CONTROL = "control"
RETURN = "Return"
SHIFT = "shift"
SUPER = "mod4"
TAB = "Tab"
VOL_DOWN = "XF86AudioLowerVolume"
VOL_MUTE = "XF86AudioMute"
VOL_UP = "XF86AudioRaiseVolume"


##########
# Config #
##########
@hook.subscribe.startup
def on_startup() -> None:
    # set default groups
    for screen in qtile.screens:
        screen.cmd_toggle_group(
            group_name=initial_group_name_for_screen_id(screen.index),
            warp=False,
        )
        screen.previous_group = None

    # start dunst as a background process
    os.system("dunst &")
    # os.system("dunst -config ~/.dotfiles-nix/modules/home-manager/dunst/dunstrc &")

    # start eww (currently unneeded, using the built-in bar instead)
    # os.system("eww open bar")


# Move the cursor, when changing focus
cursor_warp = True

focus_on_window_activation = "focus"

wl_input_rules = {"type:keyboard": InputConfig(kb_repeat_delay=200, kb_repeat_rate=25)}

layouts = [
    layout.MonadTall(
        border_width=1,
        border_focus=colors.GLAUCOUS_BLUE,
        single_border_width=0,
    )
]

groups = [Group(name, label="●") for name in GROUP_NAMES]

screens = [
    Screen(
        wallpaper=WALLPAPER_PATH,
        wallpaper_mode="fill",
        top=bar.Bar(
            [
                widget.GroupBox(
                    visible_groups=group_names_for_screen_id(screen_id),
                    highlight_method="block",
                    active=colors.WHITE,
                    inactive=colors.WHITE,
                    fontsize=BAR_FONT_SIZE,
                ),
                widget.CurrentScreen(),
                widget.Spacer(),
                widget.ThermalZone(high=50, crit=80, fontsize=BAR_FONT_SIZE),
                widget.Sep(padding=20),
                widget.Clock(
                    format="%a %b %d, %I:%M %P",
                    fontsize=BAR_FONT_SIZE,
                ),
            ],
            30,
        ),
    )
    for screen_id in SCREEN_IDS
]

# ALACRITTY_CUSTOM = (
#     f"{os.environ['HOME']}/.dotfiles-nix/modules/home-manager/alacritty/alacritty.yml"
# )

keys = [
    # Open default apps
    # Key([ALT], RETURN, lazy.spawn(f"alacritty --config-file {ALACRITTY_CUSTOM}")),
    Key([ALT], RETURN, lazy.spawn("alacritty")),
    Key([ALT], "b", lazy.spawn("brave")),
    Key([CONTROL], "q", lazy.window.kill()),
    # Change focus to the next window (same screen)
    Key([ALT, SUPER], "h", lazy.layout.left()),
    Key([ALT, SUPER], "l", lazy.layout.right()),
    Key([ALT, SUPER], "j", lazy.layout.down()),
    Key([ALT, SUPER], "k", lazy.layout.up()),
    # Move current window (same screen)
    Key(
        [ALT, SUPER, SHIFT],
        "h",
        lazy.layout.shuffle_left(),
    ),
    Key(
        [ALT, SUPER, SHIFT],
        "l",
        lazy.layout.shuffle_right(),
    ),
    Key([ALT, SUPER, SHIFT], "j", lazy.layout.shuffle_down()),
    Key([ALT, SUPER, SHIFT], "k", lazy.layout.shuffle_up()),
    # Change focus to adjacent screen
    Key([ALT], "h", lazy.function(focus_screen(Direction.LEFT))),
    Key([ALT], "l", lazy.function(focus_screen(Direction.RIGHT))),
    # Move current window adjacent screen
    Key(
        [ALT, SHIFT],
        "h",
        lazy.function(move_to_screen(Direction.LEFT)),
    ),
    Key(
        [ALT, SHIFT],
        "l",
        lazy.function(move_to_screen(Direction.RIGHT)),
    ),
    # Change focus to the next group (on the same screen)
    Key([SUPER], "h", lazy.function(focus_group(Direction.LEFT))),
    Key([SUPER], "l", lazy.function(focus_group(Direction.RIGHT))),
    # Move current window to the next group (on the same screen)
    Key([SUPER, SHIFT], "h", lazy.function(move_to_group(Direction.LEFT))),
    Key([SUPER, SHIFT], "l", lazy.function(move_to_group(Direction.RIGHT))),
    # Change focus to the last-used group on the current screen
    Key([ALT], TAB, lazy.screen.toggle_group()),
    # Reload
    Key([SUPER, CONTROL], "r", lazy.reload_config(), desc="Reload the config"),
    Key([SUPER, CONTROL], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Sound control
    Key(
        [],
        VOL_UP,
        lazy.spawn(
            f"""
            pactl set-sink-volume @DEFAULT_SINK@ +{VOLUME_STEP_PERCENT}%

            if [[ $(pamixer --get-mute) == "true" ]]; then
                pactl set-sink-mute @DEFAULT_SINK@ toggle
            fi

            notify-send "󰕾 Volume:" \
                --hint=int:value:$(pamixer --get-volume) \
                --expire-time={VOLUME_NOTIFY_EXPIRE_TIME}
            """,
            shell=True,
        ),
    ),
    Key(
        [],
        VOL_DOWN,
        lazy.spawn(
            f"""
            pactl set-sink-volume @DEFAULT_SINK@ -{VOLUME_STEP_PERCENT}%

            if [[ $(pamixer --get-mute) == "true" ]]; then
                pactl set-sink-mute @DEFAULT_SINK@ toggle
            fi

            notify-send "󰕾 Volume:" \
                --hint=int:value:$(pamixer --get-volume) \
                --expire-time={VOLUME_NOTIFY_EXPIRE_TIME}
            """,
            shell=True,
        ),
    ),
    Key(
        [],
        VOL_MUTE,
        lazy.spawn(
            f"""
            pactl set-sink-mute @DEFAULT_SINK@ toggle

            if [[ $(pamixer --get-mute) == "true" ]]; then
                vol=0
            else
                vol=$(pamixer --get-volume)
            fi
            notify-send "󰕾 Volume:" \
                --hint=int:value:$vol \
                --expire-time={VOLUME_NOTIFY_EXPIRE_TIME}
            """,
            shell=True,
        ),
    ),
]
