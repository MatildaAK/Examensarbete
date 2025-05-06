import logo from "/logo.png"
  
const Navbar = () => {

    return(
        <>
        <div>
            <div className="mx-auto my-4 flex items-center justify-center">
                <div className="w-full">
                    <div>
                        <img src={logo} alt="Logo" className="h-24 w-24" />
                    </div>
                </div>
            </div>
            <div className="flex justify-center">
                <div className="w-[80%]">
                    <div className="h-14 bg-primaryColor rounded-lg uppercase flex items-center justify-center font-extrabold text-textColor">Välkommen!</div>
                </div>
            </div>
        </div>
        </>
    )
}




export default Navbar;

