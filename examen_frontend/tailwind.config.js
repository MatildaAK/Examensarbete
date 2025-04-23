/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      boxShadow: {
        custom: "0 4px 6px -1px #c5c5c5, 0 2px 4px -2px #c5c5c5",
      },
      container: {
        center: true,
        padding: "4rem",
        screens: {
          sm: "24rem",
          md: "28rem",
          lg: "32rem",
          xl: "36rem",
        },
      },
    },
    fontFamily: {
      sans: ["Poppins", "sans-serif"],
    },
    colors: {
      hoverOnLink: "#B5C0F8",
      darkPurple: "#06020D",
      halfDarkpurple: "#252C54",
      textColor: "#ffffff",
      //primary = blue
      secondaryColor: "#92468e",
      primaryColor: "#3bb8be",
      //third = red
      thirdColor: "#db2c18",
      //darker shade of primary
      hoverOnButton: "#c471c3",
      hoverDangerButton: "#FC5D41",
      textGray: "#979797",
      borderShade: "#d9d9d9"
    },
  },
  plugins: [],
}

