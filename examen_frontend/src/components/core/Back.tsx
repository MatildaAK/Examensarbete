import { useNavigate } from "react-router-dom";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faArrowLeftLong } from "@fortawesome/free-solid-svg-icons";

interface BackButtonProps {
  children?: React.ReactNode;
}

const Back: React.FC<BackButtonProps> = ({ children }) => {
  const navigate = useNavigate();

  return (
    <div className="my-6">
      <button
        onClick={() => navigate(-1)}
        className="inline-flex items-center text-sm font-semibold leading-6 border-none bg-textColor cursor-pointer"
      >
        <FontAwesomeIcon icon={faArrowLeftLong} className="h-4 w-4 mr-2"  />
        {children || "Tillbaka"}
      </button>
    </div>
  );
};

export default Back;
