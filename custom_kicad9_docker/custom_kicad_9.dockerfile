FROM kicad/kicad:9.0

# Document the image
LABEL description="Custom KiCad 9 Docker image with InteractiveHtmlBom support"

# Switch to root to install packages
USER root

# Update package list and install all necessary packages for InteractiveHtmlBom
RUN apt-get update && \
    apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python3-tk \
    python3-wxgtk4.0 \
    python3-numpy \
    python3-lxml \
    xvfb \
    git \
    wget \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create symbolic links for python
RUN ln -sf /usr/bin/python3 /usr/bin/python && \
    ln -sf /usr/bin/pip3 /usr/bin/pip

# Clone InteractiveHtmlBom repository to a system location
RUN git clone --depth 1 https://github.com/openscopeproject/InteractiveHtmlBom.git /opt/InteractiveHtmlBom && \
    chmod -R 755 /opt/InteractiveHtmlBom

# Create a wrapper script for easier execution
RUN echo '#!/bin/bash' > /usr/local/bin/generate_ibom && \
    echo 'export DISPLAY=${DISPLAY:-:99}' >> /usr/local/bin/generate_ibom && \
    echo 'if ! pgrep -x "Xvfb" > /dev/null; then' >> /usr/local/bin/generate_ibom && \
    echo '  Xvfb :99 -screen 0 1024x768x24 > /dev/null 2>&1 &' >> /usr/local/bin/generate_ibom && \
    echo '  XVFB_PID=$!' >> /usr/local/bin/generate_ibom && \
    echo '  sleep 2' >> /usr/local/bin/generate_ibom && \
    echo '  trap "kill $XVFB_PID 2>/dev/null || true" EXIT' >> /usr/local/bin/generate_ibom && \
    echo 'fi' >> /usr/local/bin/generate_ibom && \
    echo 'python3 /opt/InteractiveHtmlBom/InteractiveHtmlBom/generate_interactive_bom.py "$@"' >> /usr/local/bin/generate_ibom && \
    chmod +x /usr/local/bin/generate_ibom

# Verify installations and InteractiveHtmlBom availability
RUN python3 --version && \
    pip3 --version && \
    which xvfb-run && \
    git --version && \
    ls -la /opt/InteractiveHtmlBom/InteractiveHtmlBom/generate_interactive_bom.py

# Switch back to the default user
USER kicad

# Set environment variables
ENV PYTHONPATH="/opt/InteractiveHtmlBom"
ENV PATH="/usr/local/bin:$PATH"