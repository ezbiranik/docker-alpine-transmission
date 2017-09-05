# docker-alpine-transmission
Docker image based on Alpine Linux with transmission-daemon

Original idea taken from https://github.com/antoineco/transmission-daemon-docker

#### How to use `docker-alpine-transmission` image?

Transmission daemon can be configured at run time using configuration flags, which can be passed either directly as the container command or via the `TRANSMISSION_OPTIONS` environment variable.

For a list of all available options, please run docker run --rm zbi192/docker-alpine-transmission -h or check the [project documentation](https://trac.transmissionbt.com/).

The `--foreground` flag is set automatically by the startup script in order to prevent the process from running as a deamon.

Besides, the following default directories are created and used automatically if `--config-dir` is not set and `settings.json` file is not present there:

Directory | Override env var | Used for flag
----------|------------------|--------------
/var/lib/transmission/config | config_dir | --config-dir
/var/lib/transmission/downloads | download_dir | --download-dir
/var/lib/transmission/watch | watch_dir | --watch-dir
/var/run/transmission | rundir| --pid-file

##### Example usage
`
$ docker run \
    -v ./data:/opt/td-data -e config_dir=/opt/td-data/config \
    -e download_dir=/opt/td-data/mydownloads -e watch_dir=/opt/td-data/watch\
    -p 9090:9090 \
    zbi192/docker-alpine-transmission \
        --auth \
        --username foo \
        --password bar \
        --port 9090
`        
