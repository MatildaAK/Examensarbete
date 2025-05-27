body = File.read!("priv/repo/data/10_rooms_seed.json")
rooms = Jason.decode!(body)

updated_rooms =
  Enum.map(rooms, fn room ->
    Map.put(room, "prefix_tenant", "100006")
  end)

File.write!("priv/repo/data/10_hotel_rooms_with_prefix.json", Jason.encode!(updated_rooms, pretty: true))
