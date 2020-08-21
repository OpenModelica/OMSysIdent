
CC ?= gcc
CXX ?= g++
LINK ?= $(CXX)

RM=rm -rf
CP=cp -rf
MKDIR=mkdir -p
ROOT_DIR=$(shell pwd)

# Statically link dependencies as much as possible
STATIC ?= OFF
# Option to switch between Debug and Release builds
BUILD_TYPE ?= Release

detected_OS ?= $(shell uname -s)


BUILD_DIR := build/linux
INSTALL_DIR := install/linux
CMAKE_TARGET=-DCMAKE_SYSTEM_NAME=$(detected_OS)
export ABI := LINUX64

FEXT=.so
CMAKE_FPIC=-DCMAKE_C_FLAGS="-fPIC"


# use cmake from above if is set, otherwise cmake
ifeq ($(CMAKE),)
	CMAKE=CC="$(CC)" CXX="$(CXX)" CFLAGS="$(CFLAGS)" CPPFLAGS="$(CPPFLAGS)" CXXFLAGS="$(CXXFLAGS)" cmake
endif

# Should we install everything into the OMBUILDDIR?
ifeq ($(OMBUILDDIR),)
	TOP_INSTALL_DIR=$(INSTALL_DIR)
	CMAKE_INSTALL_PREFIX=
	HOST_SHORT=
else
	TOP_INSTALL_DIR=$(OMBUILDDIR)
	CMAKE_INSTALL_PREFIX=-DCMAKE_INSTALL_PREFIX=$(OMBUILDDIR)
ifeq ($(host_short),)
	HOST_SHORT=
else
	HOST_SHORT_OMC=$(host_short)/omc
	HOST_SHORT=-DHOST_SHORT=$(HOST_SHORT_OMC)
endif
endif

ifeq ($(CROSS_TRIPLE),)
  CMAKE=cmake $(CMAKE_TARGET)
else
  LUA_EXTRA_FLAGS=CC=$(CC) CXX=$(CXX) RANLIB=$(CROSS_TRIPLE)-ranlib detected_OS=$(detected_OS)
  OMTLM := OFF
  CERES := OFF
  OMSYSIDENT := OFF
  LIBXML2 := OFF
  CROSS_TRIPLE_DASH = $(CROSS_TRIPLE)-
  HOST_CROSS_TRIPLE = "--host=$(CROSS_TRIPLE)"
  FMIL_FLAGS ?=
  AR ?= $(CROSS_TRIPLE)-ar
  RANLIB ?= $(CROSS_TRIPLE)-ranlib
  CMAKE=cmake $(CMAKE_TARGET)
  ifeq (MINGW,$(findstring MINGW,$(detected_OS)))
    CMAKE_TARGET=-G "Unix Makefiles" -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_RC_COMPILER=$(CROSS_TRIPLE)-windres
  endif
  ifeq ($(detected_OS),Darwin)
    EXTRA_CMAKE+=-DCMAKE_INSTALL_NAME_TOOL=$(CROSS_TRIPLE)-install_name_tool
  endif
  DISABLE_RUN_OMSIMULATOR_VERSION ?= 1
endif

.PHONY: OMSimulator OMSimulatorCore config-OMSimulator config-fmil config-lua config-zlib config-cvode config-kinsol config-gflags config-glog config-ceres-solver config-3rdParty distclean testsuite doc doc-html doc-doxygen OMTLMSimulator OMTLMSimulatorClean RegEx

config-ceres-solver: config-glog
	@echo
	@echo "# config ceres-solver"
	@echo
	$(RM) 3rdParty/ceres-solver/$(BUILD_DIR)
	$(RM) 3rdParty/ceres- solver/$(INSTALL_DIR)
	$(MKDIR) 3rdParty/ceres-solver/$(BUILD_DIR)
	cd 3rdParty/ceres-solver/$(BUILD_DIR) && $(CMAKE) $(CMAKE_TARGET) ../../ceres-solver -DCMAKE_INSTALL_PREFIX=../../$(INSTALL_DIR) -DCXX11:BOOL=ON -DEXPORT_BUILD_DIR=ON -DEIGEN_INCLUDE_DIR_HINTS=../../eigen/eigen -DBUILD_EXAMPLES:BOOL=OFF -DBUILD_TESTING:BOOL=OFF -DCMAKE_BUILD_TYPE="Release" && $(MAKE) install

config-gflags:
	@echo
	@echo "# config gflags"
	@echo
	$(RM) 3rdParty/gflags/$(BUILD_DIR)
	$(RM) 3rdParty/gflags/$(INSTALL_DIR)
	$(MKDIR) 3rdParty/gflags/$(BUILD_DIR)
	cd 3rdParty/gflags/$(BUILD_DIR) && $(CMAKE) $(CMAKE_TARGET) ../../gflags -DCMAKE_INSTALL_PREFIX=../../$(INSTALL_DIR) -DBUILD_SHARED_LIBS:BOOL=OFF -DBUILD_TESTING:BOOL=OFF $(CMAKE_FPIC) -DCMAKE_CXX_FLAGS="-fPIC" -DCMAKE_BUILD_TYPE="Release" && $(MAKE) install

config-glog: config-gflags
	@echo
	@echo "# config glog"
	@echo
	$(RM) 3rdParty/glog/$(BUILD_DIR)
	$(RM) 3rdParty/glog/$(INSTALL_DIR)
	$(MKDIR) 3rdParty/glog/$(BUILD_DIR)
	cd 3rdParty/glog/$(BUILD_DIR) && $(CMAKE) $(CMAKE_TARGET) ../../glog -DCMAKE_INSTALL_PREFIX=../../$(INSTALL_DIR) -DBUILD_SHARED_LIBS:BOOL=OFF -DBUILD_TESTING:BOOL=OFF $(CMAKE_FPIC) -DCMAKE_CXX_FLAGS="-fPIC" -DCMAKE_BUILD_TYPE="Release" && $(MAKE) install



distclean:
	@echo
	@echo "# make distclean"
	@echo
	$(RM) $(BUILD_DIR)
	$(RM) 3rdParty/gflags/$(BUILD_DIR)
	$(RM) 3rdParty/gflags/$(INSTALL_DIR)
	$(RM) 3rdParty/glog/$(BUILD_DIR)
	$(RM) 3rdParty/glog/$(INSTALL_DIR)
	$(RM) 3rdParty/ceres-solver/$(BUILD_DIR)
	$(RM) 3rdParty/ceres-solver/$(INSTALL_DIR)

# gitclean:
# 	git submodule foreach --recursive 'git clean -fdx'
# 	git clean -fdx -e .project
