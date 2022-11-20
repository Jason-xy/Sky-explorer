#!/bin/bash
SCRIPTDIR=$(cd $(dirname "${BASH_SOURCE[0]}") >/dev/null && pwd)
cd $SCRIPTDIR
echo "QT_QPA_DEFAULT_PLATFORM = linuxfb" >> qtbase/mkspecs/linux-aarch64-gnu-g++/qmake.conf
echo "QMAKE_CFLAGS_RELEASE += -O2 -march=armv8-a -lts" >> qtbase/mkspecs/linux-aarch64-gnu-g++/qmake.conf
echo "QMAKE_CXXFLAGS_RELEASE += -O2 -march=armv8-a -lts" >> qtbase/mkspecs/linux-aarch64-gnu-g++/qmake.conf

./configure \
-prefix /usr/aarch64-linux-gnu \
-confirm-license \
-opensource \
-release \
-make libs \
-xplatform linux-aarch64-gnu-g++ \
-pch \
-qt-libjpeg \
-qt-libpng \
-qt-zlib \
-no-opengl \
-no-sse2 \
-no-cups \
-no-glib \
-no-dbus \
-no-xcb \
-no-separate-debug-info \
