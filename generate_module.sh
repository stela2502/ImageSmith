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

-- check if the possible bind path's are available on this system(open or closed COSMOS)
-- Function to check if a path exists on the system
function path_exists(path)
   local file = io.open(path, "r")
   if file then
      file:close()
      return true
   else
      return false
   end
end

-- Define possible mount points
local mounts = {
    "/local",
    "/projects",
    "/scale",
    "/sw"
}

-- Prepare the bind paths environment variable
local bind_paths = ""

-- Check each mount point and only add existing ones
for _, path in ipairs(mounts) do
    if path_exists(path) then
        if bind_paths == "" then
            bind_paths = path  -- First valid path
        else
            bind_paths = bind_paths .. "," .. path  -- Append valid path
        end
    end
end

-- If any valid bind paths exist, set the environment variable for Apptainer
if bind_paths ~= "" then
    bind_paths = "-B "..bind_paths
end

-- this happens at load
execute{cmd="singularity run "..bind_paths.." --cleanenv ".. base.. "/${IMAGE_NAME}_v".. version ..".sif",modeA={"load"}}


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


