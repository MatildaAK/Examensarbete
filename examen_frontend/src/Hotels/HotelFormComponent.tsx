import { useEffect, useState } from "react";
import Button from "../components/core/Button";
import Input from "../components/core/Input";
import { Hotel, NewHotel } from "../Interfaces/HotelTypes";

interface HotelFormProps<THotel extends Hotel | NewHotel> {
  initialHotel?: THotel;
  onSubmit: (hotel: THotel) => Promise<void>;
  submitText?: string;
}

const HotelForm = <THotel extends Hotel | NewHotel>({
  initialHotel,
  onSubmit,
  submitText = "Spara",
}: HotelFormProps<THotel>) => {
  const [name, setName] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    if (initialHotel) {
      setName(initialHotel.name);
    }
  }, [initialHotel]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");

    try {
      if (initialHotel && "id" in initialHotel) {
        await onSubmit({
          id: initialHotel.id,
          name,
        } as THotel);
      } else {
        await onSubmit({
          name,
        } as THotel);
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

export default HotelForm;
