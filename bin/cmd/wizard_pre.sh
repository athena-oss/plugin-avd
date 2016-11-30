CMD_DESCRIPTION="Step-by-step guide to create a new device profile."

function _ask()
{
	local question="$1"
	local regex="$2"
	local default="$3"
	local answer=

	while :; do
		athena.print "cyan" "[Plugin] " "$question" 1>&2
		read answer

		if [[ -z "$answer" ]] && [[ -n "$default" ]]; then
			answer="$default"
			break
		elif [[ ! "$answer" =~ $regex ]]; then
			athena.error "Invalid value. Must match the following expression: ${regex}..." 1>&2
			continue
		fi

		break
	done

	echo "$answer"
	echo 1>&2
}

function _get_docker_dir()
{
	echo $(athena.plugin.get_plg_docker_dir "$(athena.plugin.get_plugin)")
}

profile_name="$(_ask "What is the name of the profile ?" "^[a-z0-9-]{1,14}$")"
device_abi="$(_ask "What is the device ABI (default/armeabi-v7a) ?" ".*" "default/armeabi-v7a")"
device_opts="$(_ask "Are there any extra options for the device creation ?" ".*")"

athena.print "cyan" "[Plugin] " "Select a device API target:"
select device_target in $(ls $(_get_docker_dir)/android-*.conf | sed "s/.*android-\([^.]*\).conf/android-\1/"); do
	if [[ -n "$device_target" ]]; then
		break
	fi
done

save_profile="$(_ask "Save the profile (Y/n) ?" "^[Yn]$" "Y")"
if [[ "$save_profile" != "Y" ]]; then
	athena.os.exit
fi

profile_file="$(_get_docker_dir)/${profile_name}.env"

cat <<EOF > $profile_file
ANDROID_DEVICE_NAME=${profile_name}
ANDROID_DEVICE_TARGET=${device_target}
ANDROID_EXTRA_OPTS=--abi $device_abi ${device_opts}
EOF

athena.info "Profile saved to '${profile_file}'..."
