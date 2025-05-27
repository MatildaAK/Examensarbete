alias ElixirPhoenix.Repo
alias ElixirPhoenix.Hotels.HotelRoom

prefix = "100006"

IO.puts("🗑️ Raderar alla hotellrum från tenant #{prefix}...")

deleted_count =
  Repo.delete_all(HotelRoom, prefix: prefix)
  |> elem(0)

IO.puts("✅ Raderade #{deleted_count} hotellrum.")
