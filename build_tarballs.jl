using BinaryBuilder

name = "Arrow"
version = v"0.13.0"
sources = [
    "http://mirror.cogentco.com/pub/apache/arrow/arrow-0.13.0/apache-arrow-0.13.0.tar.gz" =>
        "ac2a77dd9168e9892e432c474611e86ded0be6dfe15f689c948751d37f81391a"
]

script = raw"""
    cd ${WORKSPACE}/srcdir/apache-arrow-*

    # Build C++ library (required for C library)
    cd cpp
    mkdir release
    cd release
    cmake .. \
        -DCMAKE_INSTALL_PREFIX=${prefix} \
        -DCMAKE_TOOLCHAIN_FILE=/opt/${target}/${target}.toolchain \
        -DARROW_DEPENDENCY_SOURCE=BUNDLED \
        -DARROW_PARQUET=ON \
        -DBOOST_ROOT=${WORKSPACE}/destdir
    make -j${nproc}
    make -j${nproc} parquet
    make install

    # Build C library
    cd ../../c_glib
    ./configure --prefix=${prefix}
    make -j${nproc}
    make install
    """

platforms = [Linux(:x86_64)]

products(prefix) = [
    LibraryProduct(prefix, "libarrow-glib", :libarrow),
    LibraryProduct(prefix, "libparquet-glib", :libparquet),
]

dependencies = [
    "https://github.com/twadleigh/BoostBuilder/releases/download/v1.68.0-4/build_Boost.v1.68.0.jl",
]

build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
