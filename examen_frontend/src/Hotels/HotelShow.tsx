import { useNavigate, useParams } from "react-router-dom";
import { Hotel } from "../Interfaces/Hotel";
import { useEffect, useState } from "react";
import BASE_URL from "../config";
import Container from "../components/core/Container";
import Back from "../components/core/Back";
import List from "../components/core/List";
import Button from "../components/core/Button";
import Modal from "../components/core/Modal";
import HotelForm from "./HotelFormComponent";
import { updateHotel } from "./Hotel";

const HotelShow = () => {
  const { id } = useParams<{ id: string }>();
  const [hotel, setHotel] = useState<Hotel | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();
  const [modalOpen, setModalOpen] = useState(false);

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
        setHotel(data.data);
        setLoading(false);
      })
      .catch((err) => {
        setError(err.message);
        setLoading(false);
      });
  }, [id]);

  const handleSaveHotel = async (hotelToSave: Hotel) => {
    if (!hotelToSave.id) {
      console.error("Hotell saknar ID vid uppdatering");
      return;
    }

    const updated = await updateHotel(hotelToSave.id, hotelToSave.name);
    setHotel(updated);
    setModalOpen(false);
  };

  if (loading) return <p>Laddar hotell...</p>;
  if (error) return <p>Något gick fel: {error}</p>;
  if (!hotel) return <p>Ingen hotell hittades.</p>;

  const deleteHotel = async (id: number) => {
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
        Hotell: {hotel.name}
      </h1>
      <List
        items={[
            { title: "Namn", value: hotel.name },
            { title: "Hotell rum",  value: hotel.hotel_rooms?.map((room) => room.name).join(", ") || "Inga rum",}
        ]}
        renderSlot={(item) => item.value}
      />

      <div className="flex justify-end mt-8 gap-6">
        <Button
          onClick={() => deleteHotel(hotel.id)}
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
            initialHotel={hotel}
            onSubmit={handleSaveHotel}
            submitText="Uppdatera"
          />
        </Modal>
      </div>
    </Container>
  );
};

export default HotelShow;
