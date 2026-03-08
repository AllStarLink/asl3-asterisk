ARG ARCH
ARG OS

FROM $ARCH/debian:$OS

ARG ARCH
ARG OS
ARG ASL_REPO
ARG USER_ID
ARG GROUP_ID

RUN addgroup --gid $GROUP_ID user; exit 0
RUN adduser --disabled-password --gecos '' --uid $USER_ID --gid $GROUP_ID user; exit 0

# Install build dependencies
RUN apt-get update && apt-get -y install \
	apt-utils build-essential devscripts fakeroot debhelper git lsb-release \
	libterm-readline-gnu-perl  libterm-readline-perl-perl libdistro-info-perl \
    gh ca-certificates wget --no-install-recommends

# Install application dependencies
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install  \
 autoconf automake binutils-dev cmark-gfm dahdi-source debhelper-compat  \
 default-libmysqlclient-dev freetds-dev libasound2-dev libavcodec-dev libavdevice-dev  \
 libbluetooth-dev libcap-dev libcodec2-dev libcurl4-openssl-dev  \
 libedit-dev libfftw3-dev libgmime-3.0-dev libgsm1-dev libical-dev libiksemel-dev  \
 libjack-dev libjansson-dev libldap-dev liblua5.1-dev libncurses-dev libneon27-dev  \
 libnewt-dev libogg-dev libopencore-amrnb-dev libopencore-amrwb-dev libopus-dev  \
 libopusfile-dev libpopt-dev libpq-dev libradcli-dev libreadline-dev  \
 libresample1-dev libsdl-image1.2-dev libsndfile1-dev libsnmp-dev libspandsp-dev  \
 libspeex-dev libspeexdsp-dev libsqlite3-dev libsrtp2-dev  \
 libssl-dev libswscale-dev libsystemd-dev libunbound-dev  \
 liburiparser-dev libusb-dev libvo-amrwbenc-dev libvorbis-dev libxml2-dev  \
 libxslt1-dev perl portaudio19-dev subversion unixodbc-dev  \
 uuid-dev zlib1g-dev devscripts --no-install-recommends 

# Import entrypoint script
COPY ./entrypoint.sh /entrypoint.sh

# Make Executable
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
