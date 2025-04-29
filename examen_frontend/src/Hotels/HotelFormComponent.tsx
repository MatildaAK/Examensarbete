import { useEffect, useState } from "react";
import Button from "../components/core/Button";
import Input from "../components/core/Input";
import { Hotel, NewHotel } from "../Interfaces/Hotel";

interface HotelFormProps<T extends Hotel | NewHotel> {
  initialHotel?: T;
  onSubmit: (hotel: T) => Promise<void>;
  submitText?: string;
}

const HotelForm = <T extends Hotel | NewHotel>({
  initialHotel,
  onSubmit,
  submitText = "Spara",
}: HotelFormProps<T>) => {
  const [name, setName] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    if (initialHotel) {
      console.log("🔍 initialHotel i form:", initialHotel);
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
        } as T);
      } else {
        await onSubmit({
          name,
        } as T);
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
        <label htmlFor="name">Namn</label>
        <Input
          type="text"
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
