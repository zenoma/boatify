defmodule Effects do

  def print(1), do: IO.puts(1)

  def print(n) do
    print(n - 1)
    IO.puts(n)
  end

  defmacrop even?(n) do
    quote do rem(unquote(n),2) == 0 end

  end

  def is_even?(n) do
    even?(n)
  end

  def even_print(2), do: IO.puts(2)

  def even_print(n) do
    if even?(n) == true do

      even_print(n - 1)
      IO.puts(n)

    else
      even_print(n - 1)
    end
  end

end

