defmodule Echo do

  def start() do
	pid = spawn(Echo, :server, [])
	Process.register(pid, :echo)
  end

  def print(term) do
	IO.puts "Received: #{term}"
	send :echo, {:print, term}
  end

  def stop() do
	send :echo, {:stop, self()}
	receive do
		{:exit} -> :ok
	end
  end

  def server() do
    receive do
      {:print, term} ->
		IO.puts(term)
		server()
      {:stop, pid} ->
		send pid, {:exit}
		exit(:normal)
    end
  end

end
