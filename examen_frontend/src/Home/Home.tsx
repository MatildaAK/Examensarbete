import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import LinkCard from "../components/core/Card_Link";
import { faUsers } from "@fortawesome/free-solid-svg-icons";
import Container from "../components/core/Container";


const Home = () => {
    return (
        <>
        <Container className="my-6">
            <section className="grid grid-cols-1 gap-y-6 sm:grid-cols-3 sm:gap-x-4">
                <LinkCard to="/users"><FontAwesomeIcon icon={faUsers} className="h-16 w-16" /> <span className="ml-4">users</span> </LinkCard>
                <LinkCard to="/users"><FontAwesomeIcon icon={faUsers} className="h-16 w-16" /> <span className="ml-4">users</span> </LinkCard>
                <LinkCard to="/users"><FontAwesomeIcon icon={faUsers} className="h-16 w-16" /> <span className="ml-4">users</span> </LinkCard>
            </section>
        </Container>
        </>
    );
};

export default Home;