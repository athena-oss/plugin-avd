CMD_DESCRIPTION="Stops the AVD."

if athena.arg_exists "--help"; then
	athena.argument.set_arguments
fi

athena.usage 1 "<profile> [--help|<options>...]" "$(cat <<EOF
   <profile>            ; Profile with which you started the server.
   [--vnc-port=<port>]  ; VNC port with which you started the server.
   [--adb-port=<port>]  ; ADB port with which you started the server.
EOF
)"

profile=$(athena.arg 1)
athena.plugin.set_environment "$profile"

instance_id=
if athena.argument.argument_exists_and_remove "--adb-port" "adb_port"; then
	instance_id="${instance_id}${adb_port}"
fi

if athena.argument.argument_exists_and_remove "--vnc-port" "vnc_port"; then
	instance_id="${instance_id}${vnc_port}"
fi

if [[ -n "$instance_id" ]]; then
	athena.os.set_instance "$instance_id"
fi

if ! athena.docker.is_current_container_running; then
	athena.fatal "AVD container '$(athena.plugin.get_container_name)' is not running..."
fi

athena.docker.stop_container
