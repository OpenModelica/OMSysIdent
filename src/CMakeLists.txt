message(STATUS "WRITING BUILD FILES FOR OMSysIdent/src")

# TODO activate ASAN as in OMSimulator?

add_library(OMSysIdent SHARED 
  OMSysIdent.cpp
  OMSysIdent.h
  FitModel.cpp
  FitModel.h)
set_property(TARGET OMSysIdent PROPERTY INSTALL_RPATH "$ORIGIN/")
set_property(TARGET OMSysIdent PROPERTY CXX_STANDARD 11)
set_target_properties(OMSysIdent PROPERTIES POSITION_INDEPENDENT_CODE ON)
target_link_directories(OMSysIdent PUBLIC ${OMSimulator_LIBRARYDIR}) # Currently needed, but discouraged (https://cmake.org/cmake/help/latest/command/target_link_directories.html)
target_link_libraries(OMSysIdent PUBLIC OMSimulator PRIVATE ${CERES_LIBRARIES} ) # ${CMAKE_DL_LIBS}, Threads::Threads?
target_include_directories(OMSysIdent PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src> $<INSTALL_INTERFACE:Include> ${OMSimulator_INCLUDEDIR}
  PRIVATE ${OMSimulator_INCLUDEDIR} ${CERES_INCLUDE_DIRS} ${GLOG_INCLUDEDIR} ${GFLAGS_INCLUDEDIR})
# define subfolder for project in VS (otherwise the project will be on top-level, but should be under a separate folder)
set_property(TARGET OMSysIdent PROPERTY FOLDER "OMSysIdent")
source_group("API" FILES OMSysIdent.h)

install(TARGETS OMSysIdent DESTINATION lib)
install(FILES OMSysIdent.h DESTINATION include)
