function testcase_start_device_and_check_if_running()
{
	$(athena.get_current_script_dir)/athena avd start wxga720-api-24 &
	wait

	bashunit.test.assert_return "_is_avd_ready"
}

function _is_avd_ready()
{
	(athena.docker.logs "athena-plugin-avd-wxga720-api-24-0" | grep "EMULATOR IS READY")
}
