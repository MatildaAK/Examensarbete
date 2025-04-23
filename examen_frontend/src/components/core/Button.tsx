interface ButtonProps {
    children: React.ReactNode;
    type: "button" | "submit";
    variant?: "primary" | "secondary" | "danger";
    size?: "small";
    onClick?: (event: React.MouseEvent<HTMLElement>) => void;
    filterButton?: "filterButton";
    filterItem?: "filterItem";
  }

  const Button: React.FC<ButtonProps> = ({
    children,
    type,
    variant,
    size,
    onClick,
    filterButton
  }) => {
    return (
        <>
          {variant === "primary" ? (
            <button
              className={`${
                size === "small" ? "min-h-12 min-w-32" : "min-h-12 w-80"
              } h-fit 'cursor-pointer rounded bg-secondaryColor hover:bg-hoverOnButton border-hoverOnButton text-textColor font-semibold text-base hover:text-lg font-poppins shadow-custom'`}
              type={type}
              onClick={onClick}
            >
              <div
                className={`flex flex-row ${
                  filterButton ? "justify-between pr-4 pl-4" : "justify-center"
                } items-center `}
              >
                {filterButton ? (
                  <>
                    <div className="flex flex-row items-center">
                      {children}
                    </div>
                  </>
                ) : (
                  <>
                    {children}
                  </>
                )}
              </div>
            </button>
          ) : (
            <button
              className={`${
                size === "small" ? "min-h-12 min-w-32" : "min-h-12 min-w-80"
              } h-fit 'cursor-pointer rounded border border-thirdColor bg-thirdColor hover:bg-hoverDangerButton font-semibold text-textColor text-base hover:text-lg font-poppins shadow-custom '`}
              type={type}
              onClick={onClick}
            >
              <div className="flex flex-row justify-center items-center ">
                {children}
              </div>
            </button>
          )}
        </>
      );
  }

  export default Button;