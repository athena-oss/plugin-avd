FROM java:8-jdk

ARG ANDROID_DEVICE_NAME
ARG ANDROID_ABI
ARG ANDROID_SCREEN_SKIN
ARG ANDROID_API_LEVEL
ARG ADNROID_EXTRA_OPTS=""

ENV ANDROID_DEVICE_NAME $ANDROID_DEVICE_NAME
ENV ANDROID_HOME /opt/android-sdk-linux
ENV ANDROID_SDK_ROOT $ANDROID_HOME
ENV PATH $PATH:${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools

# Install dependencies
RUN apt-get update && apt-get install -y redir libc6-i386 lib32stdc++6 wget && \
    apt-get clean && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Needed to be able to run VNC - bug of Android SDK
RUN mkdir -p ${ANDROID_HOME}/tools/keymaps && touch ${ANDROID_HOME}/tools/keymaps/en-us

# install dependencies
RUN mkdir -p /root/.android
COPY api-${ANDROID_API_LEVEL}.conf /etc/environment
COPY install_dependencies.sh /tmp/install_dependencies.sh
RUN /tmp/install_dependencies.sh

# create avd
RUN echo n | android create avd -t android-${ANDROID_API_LEVEL} -n ${ANDROID_DEVICE_NAME} --abi ${ANDROID_ABI} -s ${ANDROID_SCREEN_SKIN} ${ANDROID_EXTRA_OPTS}

# Device ADB Console
EXPOSE 5555

# Device VNC
EXPOSE 5900
