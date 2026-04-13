# GROK AI ALERT

import sys
import zipfile
import re
import os

def split_lua_table_elements(table_content):
    elements = []
    i = 0
    n = len(table_content)
    current = ''
    in_string = False
    quote_char = None
    while i < n:
        c = table_content[i]
        if not in_string and c in ('"', "'"):
            in_string = True
            quote_char = c
            current += c
        elif in_string and c == quote_char:
            in_string = False
            quote_char = None
            current += c
        elif not in_string and c == ',':
            elements.append(current.strip())
            current = ''
        else:
            current += c
        i += 1
    if current.strip():
        elements.append(current.strip())
    return elements

def modify_closure(closure_str, market_dir, watermark):
    assets_match = re.search(r'm\.Assets\s*=\s*\{(.*?)\}', closure_str, re.DOTALL)
    if not assets_match:
        return closure_str
    table_content = assets_match.group(1)
    elements = split_lua_table_elements(table_content)
    modified_elements = []
    for elem in elements:
        str_match = re.match(r'^([\'"])(.*?)(\1)$', elem)
        if str_match:
            quote = str_match.group(1)
            value = str_match.group(2)
            if '@' not in value:
                new_value = f"{watermark}_{value}@MARKET/{market_dir}/{value}"
                modified_elem = f"{quote}{new_value}{quote}"
            else:
                modified_elem = elem
            modified_elements.append(modified_elem)
        else:
            modified_elements.append(elem)
    new_table = '{' + ', '.join(modified_elements) + '}'
    old_full = assets_match.group(0)
    new_full = f'm.Assets = {new_table}'
    new_closure = closure_str.replace(old_full, new_full, 1)
    return new_closure

def extract_closures(lua_code):
    closures = []
    i = 0
    length = len(lua_code)
    while i < length:
        match = re.search(r'\bfunction\b', lua_code[i:])
        if not match:
            break
        start = i + match.start()
        level = 1
        pos = start + 8
        while pos < length and level > 0:
            next_match = re.search(r'\b(function|end)\b', lua_code[pos:])
            if not next_match:
                break
            kw_start = pos + next_match.start()
            kw = next_match.group(1)
            if kw == 'function':
                level += 1
            else:
                level -= 1
            pos = kw_start + len(kw)
        if level == 0:
            closure = lua_code[start:pos]
            closures.append(closure)
            i = pos
        else:
            i = start + 1
    return closures

def main():
    if len(sys.argv) < 2:
        print("Usage: python lua_asset_patcher.py <path_to_zip_file>")
        sys.exit(1)

    zip_path = sys.argv[1]
    if not os.path.isfile(zip_path):
        print(f"Error: File not found: {zip_path}")
        sys.exit(1)

    # Directory where the zip is located
    zip_dir = os.path.dirname(zip_path) or '.'
    zip_name = os.path.basename(zip_path)
    output_name = os.path.splitext(zip_name)[0] + '.lua'
    output_path = os.path.join(zip_dir, output_name)

    # This is the variable you can change at the top of the generated file
    THE_MARKET_DIRECTORY = "nilsbin"
    THE_WATERMARK = "nil"

    try:
        all_closures = []

        with zipfile.ZipFile(zip_path, 'r') as z:
            for member in z.infolist():
                if member.filename.lower().endswith('.lua') and not member.is_dir():
                    with z.open(member) as f:
                        lua_code = f.read().decode('utf-8', errors='replace')

                    closures = extract_closures(lua_code)
                    for closure in closures:
                        modified = modify_closure(closure, THE_MARKET_DIRECTORY, THE_WATERMARK)
                        all_closures.append(modified)

        # Build the final Lua file content
        lines = ["local modules = {}"]
        for closure in all_closures:
            # indent the closure properly
            indented = '\n'.join('    ' + line for line in closure.splitlines())
            lines.append(f"table.insert(modules, {indented})")

        lines.append("")
        lines.append("return modules")

        final_content = '\n'.join(lines)

        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(final_content)

        print(f"Success! Created: {output_path}")
        print(f"   → {len(all_closures)} closures processed")
        print(f"   → THE_MARKET_DIRECTORY = \"{THE_MARKET_DIRECTORY}\"")

    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()