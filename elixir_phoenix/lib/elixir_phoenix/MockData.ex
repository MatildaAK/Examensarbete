defmodule ElixirPhoenix.MockData do

  @hotel_names %{
    "1f52e35a-e4a6-4cdb-9527-4f4971d3e02b" => "Radison Coral",
    "311fb52f-5b90-4260-af9b-9f399c3e9fe5" => "Radison Green",
    "3e98549d-0ac1-46b2-a36c-d24c3fa5c958" => "Radison Brown",
    "64952cce-7fd3-4801-a76e-7addbcc5666c" => "Radison Cherry",
    "676094a0-bd9b-4ded-af73-19bc470f59e7" => "Radison Pink",
    "7ae74f37-a1fd-40b2-9f9d-368cad624d7b" => "Radison Turquoise",
    "902c0299-a821-478d-bcc0-fbf6ed99011a" => "Radison Gold",
    "92494789-8b16-47b4-aa5d-5b7c3f4e280e" => "Radison Purple",
    "9e1a1252-608f-4a4d-92f2-02b7d7c8bd68" => "Radison Black",
    "a6b29018-30e9-4141-9a69-11ec06d37475" => "Radison Yellow",
    "b556d36d-21ca-4d45-938b-b5ed3eeecf00" => "Radison Red",
    "c1a5fbc9-cc77-4d2a-a334-1f64c462107f" => "Radison Orange"
  }

  def large_list_with_hotels do
    "priv/mockdata/mockdataroom.json"
    |> File.read!()
    |> Jason.decode!(keys: :atoms!)
    |> Enum.map(fn room ->
      Map.put(room, :hotel, %{name: Map.get(@hotel_names, room.hotel_id)})
    end)
  end

end
