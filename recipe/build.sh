#!/bin/bash

if [[ ! $BOOTSTRAPPING == yes ]]; then
  # Get an updated config.sub and config.guess
  cp $BUILD_PREFIX/share/libtool/build-aux/config.* .
fi

# need macosx-version-min flags set in cflags and not cppflags
export CFLAGS="$CFLAGS $CPPFLAGS"

if [[ $BOOTSTRAPPING == yes ]]; then
  ./configure \
      --prefix=${PREFIX}
else
  ./configure \
      --prefix=${PREFIX} \
      --host=${HOST} \
      --disable-ldap \
      --with-ca-bundle=${PREFIX}/ssl/cacert.pem \
      --with-ssl=${PREFIX} \
      --with-ssl \
      --with-zlib=${PREFIX} \
      --with-gssapi=${PREFIX} \
      --with-libssh2=${PREFIX} \
      --with-nghttp2=${PREFIX} \
  || cat config.log
fi

make -j${CPU_COUNT} ${VERBOSE_AT}
# TODO :: test 1119... exit FAILED
# make test
make install

# Includes man pages and other miscellaneous.
rm -rf "${PREFIX}/share"
