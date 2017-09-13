# docker-alpine-transmission

[![Docker Automated build](https://img.shields.io/docker/automated/ezbiranik/docker-alpine-transmission.svg?maxAge=2592000)](https://hub.docker.com/r/ezbiranik/docker-alpine-transmission/)

Docker image based on Alpine Linux with transmission-daemon

Original idea taken from https://github.com/antoineco/transmission-daemon-docker

#### How to use `docker-alpine-transmission` image?

Transmission daemon can be configured at run time using configuration flags, which can be passed either directly as the container command or via the `TRANSMISSION_OPTIONS` environment variable.

For a list of all available options, please run `docker run --rm ezbiranik/docker-alpine-transmission -h` or check the [project documentation](https://trac.transmissionbt.com/).

The `--foreground` flag is set automatically by the startup script in order to prevent the process from running as a deamon.

#### Environment variables

`TRANSMISSION_OPTIONS` - command line arguments passed to transmission-daemon (can include --config-dir, --watch-dir, etc...).

`CONFIG_DIR` - Where to look for configuration files

`DOWNLOAD_DIR` - Where to save downloaded data

`WATCH_DIR` - Where to watch for new .torrent files


##### Example usage
```
$ docker run \
    -v /data:/opt/td-data -e CONFIG_DIR=/opt/td-data/config \
    -e DOWNLOAD_DIR=/opt/td-data/downloads -e WATCH_DIR=/opt/td-data/watch\
    -p 9090:9090 \
    ezbiranik/docker-alpine-transmission \
        --auth \
        --username foo \
        --password bar \
        --port 9090
```     
