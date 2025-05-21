#!/bin/zsh

# Usage: ./inline_matlab.sh do_stuff.m

INPUT_FILE="$1"
FUNC_DIR="./matlab_functions"
OUTPUT_FILE="${INPUT_FILE%.m}_inline.m"

if [ ! -f "$INPUT_FILE" ]; then
   echo "ERROR: Input file '$INPUT_FILE' not found."
   exit 1
fi

if [ ! -d "$FUNC_DIR" ]; then
   echo "ERROR: Function directory '$FUNC_DIR' not found."
   exit 1
fi

# Start the output file
cp "$INPUT_FILE" "$OUTPUT_FILE"
echo -e "\n\n% ===== Inlined Functions =====\n" >> "$OUTPUT_FILE"

# Get list of function names from the function directory
func_files=("$FUNC_DIR"/*.m)

# Create a temporary file to store detected function names
tmpfuncs=$(mktemp)

# Detect used functions in the input file
for func_path in "${func_files[@]}"; do
   func_name=$(basename "$func_path" .m)
   if grep -q -E "\b$func_name\s*\(" "$INPUT_FILE"; then
      echo "$func_name" >> "$tmpfuncs"
   fi
done

# Read unique function names into an array
used_funcs=()
for func in $(sort -u "$tmpfuncs"); do
   used_funcs+=("$func")
done
rm "$tmpfuncs"

# Append each used function's code to the output
for func in "${used_funcs[@]}"; do
   func_file="$FUNC_DIR/$func.m"
   if [ -f "$func_file" ]; then
      echo -e "\n% ---- Inlined: $func ----\n" >> "$OUTPUT_FILE"
      cat "$func_file" >> "$OUTPUT_FILE"
      echo -e "\n" >> "$OUTPUT_FILE"
   else
      echo "WARNING: Function file '$func_file' not found." >&2
   fi
done

echo "Done. Inlined version saved to '$OUTPUT_FILE'"
