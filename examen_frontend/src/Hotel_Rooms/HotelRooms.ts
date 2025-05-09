import BASE_URL from "../config";
import { HotelRoom } from "../Interfaces/HotelTypes";

export const createHotelRoom = async(name: string, size: string, hotel_id: string) => {

    const token = localStorage.getItem("token");
    const tenant = localStorage.getItem("tenant");

    const res = await fetch(`${BASE_URL}/hotel_rooms`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`,
          "X-Tenant": `${tenant}`,
        },
        body: JSON.stringify({ hotel_room: { name, size, hotel_id } }), 
    });

    if (!res.ok) {
        throw new Error("Kunde inte skapa hotelrum.");
      }
    
      const data = await res.json();
      return data.data;
};

export const updateHotel = async (id: number, name: string, size: string, hotel_id: string): Promise<HotelRoom> => {

  const token = localStorage.getItem("token");
  const tenant = localStorage.getItem("tenant");

  const res = await fetch(`${BASE_URL}/hotel_rooms/${id}`, {
    method: "PUT",
    headers: {
       "Content-Type": "application/json",
       "Authorization": `Bearer ${token}`,
       "X-Tenant": `${tenant}`, 
    },
    body: JSON.stringify({ hotel_room: { name, size, hotel_id }}),
  });

  if (!res.ok) throw new Error("Misslyckades med att uppdatera hotellrum.");
  const data = await res.json();
  return data.data;
};