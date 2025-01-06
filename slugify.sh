#!/bin/bash

# Function to slugify text
slugify() {
  echo "$@" | tr '[:upper:]' '[:lower:]' | tr '[ ]' '-' | tr -dc '[:alnum:]-'
}
# slugify() {
#   local text="$1"
#   echo "Original text: $text"
#   local slug=$(echo "$text" | tr '[:upper:]' '[:lower:]' | tr '[:space:]' '-' | tr -dc '[:alnum:]-')
#   echo "Slugified text: $slug"
# }

