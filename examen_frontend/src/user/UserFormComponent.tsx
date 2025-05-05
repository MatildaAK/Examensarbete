import { useEffect, useState } from "react";
import Button from "../components/core/Button";
import Input from "../components/core/Input";
import { NewUser, User } from "../Interfaces/Types";

interface UserFormProps<TUser extends User | NewUser> {
  initialUser?: TUser;
  onSubmit: (user: TUser) => Promise<void>;
  submitText?: string;
}

const UserForm = <TUser extends User | NewUser>({
  initialUser,
  onSubmit,
  submitText = "Spara",
}: UserFormProps<TUser>) => {
  const [user_name, setUserName] = useState("");
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  useEffect(() => {
    if (initialUser) {
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

  try {
    if (initialUser && "id" in initialUser) {
      await onSubmit({
        id: initialUser.id,
        user_name,
        email,
        name,
        password,
      } as TUser);
    } else {
      await onSubmit({
        user_name,
        email,
        password,
        name,
      } as TUser);
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
      <Input
        type="text"
        label="Användar namn"
        value={user_name}
        onChange={(e) => setUserName(e.target.value)}
        name="username"
      />
      <Input
        type="text"
        label="Namn"
        value={name}
        onChange={(e) => setName(e.target.value)}
        name="name"
      />
      <Input
        type="email"
        label="Email"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        name="email"
      />
      <Input
        type="password"
        label="Lösenord"
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
