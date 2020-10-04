#CAPTION#
omsi_addInput
-------------

Add input values for external model inputs.

If there are several measurement series, all series need to be conducted
with the same external inputs!
#END#

#PYTHON#

Args:
  :var: (str) Name of variable..
  :values: (np.array) Array of input values for respective time instants in `omsi.initialize()`.

Returns:
  :status: (int) The C-API status code (`oms_status_enu_t`).

.. code-block:: python

  status = omsi.addInput(var, values)

#END#

#LUA#
.. code-block:: lua

  -- simodel [inout] SysIdent model as opaque pointer.
  -- var     [in] Name of input variable.
  -- values  [in] Array of input values corresponding to respective "time" array entries in omsi_initialize().
  -- status  [out] Error status.
  status = omsi_addInput(simodel, var, time, values)

#END#

#CAPI#
.. code-block:: c

  oms_status_enu_t omsi_addInput(void* simodel, const char* var, const double* values, size_t nValues);

#END#

#DESCRIPTION#
#END#
