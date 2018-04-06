FROM centos:7

ENV SLIM_VERSION=1.3.6

RUN yum -y update && \
    yum -y install epel-release && \
    yum -y groupinstall "X Window System" && \
    yum -y install openbox x11vnc && \
    yum -y install net-tools which xterm && \
    yum -y install urw-fonts && \
    yum clean all

# Install slim
RUN curl -O -L https://github.com/kramergroup/slim/releases/download/v1.3.6-p1/slim-1.3.6-0.i686.rpm && \
    yum -y install slim-1.3.6-0.i686.rpm && \
    rm slim-1.3.6-0.i686.rpm

# Important for slim to find its shared library
ENV LD_LIBRARY_PATH /usr/local/lib:/usr/lib:${LD_LIBRARY_PATH}

# Install vncd
RUN mkdir -p /install && \
    cd /install && \
    curl -O -L https://github.com/kramergroup/vncd/releases/download/v0.1.2/vncd-v0.1.2.tar.gz && \
    tar xzf vncd-v0.1.2.tar.gz -C /sbin vncd && \
    cd / && rm -rf /install
# COPY assets/vncd /sbin/vncd

# Configure X11 to run headless w/o graphics card
# Note: edit assets/xorg.conf to change resolution
COPY assets/xorg.conf /etc/X11/xorg.conf
COPY assets/xinitrc /etc/X11/xinit/xinitrc

# Install some additional themes for the window Manager and configuration
COPY assets/slim.conf /etc/slim.conf

# Install openbox assets
COPY assets/openbox/menu.xml /etc/xdg/openbox/menu.xml

# Install VNC boostrap
COPY assets/startvnc.sh /etc/vncd/startvnc.sh

# Copy entrypoint
COPY assets/entrypoint.sh /entrypoint.sh

STOPSIGNAL SIGRTMIN+3
EXPOSE 5900

CMD [ "/sbin/vncd" ]
