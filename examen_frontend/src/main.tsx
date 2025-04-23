import ReactDOM from 'react-dom/client'
import './index.css'
import App from './App.tsx'
import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import UserList from './user/UserList.tsx';
import ShowUser from './user/ShowUser.tsx';
import Home from './Home/Home.tsx';

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
        path: '',
        element: <Home />
      },
      {
        path: 'users',
        element: <UserList />
      },
      {
        path: 'users/:id',
        element: <ShowUser />
      },
    ],
  },
]);

ReactDOM.createRoot(document.getElementById('root')!).render(
  <RouterProvider router={router} />
)

