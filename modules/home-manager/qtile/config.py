from enum import Enum, auto

from libqtile import hook, qtile
from libqtile import bar, widget
from libqtile.config import Group, Key, Screen
from libqtile.lazy import lazy


screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.TextBox("default config", name="default"),
                widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                # NB Systray is incompatible with Wayland, consider using StatusNotifier instead
                # widget.StatusNotifier(),
                widget.Systray(),
                widget.Clock(format="%Y-%m-%d %a %I:%M %p"),
                widget.QuickExit(),
            ],
            24,
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    )
]

# key names
ALT = "mod1"
CONTROL = "control"
RETURN = "Return"
SHIFT = "shift"
SUPER = "mod4"
TAB = "Tab"


# screens and groups
NUM_SCREENS = 3
NUM_GROUPS_PER_SCREEN = 3

groups = [Group(str(i)) for i in range(NUM_SCREENS * NUM_GROUPS_PER_SCREEN)]


@hook.subscribe.startup
def set_default_groups():
    for screen in qtile.screens:
        screen.cmd_toggle_group(
            group_name=str(NUM_GROUPS_PER_SCREEN * screen.index),
            warp=False,
        )
        screen.previous_group = None


@lazy.function
def focus_next_group(qtile):
    curr_group_position = int(qtile.current_screen.group.name) % NUM_GROUPS_PER_SCREEN
    next_group_position = (curr_group_position + 1) % NUM_GROUPS_PER_SCREEN
    next_group_id = next_group_position + (
        qtile.current_screen.index * NUM_GROUPS_PER_SCREEN
    )
    next_group_name = str(next_group_id)

    qtile.current_screen.cmd_toggle_group(next_group_name)


@lazy.function
def focus_prev_group(qtile):
    curr_group_position = int(qtile.current_screen.group.name) % NUM_GROUPS_PER_SCREEN
    next_group_position = (curr_group_position - 1) % NUM_GROUPS_PER_SCREEN
    next_group_id = next_group_position + (
        qtile.current_screen.index * NUM_GROUPS_PER_SCREEN
    )
    next_group_name = str(next_group_id)

    qtile.current_screen.cmd_toggle_group(next_group_name)


@lazy.function
def move_to_next_group(qtile):
    curr_group_position = int(qtile.current_screen.group.name) % NUM_GROUPS_PER_SCREEN
    next_group_position = (curr_group_position + 1) % NUM_GROUPS_PER_SCREEN
    next_group_id = next_group_position + (
        qtile.current_screen.index * NUM_GROUPS_PER_SCREEN
    )
    next_group_name = str(next_group_id)
    qtile.current_window.cmd_togroup(next_group_name, switch_group=True)


@lazy.function
def move_to_prev_group(qtile):
    curr_group_position = int(qtile.current_screen.group.name) % NUM_GROUPS_PER_SCREEN
    next_group_position = (curr_group_position - 1) % NUM_GROUPS_PER_SCREEN
    next_group_id = next_group_position + (
        qtile.current_screen.index * NUM_GROUPS_PER_SCREEN
    )
    next_group_name = str(next_group_id)
    qtile.current_window.cmd_togroup(next_group_name, switch_group=True)


@lazy.function
def focus_prev_screen(qtile):
    qtile.cmd_prev_screen()
    qtile.warp_to_screen()


@lazy.function
def focus_next_screen(qtile):
    qtile.cmd_next_screen()
    qtile.warp_to_screen()


@lazy.function
def move_to_prev_screen(qtile):
    curr_screen_id: int = qtile.current_screen.index
    qtile.current_window.cmd_toscreen(curr_screen_id - 1)
    qtile.cmd_prev_screen()


@lazy.function
def move_to_next_screen(qtile):
    curr_screen_id: int = qtile.current_screen.index
    qtile.current_window.cmd_toscreen(curr_screen_id + 1)
    qtile.cmd_next_screen()


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
    # todo: can we choose a different layout...?
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
    # Key([ALT], "h", lazy.prev_screen()),
    Key([ALT], "h", focus_prev_screen),
    Key([ALT], "l", focus_next_screen),
    # Move current window adjacent screen
    Key(
        [ALT, SHIFT],
        "h",
        move_to_prev_screen,
    ),
    Key(
        [ALT, SHIFT],
        "l",
        move_to_next_screen,
    ),
    # Change focus to the next group (on the same screen)
    Key([SUPER], "h", focus_prev_group),
    Key([SUPER], "l", focus_next_group),
    # Move current window to the next group (on the same screen)
    Key([SUPER, SHIFT], "h", move_to_prev_group),
    Key([SUPER, SHIFT], "l", move_to_next_group),
    # Change focus to the last-used group on the current screen
    Key([ALT], TAB, lazy.screen.toggle_group()),
    # Reload
    Key([SUPER, CONTROL], "r", lazy.reload_config(), desc="Reload the config"),
    Key([SUPER, CONTROL], "q", lazy.shutdown(), desc="Shutdown Qtile"),
]


# Directions
class Direction(Enum):
    LEFT = auto()
    RIGHT = auto()


#
#
# @lazy.function
# def change_screen(qtile, direction: Direction):
#     # logger.warning("HELLO")
#     # curr_screen_id: int = qtile.current_screen.index
#     curr_screen_id: int = qtile.current_screen.index
#
#     # if direction == Direction.LEFT:
#     #     new_screen_id = curr_screen_id - 1
#     # elif direction == Direction.RIGHT:
#     #     new_screen_id = curr_screen_id + 1
#     if direction == Direction.LEFT:
#         new_screen_id = curr_screen_id - 1
#     elif direction == Direction.RIGHT:
#         new_screen_id = curr_screen_id + 1
#
#     logger.warning(f"new_screen_id {new_screen_id}")
#     # logger.warning(curr_window)
#
#     # lazy.window.toscreen(new_screen_id)()
#     qtile.current_window.cmd_toscreen(new_screen_id)
#     qtile.cmd_prev_screen(new_screen_id)
#     # qtile.current_window.cmd_focus()
