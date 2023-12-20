import gdb

class calculate_offset(gdb.Command):
    def __init__(self):
        super(calculate_offset, self).__init__("offset", gdb.COMMAND_USER)

    def invoke(self, arg, from_tty):
        args = gdb.string_to_argv(arg)
        
        if len(args) != 2:
            print("Usage: offset from_address to_address")
            return

        _from = gdb.parse_and_eval(args[0])
        _to = gdb.parse_and_eval(args[1])

        lower = max(_from, _to)
        greater = min(_from, _to)
        off = lower - greater
        if _from > _to:
            print(f"-{hex(off)}")
        else:
            print(f"+{hex(off)}")

calculate_offset()