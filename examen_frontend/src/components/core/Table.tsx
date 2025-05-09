import React from "react";

interface Column<T> {
  label: string;
  render: (item: T) => React.ReactNode;
}

interface Action<T> {
  render: (item: T) => React.ReactNode;
}

interface TableProps<T> {
  items: T[];
  columns: Column<T>[];
  actions?: Action<T>[];
  onRowClick?: (item: T) => void;
  rowId?: (item: T) => string | number;
}

const Table = <T extends { id: string | number }>({
  items,
  columns,
  actions = [],
  onRowClick,
  rowId = (item) => item.id,
}: TableProps<T>) => {
  return (
    <div className="overflow-y-auto sm:overflow-visible sm:px-0">
      <table className="w-[40rem] mt-11 sm:w-full">
        <thead className="text-sm leading-6">
          <tr>
            {columns.map((col, i) => (
              <th key={i} className="pr-6 pb-4 font-normal text-start">
                {col.label}
              </th>
            ))}
            {actions.length > 0 && (
              <th className="relative pb-4">
                <span className="sr-only">Actions</span>
              </th>
            )}
          </tr>
        </thead>
        <tbody className="divide-border border border-primaryColor relative divide-y text-sm leading-6">
          {items.map((item) => (
            <tr
              key={rowId(item)}
              className="group border border-primaryColor"
            >
              {columns.map((col, i) => (
                <td
                  key={i}
                  onClick={() => onRowClick?.(item)}
                  className={`relative ${onRowClick ? "cursor-pointer group-hover:bg-primaryColor/30" : ""}`}
                >
                  <div className="block py-4 text-start">
                    <span className="absolute -inset-y-px right-0 -left-4 sm:rounded-l-xl" />
                    <span className={`relative ${i === 0 ? "font-semibold" : ""}`}>
                      {col.render(item)}
                    </span>
                  </div>
                </td>
              ))}
              {actions.length > 0 && (
                <td className="relative w-14">
                  <div className="relative whitespace-nowrap py-4 text-sm font-medium">
                    <span className="absolute -inset-y-px -right-4 left-0 sm:rounded-r-xl" />
                    {actions.map((action, i) => (
                      <span
                        key={i}
                        className="relative font-semibold leading-6"
                      >
                        {action.render(item)}
                      </span>
                    ))}
                  </div>
                </td>
              )}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default Table;
