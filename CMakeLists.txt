cmake_minimum_required(VERSION 2.8.2)
project(CNPY)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_COMPILER "clang++")
set(CMAKE_C_COMPILER "clang")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++20 -fPIC")

option(ENABLE_STATIC "Build static (.a) library" ON)

find_package(ZLIB REQUIRED)

include_directories(${ZLIB_INCLUDE_DIRS})

add_library(cnpy-static STATIC "cnpy.cpp")
set_target_properties(cnpy-static PROPERTIES OUTPUT_NAME "cnpy")
install(TARGETS "cnpy-static" ARCHIVE DESTINATION lib)
install(FILES "cnpy.h" DESTINATION include)
target_link_libraries(cnpy-static ZLIB::ZLIB)
