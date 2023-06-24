import atexit
import os
import readline

"""
This script is adapted from
https://docs.python.org/3/library/readline.html#example
"""


def get_hist_filepath():
    ret = ""

    if "PYTHONHISTFILE" in os.environ:
        ret = os.environ.get("PYTHONHISTFILE")
    elif "XDG_STATE_HOME" in os.environ:
        ret = os.path.join(
            os.environ.get("XDG_STATE_HOME"),
            "python/.python_history",
        )
    else:
        ret = os.path.join(
            os.path.expanduser("~"),
            ".local/state/python/.python_history",
        )

    return ret


# create the directory and file, if they don't exist yet
def create_file(filepath):
    dirname = os.path.dirname(filepath)
    os.makedirs(dirname, exist_ok=True)
    open(filepath, "a").close()


hist_filepath = get_hist_filepath()
create_file(hist_filepath)
readline.read_history_file(hist_filepath)
h_len = readline.get_current_history_length()


def save(prev_h_len, histfile):
    new_h_len = readline.get_current_history_length()
    readline.set_history_length(1000)
    readline.append_history_file(new_h_len - prev_h_len, histfile)


atexit.register(save, h_len, hist_filepath)
