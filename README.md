# vnc-centos

This container provides a [VNC](https://en.wikipedia.org/wiki/Virtual_Network_Computing)-enabled container based on CentOS 7.

The container is meant to serve a basis for containerised X11 applications. It has the following features:

- Graphical login
- Openbox minimal Window Manager

## Usage

The container runs a VNC server on port 5900. This port has to be mapped for VNC clients to access it:

```bash
docker run -d -p 5900:5900 kramergroup/vnc-centos x11-novnc
```

## User login

A connecting VNC client will be presented with a graphical login screen, but no users are configured out-of-the-box. Hence, login will
always fail.

### Adding Users

The usual `useradd/passwd` feature of CentOS is available. To add a user to a running container with name `vnc-centos` use:

```bash
  docker exec -it vnc-centos useradd <username>
  docker exec -it vnc-centos passwd <username>
```

## Openbox Window Manager

The container uses the [Openbox](https://en.wikipedia.org/wiki/Openbox) window manager.
Openbox is lightweight and easy to configure (via xml files). Programs are started using a right-click, which produces a menu with options.
