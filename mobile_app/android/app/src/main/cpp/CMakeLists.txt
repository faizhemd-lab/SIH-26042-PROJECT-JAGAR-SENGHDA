cmake_minimum_required(VERSION 3.18.1)

project("jagar_native")

add_library(
    jagar_native
    SHARED
    native_engine.cpp
)

find_library(
    log-lib
    log
)

target_link_libraries(
    jagar_native
    ${log-lib}
)
