import clsx from "clsx";

interface ContainerProps {
    className?: string;
    children: React.ReactNode;
}

const Container: React.FC<ContainerProps> = ({ className, children}) => {
    return (
        <div className={clsx("mx-auto w-full px-4 sm:max-w-3xl sm:px-6 lg:px-8", className)}>
            {children}
        </div>
    );
};

export default Container;