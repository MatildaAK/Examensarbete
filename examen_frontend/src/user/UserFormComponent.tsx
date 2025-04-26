import { useEffect, useState } from "react";
import Button from "../components/core/Button";
import Input from "../components/core/Input";
import { NewUser, User } from "../Interfaces/Types";

// interface UserFormProps {
//   initialUser?: User | NewUser;
//   onSubmit: (user: User | NewUser) => Promise<void>
//   submitText?: string;
// }

interface UserFormProps<T extends User | NewUser> {
  initialUser?: T;
  onSubmit: (user: T) => Promise<void>;
  submitText?: string;
}


const UserForm = <T extends User | NewUser>({
  initialUser,
  onSubmit,
  submitText = "Spara",
}: UserFormProps<T>) => {
  const [user_name, setUserName] = useState("");
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    if (initialUser) {
      console.log("🔍 initialUser i form:", initialUser);
      setUserName(initialUser.user_name);
      setName(initialUser.name);
      setEmail(initialUser.email);
      setPassword(initialUser.password);
    }
  }, [initialUser]);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError("");

  //   try {
  //     await onSubmit({ id: initialUser?.id, name, email });
  //   } catch (err) {
  //     setError("Något gick fel.");
  //   } finally {
  //     setLoading(false);
  //   }
  // };
  try {
    if (initialUser && "id" in initialUser) {
      await onSubmit({
        id: initialUser.id,
        user_name,
        email,
      } as T);
    } else {
      await onSubmit({
        user_name,
        email,
        password,
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
    <form onSubmit={handleSubmit}>
      {error && <p className="text-thirdColor">{error}</p>}
      <label htmlFor="name">Användar Namn</label>
      <Input
        type="text"
        value={user_name}
        onChange={(e) => setUserName(e.target.value)}
        name="username"
      />
      <label htmlFor="name">Namn</label>
      <Input
        type="text"
        value={name}
        onChange={(e) => setName(e.target.value)}
        name="name"
      />
      <label htmlFor="email">Email</label>
      <Input
        type="email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        name="email"
      />
      <label htmlFor="name">Lösenord</label>
      <Input
        type="password"
        value={password}
        onChange={(e) => setPassword(e.target.value)}
        name="password"
      />
      <Button
        type="submit"
        onClick={() => {loading}}
        variant="primary"
        size="small"
      >
        {loading ? "Sparar..." : submitText}
      </Button>
    </form>
  );
};

export default UserForm;
