port=5555
docker_ip=$(ip addr list eth0|grep "inet "|cut -d' ' -f6|cut -d/ -f1)
redir --laddr=${docker_ip} --lport=$port --caddr=127.0.0.1 --cport=$port &

emulator_opts=(-no-window -no-audio -gpu off -verbose -netdelay none -netspeed full)

if athena.argument.argument_exists_and_remove "--emulator-opts" "other_opts"; then
	emulator_opts+=("$other_opts")
fi

if athena.argument.argument_exists_and_remove "--vnc-port"; then
	emulator_opts+=(-qemu -vnc :0)
fi

emulator_name="emulator64-arm"
athena.argument.argument_exists_and_remove "--emulator-name" "emulator_name"

cmd="${emulator_name} -avd ${ANDROID_DEVICE_NAME} ${emulator_opts[@]}"
athena.info "executing command: $cmd"
$cmd &
emulator_pid=$!
sleep 2
athena.plugins.avd.await_virtual_device_boot
athena.plugins.avd.unlock_virtual_device

adb kill-server
wait $emulator_pid
