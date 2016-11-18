CMD_DESCRIPTION="Remove AVD image from the host machine."

athena.usage 1 "<profile>"

profile="$(athena.arg 1)"
athena.pop_args 1

athena.plugin.set_environment "$profile"

image_name="$(athena.plugin.get_tag_name)"
image_version="$(athena.plugin.get_image_version)"

if ! athena.docker.image_exists "$image_name" "$image_version"; then
	athena.fatal "Image for '${profile}' was not found..."
fi

athena.docker.stop_all_containers "$(athena.plugin.get_prefix_for_container_name avd)" --global
athena.docker.rmi "${image_name}:${image_version}"
