#!/bin/bash
set -e

# Run fixuid (handles user/group mapping between host and container)
if command -v fixuid >/dev/null 2>&1; then
    eval "$(fixuid -q)"
fi

# Source native ROS 2 base environment
if [ -f "/opt/ros/${ROS_DISTRO}/setup.bash" ]; then
    source "/opt/ros/${ROS_DISTRO}/setup.bash"
else
    echo "Warning: /opt/ros/${ROS_DISTRO}/setup.bash not found."
fi

# Ensure workspace context is initialized properly
if [ -n "${WORKSPACE}" ]; then
    cd "${WORKSPACE}"

    # Detect if workspace is completely built
    if [ ! -d "build" ] || [ ! -d "install" ]; then
        echo "No workspace build detected. Updating rosdep and building with colcon..."
        
        # Update rosdep databases safely
        rosdep update --rosdistro "${ROS_DISTRO}"
        
        # Install missing package dependencies declared in the src directory
        rosdep install --from-paths src --ignore-src -r -y --rosdistro "${ROS_DISTRO}"
        
        # Compile packages using standard symlink layout
        colcon build --symlink-install
    else
        echo "Workspace already built. Skipping colcon compilation step."
    fi

    # Source the compiled workspace packages into active path profiles
    if [ -f "${WORKSPACE}/install/setup.bash" ]; then
        source "${WORKSPACE}/install/setup.bash"
    else
        echo "Warning: install/setup.bash not found even after compilation."
    fi
else
    echo "Warning: WORKSPACE variable not set."
fi

# Pass execution flow to target container processes (CMD/bash)
exec "$@"