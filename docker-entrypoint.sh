#!/usr/bin/env sh

#
# ENV vars will take precedence if are passed along with corresponding flags
#
# e.g. docker run -e WATCH_DIR=/watch zbi192/docker-alpine-transmission -c /flag_watch
#

rundir=${RUNDIR:-/var/run/transmission}
pidfile=${PIDFILE:-${rundir}/transmission.pid}
config_dir=${CONFIG_DIR:-/var/lib/transmission/config}
download_dir=${DOWNLOAD_DIR:-/var/lib/transmission/downloads}
watch_dir=${WATCH_DIR:-/var/lib/transmission/watch}
runas_user=${RUNAS_USER:-transmission:transmission}

# if command starts with an option, prepend transmission-daemon
if [ "${1:0:1}" = '-' ]; then
	set -- transmission-daemon "$@"
fi

_check_config() {	

	# use default config directory in case no config-dir option was passed
	if ! $(echo "${TRANSMISSION_OPTIONS}" | grep -q -e '\B-g' -e '\B--config-dir'); then
		echo "=== config_dir option not passed -> adding it"
		TRANSMISSION_OPTIONS="${TRANSMISSION_OPTIONS} -g ${config_dir}"
	else
		# config-dir option was passed
		if [ -n "${CONFIG_DIR:-}" ]; then
			echo "=== config_dir option was passed along with ENV -> overriding it"
			# ENV vars will take precedence
			options=$(echo "${TRANSMISSION_OPTIONS}" | sed 's/-g\s\+\S\+//g;s/--config-dir\(\s\+\|=\)\S\+//g')
			TRANSMISSION_OPTIONS="${options} -g ${config_dir}"
		else
		# option is passed but no ENV, so we need to update local variable
			config_dir=$(echo "${TRANSMISSION_OPTIONS}" | sed 's/.*-g\s\+\(\S\+\).*/\1/g;s/.*--config-dir\(\s\+\|=\)\(\S\+\).*/\2/g')	
		fi	
	fi

	# use default download directory in case no download-dir option was passed
	if ! $(echo "${TRANSMISSION_OPTIONS}" | grep -q -e '\B-w' -e '\B--download-dir'); then
		echo "=== download_dir option not passed -> adding it"
		TRANSMISSION_OPTIONS="${TRANSMISSION_OPTIONS} -w ${download_dir}"
	else
		# download-dir option was passed
		if [ -n "${DOWNLOAD_DIR:-}" ]; then
			echo "=== download_dir option was passed along with ENV -> overriding it"
			# ENV vars will take precedence
			options=$(echo "${TRANSMISSION_OPTIONS}" | sed 's/-w\s\+\S\+//g;s/--download-dir\(\s\+\|=\)\S\+//g')
			TRANSMISSION_OPTIONS="${options} -w ${download_dir}"
		else
		# option is passed but no ENV, so we need to update local variable
			download_dir=$(echo "${TRANSMISSION_OPTIONS}" | sed 's/.*-w\s\+\(\S\+\).*/\1/g;s/.*--download-dir\(\s\+\|=\)\(\S\+\).*/\2/g')	
		fi	
	fi

	# use default watch directory in case no watch-dir option was passed
	if ! $(echo "${TRANSMISSION_OPTIONS}" | grep -q -e '\B-c' -e '\B--watch-dir'); then
		echo "=== watch_dir option not passed -> adding it"
		TRANSMISSION_OPTIONS="${TRANSMISSION_OPTIONS} -c ${watch_dir}"
	else
		# watch-dir option was passed
		if [ -n "${WATCH_DIR:-}" ]; then
			echo "=== watch_dir option was passed along with ENV -> overriding it"
			# ENV vars will take precedence
			options=$(echo "${TRANSMISSION_OPTIONS}" | sed 's/-c\s\+\S\+//g;s/--watch-dir\(\s\+\|=\)\S\+//g')
			TRANSMISSION_OPTIONS="${options} -c ${watch_dir}"
		else
		# option is passed but no ENV, so we need to update local variable
			watch_dir=$(echo "${TRANSMISSION_OPTIONS}" | sed 's/.*-c\s\+\(\S\+\).*/\1/g;s/.*--watch-dir\(\s\+\|=\)\(\S\+\).*/\2/g')	
		fi		
	fi

	# use default pidfile in case no pidfile option was passed
	if ! $(echo "${TRANSMISSION_OPTIONS}" | grep -q -e '\B-x' -e '\B--pid-file'); then
		echo "=== pidfile option not passed -> adding it"
		TRANSMISSION_OPTIONS="${TRANSMISSION_OPTIONS} -x ${pidfile}"
	else
		# pidfile option was passed
		if [ -n "${PIDFILE:-}" ]; then
			echo "=== pidfile option was passed along with ENV -> overriding it"
			# ENV vars will take precedence
			options=$(echo "${TRANSMISSION_OPTIONS}" | sed 's/-x\s\+\S\+//g;s/--pid-file\(\s\+\|=\)\S\+//g')
			TRANSMISSION_OPTIONS="${options} -x ${pidfile}"
		fi		
	fi

	# check allowed access list
	if ! $(echo "${TRANSMISSION_OPTIONS}" | grep -q -e '\B-a ' -e '\B--allowed'); then
		echo "=== access option not passed -> adding it"
		TRANSMISSION_OPTIONS="${TRANSMISSION_OPTIONS} --allowed=*"
	fi

	echo "=== creating directories"
	# create directories
	for dir in "$rundir" "$config_dir" "$download_dir" "$watch_dir"; do
		echo "=== creating ${dir}"
		mkdir -p "${dir}"
		if [ -n "${runas_user:-}" ]; then
			chown -R ${runas_user} "${dir}"
		fi
	done	
}

if [ "$1" = 'transmission-daemon' ]; then
	shift
	TRANSMISSION_OPTIONS="-f ${TRANSMISSION_OPTIONS} $@"
	_check_config
	echo "==="
	echo "=== Starting transmission-daemon"
	echo "=== Options: ${TRANSMISSION_OPTIONS}"
	echo "==="
	exec su-exec "${runas_user}" transmission-daemon ${TRANSMISSION_OPTIONS}
fi

exec "$@"