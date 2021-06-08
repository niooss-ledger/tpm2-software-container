FROM docker.io/library/archlinux:latest

RUN pacman --noconfirm -Syu \
    acl \
    autoconf \
    autoconf-archive \
    automake \
    cmocka \
    clang \
    curl \
    dbus \
    dbus-glib \
    doxygen \
    expect \
    fakeroot \
    json-c \
    gawk \
    gcc \
    gcc-libs \
    git \
    glib2 \
    gnutls \
    iproute2 \
    jdk-openjdk \
    json-glib \
    junit \
    libgcrypt \
    libp11 \
    libseccomp \
    libtasn1 \
    libtool \
    libyaml \
    m4 \
    make \
    net-tools \
    nss \
    opensc \
    openssl \
    openssh \
    pandoc \
    patch \
    perl \
    perl-digest-sha1 \
    pkgconf \
    procps \
    python-bcrypt \
    python-cryptography \
    python-pip \
    python-pyasn1-modules \
    python-python-pkcs11 \
    python-setuptools \
    python-wheel \
    python-yaml \
    socat \
    sqlite3 \
    uthash \
    vim \
    wget \
    which \
    && pacman --noconfirm -Sc && rm -fr /var/cache/pacman/pkg/*

# Provide pod2man by linking /usr/bin/core_perl/pod2man, provided by "perl".
# This replicates what is done in https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=pod2man
RUN ln -s core_perl/pod2man /usr/bin/pod2man

# Create user 'makepkg' to build packages without being root
RUN useradd --system --no-create-home --shell=/bin/sh makepkg

# Install lcov from the AUR (Arch Linux User Repository)
RUN git -C /tmp clone --depth=1 https://aur.archlinux.org/lcov.git \
	&& cd /tmp/lcov \
	&& BUILDDIR=/tmp/lcov_build SRCDEST=/tmp/lcov_srcdest PKGDEST=/tmp/lcov_pkgdest su makepkg -pc makepkg \
	&& pacman --noconfirm -U /tmp/lcov_pkgdest/lcov-*.pkg.tar.* \
	&& rm -fr /tmp/lcov /tmp/lcov_build /tmp/lcov_srcdest /tmp/lcov_pkgdest

include(`ibmtpm1637.m4')
include(`swtpm.m4')
include(`junit.m4')

WORKDIR /
