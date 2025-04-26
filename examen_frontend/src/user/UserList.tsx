import { useEffect, useState } from "react";
import BASE_URL from "../config";
import Table from "../components/core/Table";
import Modal from "../components/core/Modal";
import Button from "../components/core/Button";
import { useNavigate } from "react-router-dom";
import Container from "../components/core/Container";
import { createUser } from "./User";
import UserForm from "./UserFormComponent";
import { NewUser, User } from "../Interfaces/Types";
import Back from "../components/core/Back";

const UserList: React.FC = () => {
  const [users, setUsers] = useState<User[]>([]);
  const [modalOpen, setModalOpen] = useState(false);
  const navigate = useNavigate();
  const [_selectedUser, setSelectedUser] = useState<User | undefined>(undefined);


  useEffect(() => {

    const token = localStorage.getItem("token");
    const tenant = localStorage.getItem("tenant");

    fetch(`${BASE_URL}/users`, {
      headers: {
        "Authorization": `Bearer ${token}`,
        "X-Tenant": `${tenant}`,
      }
    })
      .then((res) => res.json())
      .then((data) => setUsers(data.data));
  }, []);

  const handleCreateUser = async (newUser: NewUser) => {
    const created = await createUser(newUser.user_name, newUser.email, newUser.password, newUser.name);
    setUsers((prev) => [...prev, created]);
    setModalOpen(false);
  };
  
  return (
    <Container className="my-6">
      <h1 className="text-xl font-bold mb-4 text-center">Användare</h1>

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
          Ny användare
        </Button>

        <Modal
          isOpen={modalOpen}
          onClose={() => setModalOpen(false)}
          title={"Skapa användare"}
        >
          <UserForm<NewUser>
            onSubmit={handleCreateUser}
            submitText="Skapa användare"
          />
        </Modal>

      </div>

      <Table
        items={users}
        columns={[
          {
            label: "Namn",
            render: (user) => user.name,
          },
          {
            label: "Email",
            render: (user) => user.email,
          },
        ]}
        onRowClick={(user) =>{
          setSelectedUser(user);
          navigate(`/users/${user.id}`, { state: { user } });
        }}
      />
    </Container>
  );
};

export default UserList;
