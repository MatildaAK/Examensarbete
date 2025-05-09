import { useEffect, useState } from "react";
import { Hotel, NewHotel } from "../Interfaces/HotelTypes";
import Container from "../components/core/Container";
import Back from "../components/core/Back";
import Button from "../components/core/Button";
import Modal from "../components/core/Modal";
import Table from "../components/core/Table";
import { createHotel } from "./Hotel";
import { useNavigate } from "react-router-dom";
import HotelForm from "./HotelFormComponent";
import { mockData } from "./MockData/mockdata";

const HotelList1000 = () => {
  const [hotels, setHotels] = useState<Hotel[]>([]);
  const [modalOpen, setModalOpen] = useState(false);
  const navigate = useNavigate();
  const [_selectedHotel, setSelectedHotel] = useState<Hotel | undefined>(
    undefined
  );

  useEffect(() => {
    setHotels(mockData);
  }, []);

  const handleCreateHotel = async (newHotel: NewHotel) => {
    const created = await createHotel(newHotel.name);
    setHotels((prev) => [...prev, created]);
    setModalOpen(false);
  };

  return (
    <Container className="my-6">
      <h1 className="text-xl font-bold mb-4 text-center">Hotel</h1>

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
          Nytt hotel
        </Button>

        <Modal
          isOpen={modalOpen}
          onClose={() => setModalOpen(false)}
          title={"Skapa Hotel"}
        >
          <HotelForm<NewHotel>
            onSubmit={handleCreateHotel}
            submitText="Skapa hotel"
          />
        </Modal>
      </div>

      <Table
        items={hotels}
        columns={[
          {
            label: "Namn",
            render: (hotel) => hotel.name,
          },
        ]}
        onRowClick={(hotel) => {
          setSelectedHotel(hotel);
          navigate(`/hotels/${hotel.id}`, { state: { hotel } });
        }}
      />
    </Container>
  );
};

export default HotelList1000;
