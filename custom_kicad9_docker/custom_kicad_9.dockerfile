FROM kicad/kicad:9.0

# Document the image
LABEL description="Custom KiCad 9 Docker image based on official image"

# Install git if not already present (needed for cloning repositories)
USER root
RUN apt-get update && apt-get install -y git && apt-get clean

# Clone the 3D Models repository
RUN mkdir -p /usr/share && \
    git clone https://github.com/ionutms/3D_Models_Vault.git /usr/share/3D_Models_Vault

# Create entrypoint script inside the container
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'cd /usr/share/3D_Models_Vault && git pull' >> /entrypoint.sh && \
    echo 'exec "$@"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

# Set the entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Switch back to the default user
USER kicad