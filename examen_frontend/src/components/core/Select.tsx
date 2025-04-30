import React from "react";

interface Option {
  label: string;
  value: string | number;
}

interface SelectProps {
  name: string;
  label?: string;
  value: string | number;
  onChange: (event: React.ChangeEvent<HTMLSelectElement>) => void;
  options: Option[];
  required?: boolean;
}

const Select: React.FC<SelectProps> = ({
  name,
  label,
  value,
  onChange,
  options,
  required = true,
}) => {
  return (
    <div className="flex flex-col items-start w-full">
      {label && <label htmlFor={name}>{label}</label>}
      <select
        id={name}
        name={name}
        value={value}
        onChange={onChange}
        className="w-full rounded border border-primaryColor p-2 outline-none mt-2 mb-4"
        required={required}
      >
        <option value="">Välj ett alternativ</option>
        {options.map((opt) => (
          <option key={opt.value} value={opt.value}>
            {opt.label}
          </option>
        ))}
      </select>
    </div>
  );
};

export default Select;
