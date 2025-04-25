import BASE_URL from "../config";
import { User } from "../Interfaces/Types";

export const createUser = async (name: string, email: string) => {
  
  const token = localStorage.getItem("token");
  const tenant = localStorage.getItem("tenant");

  const res = await fetch(`${BASE_URL}/users`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`,
      "X-Tenant": `${tenant}`,
    },
    body: JSON.stringify({ user: { name, email } }),
  });

  if (!res.ok) {
    throw new Error("Kunde inte skapa användare.");
  }

  const data = await res.json();
  return data.data;
};

export const updateUser = async (id: number, name: string, email: string): Promise<User> => {

  const token = localStorage.getItem("token");
  const tenant = localStorage.getItem("tenant");

  const res = await fetch(`${BASE_URL}/users/${id}`, {
    method: "PUT",
    headers: {
       "Content-Type": "application/json",
       "Authorization": `Bearer ${token}`,
       "X-Tenant": `${tenant}`, 
    },
    body: JSON.stringify({ user: { name, email }}),
  });

  if (!res.ok) throw new Error("Misslyckades med att uppdatera användare.");
  const data = await res.json();
  return data.data;
};
