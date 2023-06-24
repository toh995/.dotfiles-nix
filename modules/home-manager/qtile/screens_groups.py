from enum import Enum, auto

from libqtile.core.manager import Qtile
from libqtile.log_utils import logger

from user_config import NUM_GROUPS_PER_SCREEN, NUM_SCREENS
from utils import curry

# from libqtile.log_utils import logger


class Direction(Enum):
    LEFT = auto()
    RIGHT = auto()


######################
# Computed Constants #
######################
GROUP_IDS = tuple(range(NUM_SCREENS * NUM_GROUPS_PER_SCREEN))
GROUP_NAMES = tuple(str(i) for i in GROUP_IDS)

SCREEN_IDS = tuple(range(NUM_SCREENS))

logger.warn(GROUP_NAMES)


###########
# Helpers #
###########
def group_names_for_screen_id(screen_id: int) -> list[str]:
    lower_bound = screen_id * NUM_GROUPS_PER_SCREEN
    upper_bound = lower_bound + NUM_GROUPS_PER_SCREEN
    group_ids = range(lower_bound, upper_bound)
    group_names = map(str, group_ids)

    return list(group_names)


def initial_group_name_for_screen_id(screen_id: int) -> str:
    return str(NUM_GROUPS_PER_SCREEN * screen_id)


############
# Handlers #
############
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
