import os
from pathlib import Path

print("=====")

gdb_config_path = Path.home() / Path(".config/gdb")
print(f"[!] GDB config dir: {gdb_config_path}")

peda_path = gdb_config_path / Path("peda")
if os.path.exists(peda_path):
    print("[+] Peda is installed!")
else:
    print(f"[-] Peda is not installed! install with `git clone https://github.com/longld/peda {peda_path}`")

print("=====")