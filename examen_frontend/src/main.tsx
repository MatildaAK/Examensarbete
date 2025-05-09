import ReactDOM from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import { createBrowserRouter, Navigate, RouterProvider } from 'react-router-dom';
import UserList from './user/UserList.tsx';
import UserShow from './user/UserShow.tsx';
import Home from './Home/Home.tsx';
import { AuthProvider, useAuth } from './components/Auth/Auth.tsx';
import Login from './Login/Login.tsx';
import HotelList from './Hotels/HotelList.tsx';
import HotelShow from './Hotels/HotelShow.tsx';
import HotelRoomList from './Hotel_Rooms/HotelRoomList.tsx';
import HotelList1000 from './Hotels/HotelList1000.tsx';
import HotelRoomList1000 from './Hotel_Rooms/HotelRoomList1000.tsx';

interface ProtectedRouteProps {
  element: React.ReactElement;
}

const ProtectedRoute: React.FC<ProtectedRouteProps> = ({ element }) => {
  const { isAuthenticated, token, loading } = useAuth();

  if (isAuthenticated && token) {
    return element;
  }

  if (loading) {
    return <div>Loading...</div>;
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
        element:  <ProtectedRoute element={<UserShow />} />
      },
      {
        path: 'hotels',
        element:  <ProtectedRoute element={<HotelList />} />
      },
      {
        path: 'hotels_1000',
        element:  <ProtectedRoute element={<HotelList1000 />} />
      },
      {
        path: 'hotels/:id',
        element:  <ProtectedRoute element={<HotelShow />} />
      },
      {
        path: 'hotel_rooms',
        element:  <ProtectedRoute element={<HotelRoomList />} />
      },
      {
        path: 'hotel_rooms_1000',
        element:  <ProtectedRoute element={<HotelRoomList1000 />} />
      },
    ],
  },
]);

ReactDOM.createRoot(document.getElementById('root')!).render(
  <AuthProvider>
    <RouterProvider router={router} />
  </AuthProvider>
)

