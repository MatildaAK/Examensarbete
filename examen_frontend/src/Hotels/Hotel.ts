import BASE_URL from "../config";
import { Hotel } from "../Interfaces/Hotel";

export const createHotel = async(name: string) => {

    const token = localStorage.getItem("token");
    const tenant = localStorage.getItem("tenant");

    const res = await fetch(`${BASE_URL}/hotels`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`,
          "X-Tenant": `${tenant}`,
        },
        body: JSON.stringify({ hotel: { name } }), 
    });

    if (!res.ok) {
        throw new Error("Kunde inte skapa hotel.");
      }
    
      const data = await res.json();
      return data.data;
};

export const updateHotel = async (id: number, name: string): Promise<Hotel> => {

  const token = localStorage.getItem("token");
  const tenant = localStorage.getItem("tenant");

  const res = await fetch(`${BASE_URL}/hotels/${id}`, {
    method: "PUT",
    headers: {
       "Content-Type": "application/json",
       "Authorization": `Bearer ${token}`,
       "X-Tenant": `${tenant}`, 
    },
    body: JSON.stringify({ hotel: { name }}),
  });

  if (!res.ok) throw new Error("Misslyckades med att uppdatera hotell.");
  const data = await res.json();
  return data.data;
};