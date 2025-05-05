import React from "react";

interface InputProps {
  type:
    | "text"
    | "checkbox"
    | "radio"
    | "email"
    | "date"
    | "time"
    | "number"
    | "datetime-local"
    | "password";
  label?: string;
  name: string;
  value?: string;
  onChange: (event: React.ChangeEvent<HTMLInputElement>) => void;
  placeholder?: string;
  checked?: boolean;
  min?: string;
  max?: string;
  inputMode?: "numeric";
}

const Input: React.FC<InputProps> = ({
  type,
  label,
  name,
  value,
  onChange,
  placeholder,
  checked,
  min,
  max,
  inputMode,
}) => {
  return (
    <div className="flex flex-row">
      {type === "checkbox" ? (
        <div className="flex flex-row justify-between items-center w-full p-2 border rounded border-primaryColor mt-2">
          {label && <label htmlFor={name}>{label}</label>}
          <input
            type={type}
            id={name}
            name={name}
            onChange={(e) => {
              if (onChange) {
                onChange(e);
              }}}
            checked={checked}
            className="size-5 border checked:bg-primaryColor mr-1"
            required
          />
        </div>
      ) : type === "text" || type === "email" || type === "password" ? (
        <div className="flex flex-col items-start w-full">
          {label && <label htmlFor={name}>{label}</label>}
          <input
            type={type}
            name={name}
            value={value}
            onChange={onChange}
            min={min}
            max={max}
            inputMode={inputMode}
            placeholder={placeholder}
            className="w-full h-full rounded border-solid border-primaryColor p-2 outline-none
            focus:invalid:border-hoverOnLink focus:invalid:ring-hoverOnLink mb-4"          
            required
          />
        </div>
      ) : type === "radio" ? (
        <div className="">
          {label && <label htmlFor={name}>{label}</label>}
          <input
            type={type}
            id={name}
            name={name}
            value={value}
            onChange={onChange}
            required
          />
        </div>
      ) : (
        <div className="flex flex-col items-start w-full">
          {label && <label htmlFor={name}>{label}</label>}
          <input
            type={type}
            id={name}
            name={name}
            value={value}
            onChange={onChange}
            placeholder={placeholder}
            className="w-full h-full rounded border-solid border-primaryColor p-2 outline-none
            focus:invalid:border-hoverOnLink focus:invalid:ring-hoverOnLink mt-2"
            required
          />
        </div>
      )}
    </div>
  );
};

export default Input;
