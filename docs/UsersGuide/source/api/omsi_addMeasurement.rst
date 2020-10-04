#CAPTION#
omsi_addMeasurement
-------------------

Add measurement values for a fitting variable.
#END#

#PYTHON#

Args:
  :iSeries: (int) Index of measurement series.
  :var: (str) Name of variable..
  :values: (np.array) List of names of input variables (empty list if none).

Returns:
  :status: (int) The C-API status code (`oms_status_enu_t`).

.. code-block:: python

  status = omsi.addMeasurement(iSeries, var, values)

#END#

#LUA#
.. code-block:: lua

  -- simodel [inout] SysIdent model as opaque pointer.
  -- iSeries [in] Index of measurement series.
  -- var     [in] Name of variable.
  -- values  [in] Array of measured values for respective time instants.
  -- status  [out] Error status.
  status = omsi_addMeasurement(simodel, iSeries, var, values)

#END#

#CAPI#
.. code-block:: c

  oms_status_enu_t omsi_addMeasurement(void* simodel, size_t iSeries, const char* var, const double* values, size_t nValues);

#END#

#DESCRIPTION#
#END#
