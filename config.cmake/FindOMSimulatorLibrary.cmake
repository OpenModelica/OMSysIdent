# Preliminary Hack. Intended to be used with a previously locally built OMSimulator project. Needs updates this to have more specific rules for finding the OMSimulator library.

find_library(OMSimulator_LIBRARY
  NAMES OMSimulator
  HINTS ${OMSimulator_ROOT}/lib
)

if(OMSimulator_LIBRARY)
  set(OMSimulator_LIBRARYDIR ${OMSimulator_ROOT}/lib)
  set(OMSimulator_INCLUDEDIR ${OMSimulator_ROOT}/include)
  message(STATUS "Found CVODE")
  message(STATUS "  OMSimulator_ROOT:       " ${OMSimulator_ROOT})
  message(STATUS "  OMSimulator_LIBRARY:    " ${OMSimulator_LIBRARY})
  message(STATUS "  OMSimulator_LIBRARYDIR: " ${OMSimulator_LIBRARYDIR})
  message(STATUS "  OMSimulator_INCLUDEDIR: " ${OMSimulator_INCLUDEDIR})
else()
  if(OMSimulator_FIND_REQUIRED)
    message(STATUS "Unable to find the requested OMSimulator" )
    message(STATUS "Looked in OMSimulator_ROOT ${OMSimulator_ROOT}" )
    message(SEND_ERROR "Could not find OMSimulator. Make sure you have set the OMSimulator_ROOT in the CMakeFile.txt to point to your OMSimulator installation." )
  else()
    message(STATUS "OMSimulator - NOT Found" )
  endif(OMSimulator_FIND_REQUIRED)
endif()
