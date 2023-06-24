def curry(func):
    """
    This is a simple decorator to curry a function.
    This only support positional args, not keyword args.
    Adapted from https://stackoverflow.com/a/25078860
    """

    def curried(*args):
        if len(args) < func.__code__.co_argcount:
            return lambda *args2: curried(*(args + args2))
        else:
            return func(*args)

    return curried
