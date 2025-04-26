import { useState } from "react";
import { useNavigate, useOutletContext } from "react-router-dom";
import BASE_URL from "../config";

interface ContextType {
    onLogin: (user_name: string, userId: string, token: string, tenant: string) => void;
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
        const response = await fetch(`${BASE_URL}/login`, {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({
            user: {
                account: `${user_name}@${tenant}`,
                password: password
            }          
          }),
        });
  
        if (!response.ok) {
          // Om svaret inte är OK, kasta ett fel
          const errorData = await response.json();
          throw new Error(errorData.error || "Inloggning misslyckades");
        }
  
        const data = await response.json();
  
        if (response.ok) {
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
      <div className="h-svh md:h-lvh">
        <div className="flex items-center justify-center">
          <div className="my-10 mx-2 py-6 w-80 bg-primaryLightGreen dark:bg-primaryDarkGreen rounded-md md:w-96">
            <form onSubmit={handleLogin} className="space-y-4">
              <div className="flex justify-center">
                <div className="flex flex-col gap-y-4 w-1/2">
                  <input
                    type="text"
                    value={loginInput}
                    onChange={(e) => setLoginInput(e.target.value)}
                    name="identifier"
                    placeholder="Användarnamn @ E-post"
                  />
                  <input
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    name="password"
                    placeholder="Lösenord"
                  />
                </div>
              </div>
  
              {error && <p className="text-red-500">{error}</p>}
              {success && <p className="text-green-500">{success}</p>}
  
              <div className="flex justify-center text-black dark:text-white">
                <button
                  type="submit"
                  className="bg-thirdLightBlue dark:bg-thirdDarkBlue px-4 py-2 rounded-md"
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