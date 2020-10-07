.. index:: OMSysIdent

.. Get arrow |rarr| (https://docutils.sourceforge.io/docs/ref/rst/definitions.html)

.. include:: <isonum.txt>

.. Define line break |br| (https://stackoverflow.com/questions/51198270/how-do-i-create-a-new-line-with-restructuredtext/51199504)

.. |br| raw:: html

  <br/>

OMSysIdent
==========

OMSysIdent is a module for the parameter estimation for linear and nonlinear
parametric dynamic models (wrapped as FMUs) on top of the OMSimulator API.
It uses the Ceres solver (http://ceres-solver.org/) for the optimization task.

.. index:: OMSysIdent; Examples

Examples
########

There are examples in the testsuite which use the scripting API, as well as
examples which directly use the C API.

Below is a basic example from the testsuite (`HelloWorld_cs_Fit.py`) which
uses the Python scripting API. It determines the parameters for the following
"hello world" style Modelica model:

.. code-block:: Modelica

  model HelloWorld
    parameter Real a = -1;
    parameter Real x_start = 1;
    Real x(start=x_start, fixed=true);
  equation
    der(x) = a*x;
  end HelloWorld;

The goal is to estimate the value of the coefficent `a` and the initial value
`x_start` of the state variable `x`. Instead of real measurements, the script
simply uses simulation data generated from the `HelloWorld` examples as
measurement data. The array `data_time` contains the time instants at which a
sample is taken and the array `data_x` contains the value of `x` that
corresponds to the respective time instant.

The estimation parameters are defined by calls to function
`simodel.addParameter(..)` in which the name of the parameter and a first guess
for the parameter's value is stated.

.. code-block:: python
  :caption: HelloWorld_cs_Fit.py
  :name: HelloWorld_cs_Fit-python

  from OMSimulator import OMSimulator
  from OMSysIdent import OMSysIdent
  import numpy as np

  oms = OMSimulator()

  oms.setLogFile("HelloWorld_cs_Fit_py.log")
  oms.setTempDirectory("./HelloWorld_cs_Fit_py/")
  oms.newModel("HelloWorld_cs_Fit")
  oms.addSystem("HelloWorld_cs_Fit.root", oms.system_wc)
  # oms.setTolerance("HelloWorld_cs_Fit.root", 1e-5)

  # add FMU
  oms.addSubModel("HelloWorld_cs_Fit.root.HelloWorld", "../resources/HelloWorld.fmu")

  # create simodel for model
  simodel = OMSysIdent("HelloWorld_cs_Fit")
  # simodel.describe()

  # Data generated from simulating HelloWorld.mo for 1.0s with Euler and 0.1s step size
  kNumSeries = 1
  kNumObservations = 11
  data_time = np.array([0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1])
  inputvars = []
  measurementvars = ["root.HelloWorld.x"]
  data_x = np.array([1, 0.9, 0.8100000000000001, 0.7290000000000001, 0.6561, 0.5904900000000001, 0.5314410000000001, 0.4782969000000001, 0.43046721, 0.387420489, 0.3486784401])

  simodel.initialize(kNumSeries, data_time, inputvars, measurementvars)
  # simodel.describe()

  simodel.addParameter("root.HelloWorld.x_start", 0.5)
  simodel.addParameter("root.HelloWorld.a", -0.5)
  simodel.addMeasurement(0, "root.HelloWorld.x", data_x)
  # simodel.describe()

  simodel.setOptions_max_num_iterations(25)
  simodel.solve("BriefReport")

  status, state = simodel.getState()
  # print('status: {0}; state: {1}').format(OMSysIdent.status_str(status), OMSysIdent.omsi_simodelstate_str(state))

  status, startvalue1, estimatedvalue1 = simodel.getParameter("root.HelloWorld.a")
  status, startvalue2, estimatedvalue2 = simodel.getParameter("root.HelloWorld.x_start")
  # print('HelloWorld.a startvalue1: {0}; estimatedvalue1: {1}'.format(startvalue1, estimatedvalue1))
  # print('HelloWorld.x_start startvalue2: {0}; estimatedvalue2: {1}'.format(startvalue2, estimatedvalue2))
  is_OK1 = estimatedvalue1 > -1.1 and estimatedvalue1 < -0.9
  is_OK2 = estimatedvalue2 > 0.9 and estimatedvalue2 < 1.1
  print('HelloWorld.a estimation is OK: {0}'.format(is_OK1))
  print('HelloWorld.x_start estimation is OK: {0}'.format(is_OK2))

  # del simodel
  oms.terminate("HelloWorld_cs_Fit")
  oms.delete("HelloWorld_cs_Fit")

Running the script generates the following console output:

::

  iter      cost      cost_change  |gradient|   |step|    tr_ratio  tr_radius  ls_iter  iter_time  total_time
   0  4.069192e-01    0.00e+00    2.20e+00   0.00e+00   0.00e+00  1.00e+04        0    7.91e-03    7.93e-03
   1  4.463938e-02    3.62e-01    4.35e-01   9.43e-01   8.91e-01  1.92e+04        1    7.36e-03    1.53e-02
   2  7.231043e-04    4.39e-02    5.16e-02   3.52e-01   9.85e-01  5.75e+04        1    7.26e-03    2.26e-02
   3  1.046555e-07    7.23e-04    4.74e-04   4.40e-02   1.00e+00  1.73e+05        1    7.31e-03    3.00e-02
   4  2.192358e-15    1.05e-07    5.77e-08   6.05e-04   1.00e+00  5.18e+05        1    7.15e-03    3.71e-02
   5  7.377320e-26    2.19e-15    2.05e-13   9.59e-08   1.00e+00  1.55e+06        1    7.42e-03    4.46e-02
  Ceres Solver Report: Iterations: 6, Initial cost: 4.069192e-01, Final cost: 7.377320e-26, Termination: CONVERGENCE

  =====================================
  Total duration for parameter estimation: 44msec.
  Result of parameter estimation (check 'Termination' status above whether solver converged):

  HelloWorld_cs_Fit.root.HelloWorld.a(start=-0.5, *estimate*=-1)
  HelloWorld_cs_Fit.root.HelloWorld.x_start(start=0.5, *estimate*=1)

  =====================================
  HelloWorld.a estimation is OK: True
  HelloWorld.x_start estimation is OK: True
  info:    Logging information has been saved to "HelloWorld_cs_Fit_py.log"

.. index:: OMSysIdent; Scripting Commands

Python Scripting Commands
#########################

.. _omsi-python :

.. include:: OMSysIdentPython.inc
