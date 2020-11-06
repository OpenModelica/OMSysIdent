message(STATUS "WRITING BUILD FILES FOR OMSysIdent/src")

# MAYBE Activate ASAN as in OMSimulator?

add_library(OMSysIdent SHARED
  OMSysIdent.cpp
  OMSysIdent.h
  FitModel.cpp
  FitModel.h)
set_property(TARGET OMSysIdent PROPERTY INSTALL_RPATH "$ORIGIN/")
set_property(TARGET OMSysIdent PROPERTY CXX_STANDARD 11)
set_target_properties(OMSysIdent PROPERTIES POSITION_INDEPENDENT_CODE ON)
# Currently needed, but discouraged (https://cmake.org/cmake/help/latest/command/target_link_directories.html)
if(${CMAKE_VERSION} VERSION_LESS "3.13.0")
  link_directories(${OMSimulator_LIBRARYDIR}) # FIXME this might not work, in which case one needs to set cmake_minimum_required(VERSION 3.13.0)
else()
  target_link_directories(OMSysIdent PUBLIC ${OMSimulator_LIBRARYDIR})
endif()
target_link_libraries(OMSysIdent PUBLIC OMSimulator PRIVATE ${CERES_LIBRARIES} ) # ${CMAKE_DL_LIBS}, Threads::Threads?
# target_link_libraries(OMSysIdent PUBLIC ${OMSimulator_LIBRARY} PRIVATE ${CERES_LIBRARIES} ) # Better alternative, but with it RPATH rewritting fails
target_include_directories(OMSysIdent PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/src> $<INSTALL_INTERFACE:Include> ${OMSimulator_INCLUDEDIR}
  PRIVATE ${OMSimulator_INCLUDEDIR} ${CERES_INCLUDE_DIRS} ${GLOG_INCLUDEDIR} ${GFLAGS_INCLUDEDIR})
# define subfolder for project in VS (otherwise the project will be on top-level, but should be under a separate folder)
set_property(TARGET OMSysIdent PROPERTY FOLDER "OMSysIdent")
source_group("API" FILES OMSysIdent.h)

install(TARGETS OMSysIdent DESTINATION lib)
install(FILES OMSysIdent.h DESTINATION include)
# TODO export package config in install

install(FILES OMSimulatorPython/OMSysIdent.py DESTINATION lib)
install(FILES ${OMSimulator_ROOT}/bin/OMSimulatorPython3 DESTINATION bin PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ)
#install(FILES ${OMSimulator_ROOT}/bin/OMSimulatorPython3.bat DESTINATION bin) # TODO WINDOWS
install(FILES ${OMSimulator_ROOT}/lib/OMSimulator/OMSimulator.py DESTINATION lib)
install(FILES ${OMSimulator_LIBRARY} DESTINATION lib)
install(FILES ${OMTLMSimulator_LIBRARY} DESTINATION lib)
