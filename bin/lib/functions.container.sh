function athena.plugins.avd.await_virtual_device_boot()
{
	if ! ps -ef | grep -n "emulator64-${ANDROID_ARCH_NAME}" | grep -v "grep" >/dev/null; then
		echo "Cannot wait for device. No devices were found running..." 1>&2
		exit 1
	fi

	bootanim=
	failcounter=0
	echo "Waiting for device to boot. This may take several minutes..."
	while [[ ! "$bootanim" =~ "stopped" ]]; do
		bootanim=$(adb -e wait-for-device shell getprop init.svc.bootanim 2>&1)
		if [[ "$bootanim" =~ "not found" ]]; then
			let "failcounter += 1"
			if [[ $failcounter -gt 3 ]]; then
				echo "Failed to start emulator" 1>&2
				exit 1
			fi
		fi
		echo -n "."
		sleep 1
	done
	echo "EMULATOR IS READY TO USE"
}

function athena.plugins.avd.unlock_virtual_device()
{
	adb shell input keyevent 82
}
