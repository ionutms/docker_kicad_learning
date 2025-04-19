FROM ubuntu:24.04

# Avoid prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install desktop environment, VNC server, basic utilities, and software-properties-common for add-apt-repository
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    tigervnc-standalone-server \
    tigervnc-common \
    x11-xserver-utils \
    xterm \
    firefox \
    dbus-x11 \
    software-properties-common \
    wget \
    gnupg \
    ca-certificates \
    git \
    && apt-get clean

# Add KiCad 9 PPA and install KiCad with retry mechanism
RUN for i in {1..5}; do \
        add-apt-repository ppa:kicad/kicad-9.0-releases && break || \
        echo "Retrying PPA addition in 5 seconds..." && sleep 5; \
    done && \
    apt-get update && \
    apt-get install -y kicad && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create directory for KiCad configuration
RUN mkdir -p /root/.config/kicad/9.0/

# Copy kicad_common.json from host to container
COPY kicad_common.json /root/.config/kicad/9.0/kicad_common.json

# Create directory for KiCad configuration
RUN mkdir -p /root/.local/share/kicad/9.0/3rdparty/colors/com_github_alexanderbrevig_kicad-gruvbox-theme/

# Copy Gruvbox.json from host to container
COPY Gruvbox.json /root/.local/share/kicad/9.0/3rdparty/colors/com_github_alexanderbrevig_kicad-gruvbox-theme/Gruvbox.json

# Create directory for KiCad configuration
RUN mkdir -p /root/.local/share/kicad/9.0/3rdparty/resources/com_github_alexanderbrevig_kicad-gruvbox-theme/

# Copy icon.png from host to container
COPY icon.png /root/.local/share/kicad/9.0/3rdparty/resources/com_github_alexanderbrevig_kicad-gruvbox-theme/icon.png

# Clone the 3D Models repository
RUN mkdir -p /usr/share && \
    git clone https://github.com/ionutms/3D_Models_Vault.git /usr/share/3D_Models_Vault

# Set up startup script
RUN mkdir -p /root/.vnc
RUN echo "#!/bin/bash\n\
# Set VNC password\n\
mkdir -p /root/.vnc\n\
echo 'password' | vncpasswd -f > /root/.vnc/passwd\n\
chmod 600 /root/.vnc/passwd\n\
\n\
# Create proper xstartup script\n\
cat > /root/.vnc/xstartup << 'EOL'\n\
#!/bin/sh\n\
# Start up the standard system desktop\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
\n\
/usr/bin/startxfce4\n\
\n\
[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup\n\
[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources\n\
EOL\n\
\n\
chmod +x /root/.vnc/xstartup\n\
\n\
# Start VNC server\n\
vncserver :1 -geometry 1920x1080 -depth 32 -SecurityTypes VncAuth -localhost no\n\
\n\
# Keep the script running\n\
tail -f /dev/null\n\
" > /usr/local/bin/start-vnc.sh

RUN chmod +x /usr/local/bin/start-vnc.sh

# Expose VNC port
EXPOSE 5901

# Start the VNC server
CMD ["/usr/local/bin/start-vnc.sh"]