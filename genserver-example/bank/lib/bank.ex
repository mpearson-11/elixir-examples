defmodule Bank do
  @moduledoc false
  # Supervisor is the GenServer pid.

  def get_balance do
    GenServer.call(Supervisor, {:get_balance})
  end

  def get_account_name do
    GenServer.call(Supervisor, {:get_account_name})
  end

  def set_balance(balance) do
    GenServer.cast(Supervisor, {:set_balance, balance})
  end

  def set_account_name(name) do
    GenServer.cast(Supervisor, {:set_account_name, name})
  end
end
