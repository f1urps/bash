
# Script to fix images with the wrong file extensions.
# Runs on all images in the current directory.

for f in *.{jpg,JPG,png,PNG,jpeg,JPEG}; do 
    type=$( file "$f" | grep -oP '\w+(?= image)' )
    case $type in  
        PNG)  newext=png ;; 
        JPEG) newext=jpg ;; 
        P) newext=webp ;;
        *)    echo "??? what is this: $f"; continue ;; 
    esac
    ext=${f##*.}   # remove everything up to and including the last dot
    if [[ $ext != $newext ]]; then
        # remove "echo" if you're satisfied it's working
        mv -v "$f" "${f%.*}.$newext"
    fi
done

