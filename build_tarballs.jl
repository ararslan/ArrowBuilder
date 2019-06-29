using BinaryBuilder

name = "Arrow"
version = v"0.13.0"
sources = [
    "http://mirror.cogentco.com/pub/apache/arrow/arrow-0.13.0/apache-arrow-0.13.0.tar.gz" =>
        "ac2a77dd9168e9892e432c474611e86ded0be6dfe15f689c948751d37f81391a"
]

script = raw"""
    cd ${WORKSPACE}/srcdir

    # Build C++ library (required for C library)
    cd cpp
    mkdir release
    cd release
    cmake -DARROW_PARQUET=ON ..
    make
    make parquet
    make install

    # Build C library
    cd ../../c_glib
    ./configure
    make
    make install
    """

platforms = [Linux(:x86_64)]

products(prefix) = [
    LibraryProduct(prefix, "libarrow-glib", :libarrow),
    LibraryProduct(prefix, "libparquet-glib", :libparquet),
]

dependencies = []

build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
