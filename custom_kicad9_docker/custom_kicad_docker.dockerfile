FROM kicad/kicad:9.0

# Document the image
LABEL description="Custom KiCad 9 Docker image based on official image"

# Create directory for KiCad configuration using the current user's home directory
RUN mkdir -p /home/kicad/.config/kicad/9.0/

# Copy kicad_common.json from host to container
COPY kicad_common.json /home/kicad/.config/kicad/9.0/kicad_common.json

# Create directory for Gruvbox theme colors
RUN mkdir -p /home/kicad/.local/share/kicad/9.0/3rdparty/colors/com_github_alexanderbrevig_kicad-gruvbox-theme/

# Copy Gruvbox.json from host to container
COPY Gruvbox.json /home/kicad/.local/share/kicad/9.0/3rdparty/colors/com_github_alexanderbrevig_kicad-gruvbox-theme/Gruvbox.json

# Create directory for Gruvbox theme resources
RUN mkdir -p /home/kicad/.local/share/kicad/9.0/3rdparty/resources/com_github_alexanderbrevig_kicad-gruvbox-theme/

# Copy icon.png from host to container
COPY icon.png /home/kicad/.local/share/kicad/9.0/3rdparty/resources/com_github_alexanderbrevig_kicad-gruvbox-theme/icon.png

# Install git if not already present (needed for cloning repositories)
USER root
RUN apt-get update && apt-get install -y git && apt-get clean

# Clone the 3D Models repository
RUN mkdir -p /usr/share && \
    git clone https://github.com/ionutms/3D_Models_Vault.git /usr/share/3D_Models_Vault

# Switch back to the default user
USER kicad