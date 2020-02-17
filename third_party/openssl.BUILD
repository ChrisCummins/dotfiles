# OpenSSL.
# https://www.openssl.org/

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "openssl",
    srcs = glob([
        "lib/libcrypto*",
        "lib/libssl*",
    ]),
    hdrs = glob([
        "include/openssl/**/*",
    ]),
    includes = ["include"],
)
