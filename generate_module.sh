#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <path> <version> <name>"
    exit 1
fi

# Variables from arguments
PATH_ARG=$1
VERSION=$2
IMAGE_NAME=$3

# Define the output module file path
MODULE_FILE="modules/${IMAGE_NAME}/${VERSION}.lua"

# Ensure the directory exists
mkdir -p "$(dirname "$MODULE_FILE")"

# Create the module file
cat <<EOF 
help([[This is the ImageSmith - an apptainer image to build apptainer images]])

local version = "$VERSION"
local base = pathJoin("$PATH_ARG")


-- this happens at load
execute{cmd="singularity run -B/scale,/sw ".. base.. "/${IMAGE_NAME}_v".. version ..".sif",modeA={"load"}}


-- this happens at unload
-- could also do "conda deactivate; " but that should be part of independent VE module

-- execute{cmd="exit",modeA={"load"}}

whatis("Name         : ${IMAGE_NAME} singularity image")
whatis("Version      : ${IMAGE_NAME} $VERSION")
whatis("Category     : Image")
whatis("Description  : Singularity image providing a jupyter lab as default entry point and the create_new_image_builder.sh image setup tool")
whatis("Installed on : $(date +'%d/%m/%Y') ")
whatis("Modified on  : --- ")
whatis("Installed by : \`whomai\`")

family("images")

-- Change Module Path
--local mroot = os.getenv("MODULEPATH_ROOT")
--local mdir = pathJoin(mroot,"Compiler/anaconda",version)
--prepend_path("MODULEPATH",mdir)
--
EOF


