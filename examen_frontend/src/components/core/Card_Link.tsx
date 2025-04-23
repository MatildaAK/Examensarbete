import React from "react";
import { Link, LinkProps } from "react-router-dom";
import clsx from "clsx";

interface LinkCardProps extends LinkProps {
  className?: string;
  children: React.ReactNode;
}

const LinkCard: React.FC<LinkCardProps> = ({ to, className, children, ...rest }) => {
  return (
    <Link
      to={to}
      className={clsx("group text-center no-underline", className)}
      {...rest}
    >
      <div className="bg-secondaryColor text-textColor relative flex flex-col cursor-pointer items-center justify-center gap-y-2 rounded-lg py-6 text-center text-lg font-bold uppercase group-hover:bg-hoverOnButton">
        {children}
      </div>
    </Link>
  );
};

export default LinkCard;
