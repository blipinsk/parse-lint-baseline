#!/bin/bash
echo 
echo '    ____  ____ ______________                              '
echo '   / __ \/ __ `/ ___/ ___/ _ \                             '
echo '  / /_/ / /_/ / /  (__  )  __/                             '
echo ' / .___/\__,_/_/  /____/\___/                              '
echo '/_/ ___       __        __                    ___          '
echo '   / (_)___  / /_      / /_  ____ _________  / (_)___  ___ '
echo '  / / / __ \/ __/_____/ __ \/ __ `/ ___/ _ \/ / / __ \/ _ \'
echo ' / / / / / / /_/_____/ /_/ / /_/ (__  )  __/ / / / / /  __/'
echo '/_/_/_/ /_/\__/     /_.___/\__,_/____/\___/_/_/_/ /_/\___/ '
echo 
echo "╔═════════════════════════════════════╗"
echo "║     by Bartek Lipinski @blipinsk    ║"
echo "╚═════════════════════════════════════╝"
echo

if [ "$#" -ne 1 ]; then
    echo "🔍 Usage: $0 <path-to-lint-baseline.xml>"
    exit 1
fi

# Getting the full path of the input file by combining the current working directory with the relative path
CURRENT_DIR=$(pwd)
INPUT_FILE="$CURRENT_DIR/$1"
TEMP_FILE="$CURRENT_DIR/temp_issue_ids.txt"
OUTPUT_FILE="$CURRENT_DIR/lint-violations.csv"

if [ ! -f "$INPUT_FILE" ]; then
    echo "❌  File not found: file://$INPUT_FILE"
    exit 1
fi

echo -e "🔍 Analyzing file:\n file://$INPUT_FILE\n"
grep 'id=' "$INPUT_FILE" | sed 's/.*id="\([^"]*\)".*/\1/' > "$TEMP_FILE"
echo "Lint ID,Count" > "$OUTPUT_FILE"

sort "$TEMP_FILE" | uniq | while read -r id; do
    count=$(grep -c "$id" "$TEMP_FILE")
    echo "$id,$count" >> "$OUTPUT_FILE"
done

TOTAL_VIOLATIONS=$(wc -l < "$TEMP_FILE")
echo -e "🔢 Total number of lint violations: $TOTAL_VIOLATIONS\n"

rm "$TEMP_FILE"
echo -e "✅  Generated CSV file:\n file://$OUTPUT_FILE\n"
