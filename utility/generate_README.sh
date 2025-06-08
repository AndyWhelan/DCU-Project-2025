#!/bin/zsh

# Usage: ./inline_matlab.zsh README_template.md > README.md

TEMPLATE="$1"

if [[ ! -f "$TEMPLATE" ]]; then
   echo "Template file not found: $TEMPLATE" >&2
   exit 1
fi

# Process each line
while IFS= read -r line; do
   if [[ "$line" =~ '<!--INLINE:(.*\.m)-->' ]]; then
      FILE="${match[1]}"
      if [[ -f "$FILE" ]]; then
         echo '```matlab'
         ~/DCU-Project-2025/utility/inline_matlab.sh "$FILE"
         echo '```'
      else
         echo "⚠️ File not found: $FILE" >&2
         echo "<!-- Failed to inline: $FILE -->"
      fi
   else
      echo "$line"
   fi
done < "$TEMPLATE"
