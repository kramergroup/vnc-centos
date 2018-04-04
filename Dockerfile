FROM centos:7

RUN yum -y update && \
    yum -y install epel-release && \
    yum -y groupinstall "X Window System" && \
    yum -y install openbox x11vnc && \
    yum -y install sddm && \
    yum -y install net-tools which xterm && \
    yum -y install urw-fonts && \
    yum clean all

# Install vncproxy
COPY assets/vncd /sbin/vncd

# Configure X11 to run headless w/o graphics card
# Note: edit assets/xorg.conf to change resolution
COPY assets/xorg.conf /etc/X11/xorg.conf
COPY assets/xinitrc /etc/X11/xinit/xinitrc

# Install some additional themes for the window Manager and configuration
COPY assets/sddm-themes /usr/share/sddm/themes
COPY assets/sddm.conf /etc/sddm.conf

# Install openbox assets
COPY assets/openbox/menu.xml /etc/xdg/openbox/menu.xml

# Install VNC boostrap
COPY assets/startvnc.sh /etc/vncd/startvnc.sh

# Copy entrypoint
COPY assets/entrypoint.sh /entrypoint.sh

STOPSIGNAL SIGRTMIN+3
EXPOSE 5900

CMD [ "/entrypoint.sh" ]
