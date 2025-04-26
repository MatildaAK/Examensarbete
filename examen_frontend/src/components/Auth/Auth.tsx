import { createContext, useState, useContext, ReactNode, useEffect } from "react";

interface AuthContextType {
  isAuthenticated: boolean;
  userName: string | null;
  userId: string | null;
  token: string | null;
  tenant: string | null;
  login: (user_name: string, id: string, token: string, tenant: string) => void;
  logout: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider = ({ children }: { children: ReactNode }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [userName, setUserName] = useState<string | null>(null);
  const [userId, setUserId] = useState<string | null>(localStorage.getItem("id"));
  const [token, setToken] = useState<string | null>(localStorage.getItem("token"));
  const [tenant, setTenant] = useState<string | null>(localStorage.getItem("tenant"))

  function isTokenExpired(token: string | null) {
    if (!token) return true;
    const parts = token.split('.');
    if (parts.length !== 3) return true;
    try {
      const payload = JSON.parse(atob(parts[1]));
      const currentTime = Math.floor(Date.now() / 1000);
      return payload.exp < currentTime;
    } catch (error) {
      console.error("Invalid token", error);
      return true;
    }
  }
  

  useEffect(() => {
    const storedToken = localStorage.getItem("token");
    const storedUserName = localStorage.getItem("user_name");
    const storedUserId = localStorage.getItem("id");
    const storedTenant = localStorage.getItem("tenant");
    
    if (storedToken && !isTokenExpired(storedToken)) {
      setToken(storedToken);
      setUserName(storedUserName);
      setUserId(storedUserId);
      setIsAuthenticated(true);
      setTenant(storedTenant);
    } else {
      logout();
    }
  }, []);

  const login = (user_name: string, userId: string, token: string, tenant: string) => {
    setIsAuthenticated(true);
    setUserName(user_name);
    setUserId(userId);
    setToken(token);
    setTenant(tenant);
    localStorage.setItem("isAuthenticated", "true");
    localStorage.setItem("user_name", user_name);
    localStorage.setItem("id", userId);
    localStorage.setItem("token", token);
    localStorage.setItem("tenant", tenant);
  };

  const logout = () => {
    setIsAuthenticated(false);
    setUserName(null);
    setUserId(null);
    setToken(null);
    setTenant(null);
    localStorage.removeItem("isAuthenticated");
    localStorage.removeItem("user_name");
    localStorage.removeItem('token');
    localStorage.removeItem('id');
    localStorage.removeItem("tenant");
  };

  return (
    <AuthContext.Provider value={{ isAuthenticated, userName, userId, token, tenant, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
};
