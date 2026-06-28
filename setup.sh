#!/bin/bash

echo "========================================="
echo "INSTALACIÓN DEL SISTEMA DE INSCRIPCIONES"
echo "========================================="

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Función para verificar errores
check_error() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error: $1${NC}"
        exit 1
    fi
}

# 1. Verificar requisitos
echo -e "${YELLOW}Verificando requisitos...${NC}"

# Verificar Node.js
if command -v node &> /dev/null; then
    echo -e "${GREEN}✓ Node.js instalado: $(node --version)${NC}"
else
    echo -e "${RED}✗ Node.js no encontrado. Instálalo desde https://nodejs.org${NC}"
    exit 1
fi

# Verificar Python
if command -v python3 &> /dev/null; then
    echo -e "${GREEN}✓ Python instalado: $(python3 --version)${NC}"
else
    echo -e "${RED}✗ Python no encontrado. Instálalo desde https://python.org${NC}"
    exit 1
fi

# Verificar MySQL/MariaDB
if command -v mysql &> /dev/null; then
    echo -e "${GREEN}✓ MySQL/MariaDB instalado${NC}"
else
    echo -e "${YELLOW}⚠ MySQL/MariaDB no encontrado. Instálalo para la parte de base de datos${NC}"
fi

# 2. Configurar Base de Datos
echo -e "\n${YELLOW}Configurando base de datos...${NC}"
if [ -f "database/sistema_inscripciones.sql" ]; then
    echo -e "${GREEN}✓ Script SQL encontrado${NC}"
    echo "Para ejecutarlo: mysql -u root -p < database/sistema_inscripciones.sql"
else
    echo -e "${RED}✗ Script SQL no encontrado${NC}"
fi

# 3. Configurar entorno Python
echo -e "\n${YELLOW}Configurando entorno Python...${NC}"
cd analysis
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo -e "${GREEN}✓ Entorno virtual creado${NC}"
else
    echo -e "${GREEN}✓ Entorno virtual existente${NC}"
fi

source venv/bin/activate 2>/dev/null || source venv/Scripts/activate 2>/dev/null
pip install --upgrade pip
pip install -r requirements.txt
check_error "No se pudieron instalar las dependencias de Python"
echo -e "${GREEN}✓ Dependencias Python instaladas${NC}"
cd ..

# 4. Configurar Frontend
echo -e "\n${YELLOW}Configurando frontend Angular...${NC}"
cd frontend/sistema-inscripciones

if [ ! -d "node_modules" ]; then
    echo "Instalando dependencias de Angular (esto puede tomar unos minutos)..."
    npm install
    check_error "No se pudieron instalar las dependencias de Angular"
    echo -e "${GREEN}✓ Dependencias Angular instaladas${NC}"
else
    echo -e "${GREEN}✓ Dependencias Angular existentes${NC}"
fi

cd ../..

# 5. Resumen final
echo -e "\n${GREEN}=========================================${NC}"
echo -e "${GREEN}¡INSTALACIÓN COMPLETADA EXITOSAMENTE!${NC}"
echo -e "${GREEN}=========================================${NC}"
echo -e "\nPara comenzar:"
echo -e "1. Base de datos: ${YELLOW}mysql -u root -p < database/sistema_inscripciones.sql${NC}"
echo -e "2. Análisis Python: ${YELLOW}cd analysis && source venv/bin/activate && jupyter notebook${NC}"
echo -e "3. Frontend Angular: ${YELLOW}cd frontend/sistema-inscripciones && ng serve${NC}"
echo -e "\n${GREEN}¡Buena suerte con tu prueba técnica!${NC}"
