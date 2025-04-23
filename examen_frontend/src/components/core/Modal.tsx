import React, { useEffect, useRef } from "react";
import { createPortal } from "react-dom";

interface ModalProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
}

const Modal: React.FC<ModalProps> = ({ isOpen, onClose, title, children }) => {
  const overlayRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const handleKeyDown = (e: KeyboardEvent) => {
      if (e.key === "Escape") {
        onClose();
      }
    };

    if (isOpen) {
      document.addEventListener("keydown", handleKeyDown);
    }

    return () => document.removeEventListener("keydown", handleKeyDown);
  }, [isOpen, onClose]);

  const handleClickOutside = (e: React.MouseEvent<HTMLDivElement>) => {
    if (e.target === overlayRef.current) {
      onClose();
    }
  };

  if (!isOpen) return null;

  return createPortal(
    <div
      ref={overlayRef}
      className="fixed inset-0 z-50 flex items-center justify-center"
      onClick={handleClickOutside}
    >
      <div className="bg-textColor rounded-2xl shadow-lg w-full max-w-3xl h-auto p-6 sm:p-8">
        <div className="flex justify-between items-start mb-4">
          <h2 className="text-xl font-semibold">{title}</h2>
          <button
            onClick={onClose}
            className="text-lg border-none bg-textColor"
            aria-label="Stäng modal"
          >
            ×
          </button>
        </div>
        <div>{children}</div>
      </div>
    </div>,
    document.body
  );
};

export default Modal;
