import { useNavigate, useParams } from "react-router-dom";
import { Hotel, HotelRoom, NewHotelRoom } from "../Interfaces/HotelTypes";
import { useEffect, useState } from "react";
import BASE_URL from "../config";
import Container from "../components/core/Container";
import Back from "../components/core/Back";
import Button from "../components/core/Button";
import Modal from "../components/core/Modal";
import HotelForm from "./HotelFormComponent";
import { updateHotel } from "./Hotel";
import Table from "../components/core/Table";
import HotelRoomForm from "../Hotel_Rooms/HotelRoomFormComponent";
import { createHotelRoom } from "../Hotel_Rooms/HotelRooms";

const HotelShow = () => {
  const { id } = useParams<{ id: string }>();
  const [hotels, setHotels] = useState<Hotel | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();
  const [modalOpen, setModalOpen] = useState(false);
  const [roomModalOpen, setRoomModalOpen] = useState(false);
  const [_selectedHotel, setSelectedHotel] = useState<Hotel | undefined>(undefined);
  const [hotelRooms, setHotelRooms] = useState<HotelRoom[]>([]);

  useEffect(() => {
    if (!id) return;

    const token = localStorage.getItem("token");
    const tenant = localStorage.getItem("tenant");

    fetch(`${BASE_URL}/hotels/${id}`, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
        "X-Tenant": `${tenant}`,
      },
    })
      .then((res) => {
        if (!res.ok) throw new Error("Kunde inte hämta hotell");
        return res.json();
      })
      .then((data) => {
        setHotels(data.data);
        setLoading(false);
      })
      .catch((err) => {
        setError(err.message);
        setLoading(false);
      });

      fetch(`${BASE_URL}/hotel_rooms`, {
        method: "GET",
        headers: {
          Authorization: `Bearer ${token}`,
          "X-Tenant": `${tenant}`,
        },
      })
      .then((res) => res.json())
      .then((data) => {
        setHotelRooms(data.data);
        setLoading(false);
      });
  }, [id]);

  const handleSaveHotel = async (hotelToSave: Hotel) => {
    if (!hotelToSave.id) {
      console.error("Hotell saknar ID vid uppdatering");
      return;
    }

    const updated = await updateHotel(hotelToSave.id, hotelToSave.name);
    setHotels(updated);
    setModalOpen(false);
  };

    const handleCreateHotelRoom = async (newHotelRoom: NewHotelRoom) => {
      const created = await createHotelRoom(newHotelRoom.name, newHotelRoom.size, newHotelRoom.hotel_id);
      setHotelRooms((prev) => [...prev, created]);
      setRoomModalOpen(false);
    };

  if (loading) return <p>Laddar hotell...</p>;
  if (error) return <p>Något gick fel: {error}</p>;
  if (!hotels) return <p>Ingen hotell hittades.</p>;

  const deleteHotel = async (id: string) => {
    const confirmDelete = window.confirm(
      "Är du säker på att du vill ta bort detta hotell?"
    );
    if (!confirmDelete) return;

    try {
      const res = await fetch(`${BASE_URL}/hotels/${id}`, {
        method: "DELETE",
      });

      if (!res.ok) throw new Error("Kunde inte radera hotell");

      navigate("/hotels");
    } catch (err) {
      console.error(err);
      alert("Något gick fel vid radering.");
    }
  };

  return (
    <Container className="p-4 max-w-xl mx-auto">
      <div className="flex justify-start">
        <Back>Tillbaka till Lista</Back>
      </div>
      <h1 className="text-2xl font-bold mb-4 text-start">
        Hotell: {hotels.name}
      </h1>
      <div className="p-6 flex justify-end">
        <Button
          onClick={() => setRoomModalOpen(true)}
          type="button"
          variant="primary"
          size="small"
        >
          Nytt hotellrum
        </Button>

        <Modal
          isOpen={roomModalOpen}
          onClose={() => setRoomModalOpen(false)}
          title={"Skapa Hotellrum"}
        >
          <HotelRoomForm<NewHotelRoom>
            onSubmit={handleCreateHotelRoom}
            submitText="Skapa hotelrum" 
            initialHotelId={hotels.id.toString()}         
          />
        </Modal>
      </div>
      <Table
        items={hotelRooms.filter((hotel_room) => hotel_room.hotel_id === id)}
        columns={[
          {
            label: "Namn",
            render: (hotel_room) => hotel_room.name,
          },
          {
            label: "Storlek",
            render: (hotel_room) => hotel_room.size,
          },
        ]}
        onRowClick={(hotel_room) => {
          setSelectedHotel(hotel_room);
          navigate(`/hotel_rooms/${hotel_room.id}`, { state: { hotel_room } });
        }}
      />

      <div className="flex justify-end mt-8 gap-6">
        <Button
          onClick={() => deleteHotel(hotels.id)}
          type="button"
          size="small"
          variant="danger"
        >
          Radera
        </Button>

        <Button
          onClick={() => setModalOpen(true)}
          type="button"
          variant="primary"
          size="small"
        >
          Uppdatera
        </Button>
        <Modal
          isOpen={modalOpen}
          onClose={() => {
            setModalOpen(false);
          }}
          title={"Redigera hotell"}
        >
          <HotelForm<Hotel>
            initialHotel={hotels}
            onSubmit={handleSaveHotel}
            submitText="Uppdatera"
          />
        </Modal>
      </div>
    </Container>
  );
};

export default HotelShow;
