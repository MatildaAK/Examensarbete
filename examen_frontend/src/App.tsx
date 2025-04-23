import { Outlet } from 'react-router-dom'
import './App.css'
import Header from './components/Header/Header'

function App() {

  return (
    <>
      <Header />
      <div className='mx-auto'>
        <Outlet />
      </div>
    </>
  )
}

export default App
