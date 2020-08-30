#CAPTION#
omsi_addParameter
-------------------

Add parameter that should be estimated.
#END#

#PYTHON#

Args:
  :var: str → Name of parameter.
  :startvalue: float → Start value of parameter.

Returns: 
  :status: int → The C-API status code (`oms_status_enu_t`).

.. code-block:: python

  status = omsi.addParameter(var, startvalue)

#END#

#LUA#
.. code-block:: lua

  -- simodel    [inout] SysIdent model as opaque pointer.
  -- var        [in] Name of parameter.
  -- startvalue [in] Start value of parameter.
  -- status     [out] Error status.
  status = omsi_addParameter(simodel, var, startvalue)

#END#

#CAPI#
.. code-block:: c

  oms_status_enu_t omsi_addParameter(void* simodel, size_t iSeries, const char* var, const double* values, size_t nValues);

#END#

#DESCRIPTION#
#END#
