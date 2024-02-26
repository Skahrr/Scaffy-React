#!/bin/bash


print_success() {
  echo -e "\e[32m$1\e[0m"
}


print_warning() {
  echo -e "\e[33m$1\e[0m"
}


print_error() {
  echo -e "\e[31m$1\e[0m"
}


get_input() {
  local message="$1"
  local result

  result=$(whiptail --inputbox "$message" 8 60 3>&1 1>&2 2>&3)
  echo "$result"
}


get_selection() {
  local title="$1"
  local message="$2"
  shift 2
  local options=("$@")
  local selection

  selection=$(whiptail --title "$title" --menu "$message" 20 60 10 "${options[@]}" 3>&1 1>&2 2>&3)
  echo "$selection"
}


print_warning "==========================================="
print_warning "|       Welcome to Lazy-React-Setup!      |"
print_warning "==========================================="
echo ""
echo "This script is going to guide you through the process of creating a React project with Vite, including basic files and folders"
echo ""

projectName=$(get_input "What is the name of your project?")
while [[ -z "$projectName" ]]; do
  projectName=$(get_input "What is the name of your project?")
done


print_warning "\n======================================="
print_warning "|   Creating a new project ...        |"
print_warning "======================================="
npx create-vite@latest "$projectName" --template react


cd "$projectName"


print_warning "\n==========================================="
print_warning "|  Installing dependencies ...            |"
print_warning "==========================================="
npm install


rm -r public/*
rm -r src/assets/*


echo "" > src/App.css
echo "" > src/index.css


echo "import \"./App.css\";

function App() {
  return <div></div>;
}

export default App;" > src/App.jsx


mkdir src/components
mkdir src/pages
mkdir src/services
mkdir src/router


touch src/services/config.js


echo "import axios from 'axios';

const api = axios.create({
  baseURL: 'https://api.example.com', // Reemplazar con la URL base de tu API
});

export default api;" > src/services/config.js


echo ""
numComponents=$(get_input "How many components are you going to use?")
while [[ ! "$numComponents" =~ ^[0-9]+$ ]]; do
  print_error "Por favor, ingresa un número válido."
  numComponents=$(get_input "How many components are you going to use?")
done


for ((i=1; i<=numComponents; i++)); do
  componentName="Component$i"

  mkdir "src/components/$componentName"
  touch "src/components/$componentName/$componentName.jsx"
  touch "src/components/$componentName/$componentName.css"
  echo "import React from 'react';
import './$componentName.css';

const $componentName = () => {
  return (
    <div>
      {/* Contenido del componente */}
    </div>
  );
};

export default $componentName;" > "src/components/$componentName/$componentName.jsx"
done


echo ""
numPages=$(get_input "How many pages are you going to use?")
while [[ ! "$numPages" =~ ^[0-9]+$ ]]; do
  print_error "Por favor, ingresa un número válido."
  numPages=$(get_input "How many pages are you going to use?")
done


for ((i=1; i<=numPages; i++)); do
  pageName="Page$i"

  mkdir "src/pages/$pageName"
  touch "src/pages/$pageName/$pageName.jsx"
  touch "src/pages/$pageName/$pageName.css"
  echo "import React from 'react';
import './$pageName.css';

const $pageName = () => {
  return (
    <div>
      {/* Contenido del componente */}
    </div>
  );
};

export default $pageName;" > "src/pages/$pageName/$pageName.jsx"
done



mkdir src/pages/Home


touch src/pages/Home/Home.jsx
touch src/pages/Home/Home.css


echo "import './Home.css';

const Home = () => {
  return (
    <div>
      {/* Contenido del componente */}
    </div>
  );
};

export default Home;" > src/pages/Home/Home.jsx



echo ""
while true; do
  layoutOption=$(get_selection "Select one option" "Would you like to setup a default layout?" \
    "Yes" "Create a default layout" \
    "No" "Do not create a default layout")
  if [[ "$layoutOption" == "Yes" || "$layoutOption" == "No" ]]; then
    break
  else
    print_error "Please, select a valid option."
  fi
done

if [ "$layoutOption" == "Yes" ]; then

  mkdir src/layouts


  touch src/layouts/index.jsx


  echo "import { Outlet } from 'react-router-dom';

function Root() {
  return (
    <div>
      <Outlet />
    </div>
  );
}

export default Root;" > src/layouts/index.jsx
fi



echo ""
while true; do
  routerOption=$(get_selection "Select one option" "Would you like to setup a default router?" \
    "Yes" "Create a default router" \
    "No" "Do not create a default router")
  if [[ "$routerOption" == "Yes" || "$routerOption" == "No" ]]; then
    break
  else
    print_error "Please, select a valid answer."
  fi
done

if [[ "$routerOption" == "Yes" && "$layoutOption" == "No" ]]; then

  
  echo "import { createBrowserRouter } from 'react-router-dom';

import Home from '../pages/Home/Home';

const router = createBrowserRouter([
  {
    path: '/',
    element: <Home />,
  },
]);

export default router;" > src/router/index.jsx
else
  echo "import { createBrowserRouter } from 'react-router-dom'

import Home from '../pages/Home/Home'
import Root from '../layouts'

const router = createBrowserRouter([
  {
    path: '/',
    element: <Root />,
    children: [
      {
        path: '/',
        element: <Home />
      }
    ]
  }
])

export default router" > src/router/index.jsx

  echo "import { RouterProvider } from 'react-router-dom';
import router from './router';
import './App.css';

function App() {
  return (
    <>
      <RouterProvider router={router} />
    </>
  );
}

export default App;" > src/App.jsx
fi



echo ""
frameworkOption=$(get_selection "Select a CSS Framework" "Choose between one of the options:" \
  "Material UI" "Popular React Framework" \
  "Tailwind" "CSS utilities Framework" \
  "Vanilla CSS" "Traditional CSS")
frameworkOption=$(echo "$frameworkOption" | tr -d '"')

case $frameworkOption in
  "Material UI")

    print_warning "\n==========================================="
    print_warning "|  Installing Material UI...              |"
    print_warning "==========================================="
    npm install @mui/material @emotion/react @emotion/styled

    npm install @mui/icons-material

    npm install @fontsource/roboto

    echo "import { createTheme } from '@mui/material/styles';
import { ThemeProvider } from '@mui/material/styles';
import { CssBaseline } from '@mui/material';

const theme = createTheme({
  typography: {
    fontFamily: 'Roboto, sans-serif',
    fontWeightLight: 300,
    fontWeightRegular: 400,
    fontWeightMedium: 500,
    fontWeightBold: 700,
  },
});

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      {/* Contenido de la aplicación */}
    </ThemeProvider>
  );
}

export default App;" > src/main.jsx
    ;;
  "Tailwind")

    print_warning "\n==========================================="
    print_warning "|  Installing Tailwind CSS...             |"
    print_warning "==========================================="
    npm install -D tailwindcss@latest postcss@latest autoprefixer@latest
    npx tailwindcss init -p
    
    echo "/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './src/**/*.{js,jsx,ts,tsx}',
  ],
  theme: {
    extend: {},
  },
  plugins: [],
};" > tailwind.config.js

    echo "@tailwind base;
@tailwind components;
@tailwind utilities;" > src/index.css
    ;;
  "Vanilla CSS")

    print_warning "\n==========================================="
    print_warning "|    Using Vanilla CSS...                 |"
    print_warning "==========================================="
    ;;
  *)
    print_error "Option not valid. Please, choose one of the options above."
    ;;
esac


print_warning "\n==========================================="
print_warning "|    Installing NPM dependencies          |"
print_warning "==========================================="
npm i axios
npm i react-router-dom@6


print_success "\n==========================================="
print_success "|   Project created successfuly!          |"
print_success "==========================================="
echo ""
echo "The project '$projectName' has been created successfuly. Are the folders and files created have been adjusted according to your preferences."
echo "To run your project, follow these commands:"
echo ""
echo "cd $projectName"
echo "npm run dev"
echo ""
echo "Happy coding!"

