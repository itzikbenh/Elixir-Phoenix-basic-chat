ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Chat.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Chat.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Chat.Repo)

