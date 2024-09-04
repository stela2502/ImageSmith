# Singularity Image Builder Facility

This repository provides a facility for building and managing Apptainer images, especially suited for HPC environments where users lack root access. The facility includes scripts and a Makefile to automate the creation, running, and deployment of Apptainer images.

## Overview

The facility includes the following components:

- `shell.sh`: Opens a shell within a writable sandbox.
- `run.sh`: Runs the Apptainer image.
- `Makefile`: Automates the process of building, deploying, and cleaning up the Apptainer image.
- `ImageSmith.def`: Definition file used to build the Apptainer image.

## Components

### `shell.sh`

The `shell.sh` script opens a writable shell in the sandbox environment.

**Usage:**
```
./shell.sh
```

**Description:**
- Checks if the sandbox directory exists.
- Uses `apptainer shell` to open a shell with the sandbox directory mounted as writable.

### `run.sh`

The `run.sh` script runs the built Apptainer image.

**Usage:**
```
./run.sh
```

**Description:**
- Checks if the Apptainer image file exists.
- Uses `apptainer run` to execute the image.

### `Makefile`

The `Makefile` automates building and deploying the Apptainer image.

**Usage:**
```
make        # Runs all steps: restart, build, and deploy
make restart  # Creates or updates the sandbox
make build    # Builds the .sif image from the sandbox
make deploy   # Deploys the image to the deployment directory
make clean    # Cleans up the sandbox and image
```

**Description:**
- `restart`: Creates or updates the sandbox using the definition file (`ImageSmith.def`).
- `build`: Builds the Apptainer image (`ImageSmith_v1.0.sif`) from the sandbox.
- `deploy`: Deploys the built image to the specified deployment directory and creates a module file.
- `clean`: Removes the sandbox and image file.

### `ImageSmith.def`

The `ImageSmith.def` file is used to build the Apptainer image. It specifies the base image and instructions for setting up the environment within the container.

**Definition File:**
```
# Use an Alpine Linux base image
Bootstrap: docker
From: alpine:latest

%environment
    export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

%post
    # Update and install required packages
    apk update && apk add --no-cache \
        build-base \
        go \
        git \
        linux-headers \
        libseccomp-dev \
        squashfs-tools \
        curl \
        apptainer

    git clone https://github.com/stela2502/Tutorial_Singularity.git
    mkdir /opt/ImageSmith
    cp -R Tutorial_Singularity/* /opt/ImageSmith
    ln -s /opt/ImageSmith/create_new_image_builder.sh /usr/bin

%runscript
    echo "Welcome to the ImageSmith apptainer production environment"
```

**Description:**
- **Bootstrap**: Specifies the base image source.
- **%environment**: Sets environment variables for the container.
- **%post**: Installs necessary packages, clones a repository, and sets up the environment.
- **%runscript**: Defines the default command to be executed when the container is run.

## Requirements

- **Apptainer**: Ensure Apptainer is installed on your system.
- **sudo Access**: `shell.sh` and `Makefile` require `sudo` privileges for certain operations.

## Directory Structure

- `ImageSmith.def`: Definition file used to build the sandbox and image.
- `shell.sh`: Script to open a writable shell in the sandbox.
- `run.sh`: Script to run the Apptainer image.
- `Makefile`: Build automation and deployment script.

## Notes

- Update the `SANDBOX_DIR` and `IMAGE_NAME` variables in the Makefile to reflect the desired sandbox and image names.
- Adjust the deployment path (`DEPLOY_DIR`) and server path (`SERVER_DIR`) in the Makefile according to your environment.

## Troubleshooting

- If you encounter issues with `sudo apptainer` commands, ensure you have appropriate permissions and that Apptainer is correctly installed.
- Verify the existence of required directories and files as indicated by error messages from the scripts.

For further customization or support, refer to the [Apptainer documentation](https://apptainer.org/docs/).

