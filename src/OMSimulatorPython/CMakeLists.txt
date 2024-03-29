project(OMSimulatorPython)

set(OMSIMULATORLIB_DIR_STRING ${HOST_SHORT})
IF (WIN32 AND MSVC)
  set(OMSIMULATORLIB_STRING "OMSimulator.dll")
ELSEIF (WIN32 AND MINGW)
  set(OMSIMULATORLIB_STRING "libOMSimulator.dll")
ELSE ()
  set(OMSIMULATORLIB_STRING "libOMSimulator.so")
ENDIF ()
configure_file("${CMAKE_CURRENT_SOURCE_DIR}/OMSimulator.py.in" "${CMAKE_CURRENT_BINARY_DIR}/OMSimulator.py" @ONLY)
install(FILES "${CMAKE_CURRENT_BINARY_DIR}/OMSimulator.py" DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)

IF (WIN32 AND MSVC)
  install(FILES OMSimulatorPython.bat DESTINATION ${CMAKE_INSTALL_PREFIX}/bin PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ)
  install(FILES OMSimulatorPython3.bat DESTINATION ${CMAKE_INSTALL_PREFIX}/bin PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ)
ELSEIF (WIN32 AND MINGW)
  install(FILES OMSimulatorPython.bat DESTINATION ${CMAKE_INSTALL_PREFIX}/bin PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ)
  install(FILES OMSimulatorPython3.bat DESTINATION ${CMAKE_INSTALL_PREFIX}/bin PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ)
  install(FILES OMSimulatorPython DESTINATION ${CMAKE_INSTALL_PREFIX}/bin PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ)
  install(FILES OMSimulatorPython3 DESTINATION ${CMAKE_INSTALL_PREFIX}/bin PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ)
ELSEIF (APPLE)
  message(WARNING "OMSimulatorPython is not available on Mac OS X.")
ELSE ()
  install(FILES OMSimulatorPython DESTINATION ${CMAKE_INSTALL_PREFIX}/bin PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ)
  install(FILES OMSimulatorPython3 DESTINATION ${CMAKE_INSTALL_PREFIX}/bin PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ)
ENDIF ()

IF (Ceres_FOUND AND OMSYSIDENT)
  install(FILES OMSysIdent.py DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)
ENDIF ()
