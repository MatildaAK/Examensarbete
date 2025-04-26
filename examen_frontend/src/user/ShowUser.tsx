import React, { useEffect, useState } from "react";
import { useNavigate, useParams } from "react-router-dom";
import BASE_URL from "../config";
import Back from "../components/core/Back";
import List from "../components/core/List";
import Button from "../components/core/Button";
import Container from "../components/core/Container";
import Modal from "../components/core/Modal";
import UserForm from "./UserFormComponent";
import { User } from "../Interfaces/Types";
import { updateUser } from "./User";

const ShowUser: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();
  const [modalOpen, setModalOpen] = useState(false);

  useEffect(() => {
    if (!id) return;

    fetch(`${BASE_URL}/users/${id}`)
      .then((res) => {
        if (!res.ok) throw new Error("Kunde inte hämta användare");
        return res.json();
      })
      .then((data) => {
        setUser(data.data);
        setLoading(false);
      })
      .catch((err) => {
        setError(err.message);
        setLoading(false);
      });
  }, [id]);

  const handleSaveUser = async (userToSave: User) => {
    if (!userToSave.id) {
      console.error("Användare saknar ID vid uppdatering");
      return;
    }
  
    const updated = await updateUser(userToSave.id, userToSave.user_name, userToSave.email);
    setUser(updated);
    setModalOpen(false);
  };
  

  if (loading) return <p>Laddar användare...</p>;
  if (error) return <p>Något gick fel: {error}</p>;
  if (!user) return <p>Ingen användare hittades.</p>;

  const deleteUser = async (id: number) => {
    const confirmDelete = window.confirm(
      "Är du säker på att du vill ta bort denna användare?"
    );
    if (!confirmDelete) return;

    try {
      const res = await fetch(`${BASE_URL}/users/${id}`, {
        method: "DELETE",
      });

      if (!res.ok) throw new Error("Kunde inte radera användare");

      navigate("/users");
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
        Användare {user.user_name}
      </h1>
      <List
      items={[
        { title: "Name", value: user.user_name },
        { title: "Email", value: user.email },
      ]}
      renderSlot={(item) => item.value}
    />

      <div className="flex justify-end mt-8 gap-6">
        <Button
          onClick={() => deleteUser(user.id)}
          type="button"
          size="small"
          variant="danger"
        >
          Delete
        </Button>

        <Button
          onClick={() => setModalOpen(true)}
          type="button"
          variant="primary"
          size="small"
        >
          Uppdatera användare
        </Button>
        <Modal isOpen={modalOpen} onClose={() => {
          setModalOpen(false);
        }} title={"Redigera användare"}>
          <UserForm<User>
            initialUser={user}
            onSubmit={handleSaveUser}
            submitText="Uppdatera"
          />
        </Modal>
      </div>
    </Container>
  );
};

export default ShowUser;
