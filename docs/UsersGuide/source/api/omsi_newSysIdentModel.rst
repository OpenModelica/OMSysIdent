#CAPTION#
omsi_newSysIdentModel
---------------------

Creates an empty model for parameter estimation.
#END#

#PYTHON#

The corresponding Python function is the class constructor.

Args:
  :ident: (str) Name of the model instance.

Returns:
  :omsi: SysIdent model instance.

.. code-block:: python

  omsi = OMSysIdent(ident)

#END#

#LUA#
.. code-block:: lua

  -- ident   [in]  Name of the model instance as string.
  -- simodel [out] SysIdent model instance as opaque pointer.
  simodel = omsi_newSysIdentModel(ident)

#END#

#CAPI#
.. code-block:: c

  void* omsi_newSysIdentModel(const char* ident);

#END#

#DESCRIPTION#
#END#
