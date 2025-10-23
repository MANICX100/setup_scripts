#!/bin/bash

# Source fish configuration file
source_file="$HOME/.config/fish/config.fish"

# Destination mkshrc file
destination_file="$HOME/.mkshrc"

# Delete existing mkshrc file if it exists
if [ -f "$destination_file" ]; then
  rm "$destination_file"
fi

# Convert fish config to mkshrc
echo "# Converted fish config to mkshrc" > "$destination_file"

while IFS= read -r line; do
  # Remove leading/trailing whitespace
  line="${line#"${line%%[![:space:]]*}"}"
  line="${line%"${line##*[![:space:]]}"}"

  # Skip empty lines and comments
  if [[ -z $line || $line == \#* ]]; then
    continue
  fi

  # Convert set -x to export
  if [[ $line == set\ -x* ]]; then
    var_name="${line#*set -x }"
    echo "export $var_name" >> "$destination_file"
    continue
  fi

  # Convert function definition
  if [[ $line == function* ]]; then
    function_name="${line#*function }"
    echo "$function_name() {" >> "$destination_file"
    continue
  fi

  # Convert alias definition
  if [[ $line == alias* ]]; then
    alias_name="${line#*alias }"
    alias_name="${alias_name%%=*}"
    alias_value="${line#*\'*}"
    alias_value="${alias_value%\'*}"
    echo "alias $alias_name='$alias_value'" >> "$destination_file"
    continue
  fi

  # Convert fish_prompt to PS1
  if [[ $line == set\ -g\ fish_prompt* ]]; then
    prompt_value="${line#*set -g fish_prompt }"
    echo "PS1='$prompt_value'" >> "$destination_file"
    continue
  fi

  # Convert sourcing external files
  if [[ $line == source* ]]; then
    source_file="${line#*source }"
    echo ". $source_file" >> "$destination_file"
    continue
  fi

  # Convert PATH variable
  if [[ $line == set\ -x\ PATH* ]]; then
    new_path="${line#*set -x PATH }"
    echo "PATH=\"$new_path:\$PATH\"" >> "$destination_file"
    continue
  fi

  # Close function definitions
  if [[ $line == end ]]; then
    echo "}" >> "$destination_file"
    continue
  fi

  # Copy other configurations as is
  echo "$line" >> "$destination_file"

done < "$source_file"

echo "Conversion completed. The mkshrc file has been created at: $destination_file"

