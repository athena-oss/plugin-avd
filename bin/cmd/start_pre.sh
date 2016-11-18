CMD_DESCRIPTION="Starts the AVD."

if athena.arg_exists "--help"; then
	athena.argument.set_arguments
fi

athena.usage 1 "<profile> [--help|<options>...]" "$(cat <<'EOF'
   [--emulator-opts="<args>..."] ; Extra options for the emulator.
   [--vnc-port=<port>]           ; Port where the VNC will be listening at for connections.
   [--adb-port=<port>]           ; Port where the android debug bridge will be listening at.
   [--list-profiles]             ; Get a list of available profiles.
EOF
)"

if athena.arg_exists "--list-profiles"; then
	athena.info "Available profiles:"
	for file in $(athena.plugin.get_plg_docker_dir "$(athena.plugin.get_plg)")/*.env; do
		athena.info "* $(basename ${file%.env})"
	done
	athena.os.exit
fi

profile=$(athena.arg 1)
athena.pop_args 1

athena.plugin.set_environment "$profile"
athena.docker.add_daemon

instance_id=
if athena.argument.argument_exists_and_remove "--adb-port" "adb_port"; then
	athena.docker.add_option "-p ${adb_port}:5555"
	instance_id="${instance_id}${adb_port}"
fi

if athena.argument.argument_exists_and_remove "--vnc-port" "vnc_port"; then
	athena.docker.add_option "-p ${vnc_port}:5900"
	instance_id="${instance_id}${vnc_port}"
fi

if [[ -n "$instance_id" ]]; then
	athena.os.set_instance "$instance_id"
fi

if athena.docker.is_current_container_running; then
	athena.fatal "There's already an AVD with the same profile running ('$(athena.plugin.get_container_name)')..."
fi
