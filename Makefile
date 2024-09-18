# Variables
VERSION := 1.1
IMAGE_NAME := ImageSmith_v$(VERSION).sif
SANDBOX_DIR := ImageSmith
DEFINITION_FILE := ImageSmith.def

# Assuming COSMOS shared folders are mounted in $(HOME)/sens05_shared on the development computer
# Paths on the development computer where the image will be deployed
DEPLOY_DIR := $(HOME)/sens05_shared/common/software/$(SANDBOX_DIR)/$(VERSION)
MODULE_FILE := $(HOME)/sens05_shared/common/modules/$(SANDBOX_DIR)/$(VERSION).lua

# Path on COSMOS where the image will be stored
SERVER_DIR := /scale/gr01/shared/common/software/$(SANDBOX_DIR)/$(VERSION)

# Phony targets are not actual files, but represent actions
.PHONY: all restart build deploy clean

# Default target - runs all the steps
all: clean restart build deploy

# Restart the sandbox - creates or updates the sandbox
restart:
	@echo "Restarting sandbox..."
	@if [ -d $(SANDBOX_DIR) ]; then \
		echo "Updating existing sandbox..."; \
	else \
		echo "Creating new sandbox..."; \
	fi
	sudo apptainer build --sandbox $(SANDBOX_DIR) $(DEFINITION_FILE)

# Build the .sif image from the definition file or sandbox
build:
	@echo "Building $(IMAGE_NAME) from $(SANDBOX_DIR)..."
	sudo apptainer build $(IMAGE_NAME) $(SANDBOX_DIR)
	@# make sure the run script starts the correct version.
	@sed -i 's/^VERSION=1.0/VERSION=$(VERSION)/' run.sh	
direct:
	@echo "Building from definition file..."
	sudo apptainer build $(IMAGE_NAME) $(DEFINITION_FILE)
	@# make sure the run script starts the correct version.
	@sed -i 's/^VERSION=1.0/VERSION=$(VERSION)/' run.sh

# Deploy the image by copying it to the deployment directory
deploy:
	@echo "Deploying $(IMAGE_NAME) to $(DEPLOY_DIR)..."
	@mkdir -p $(DEPLOY_DIR)
	rsync -avh --no-perms --no-owner --no-group --progress $(IMAGE_NAME) $(DEPLOY_DIR)
	@mkdir -p $(dir $(MODULE_FILE))
	@if [ ! -f $(MODULE_FILE) ]; then \
		$(CURDIR)/generate_module.sh $(SERVER_DIR) $(VERSION) $(SANDBOX_DIR) > $(MODULE_FILE);\
	fi

# Clean up the sandbox and image
clean:
	@echo "Cleaning up..."
	sudo rm -rf $(SANDBOX_DIR)
	sudo rm -f $(IMAGE_NAME)

