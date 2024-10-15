#!/bin/bash

# Variables
VERSION=1.0
IMAGE_NAME="ImageSmith_v${VERSION}.sif"
SCRIPT=$(readlink -f $0)
IMAGE_PATH=`dirname $SCRIPT`

# Check if the image exists
if [ ! -f "${IMAGE_PATH}/${IMAGE_NAME}" ]; then
    echo "Error: Image ${IMAGE_NAME} not found in ${IMAGE_PATH}."
    exit 1
fi

# Define the folders to check and mount if exist
# This only makes sense if they are mount points!
FOLDERS=("/local" "/projects" "/mnt" )
MOUNT_OPTIONS=""

# Check if each folder exists and build the mount options
for dir in "${FOLDERS[@]}"; do
    if [ -d "$dir" ]; then
        MOUNT_OPTIONS+="$dir,"
    fi
done

if [ -n "$MOUNT_OPTIONS" ]; then
        MOUNT_OPTIONS = "-B "+MOUNT_OPTIONS
fi

# Run the image
echo "Running ${IMAGE_NAME}..."
apptainer exec $MOUNT_OPTIONS --cleanenv "${IMAGE_PATH}/${IMAGE_NAME}" jupyter lab --port 9734 --ip=0.0.0.0 --allow-root --no-browser

