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
device_skin="$(_ask "What is the device skin name (WXGA720) ?" ".*" "WXGA720")"

athena.print "cyan" "[Plugin] " "Select an API level:"
select device_api_level in $(ls $(_get_docker_dir)/api-*.conf | sed "s/.*api-\([^.]*\).conf/\1/"); do
	if [[ -n "$device_api_level" ]]; then
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
ANDROID_ABI=${device_abi}
ANDROID_SCREEN_SKIN=${device_skin}
ANDROID_API_LEVEL=${device_api_level}
EOF

athena.info "Profile saved to '${profile_file}'..."
