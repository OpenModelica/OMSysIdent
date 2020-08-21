message(STATUS "WRITING BUILD FILES FOR OMSysIdent/src")

# TODO activate ASAN as in OMSimualtor?

include_directories(
  ${OMSimulator_INCLUDEDIR}
  ${CERES_INCLUDE_DIRS}
  ${GLOG_INCLUDEDIR}
  ${GFLAGS_INCLUDEDIR}
)

link_directories(
  ${OMSimulator_LIBRARYDIR}
)

set(OMSYSIDENTLIB_SOURCES OMSysIdent.cpp FitModel.cpp)
set(OMSYSIDENTLIB_LIBRARIES OMSimulatorLib ${OMSimulator_LIBRARY} ${CMAKE_DL_LIBS})

add_library(OMSysIdent SHARED ${OMSYSIDENTLIB_SOURCES})
set_property(TARGET OMSysIdent PROPERTY CXX_STANDARD 11)
set_target_properties(OMSysIdent PROPERTIES POSITION_INDEPENDENT_CODE ON)
target_link_libraries(OMSysIdent ${CERES_LIBRARIES} OMSimulator)

install(TARGETS OMSysIdent DESTINATION lib)
install(FILES OMSysIdent.h DESTINATION include)

#############
# Testing
# For testing use either
# CTEST_OUTPUT_ON_FAILURE=1 make test
# for showing any output from a test program whenever a test fails
# or
# ctest -V
# for showing the stdout output for all test cases, alternatively, for a specific test,
# make test ARGS="-V -R some-specific-test"

# set(OMSYSIDENTTEST_LIBRARIES OMSysIdent_static ${OMSYSIDENTLIB_LIBRARIES})
#
# add_executable(test_HelloWorld_cs_Fit test_HelloWorld_cs_Fit.c)
# target_link_libraries(test_HelloWorld_cs_Fit ${OMSYSIDENTTEST_LIBRARIES})
# add_test(NAME test_HelloWorld_cs_Fit
#   COMMAND test_HelloWorld_cs_Fit
# WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/testsuite/OMSysIdent)
#
# add_executable(test_Lin2DimODE_cs_Fit test_Lin2DimODE_cs_Fit.cpp)
# target_link_libraries(test_Lin2DimODE_cs_Fit ${OMSYSIDENTTEST_LIBRARIES})
# add_test(NAME test_Lin2DimODE_cs_Fit
#   COMMAND test_Lin2DimODE_cs_Fit
# WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/testsuite/OMSysIdent)
