# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="ecwolf"
PKG_VERSION="cdf5a4ccc09610914134844bb81f7df3105d4336"
PKG_LICENSE="GPLv2"
PKG_SITE="https://bitbucket.org/ecwolf/ecwolf"
PKG_URL="$PKG_SITE.git"
PKG_DEPENDS_TARGET="toolchain SDL2 SDL2_mixer SDL2_net ecwolf:host"
PKG_LONGDESC="ECWolf is a port of the Wolfenstein 3D engine based of Wolf4SDL. It combines the original Wolfenstein 3D engine with the user experience of ZDoom to create the most user and mod author friendly Wolf3D source port."
PKG_TOOLCHAIN="cmake-make"

pre_patch() {
  find $(echo "${PKG_BUILD}" | cut -f1 -d\ ) -type f -exec dos2unix -q {} \;
}

pre_build_host() {
HOST_CMAKE_OPTS=""
}

make_host() {
  cmake . -DNO_GTK=ON
  make
}

makeinstall_host() {
: #no 
}

pre_configure_target() {
PKG_CMAKE_OPTS_TARGET=" -DNO_GTK=ON \
						-DFORCE_CROSSCOMPILE=ON \
						-DIMPORT_EXECUTABLES=$PKG_BUILD/.$HOST_NAME/ImportExecutables.cmake						
						-DCMAKE_BUILD_TYPE=Release"

 cd $PKG_BUILD/deps/gdtoa
 $HOST_CC -o rithchk arithchk.c -Wall -Wextra
 ./rithchk > $PKG_BUILD/deps/gdtoa/arith.h

 $HOST_CC -o qnan qnan.c -Wall -Wextra
 ./qnan > $PKG_BUILD/deps/gdtoa/gd_qnan.h
 cd $PKG_BUILD
}

makeinstall_target() {
  mkdir -p $INSTALL/usr/bin
  cp $PKG_BUILD/ecwolf $INSTALL/usr/bin/
  cp $PKG_DIR/ecwolf.sh $INSTALL/usr/bin/
  
  mkdir -p $INSTALL/usr/config/distribution/ecwolf
  cp $PKG_BUILD/ecwolf.pk3 $INSTALL/usr/config/distribution/ecwolf/
  cp $PKG_DIR/config/* $INSTALL/usr/config/distribution/ecwolf/
}
