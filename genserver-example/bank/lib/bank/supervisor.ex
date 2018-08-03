defmodule Bank.Supervisor do
  use GenServer
  alias Bank.Account

  def start_link(params) do
    GenServer.start_link(__MODULE__, %Account{account_name: "current"}, params)
  end

  def init(params) do
    # initiates genserver state with %Account{balance: 0, account_name: "current"}
    {:ok, params}
  end

  def handle_call({:get_balance}, _from, state) do
    # {:reply, [VALUE RETURNED], [NEW_STATE]}
    {:reply, Account.get_balance(state), state}
  end

  def handle_call({:get_account_name}, _from, state) do
    # {:reply, [VALUE RETURNED], [NEW_STATE]}
    {:reply, Account.get_account_name(state), state}
  end

  def handle_cast({:set_balance, balance}, state) do
    # {:noreply, [NEW_STATE]}
    {:noreply, Account.set_balance(state, balance)}
  end

  def handle_cast({:set_account_name, name}, state) do
     # {:noreply, [NEW_STATE]}
    {:noreply, Account.set_account_name(state, name)}
  end
end
