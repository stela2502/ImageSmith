# Singularity Image Builder Facility

This repository provides a facility for building and managing Apptainer images, especially suited for HPC environments where users lack root access.
The facility is based on [this Tutorial](https://github.com/stela2502/Tutorial_Singularity). The assisted image creation discussed in the Tutorial is available as  ``/opt/ImageSmith/create_new_image_builder.sh`` in the image.

This repo includes scripts and a Makefile to automate the creation, running, and deployment of the ImageSmith images.

# This Repository

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

**Deploy:**

The deployment part is a little more complicated as it will also create a lua module to integrate with COSMOS software management system.
In theory you only need to specifiy the path to the module's software directory - adjust the DEPLOY_DIR, MODULE_FILE and SERVER_DIR variables in the ``Makefile``.

### `ImageSmith.def`

The `ImageSmith.def` file is used to build the Apptainer image. It specifies the base image and instructions for setting up the environment within the container.

## Requirements to build this image

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


# Usage of the ImageSmith image

The ImageSmith image enables regular users to build Apptainer images on an HPC system, provided it has internet access. Its key advantage over a raw Apptainer image is that it includes all the necessary logic to create new images from scratch—such as itself.


To create a new image, simply run:
```bash
create_new_image_builder.sh <path-to>/<new-image-name>
```

This command generates the core structure of the image, including a ``Makefile``, as well as ``shell.sh`` and ``run.sh`` scripts, similar to those found in this repository.

The definition file included in the generated image will be the minimal ``Bioinformatics.def`` from the tutorial. This provides JupyterLab with ``nbconvert`` and ``papermill`` extensions, along with R. You can also run R through JupyterLab.

To customize the image, just edit the ``.def`` file to specify which R, Python, or other packages and programs you'd like to install. Then, build the image and you're ready to use or deploy it.

I hope this helps make Apptainer images more accessible and encourages more people to use them regularly!
