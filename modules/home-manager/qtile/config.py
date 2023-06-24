from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import Group, Key, Screen
from libqtile.lazy import lazy

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
from user_config import BAR_FONT_SIZE, WALLPAPER_PATH

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
    # start eww (currently unneeded, using the built-in bar instead)
    # os.system("eww open bar")


# Move the cursor, when changing focus
cursor_warp = True

layouts = [layout.MonadTall()]

groups = [Group(name, label="󰏃") for name in GROUP_NAMES]

screens = [
    Screen(
        # wallpaper="~/downloads/wallpaperflare.com_wallpaper (1).jpg",
        wallpaper=WALLPAPER_PATH,
        wallpaper_mode="fill",
        top=bar.Bar(
            [
                widget.GroupBox(
                    visible_groups=group_names_for_screen_id(screen_id),
                    highlight_method="block",
                    active="FFFFFF",
                    inactive="FFFFFF",
                    fontsize=BAR_FONT_SIZE,
                ),
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

keys = [
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
]
