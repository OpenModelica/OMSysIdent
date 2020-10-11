# OMSysIdent - OpenModelica Parameter Estimation [![License: OSMC-PL](https://img.shields.io/badge/license-OSMC--PL-lightgrey.svg)](OSMC-License.txt)

OMSysIdent is a module for the parameter estimation for linear and nonlinear
parametric dynamic models (wrapped as FMUs) on top of the OMSimulator API.
It uses the [Ceres solver](http://ceres-solver.org/) for the optimization task.
It is part of the [OpenModelica](https://openmodelica.org/) tool suite.

The module provides a _Python scripting API_ as well a _C API_. Examples for using
these APIs can be found below the `testsuite` directory.

Notice that this module was previously part of OMSimulator. It has been extracted
out of the OMSimulator project and reorganized as a separate project in September 2020.
As of 2020-10-07 the project is working on Linux but some more efforts are needed
for migrating the Windows build and make the build and usage of the module
more convenient.

## Dependencies

- [OMSimulator](https://github.com/OpenModelica/OMSimulator/)
- [cmake](http://www.cmake.org)
- Optional - [Python](https://www.python.org/) for using the Python scripting API
- Optional - [Sphinx](http://www.sphinx-doc.org/en/stable/) for documentation generation
- Included 3rdParty libraries
  - Ceres Solver
  - Eigen
  - gflags
  - glog

## Build

Prerequisites:

1. The OMSimulator project needs to be cloned and build.

1. OMSysIdent needs to be cloned so that it shares the same parent directory with
OMSimulator.

### Linux

1. Build the included 3rdParty libraries

   ```bash
   make -j4
   ```

1. Build OMSysIdent

   ```bash
   mkdir build
   cd build
   cmake ..
   make -j4
   make install
   ```

Notice that `make install` will default to a relative installation at
`install/${PLATFORM_STRING}` within the OMSysIdent project directory.

### Windows

__To Be Done__
