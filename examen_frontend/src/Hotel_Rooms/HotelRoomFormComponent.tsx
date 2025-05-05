import { useEffect, useState } from "react";
import Button from "../components/core/Button";
import Input from "../components/core/Input";
import { Hotel, HotelRoom, NewHotelRoom } from "../Interfaces/HotelTypes";
import Select from "../components/core/Select";

interface HotelRoomFormProps<TRoom extends HotelRoom | NewHotelRoom> {
  initialHotelRoom?: TRoom;
  onSubmit: (hotelRoom: TRoom) => Promise<void>;
  submitText?: string;
  hotels?: Hotel[];
  initialHotelId?: string;
}

const HotelRoomForm = <TRoom extends HotelRoom | NewHotelRoom>({
  initialHotelRoom,
  onSubmit,
  hotels,
  submitText = "Spara",
  initialHotelId,
}: HotelRoomFormProps<TRoom>) => {
  const [name, setName] = useState("");
  const [size, setSize] = useState("");
  const [hotelId, setHotelId] = useState<string>("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    if (initialHotelRoom) {
      setName(initialHotelRoom.name);
      setSize(initialHotelRoom.size);
      if (initialHotelRoom.hotel_id) {
        setHotelId(initialHotelRoom.hotel_id.toString());
      }
    }
  }, [initialHotelRoom]);

  useEffect(() => {
    if (initialHotelId) {
      setHotelId(initialHotelId.toString());
    }
  }, [initialHotelId]);

  useEffect(() => {
    if (!initialHotelId && hotels && hotels.length > 0 && !hotelId) {
      setHotelId(hotels[0].id.toString());
    }
  }, [hotels, initialHotelId, hotelId]);
  
  

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");
  
    try {
      if (initialHotelRoom && "id" in initialHotelRoom) {
        await onSubmit({
          id: initialHotelRoom.id,
          name,
          size,
          hotel_id: hotelId,
        } as TRoom);
      } else {
        await onSubmit({
          name,
          size,
          hotel_id: hotelId,
        } as TRoom);
      }
    } catch (err) {
      setError("Något gick fel.");
    } finally {
      setLoading(false);
    }
  };
  
  return (
    <>
      <form onSubmit={handleSubmit}>
        {error && <p className="text-thirdColor">{error}</p>}
        <Input
          type="text"
          label="Namn"
          value={name}
          onChange={(e) => setName(e.target.value)}
          name="name"
        />
        <Input
          type="text"
          label="Storlek"
          value={size}
          onChange={(e) => setSize(e.target.value)}
          name="size"
        />
        {hotels && hotels.length > 0 && (
        <Select
            name="hotel_id"
            label="Hotell"
            value={hotelId}
            onChange={(e) => setHotelId(e.target.value)}
            options={hotels.map((hotel) => ({
              label: hotel.name,
              value: hotel.id.toString(),
            }))}
        />
        )}
        <Button
          type="submit"
          onClick={() => {
            loading;
          }}
          variant="primary"
          size="small"
        >
          {loading ? "Sparar..." : submitText}
        </Button>
      </form>
    </>
  );
};

export default HotelRoomForm;
