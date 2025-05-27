# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExamenBackend.Repo.insert!(%ExamenBackend.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.


  alias ExamenBackend.Repo
  alias ExamenBackend.Hotels.HotelRoom

  body = File.read!("priv/repo/data/10_hotel_rooms_with_prefix.json")
  rooms = Jason.decode!(body)

  Enum.each(rooms, fn %{
    "id" => id,
    "name" => name,
    "size" => size,
    "hotel_id" => hotel_id,
    "prefix_tenant" => prefix
  } ->
    attrs = %{
      id: id,
      name: name,
      size: size,
      hotel_id: hotel_id
    }

    %HotelRoom{}
    |> HotelRoom.changeset(attrs, prefix: prefix)
    |> Repo.insert!(prefix: prefix)
  end)
