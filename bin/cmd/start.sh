port=5555
docker_ip=$(ip addr list eth0|grep "inet "|cut -d' ' -f6|cut -d/ -f1)
redir --laddr=${docker_ip} --lport=$port --caddr=127.0.0.1 --cport=$port &

. /etc/environment

emulator_opts=("-no-window" "-no-audio" "-gpu off" "-verbose")

if [[ -n "$ANDROID_SCREEN_SKIN" ]]; then
	emulator_opts+=("-skin ${ANDROID_SCREEN_SKIN}")
fi

if athena.argument.argument_exists_and_remove "--emulator-opts" "other_opts"; then
	emulator_opts+=("$other_opts")
fi
emulator_opts+=("-qemu -vnc :0")

cmd="emulator64-${ANDROID_ARCH_NAME} -avd ${ANDROID_DEVICE_NAME} ${emulator_opts[@]}"
athena.info "executing command: $cmd"
$cmd &

sleep 2
emulator_pid=$!
athena.plugins.avd.await_virtual_device_boot
athena.plugins.avd.unlock_virtual_device

adb kill-server
wait $emulator_pid
