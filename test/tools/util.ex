defmodule ConstantHelper do
 defmacro __using__(_opts) do
    quote do
      import ConstantHelper
    end
  end

  @doc "Define a constant"
  defmacro constant(name, value) do
    quote do
      defmacro unquote(name), do: unquote(value)
    end
  end

  @doc "Define a constant. An alias for constant"
  defmacro define(name, value) do
    quote do
      constant unquote(name), unquote(value)
    end
  end
end

defmodule Constants do
  use ConstantHelper
  alias ConstantHelper, as: Helper
  Helper.define(base_url, "https://the-internet.herokuapp.com")
end

defmodule Modules do
  require Constants
  def get_url(extension), do: "#{Constants.base_url}/#{extension}"

  def makeColumn(table_matrix, email_list) do
    element1 =
      table_matrix
      |> Enum.at(0)
      |> Enum.at(2)

    element2 =
      table_matrix
      |> Enum.at(1)
      |> Enum.at(2)

    element3 =
      table_matrix
      |> Enum.at(2)
      |> Enum.at(2)

    element4 =
      table_matrix
      |> Enum.at(3)
      |> Enum.at(2)

    email_list = [element1, element2, element3, element4]
  end
end
