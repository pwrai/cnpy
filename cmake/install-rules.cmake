if(PROJECT_IS_TOP_LEVEL)
  set(CMAKE_INSTALL_INCLUDEDIR include/cnpy CACHE PATH "")
endif()

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

# find_package(<package>) call for consumers to find this project
set(package cnpy)

install(
    DIRECTORY
    include/
    "${PROJECT_BINARY_DIR}/export/"
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
    COMPONENT cnpy_Development
)

install(
    TARGETS cnpy_cnpy
    EXPORT cnpyTargets
    RUNTIME #
    COMPONENT cnpy_Runtime
    LIBRARY #
    COMPONENT cnpy_Runtime
    NAMELINK_COMPONENT cnpy_Development
    ARCHIVE #
    COMPONENT cnpy_Development
    INCLUDES #
    DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
)

write_basic_package_version_file(
    "${package}ConfigVersion.cmake"
    COMPATIBILITY SameMajorVersion
)

# Allow package maintainers to freely override the path for the configs
set(
    cnpy_INSTALL_CMAKEDIR "${CMAKE_INSTALL_DATADIR}/${package}"
    CACHE PATH "CMake package config location relative to the install prefix"
)
mark_as_advanced(cnpy_INSTALL_CMAKEDIR)

install(
    FILES cmake/install-config.cmake
    DESTINATION "${cnpy_INSTALL_CMAKEDIR}"
    RENAME "${package}Config.cmake"
    COMPONENT cnpy_Development
)

install(
    FILES "${PROJECT_BINARY_DIR}/${package}ConfigVersion.cmake"
    DESTINATION "${cnpy_INSTALL_CMAKEDIR}"
    COMPONENT cnpy_Development
)

install(
    EXPORT cnpyTargets
    NAMESPACE cnpy::
    DESTINATION "${cnpy_INSTALL_CMAKEDIR}"
    COMPONENT cnpy_Development
)

if(PROJECT_IS_TOP_LEVEL)
  include(CPack)
endif()
