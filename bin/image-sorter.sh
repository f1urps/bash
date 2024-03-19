#! /bin/bash
#
# Sort image files in the given directory.
#
# Usage:
#   ./image-sorter.sh [dirpath]
#
# If no target directory is given, this script will operate on the
# current working directory.
#
# If the target directory contains any non-image files, a warning
# will be given.
#
# For each image file in the target directory, display the image,
# then prompt the user for input.
#   - If the user inputs an empty string, the file will be skipped.
#   - If the user inputs a non-empty string, the file will be moved
#     into that directory (which will be created if it doesn't exist).
##

# Command to view an image.
IMAGE_VIEWER_EXEC='/usr/bin/imv'

# File extensions to treat as images.
IMAGE_FILE_EXTENSIONS='png,jpg,jpeg,webp,gif'

# If true, will use qtile commands to change the focus between windows
# for a smoother experience. Disable this if not using qtile!
ENABLE_QTILE_FOCUS=true


##
# Handle an image file.
# Displays the image, prompts for input, then acts on the input.
#
# Usage:
#   handle_image_file [image_file] [destination_dir]
function handle_image_file {
    local image_file="$1"
    local destination_dir="$2"
    local image_viewer_pid
    local user_input
    local qtile_window_id
    if [[ -z "$image_file" || -z "$destination_dir" ]]; then
        echo >&2 "Error: Missing argument to handle_image_file."
        return 1
    fi

    if [[ "$ENABLE_QTILE_FOCUS" == true ]]; then
        qtile_window_id=$(qtile cmd-obj -o window -f info | grep "'id'" | awk '{print $2}' | sed 's/,//')
    fi

    $IMAGE_VIEWER_EXEC "$image_file" &
    image_viewer_pid="$!"

    if [[ "$ENABLE_QTILE_FOCUS" == true ]]; then
        qtile cmd-obj -o window "$qtile_window_id" -f focus
    fi

    read -p "Directory name, or [enter] to skip: " user_input </dev/tty
    if [[ -n "$user_input" ]]; then
        echo "Moving '$image_file' to '$destination_dir/$user_input/'"
        mkdir -p "$destination_dir/$user_input/" && \
            mv "$image_file" "$destination_dir/$user_input/"
    else
        echo "Skipping."
    fi
    kill "$image_viewer_pid" 2>/dev/null
}

##
# Convert $IMAGE_FILE_EXTENSIONS into an expression that
# can be consumed by the `find` command.
##
function _image_extension_find_expr {
    local pattern
    pattern=$(echo "$IMAGE_FILE_EXTENSIONS" | sed 's/,/ -o -name \\*./g')
    echo "\( -name \*.$pattern \)"
}

##
# Handle all images in the given directory.
#
# Usage:
#   handle_all_image_files [dir]
##
function handle_all_image_files {
    local dir="$1"
    local find_cmd
    local image_files
    local image_file_count
    if [[ -z "$dir" ]]; then
        echo >&2 "Error: Missing argument to handle_all_image_files."
        return 1
    fi
    find_cmd="find \"$dir\" -mindepth 1 -maxdepth 1 $(_image_extension_find_expr)" 
    image_files="$(eval $find_cmd | sort | awk NF)"
    if [[ -z "$image_files" ]]; then
        echo >&2 "Error: No image files found in directory '$dir'."
        return 0
    fi

    image_file_count="$(echo "$image_files" | wc -l)"
    echo "Found $image_file_count image files in directory '$dir'."

    while read image_file; do
        echo -e "\nFile: '$image_file'"
        handle_image_file "$image_file" "$dir"
    done <<< "$image_files"
}

##
# Issue a warning to the user if the given directory
# contains any non-image files.
#
# Usage:
#   warn_if_dir_contains_non_image_files [dir]
##
function warn_if_dir_contains_non_image_files {
    local dir="$1"
    local find_cmd
    local non_image_files
    local non_image_file_count
    if [[ -z "$dir" ]]; then
        echo >&2 "Error: Missing argument to warn_if_dir_contains_non_image_files."
        return 1
    fi
    find_cmd="find \"$dir\" -mindepth 1 -maxdepth 1 -not $(_image_extension_find_expr)" 
    non_image_files="$(eval $find_cmd | sort)"
    non_image_file_count="$(echo "$non_image_files" | wc -l)"
    echo >&2 "Warning: Found $non_image_file_count non-image files in directory '$dir'. These files will be skipped."
}

# Run if this script is being executed, not sourced.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    dir="$1"
    if [[ -z "$dir" ]]; then
        dir="$(pwd)"
    fi
    warn_if_dir_contains_non_image_files "$dir"
    handle_all_image_files "$dir"
fi

