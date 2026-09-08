#!/bin/bash

IMAGES_DIR="./images"

# Create images folder
mkdir -p "$IMAGES_DIR"

echo "Moving all images to $IMAGES_DIR ..."
find . -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" -o -iname "*.webp" \) \
    ! -path "./images/*" -exec mv -n {} "$IMAGES_DIR" \;

echo "Updating image links inside Markdown files..."

find . -type f -name "*.md" | while read -r file; do
    echo "Processing: $file"

    # Use a temp file for macOS-safe in-place replacement
    tmpfile="${file}.tmp"

    sed -E \
        -e 's/!\[\[([[:alnum:] _.-]+\.png)\]\]/<img src="\/images\/\1" alt="image" width="500">/g' \
        -e 's/!\[\[([[:alnum:] _.-]+\.jpg)\]\]/<img src="\/images\/\1" alt="image" width="500">/g' \
        -e 's/!\[\[([[:alnum:] _.-]+\.jpeg)\]\]/<img src="\/images\/\1" alt="image" width="500">/g' \
        -e 's/!\[\[([[:alnum:] _.-]+\.gif)\]\]/<img src="\/images\/\1" alt="image" width="500">/g' \
        -e 's/!\[\[([[:alnum:] _.-]+\.webp)\]\]/<img src="\/images\/\1" alt="image" width="500">/g' \
        "$file" > "$tmpfile"

    mv "$tmpfile" "$file"
done

echo "✔ All markdown files updated in-place!"

