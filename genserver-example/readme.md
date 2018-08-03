# Instructions to Create

## Create Application with Supervisor
- `mix new bank --sup`

## Create Basic Bank Account

- go to bank/lib/bank
- `touch account.ex`
- create `Bank.Account` class

```elixir
defmodule Bank.Account do
  defstruct [balance: 0, account_name: ""]

  def get_balance(%Bank.Account{balance: balance}), do: balance
  def get_account_name(%Bank.Account{account_name: name}), do: name

  defp set_balance(account, balance) do
    Map.put(account, :balance, balance)
  end
  defp set_account_name(account, name) do
    Map.put(account, :name, name)
  end
end
```

## Create Bank Supervisor
- go to bank/lib/bank
- `touch supervisor.ex`
- create `Bank.Supervisor` class

```elixir
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
end
```

**This class creates a basic GenServer with an Account as state**

## Extend the Bank Supervisor

- add this code into the `Bank.Supervisor` class

```elixir
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

  def handle_cast({:set_account_name}, state) do
     # {:noreply, [NEW_STATE]}
    {:noreply, Account.set_account_name(state)}
  end
```

## Connect the Supervisor to the application

- go to bank/lib/bank
- open `application.ex`
- add this code:

``` elixir
defmodule Bank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    import Supervisor.Spec

    children = [
      # Starts a worker by calling: Bank.Worker.start_link(arg)
      # {Bank.Worker, arg},
      {Bank.Supervisor, name: Supervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bank.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

```

# Connect the Main Bank class to mutate Bank.Supervisor data

- go to bank/lib
- open `bank.ex`
- change the code to:

```elixir
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
```


# Done !!!!

**To run this application**

- type in `iex -S mix` this will run the app with an iex console.
- to interact with the bank type:

```
Bank.set_balance(1000) # :ok`
Bank.get_balance() # 1000
```