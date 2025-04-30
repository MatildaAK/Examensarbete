import { useEffect, useState } from "react";
import BASE_URL from "../config";
import { Hotel, HotelRoom, NewHotelRoom } from "../Interfaces/HotelTypes";
import Container from "../components/core/Container";
import Back from "../components/core/Back";
import Button from "../components/core/Button";
import Modal from "../components/core/Modal";
import Table from "../components/core/Table";

import { useNavigate } from "react-router-dom";
import HotelRoomForm from "./HotelRoomFormComponent";
import { createHotelRoom } from "./HotelRooms";

const HotelRoomList = () => {
  const [hotelRooms, setHotelRooms] = useState<HotelRoom[]>([]);
  const [allHotels, setAllHotels] = useState<Hotel[]>([]);
  const [hotelsLoading, setHotelsLoading] = useState(true);
  const [modalOpen, setModalOpen] = useState(false);
  const navigate = useNavigate();
  const [_selectedHotelRoom, setSelectedHotelRoom] = useState<HotelRoom | undefined>(undefined);

  useEffect(() => {
    const token = localStorage.getItem("token");
    const tenant = localStorage.getItem("tenant");

    fetch(`${BASE_URL}/hotel_rooms`, {
      headers: {
        Authorization: `Bearer ${token}`,
        "X-Tenant": `${tenant}`,
      },
    })
      .then((res) => res.json())
      .then((data) => setHotelRooms(data.data));

    fetch(`${BASE_URL}/hotels`, {
      headers: {
        Authorization: `Bearer ${token}`,
        "X-Tenant": `${tenant}`,
      },
    })
      .then((res) => res.json())
      .then((data) => {
        setAllHotels(data.data);
        setHotelsLoading(false);
      });
  }, []);

  const handleCreateHotelRoom = async (newHotelRoom: NewHotelRoom) => {
    const created = await createHotelRoom(
      newHotelRoom.name,
      newHotelRoom.size,
      newHotelRoom.hotel_id
    );
    setHotelRooms((prev) => [...prev, created]);
    setModalOpen(false);
  };

  return (
    <Container className="my-6">
      <h1 className="text-xl font-bold mb-4 text-center">Hotell Rum</h1>

      <div className="flex justify-start">
        <Back>Tillbaka till Lista</Back>
      </div>

      <div className="p-6 flex justify-end">
        <Button
          onClick={() => setModalOpen(true)}
          type="button"
          variant="primary"
          size="small"
        >
          Nytt hotelrum
        </Button>

        <Modal
          isOpen={modalOpen}
          onClose={() => setModalOpen(false)}
          title={"Skapa Hotel rum"}
        >
          {!hotelsLoading && (
            <HotelRoomForm<NewHotelRoom>
              onSubmit={handleCreateHotelRoom}
              submitText="Skapa hotel rum"
              hotels={allHotels}
            />
          )}
          {hotelsLoading && <p>Laddar hotell...</p>}
        </Modal>
      </div>

      <Table
        items={hotelRooms}
        columns={[
          {
            label: "Namn",
            render: (hotel_room) => hotel_room.name,
          },
          {
            label: "Hotell",
            render: (hotel_room) => {
              const hotel = allHotels.find((h) => h.id === hotel_room.hotel_id);
              return hotel ? hotel.name : "Okänt hotell";
            },
          },
        ]}
        onRowClick={(hotel_room) => {
          setSelectedHotelRoom(hotel_room);
          navigate(`/hotels/${hotel_room.id}`, { state: { hotel_room } });
        }}
      />
    </Container>
  );
};

export default HotelRoomList;
