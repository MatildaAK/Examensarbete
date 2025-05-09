import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import LinkCard from "../components/core/Card_Link";
import { faBuilding, faCity, faHotel, faUsers } from "@fortawesome/free-solid-svg-icons";
import Container from "../components/core/Container";


const Home = () => {
    return (
        <>
        <Container className="my-6">
            <section className="grid grid-cols-1 gap-y-6 sm:grid-cols-3 sm:gap-x-4">
                <LinkCard to="/users"><FontAwesomeIcon icon={faUsers} className="h-16 w-16" /> <span className="ml-4">användare</span> </LinkCard>
                <LinkCard to="/hotels"><FontAwesomeIcon icon={faHotel} className="h-16 w-16" /> <span className="ml-4">Hotell</span> </LinkCard>
                <LinkCard to="/hotels_1000"><FontAwesomeIcon icon={faCity} className="h-16 w-16" /> <span className="ml-4">Hotell 1000</span> </LinkCard>
                <LinkCard to="/hotel_rooms"><FontAwesomeIcon icon={faBuilding} className="h-16 w-16" /> <span className="ml-4">Hotellrum</span> </LinkCard>
                <LinkCard to="/hotel_rooms_1000"><FontAwesomeIcon icon={faBuilding} className="h-16 w-16" /> <span className="ml-4">Hotellrum 1000</span> </LinkCard>
            </section>
        </Container>
        </>
    );
};

export default Home;