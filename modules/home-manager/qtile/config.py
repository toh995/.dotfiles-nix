from enum import Enum, auto

from libqtile import hook, qtile
from libqtile import bar, widget
from libqtile.config import Group, Key, Screen
from libqtile.core.manager import Qtile
from libqtile.lazy import lazy

cursor_warp = True

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


class Direction(Enum):
    LEFT = auto()
    RIGHT = auto()


# simple curry decorator
# adapted from https://stackoverflow.com/a/25078860
# only supports positional args, not keyword args
def curry(func):
    def curried(*args):
        if len(args) < func.__code__.co_argcount:
            return lambda *args2: curried(*(args + args2))
        else:
            return func(*args)

    return curried


# screens and groups
NUM_SCREENS = 3
NUM_GROUPS_PER_SCREEN = 3

groups = [Group(str(i)) for i in range(NUM_SCREENS * NUM_GROUPS_PER_SCREEN)]


@hook.subscribe.startup
def set_default_groups() -> None:
    for screen in qtile.screens:
        screen.cmd_toggle_group(
            group_name=str(NUM_GROUPS_PER_SCREEN * screen.index),
            warp=False,
        )
        screen.previous_group = None


def get_next_group_name(direction: Direction, qtile: Qtile) -> str | None:
    curr_group_position: int = (
        int(qtile.current_screen.group.name) % NUM_GROUPS_PER_SCREEN
    )

    match direction:
        case Direction.LEFT:
            next_group_position: int = (curr_group_position - 1) % NUM_GROUPS_PER_SCREEN
        case Direction.RIGHT:
            next_group_position: int = (curr_group_position + 1) % NUM_GROUPS_PER_SCREEN
        case _:
            return None

    next_group_id = next_group_position + (
        qtile.current_screen.index * NUM_GROUPS_PER_SCREEN
    )
    return str(next_group_id)


@curry
def focus_group(direction: Direction, qtile: Qtile) -> None:
    next_group_name = get_next_group_name(direction, qtile)
    qtile.current_screen.cmd_toggle_group(next_group_name)


@curry
def move_to_group(direction: Direction, qtile: Qtile) -> None:
    next_group_name = get_next_group_name(direction, qtile)
    qtile.current_window.cmd_togroup(next_group_name, switch_group=False)
    focus_group(direction, qtile)


def get_next_screen_id(direction: Direction, qtile: Qtile) -> int | None:
    curr_screen_id: int = qtile.current_screen.index

    match direction:
        case Direction.LEFT:
            return curr_screen_id - 1 % len(qtile.screens)
        case Direction.RIGHT:
            return curr_screen_id + 1 % len(qtile.screens)
        case _:
            return None


@curry
def focus_screen(direction: Direction, qtile: Qtile) -> None:
    next_screen_id = get_next_screen_id(direction, qtile)
    qtile.cmd_to_screen(next_screen_id)
    qtile.current_screen.window.focus(warp=True)


@curry
def move_to_screen(direction: Direction, qtile: Qtile) -> None:
    next_screen_id = get_next_screen_id(direction, qtile)
    qtile.current_window.cmd_toscreen(next_screen_id)
    focus_screen(direction, qtile)


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
