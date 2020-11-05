cmake_minimum_required(VERSION 3.12.0)
project(OMSysIdent VERSION 0.1.0)
# project(OMSysIdent LANGUAGES C CXX VERSION 0.1.0) # TODO Test if this is better

#include(CTest) # If one wants dashboards (https://gitlab.kitware.com/cmake/community/-/wikis/doc/ctest/Testing-With-CTest)
enable_testing()
set_property(GLOBAL PROPERTY USE_FOLDERS ON)
set(CMAKE_FIND_PACKAGE_PREFER_CONFIG, true)
set(CMAKE_CXX_STANDARD 11)
# set(CMAKE_CXX_STANDARD 17)
# set(CMAKE_C_STANDARD 99) # Set C standard if needed
# set(CMAKE_BUILD_TYPE DEBUG)
# set(CMAKE_VERBOSE_MAKEFILE ON)

# TODO Use below in project
list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/config.cmake/")
include(GetGitRevisionDescription)
git_describe(OMSI_VERSION_STRING --tags --abbrev=7) # --match=v*.*

# Default install directory
# TODO Remove `/linux` from prefix and adapt logic accordingly
IF(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX ${PROJECT_SOURCE_DIR}/install/linux CACHE PATH "Installation prefix path" FORCE)
ENDIF(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
# Put all output artifacts into same folder to make Windows happy (so that DLLs are found by dependent artifacts).
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin CACHE STRING "")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin CACHE STRING "")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin CACHE STRING "")
# Keep CACHE cleaner
mark_as_advanced(CMAKE_RUNTIME_OUTPUT_DIRECTORY CMAKE_LIBRARY_OUTPUT_DIRECTORY CMAKE_ARCHIVE_OUTPUT_DIRECTORY)

IF(NOT PLATFORM_STRING)
  set(PLATFORM_STRING linux)
ENDIF()

# https://bastian.rieck.ru/blog/posts/2015/ycm_cmake/
# Ensures that CMake creates the file compile_commands.json (if desired).
# SET( CMAKE_EXPORT_COMPILE_COMMANDS ON )

################################################################################
# Find dependencies
################################################################################

# Find Threads
set(THREADS_PREFER_PTHREAD_FLAG TRUE)
find_package(Threads)

# Configuring for OMSimulator (preliminary hack, expects OMSimulator and OMSysIdent have the same parent directory)
set(OMSimulator_ROOT ${PROJECT_SOURCE_DIR}/../OMSimulator/install/${PLATFORM_STRING})
find_package(OMSimulatorLibrary REQUIRED)

# Configuring for Python
find_package(PythonLibs)
IF(PYTHONLIBS_FOUND)
  message(STATUS "Found Python")
  message(STATUS "  PYTHON_VERSION:      " ${PYTHONLIBS_VERSION_STRING})
  message(STATUS "  PYTHON_LIBRARIES:    " ${PYTHON_LIBRARIES})
  message(STATUS "  PYTHON_INCLUDE_DIRS: " ${PYTHON_INCLUDE_DIRS})
ELSE()
  MESSAGE(WARNING, "Python library not found.")
ENDIF()

# Configuring for glog
set(GLOG_INCLUDEDIR ${PROJECT_SOURCE_DIR}/3rdParty/glog/install/${PLATFORM_STRING}/include)

# Configuring for gflags
set(GFLAGS_INCLUDEDIR ${PROJECT_SOURCE_DIR}/3rdParty/gflags/install/${PLATFORM_STRING}/include)

# Configuring for Ceres-Solver
find_package(Ceres REQUIRED)
IF(Ceres_FOUND)
  message(STATUS "Found Ceres-Solver")
  message(STATUS "  CERES_INCLUDE_DIRS: " ${CERES_INCLUDE_DIRS})
  message(STATUS "  GLOG_INCLUDEDIR:    " ${GLOG_INCLUDEDIR})
  message(STATUS "  GFLAGS_INCLUDEDIR:  " ${GFLAGS_INCLUDEDIR})
ELSE()
  message(ERROR "Ceres-Solver not found.")
ENDIF()

################################################################################
# Add the various project modules
################################################################################
add_subdirectory(src)

################################################################################
# Tests
################################################################################
add_subdirectory(testsuite)


# Add support for packaging?
# set(CPACK_PROJECT_NAME ${PROJECT_NAME})
# set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
# include(CPack)

################################################################################
# Doxygen Build
################################################################################

find_package(Doxygen)
if(DOXYGEN_FOUND)
    message(STATUS "WRITING BUILD FILES FOR docs_doxygen")

    set(DOXYGEN_IN ${CMAKE_CURRENT_SOURCE_DIR}/docs/Doxyfile.in)
    set(DOXYGEN_OUT ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile)
    configure_file(${DOXYGEN_IN} ${DOXYGEN_OUT} @ONLY)

    add_custom_target(docs_doxygen
            COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUT}
            COMMAND cmake -E remove_directory ${CMAKE_CURRENT_SOURCE_DIR}/docs_doxygen
            COMMAND cmake -E copy_directory ${CMAKE_CURRENT_BINARY_DIR}/docs_doxygen/html ${CMAKE_INSTALL_PREFIX}/docs_doxygen
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMENT "Generating API documentation with Doxygen"
            VERBATIM)

else(DOXYGEN_FOUND)
    message("Doxygen needs to be installed to generate the documentation.")
endif(DOXYGEN_FOUND)
