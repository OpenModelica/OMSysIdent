## status: correct
## teardown_command: rm -rf HelloWorldWithInput_cs_Fit/ HelloWorldWithInput_cs_Fit.log HelloWorldWithInput_cs_Fit_res.csv
## linux: yes
## mingw: no
## win: no
## mac: no

from OMSimulator import OMSimulator
from OMSysIdent import OMSysIdent
import numpy as np

oms = OMSimulator()

oms.setLogFile("HelloWorldWithInput_cs_Fit.log")
oms.setTempDirectory("./HelloWorldWithInput_cs_Fit/")
oms.newModel("HelloWorldWithInput_cs_Fit")
oms.addSystem("HelloWorldWithInput_cs_Fit.root", oms.system_wc)
oms.setFixedStepSize("HelloWorldWithInput_cs_Fit.root", 1e-1)
oms.setTolerance("HelloWorldWithInput_cs_Fit.root", 1e-5, 1e-5)
oms.setResultFile("HelloWorldWithInput_cs_Fit", "");


# add FMU
status = oms.addSubModel("HelloWorldWithInput_cs_Fit.root.HelloWorldWithInput", "../resources/HelloWorldWithInput.fmu")

# create system identification model for model
simodel = OMSysIdent("HelloWorldWithInput_cs_Fit")
# simodel.describe()

# Data generated from simulating HelloWorldWithInput.mo for 1.0s with Euler and 0.1s step size
kNumSeries = 1;
kNumObservations = 11;
data_time = np.array([0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1])
inputvars = ["root.HelloWorldWithInput.u"]
data_u =    np.array([0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]) # input u=time
measurementvars = ["root.HelloWorldWithInput.x"];
data_x =    np.array([1, 0.91, 0.839, 0.7851, 0.74659, 0.721931, 0.7097379, 0.70876411, 0.717887699, 0.7360989291, 0.76248903619])

simodel.initialize(kNumSeries, data_time, inputvars, measurementvars)
# simodel.describe()

simodel.addParameter("root.HelloWorldWithInput.x_start", 0.5)
simodel.addParameter("root.HelloWorldWithInput.a", -0.5)
simodel.addInput("root.HelloWorldWithInput.u", data_u)
simodel.addMeasurement(0, "root.HelloWorldWithInput.x", data_x)
# simodel.describe()

simodel.setOptions_max_num_iterations(25)
simodel.solve("") # use "BriefReport" for more information

status, state = simodel.getState()
# print('status: {0}; state: {1}').format(OMSysIdent.status_str(status), OMSysIdent.omsi_simodelstate_str(state))

status, startvalue1, estimatedvalue1 = simodel.getParameter("root.HelloWorldWithInput.a")
status, startvalue2, estimatedvalue2 = simodel.getParameter("root.HelloWorldWithInput.x_start")
# print('HelloWorldWithInput.a startvalue1: {0}; estimatedvalue1: {1}'.format(startvalue1, estimatedvalue1))
# print('HelloWorldWithInput.x_start startvalue2: {0}; estimatedvalue2: {1}'.format(startvalue2, estimatedvalue2))
is_OK1 = estimatedvalue1 > -1.1 and estimatedvalue1 < -0.9
is_OK2 = estimatedvalue2 > 0.9 and estimatedvalue2 < 1.1
print('HelloWorldWithInput.a estimation is OK: {0}'.format(is_OK1))
print('HelloWorldWithInput.x_start estimation is OK: {0}'.format(is_OK2))

# del simodel
oms.terminate("HelloWorldWithInput_cs_Fit")
oms.delete("HelloWorldWithInput_cs_Fit")

## Result:
## HelloWorldWithInput.a estimation is OK: True
## HelloWorldWithInput.x_start estimation is OK: True
## info:    Logging information has been saved to "HelloWorldWithInput_cs_Fit.log"
## endResult
