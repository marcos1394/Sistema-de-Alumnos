# Sistema de Inscripciones - Prueba Técnica

## Descripción
Sistema completo de registro, seguimiento y análisis de inscripciones para un programa educativo.

## Estructura del Proyecto

```
sistema-inscripciones/
├── database/
│   └── sistema_inscripciones.sql
├── analysis/
│   ├── analisis_datos.ipynb
│   └── requirements.txt
├── frontend/
│   └── sistema-inscripciones/
└── README.md
```

## Requisitos Previos

- MariaDB 10.4+
- Python 3.8+
- Node.js 14+
- Angular CLI 12+

## Instalación Rápida

### 1. Base de Datos

```bash
cd database
mysql -u root -p < sistema_inscripciones.sql
```

### 2. Análisis de Datos

```bash
cd analysis
python3 -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate
pip install -r requirements.txt
jupyter notebook analisis_datos.ipynb
```

### 3. Frontend Angular

```bash
cd frontend/sistema-inscripciones
npm install
ng serve
# Abrir http://localhost:4200
```

## Configuración de Base de Datos

- Asegúrate de que MariaDB esté corriendo.
- Modifica la contraseña en el archivo de análisis.
- Ejecuta primero el script SQL.

## Tecnologías Utilizadas

- **Backend DB:** MariaDB
- **Análisis:** Python (Pandas, Matplotlib, Seaborn)
- **Frontend:** Angular 17, Bootstrap 5
- **Conexión:** SQLAlchemy, PyMySQL

## Autor

**Marcos Sandoval Ruiz**

