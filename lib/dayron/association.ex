defmodule Dayron.Association.NotLoaded do
  @moduledoc """
  Struct returned by one to one associations when they are not loaded.

  The fields are:

    * `__field__` - the association field in `owner`
    * `__owner__` - the schema that owns the association
    * `__cardinality__` - the cardinality of the association

  """
  defstruct [:__field__, :__owner__, :__cardinality__]

  defimpl Inspect do
    def inspect(not_loaded, _opts) do
      msg = "association #{inspect not_loaded.__field__} is not loaded"
      ~s(#Dayron.Association.NotLoaded<#{msg}>)
    end
  end
end
