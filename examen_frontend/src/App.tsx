import { Outlet, useNavigate } from 'react-router-dom'
import './App.css'
import Header from './components/Header/Header'
import { useAuth } from './components/Auth/Auth';
import Footer from './components/Footer/Footer';

function App() {
  const navigate = useNavigate();
  const { login, logout, isAuthenticated, loading } = useAuth();

  const handleLogin = (user_name: string, userId: string, token: string, tenant: string) => {
    login(user_name, userId, token, tenant);
    navigate("/");
  };

  const handleLogout = () => {
    logout();
    navigate("/");
  };

  if (loading) {
    return <div>Loading...</div>;
  }

  return (
    <main className='min-h-screen flex flex-col'>
      <Header />
      <div className='flex-grow'>
        <Outlet         
           context={{
              onLogin: handleLogin,
            }} />
      </div>
      <Footer isAuthenticated={isAuthenticated} onLogout={handleLogout} />
    </main>
  );
};

export default App;
