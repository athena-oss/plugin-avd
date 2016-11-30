# AVD Plugin [![Build Status](https://travis-ci.org/athena-oss/plugin-avd.svg?branch=master)](https://travis-ci.org/athena-oss/plugin-avd)

This plugins provides a straightforward API to manage Android Virtual Devices.

You can easily use this plugin in your local development machine or in a CI/CD pipeline.

## How to Install ?

To install it simply run the following command :

```bash
$ athena plugins install avd https://github.com/athena-oss/plugin-avd.git
```

or

* On MAC OSX using [Homebrew](http://brew.sh/) :
```bash
$ brew tap athena-oss/tap
$ brew install plugin-avd
```

Read the [Documentation](http://athena-oss.github.io/plugin-avd) on using the [Athena](https://github.com/athena-oss/athena) AVD plugin.

## How to Use ?

This plugin provides the following commands:

### start - Starts the AVD

```bash
$ athena avd start <profile> [--help|<options>...]

$ # e.g. start one of the pre-defined devices
$ athena avd start wxga720-api-24

$ # e.g. start a pre-defined device and open a VNC at port 9001
$ athena avd start wxga720-api-24 --vnc-port=9001
```

### stop - Stops the AVD

```bash
$ athena avd stop <profile> [--help|<options>...]

$ # e.g. stop a device that was started without any extra options
$ athena avd stop wxga720-api-24

$ # e.g. stop a device that was started with a VNC port at 9001
$ athena avd stop wxga720-api-24 --vnc-port=9001
```

### logs - Retrieve AVD logs

```bash
$ athena avd logs <profile> [--help|<options>...]

$ # e.g. get logs from a device that was started without any extra options
$ athena avd logs wxga720-api-24

$ # e.g. get logs from a device that was started with a VNC port at 9001
$ athena avd logs wxga720-api-24 --vnc-port=9001
```

### terminal - Starts a shell inside the AVD container

```bash
$ athena avd terminal <profile> [--help|<options>...]

$ # e.g. open a shell in a device that was started without any extra options
$ athena avd terminal wxga720-api-24

$ # e.g. open a shell in a device that was started with a VNC port at 9001
$ athena avd terminal wxga720-api-24 --vnc-port=9001
```

### cleanup - Remove AVD image from the host machine

```bash
$ athena avd cleanup <profile>
```

### wizard - Step-by-step guide to create a new device profile

```bash
$ athena avd wizard
```

## Profiles Explained

* `android-<level>.conf` - Contains the Android SDK information for a given API level
* `<name>.env` - Contains the device ABI, the name, skin information and which API level to use (based on the file above)

Both of these files are stored inside [Athena](https://github.com/athena-oss/athena) plugins/avd/docker directory.

As soon as you add a new `.env` file inside the directory, mentioned above, it will be available for you automatically.

If you your device uses a API level and the `android-<level>.conf` does not exist, then you need to create it, otherwise the device will fail during build time.

You can also use `athena avd wizard` to create a device profile step-by-step.

## Contributing

Checkout our guidelines on how to contribute in [CONTRIBUTING.md](CONTRIBUTING.md).

## Versioning

Releases are managed using github's release feature. We use [Semantic Versioning](http://semver.org) for all
the releases. Every change made to the code base will be referred to in the release notes (except for
cleanups and refactorings).

## License

Licensed under the [Apache License Version 2.0 (APLv2)](LICENSE).
