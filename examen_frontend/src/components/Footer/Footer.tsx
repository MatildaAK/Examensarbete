import { faUserTie } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { useEffect, useRef, useState } from "react";
import { Link } from "react-router-dom";

interface FooterProps {
  isAuthenticated: boolean;
  onLogout: () => void;
}

const Footer: React.FC<FooterProps> = ({ isAuthenticated, onLogout }) => {
  const dropdownRef = useRef<HTMLDivElement>(null);
  const [isDropdownVisible, setIsDropdownVisible] = useState(false);

  useEffect(() => {
    setIsDropdownVisible(false);
  }, [isAuthenticated]);

  const toggleDropdown = () => setIsDropdownVisible(!isDropdownVisible);
  const closeDropdown = () => setIsDropdownVisible(false);

  return (
    <>
      <footer className="relative inset-0 bg-primaryColor w-full py-8 flex justify-start">
        <div ref={dropdownRef} className="ml-14">
          {isAuthenticated ? (
            <>
              <FontAwesomeIcon
                icon={faUserTie}
                className="h-[35px] w-[35px] text-textColor cursor-pointer"
                onClick={toggleDropdown}
              />
              {isDropdownVisible && (
                <div className="absolute bottom-full left-0 inline-block text-center w-48 shadow-lg rounded-t-md bg-primaryColor py-6">
                    <dl className="list-none">
                        <dt className="mb-2">
                            <Link
                            to="/#"
                            onClick={closeDropdown}
                            className="text-textColor no-underline"
                            >
                            Min sida
                            </Link>
                        </dt>
                        <dt>
                            <button
                            onClick={onLogout}
                            className="w-full text-textColor border-none bg-primaryColor cursor-pointer"
                            >
                            Logga ut
                            </button>
                        </dt>
                    </dl>
                </div>
                )}

            </>
          ) : (
          <p className="text-textColor font-bold text-xl">Kontaka oss</p>
          )}
        </div>
      </footer>
    </>
  );
};

export default Footer;
