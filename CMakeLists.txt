cmake_minimum_required(VERSION 3.14)

include(cmake/prelude.cmake)

project(
    cnpy
    VERSION 0.1.0
    DESCRIPTION "Short description"
    HOMEPAGE_URL "https://github.com/twig-energy/cnpy"
    LANGUAGES CXX
)

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)


find_package(ZLIB REQUIRED)

# ---- Declare library ----

add_library(
    cnpy_cnpy
    source/cnpy.cpp
)
add_library(cnpy::cnpy ALIAS cnpy_cnpy)

include(GenerateExportHeader)
generate_export_header(
    cnpy_cnpy
    BASE_NAME cnpy
    EXPORT_FILE_NAME export/cnpy/cnpy_export.hpp
    CUSTOM_CONTENT_FROM_VARIABLE pragma_suppress_c4251
)

if(NOT BUILD_SHARED_LIBS)
  target_compile_definitions(cnpy_cnpy PUBLIC CNPY_STATIC_DEFINE)
endif()

set_target_properties(
    cnpy_cnpy PROPERTIES
    CXX_VISIBILITY_PRESET hidden
    VISIBILITY_INLINES_HIDDEN YES
    VERSION "${PROJECT_VERSION}"
    SOVERSION "${PROJECT_VERSION_MAJOR}"
    EXPORT_NAME cnpy
    OUTPUT_NAME cnpy
)

target_include_directories(
    cnpy_cnpy ${warning_guard}
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>"
)

target_include_directories(
    cnpy_cnpy SYSTEM
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_BINARY_DIR}/export>"
)

target_link_libraries(cnpy_cnpy PUBLIC ZLIB::ZLIB)

target_compile_features(cnpy_cnpy PUBLIC cxx_std_17)

# ---- Install rules ----

if(NOT CMAKE_SKIP_INSTALL_RULES)
  include(cmake/install-rules.cmake)
endif()

# ---- Examples ----

if(PROJECT_IS_TOP_LEVEL)
  option(BUILD_EXAMPLES "Build examples tree." "${cnpy_DEVELOPER_MODE}")
  if(BUILD_EXAMPLES)
    add_subdirectory(example)
  endif()
endif()

# ---- Developer mode ----

if(NOT cnpy_DEVELOPER_MODE)
  return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
  message(
      AUTHOR_WARNING
      "Developer mode is intended for developers of cnpy"
  )
endif()

include(cmake/dev-mode.cmake)
