cmake_minimum_required(VERSION 3.12.0)
project(OMSysIdent VERSION 0.1.0)

include(CTest)
enable_testing()

# add_library(OMSysIdent OMSysIdent.cpp)

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})
include(CPack)

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
            COMMAND cmake -E copy_directory ${CMAKE_CURRENT_BINARY_DIR}/docs_doxygen/html ${CMAKE_CURRENT_SOURCE_DIR}/docs_doxygen
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMENT "Generating API documentation with Doxygen"
            VERBATIM)

else(DOXYGEN_FOUND)
    message("Doxygen needs to be installed to generate the documentation.")
endif(DOXYGEN_FOUND)
