import ReactDOM from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import { createBrowserRouter, Navigate, RouterProvider } from 'react-router-dom';
import UserList from './user/UserList.tsx';
import ShowUser from './user/ShowUser.tsx';
import Home from './Home/Home.tsx';
import { AuthProvider, useAuth } from './components/Auth/Auth.tsx';
import Login from './Login/Login.tsx';
import HotelList from './Hotels/HotelList.tsx';
import HotelShow from './Hotels/HotelShow.tsx';

interface ProtectedRouteProps {
  element: React.ReactElement;
}

const ProtectedRoute: React.FC<ProtectedRouteProps> = ({ element }) => {
  const { isAuthenticated, token } = useAuth();

  if (isAuthenticated) {
    return element;
  }
  if (token !== null) {
    return element;
  }

  return <Navigate to="/login" />;
};

const router = createBrowserRouter([
  {
    path: '/',
    element: (
      <>
        <App />
      </>
    ),
    children: [
      {
        path: "login",
        element: <Login />
      },
      {
        path: '',
        element: <ProtectedRoute element={<Home />} />
      },
      {
        path: 'users',
        element:  <ProtectedRoute element={<UserList />} />
      },
      {
        path: 'users/:id',
        element:  <ProtectedRoute element={<ShowUser />} />
      },
      {
        path: 'hotels',
        element:  <ProtectedRoute element={<HotelList />} />
      },
      {
        path: 'hotels/:id',
        element:  <ProtectedRoute element={<HotelShow />} />
      },
    ],
  },
]);

ReactDOM.createRoot(document.getElementById('root')!).render(
  <AuthProvider>
    <RouterProvider router={router} />
  </AuthProvider>
)

