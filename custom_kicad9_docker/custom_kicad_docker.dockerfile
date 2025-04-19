FROM kicad/kicad:9.0

# Document the image
LABEL description="Custom KiCad 9 Docker image based on official image"

# Create directory for KiCad configuration using the current user's home directory
RUN mkdir -p /home/kicad/.config/kicad/9.0/

# Copy kicad_common.json from host to container
COPY kicad_common.json /home/kicad/.config/kicad/9.0/kicad_common.json

# Install git if not already present (needed for cloning repositories)
USER root
RUN apt-get update && apt-get install -y git && apt-get clean

# Clone the 3D Models repository
RUN mkdir -p /usr/share && \
    git clone https://github.com/ionutms/3D_Models_Vault.git /usr/share/3D_Models_Vault

# Switch back to the default user
USER kicad