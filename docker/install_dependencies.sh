# load the environmnent
. /etc/environment

# install SDK
wget -qO- "$ANDROID_SDK_URL" | tar -zx -C /opt
echo y | android update sdk --no-ui --all --filter platform-tools --force

# install dependencies for emulator
echo y | android update sdk --no-ui --all -t `android list sdk --all | grep "SDK Platform Android ${ANDROID_VERSION}, API ${ANDROID_API_LEVEL}" | awk -F'[^0-9]*' '{print $2}'`
echo y | android update sdk --no-ui --all -t `android list sdk --all | grep "$ANDROID_SDK_STRING" | awk -F'[^0-9]*' '{print $2}'`
echo y | android update sdk --no-ui --all --filter sys-img-${ANDROID_ARCH_IMAGE}-android-${ANDROID_API_LEVEL} --force
