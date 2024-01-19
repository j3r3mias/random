set disassembly-flavor intel
set pagination off
set confirm off

python
gdb.execute("starti")
# gdb.execute("set $stack_base = $rsp")

red = 31
blue = 34
white = 37
def color(value, ansi_color):
    return f"\033[{ansi_color}m{value}\033[0m"

prev_regs = {}
def save_prev_regs():
    prev_regs.clear()
    for line in gdb.execute("info registers", to_string=True).splitlines():
        reg, value = line.split()[:2]
        value = int(value, 16) & 0xffffffffffffffff
        prev_regs[reg] = value
save_prev_regs()

prev_stack = {}
def save_prev_stack():
    prev_stack.clear()
    rbp = prev_regs['rbp'] if prev_regs['rbp'] else prev_regs['rsp']
    rsp = prev_regs['rsp']
    for address in range(rsp, rbp + 0x1, 0x8):
        address = address & 0xffffffffffffffff
        value = int(gdb.parse_and_eval(f"*(long long *)({address})")) & 0xffffffffffffffff
        prev_stack[address] = value
save_prev_stack()

def context():
    gdb.execute("shell clear")
    try:
        disas = gdb.execute("disas", to_string=True).splitlines()
        symbol = disas[0].split()[-1]
        disas = disas[1:-1]
        gdb.write(f"{symbol}\n")
        gdb.write("\n".join(disas))
        gdb.write("\n\n")
    except gdb.error:
        gdb.execute("x/4i $rip")
        gdb.write("\n")

    for reg_group in [["rax", "rbx", "rcx"], ["rdi", "rsi", "rdx"], ["rip", "rsp", "rbp"]]:
        for reg in reg_group:
            value = int(gdb.parse_and_eval(f"${reg}")) & 0xffffffffffffffff
            value = color(f"0x{value:016x}", red if prev_regs[reg] != value else white)
            gdb.write(f"{color(reg, blue)}: {value}  ")
        gdb.write("\n")
    gdb.write("\n")
    save_prev_regs()

    stack_base = gdb.parse_and_eval("$stack_base")
    rbp = prev_regs['rbp'] if prev_regs['rbp'] else prev_regs['rsp']
    rsp = prev_regs['rsp']
 
    for address in range(rsp, rbp + 0x1, 0x8):
        address = int(address) & 0xffffffffffffffff
        value = int(gdb.parse_and_eval(f"*(long long *)({address})")) & 0xffffffffffffffff
        value = color(" ".join(f"{b:02x}" for b in value.to_bytes(8, "little")) + f"  0x{value:016x}", red if address in prev_stack and prev_stack[address] != value else white)
        if address == rbp and address == rsp:
            prefix = 'rsp == rbp =>'
        elif address == rbp:
            prefix = '       rbp =>'
        elif address == rsp:
            prefix = '       rsp =>'
        else:
            prefix = '             '
        address = color(f"0x{address:016x}", blue)
        gdb.write(f"{prefix} {address}: {value}\n")
    gdb.write("\n")
    save_prev_stack()

def on_stop(_):
    context()

gdb.events.stop.connect(on_stop)
context()
end
