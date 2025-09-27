import re
from pathlib import Path

infile = Path("itemInfo_re_Copy.lua")
outfile = Path("itemInfo_re_Copy_patched.lua")

# Detect encoding (fallbacks)
raw = infile.read_bytes()
for enc in ("utf-8", "cp949", "euc-kr", "latin-1", "windows-1252"):
    try:
        text = raw.decode(enc)
        chosen = enc
        break
    except Exception:
        pass

lines = text.splitlines(keepends=True)
out = []

depth = 0
current_id = None
enter_depth = None
target = False
saw_costume = False
prop_indent = None

def brace_delta(s): return s.count("{") - s.count("}")

for line in lines:
    if current_id is None:
        m = re.match(r"^\s*\[(\d+)\]\s*=\s*{", line)
        if m:
            current_id = int(m.group(1))
            enter_depth = depth
            target = False
            saw_costume = False
            prop_indent = None

    if current_id is not None:
        if prop_indent is None:
            m = re.match(r"^(\s+)\S", line); prop_indent = m.group(1) if m else "\t\t"
        if ("identifiedDisplayName" in line) and ("Kaho's Horn" in line):
            target = True
        if target:
            if re.search(r"\bcostume\s*=", line):
                line = re.sub(r"(\bcostume\s*=\s*)(true|false)\b", r"\1false", line)
                saw_costume = True
            delta = brace_delta(line)
            if ("}" in line) and (depth + delta <= enter_depth) and not saw_costume:
                out.append(f"{prop_indent}costume = false\n")
                saw_costume = True

    out.append(line)
    depth += brace_delta(line)
    if current_id is not None and depth <= enter_depth:
        current_id = None

# write back using original encoding we detected
outfile.write_bytes("".join(out).encode(chosen))
print("Done.")
