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

# Add KiCad 9 PPA and install KiCad with retry mechanism and
# Clone the 3D Models repository
RUN for i in {1..5}; do \
        add-apt-repository ppa:kicad/kicad-9.0-releases && break || \
        echo "Retrying PPA addition in 5 seconds..." && sleep 5; \
    done && \
    apt-get update && \
    apt-get install -y kicad && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /usr/share && \
        git clone https://github.com/ionutms/3D_Models_Vault.git /usr/share/3D_Models_Vault

# Set up startup script
RUN mkdir -p /root/.vnc && \
echo "#!/bin/bash\n\
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
vncserver :1 -geometry 1024x600 -depth 32 -SecurityTypes VncAuth -localhost no\n\
\n\
# Keep the script running\n\
tail -f /dev/null\n\
" > /usr/local/bin/start-vnc.sh && \
chmod +x /usr/local/bin/start-vnc.sh

# Expose VNC port
EXPOSE 5901

# Start the VNC server
CMD ["/usr/local/bin/start-vnc.sh"]