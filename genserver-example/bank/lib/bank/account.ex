defmodule Bank.Account do
  defstruct [balance: 0, account_name: ""]

  def get_balance(%Bank.Account{balance: balance}), do: balance
  def get_account_name(%Bank.Account{account_name: name}), do: name

  def set_balance(account, balance) do
    Map.put(account, :balance, balance)
  end
  def set_account_name(account, name) do
    Map.put(account, :name, name)
  end
end
