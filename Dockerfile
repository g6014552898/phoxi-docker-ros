FROM ros:melodic-perception

USER root

RUN set -eux \
    && mkdir -p /root/catkin_ws/src && cd /root/catkin_ws/src && \
    /bin/bash -c "source /opt/ros/melodic/setup.bash && catkin_init_workspace && \
    cd /root/catkin_ws && catkin_make" \
    && apt-get update -y \
    && apt-get install -y -q software-properties-common && apt-add-repository universe \
    && apt-get update -y \
    # phoxicontrol dependencies (gui...)
    && apt install -y avahi-utils libqt5core5a libqt5dbus5 libqt5gui5 libgtk2.0-0 libssl1.0.0 libgomp1 libpcre16-3 libflann-dev libssh2-1-dev libpng16-16 libglfw3-dev xcb

COPY installer/phoxi.run /tmp/phoxi.run
COPY system_files/PhoXiControl /usr/local/bin/PhoXiControl
COPY phoxi_camera /root/catkin_ws/src/phoxi_camera

ENV PHOXI_CONTROL_PATH="/opt/Photoneo/PhoXiControl"

RUN set -eux \
    && cd /tmp \
    && chmod a+x phoxi.run \
    && ./phoxi.run --accept ${PHOXI_CONTROL_PATH} \
    && rm -rf phoxi.run \
    && /bin/bash -c "source /root/catkin_ws/devel/setup.bash && cd /root/catkin_ws  && rosdep update && rosdep install --from-paths src --ignore-src -r -y && catkin_make && source /root/catkin_ws/devel/setup.bash" &&\
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/ && mkdir /root/.PhotoneoPhoXiControl
    
