import { useState } from "react";
import { useNavigate, useOutletContext } from "react-router-dom";
import BASE_URL from "../config";

interface ContextType {
  onLogin: (
    user_name: string,
    userId: string,
    token: string,
    tenant: string
  ) => void;
}

const Login: React.FC = () => {
  const [loginInput, setLoginInput] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);
  const { onLogin } = useOutletContext<ContextType>();
  const navigate = useNavigate();

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    const [user_name, tenant] = loginInput.split("@");

    try {
      const res = await fetch(`${BASE_URL}/login`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({
          user: {
            account: `${user_name}@${tenant}`,
            password: password,
          },
        }),
      });

      if (!res.ok) {
        const errorData = await res.json();
        throw new Error(errorData.error || "Inloggning misslyckades");
      }

      const data = await res.json();

      if (res.ok) {
        const { user_name, id, token } = data;

        onLogin(user_name, id, token, tenant);

        localStorage.setItem("token", data.token);
        localStorage.setItem("tenant", tenant);
        localStorage.setItem("id", id);
      } else {
        console.error(data.error);
      }

      setLoginInput("");
      setPassword("");

      setSuccess("Inloggning lyckades!");
      navigate("/");
      setError(null);
    } catch (err) {
      setError("Inloggning misslyckades. Kontrollera dina uppgifter.");
      setSuccess(null);
      console.error("Error during login:", err);
    }
  };

  return (
    <div>
      <div className="flex items-center justify-center mt-16">
        <div className="w-80 md:w-96">
          <form onSubmit={handleLogin} className="space-y-4">
            <div className="flex justify-center p-14  bg-primaryColor rounded-md">
              <div className="flex flex-col">
                <div className="flex items-center gap-1">
                  <label htmlFor="account" className="text-lg font-bold leading-6 text-textColor">
                    Konto:
                  </label>
                  <input
                    type="text"
                    value={loginInput}
                    onChange={(e) => setLoginInput(e.target.value)}
                    name="account"
                    id="account"
                    className="text-textColor text-start login_input"
                  />
                </div>
                <div className="flex items-center gap-1">
                  <label htmlFor="password" className="block text-lg font-bold leading-6 text-textColor">
                    Lösenord:
                  </label>
                  <input
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    name="password"
                    id="password"
                    className="text-textColor text-start login_input"
                  />
                </div>
              </div>
            </div>

            {error && <p className="text-red-500">{error}</p>}
            {success && <p className="text-green-500">{success}</p>}

            <div className="flex justify-center">
              <button
                type="submit"
                className="bg-secondaryColor text-textColor px-8 py-3 rounded-md border-none cursor-pointer"
              >
                Logga in
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
};

export default Login;
