if [ "$(uname)" == "Darwin" ]; then
    ARCH_ARGS=""

    # c-f-provided CMAKE_ARGS handles CMAKE_OSX_DEPLOYMENT_TARGET, CMAKE_OSX_SYSROOT
fi
if [ "$(uname)" == "Linux" ]; then
    ARCH_ARGS=""

fi

${BUILD_PREFIX}/bin/cmake ${CMAKE_ARGS} ${ARCH_ARGS} \
  -S ${SRC_DIR} \
  -B build \
  -G Ninja \
  -D CMAKE_INSTALL_PREFIX=${PREFIX} \
  -D CMAKE_BUILD_TYPE=Release \
  -D CMAKE_C_COMPILER=${CC} \
  -D CMAKE_C_FLAGS="${CFLAGS}" \
  -D CMAKE_CXX_COMPILER=${CXX} \
  -D CMAKE_CXX_FLAGS="${CXXFLAGS}" \
  -D CMAKE_INSTALL_LIBDIR=lib \
  -D SHARED_ONLY=ON \
  -D ambit_ENABLE_PYTHON=OFF \
  -D ENABLE_OPENMP=ON \
  -D ENABLE_XHOST=OFF \
  -D ENABLE_GENERIC=OFF \
  -D ENABLE_TESTS=ON \
  -D WITH_MPI=OFF \
  -D LAPACK_LIBRARIES="${PREFIX}/lib/liblapack${SHLIB_EXT};${PREFIX}/lib/libblas${SHLIB_EXT}" \
  -D CMAKE_VERBOSE_MAKEFILE=OFF \
  -D CMAKE_PREFIX_PATH="${PREFIX}"

cmake --build build --target install -j${CPU_COUNT}

cd build
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
    ctest --rerun-failed --output-on-failure -j${CPU_COUNT}
fi

