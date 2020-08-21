message(STATUS "WRITING BUILD FILES FOR tests")

################################################################################
# Testing
################################################################################
# For testing use either
# CTEST_OUTPUT_ON_FAILURE=1 make test
# for showing any output from a test program whenever a test fails
# or
# ctest -V
# for showing the stdout output for all test cases, alternatively, for a specific test,
# make test ARGS="-V -R some-specific-test"

add_executable(test_HelloWorld_cs_Fit test_HelloWorld_cs_Fit.c)
target_link_libraries(test_HelloWorld_cs_Fit OMSysIdent ${CERES_LIBRARIES} OMSimulator)
add_test(NAME test_HelloWorld_cs_Fit
  COMMAND test_HelloWorld_cs_Fit
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/tests)

add_executable(test_Lin2DimODE_cs_Fit test_Lin2DimODE_cs_Fit.cpp)
target_include_directories(test_Lin2DimODE_cs_Fit PRIVATE ${CMAKE_SOURCE_DIR}/3rdParty/eigen/eigen)
target_link_libraries(test_Lin2DimODE_cs_Fit OMSysIdent ${CERES_LIBRARIES} OMSimulator)
add_test(NAME test_Lin2DimODE_cs_Fit
  COMMAND test_Lin2DimODE_cs_Fit
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/tests)