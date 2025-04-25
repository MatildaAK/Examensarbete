import { Outlet, useNavigate } from 'react-router-dom'
import './App.css'
import Header from './components/Header/Header'
import { useAuth } from './components/Auth/Auth';

function App() {
  const navigate = useNavigate();
  const { login, logout, isAuthenticated } = useAuth();

  const handleLogin = (user_name: string, userId: string, token: string, tenant: string) => {
    login(user_name, userId, token, tenant);
    navigate("/");
  };

  const handleLogout = () => {
    logout();
    navigate("/");
  };

  return (
    <main>
      <Header isAuthenticated={isAuthenticated} onLogout={handleLogout} />
      <div className='mx-auto'>
        <Outlet         
           context={{
              onLogin: handleLogin,
            }} />
      </div>
    </main>
  );
};

export default App;
