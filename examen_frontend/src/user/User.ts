import BASE_URL from "../config";
import { User } from "../Interfaces/Types";

export const createUser = async (user_name: string, email: string, password: string, name: string) => {
  
  const token = localStorage.getItem("token");
  const tenant = localStorage.getItem("tenant");

  const res = await fetch(`${BASE_URL}/users`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": `Bearer ${token}`,
      "X-Tenant": `${tenant}`,
    },
    body: JSON.stringify({ user: { user_name, email, password, name } }),
  });

  if (!res.ok) {
    throw new Error("Kunde inte skapa användare.");
  }

  const data = await res.json();
  return data.data;
};

export const updateUser = async (id: number, user_name: string, email: string, name: string, password: string): Promise<User> => {

  const token = localStorage.getItem("token");
  const tenant = localStorage.getItem("tenant");

  const res = await fetch(`${BASE_URL}/users/${id}`, {
    method: "PUT",
    headers: {
       "Content-Type": "application/json",
       "Authorization": `Bearer ${token}`,
       "X-Tenant": `${tenant}`, 
    },
    body: JSON.stringify({ user: { user_name, email, name, password }}),
  });

  if (!res.ok) throw new Error("Misslyckades med att uppdatera användare.");
  const data = await res.json();
  return data.data;
};
