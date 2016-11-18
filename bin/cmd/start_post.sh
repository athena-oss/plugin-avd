failcounter=0
timeout_in_sec=600
container_name="$(athena.plugin.get_container_name)"

athena.info "Waiting for device '${container_name}' to be ready..."

while :; do
	if athena.docker.logs "$(athena.plugin.get_container_name)" | grep -i "EMULATOR IS READY" &>/dev/null; then
		echo
		break
	fi

	if [[ $failcounter -gt $timeout_in_sec ]]; then
		athena.fatal "Timeout ($timeout_in_sec seconds) reached; failed to start device"
	fi

	echo -n "."
	let "failcounter += 1"
	sleep 1
done
