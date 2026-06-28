-- ============================================
-- PRUEBA TÉCNICA - SISTEMA DE INSCRIPCIONES
-- PARTE 1: BASE DE DATOS
-- ============================================

-- CREACIÓN DE BASE DE DATOS
CREATE DATABASE IF NOT EXISTS sistema_inscripciones;
USE sistema_inscripciones;

-- ============================================
-- DDL: CREACIÓN DE TABLAS
-- ============================================

-- Tabla de alumnos
CREATE TABLE alumnos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    empresa VARCHAR(100),
    fecha_ingreso DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de programas
CREATE TABLE programas (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    duracion_meses INT,
    activo BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de inscripciones
CREATE TABLE inscripciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_alumno INT NOT NULL,
    id_programa INT NOT NULL,
    fecha_inscripcion DATE NOT NULL,
    estatus_actual ENUM('Activo', 'Baja de empresa', 'Baja del programa', 'Inscrito', 'Suspendido', 'Reingreso', 'Egresado') DEFAULT 'Inscrito',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id) ON DELETE CASCADE,
    FOREIGN KEY (id_programa) REFERENCES programas(id) ON DELETE CASCADE
);

-- Tabla de historial de estatus
CREATE TABLE historial_estatus (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_inscripcion INT NOT NULL,
    estatus_anterior VARCHAR(50),
    estatus_nuevo VARCHAR(50) NOT NULL,
    fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    motivo TEXT,
    FOREIGN KEY (id_inscripcion) REFERENCES inscripciones(id) ON DELETE CASCADE
);

-- ============================================
-- DML: INSERCIÓN DE DATOS
-- ============================================

-- Programas académicos
INSERT INTO programas (nombre, descripcion, duracion_meses) VALUES
('Desarrollo Web Full Stack', 'Programa completo de desarrollo web', 6),
('Data Science', 'Ciencia de datos y machine learning', 8),
('Marketing Digital', 'Estrategias de marketing online', 4),
('Ciberseguridad', 'Seguridad informática y hacking ético', 6);

-- Alumnos (mínimo 10)
INSERT INTO alumnos (nombre, empresa, fecha_ingreso) VALUES
('Ana García López', 'TechCorp', '2024-01-15'),
('Carlos Martínez Ruiz', 'DataSystems', '2024-02-01'),
('María Rodríguez Sánchez', 'InnovaTech', '2024-02-15'),
('Juan Torres Hernández', 'TechCorp', '2024-03-01'),
('Laura Díaz Flores', 'DataSystems', '2024-03-15'),
('Pedro Ramírez Cruz', 'WebSolutions', '2024-04-01'),
('Sofía Morales Vega', 'InnovaTech', '2024-04-15'),
('Diego Castro Jiménez', 'TechCorp', '2024-05-01'),
('Valentina Ortiz Mendoza', 'DataSystems', '2024-05-15'),
('Fernando Ruiz Navarro', 'WebSolutions', '2024-06-01'),
('Andrea Vargas Ponce', 'CloudTech', '2024-06-15'),
('Roberto Sánchez Luna', 'CloudTech', '2024-06-20');

-- Inscripciones
INSERT INTO inscripciones (id_alumno, id_programa, fecha_inscripcion, estatus_actual) VALUES
(1, 1, '2024-01-15', 'Activo'),
(2, 2, '2024-02-01', 'Activo'),
(3, 3, '2024-02-15', 'Baja de empresa'),
(4, 1, '2024-03-01', 'Activo'),
(5, 2, '2024-03-15', 'Baja del programa'),
(6, 4, '2024-04-01', 'Activo'),
(7, 1, '2024-04-15', 'Suspendido'),
(8, 2, '2024-05-01', 'Reingreso'),
(9, 3, '2024-05-15', 'Egresado'),
(10, 4, '2024-06-01', 'Activo'),
(11, 1, '2024-06-15', 'Activo'),
(12, 2, '2024-06-20', 'Inscrito');

-- Historial de estatus (al menos 8 movimientos)
INSERT INTO historial_estatus (id_inscripcion, estatus_anterior, estatus_nuevo, fecha_cambio, motivo) VALUES
(1, NULL, 'Inscrito', '2024-01-15 09:00:00', 'Inscripción inicial'),
(1, 'Inscrito', 'Activo', '2024-01-20 10:00:00', 'Inicio de clases'),
(3, 'Inscrito', 'Activo', '2024-02-15 09:00:00', 'Inicio de actividades'),
(3, 'Activo', 'Baja de empresa', '2024-05-10 14:30:00', 'Cambio de empleo'),
(4, 'Inscrito', 'Activo', '2024-03-01 09:00:00', 'Inicio de clases'),
(5, 'Inscrito', 'Activo', '2024-03-15 09:00:00', 'Inicio de actividades'),
(5, 'Activo', 'Baja del programa', '2024-06-01 11:00:00', 'Problemas personales'),
(8, 'Baja de empresa', 'Reingreso', '2024-05-01 09:00:00', 'Reincorporación a nueva empresa'),
(9, 'Activo', 'Egresado', '2024-11-15 18:00:00', 'Finalización exitosa del programa'),
(7, 'Activo', 'Suspendido', '2024-07-01 10:00:00', 'Falta de pago');

-- ============================================
-- CONSULTAS REQUERIDAS
-- ============================================

-- 1. Alumnos activos por programa
SELECT 
    p.nombre AS programa,
    COUNT(i.id) AS alumnos_activos
FROM programas p
LEFT JOIN inscripciones i ON p.id = i.id_programa 
    AND i.estatus_actual = 'Activo'
GROUP BY p.id, p.nombre
ORDER BY alumnos_activos DESC;

-- 2. Alumnos que tuvieron al menos un cambio de estatus en los últimos 30 días
SELECT DISTINCT
    a.id,
    a.nombre,
    i.id AS id_inscripcion,
    p.nombre AS programa,
    MAX(h.fecha_cambio) AS ultimo_cambio
FROM alumnos a
JOIN inscripciones i ON a.id = i.id_alumno
JOIN programas p ON i.id_programa = p.id
JOIN historial_estatus h ON i.id = h.id_inscripcion
WHERE h.fecha_cambio >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
GROUP BY a.id, a.nombre, i.id, p.nombre
HAVING COUNT(h.id) >= 1;

-- 3. Tasa de baja por programa (bajas / total inscritos)
SELECT 
    p.nombre AS programa,
    COUNT(i.id) AS total_inscritos,
    SUM(CASE WHEN i.estatus_actual IN ('Baja de empresa', 'Baja del programa') THEN 1 ELSE 0 END) AS bajas,
    ROUND(
        SUM(CASE WHEN i.estatus_actual IN ('Baja de empresa', 'Baja del programa') THEN 1 ELSE 0 END) * 100.0 / 
        NULLIF(COUNT(i.id), 0), 
        2
    ) AS tasa_baja_porcentaje
FROM programas p
LEFT JOIN inscripciones i ON p.id = i.id_programa
GROUP BY p.id, p.nombre;

-- 4. Historial completo de un alumno específico (JOIN de 4 tablas)
SELECT 
    a.id AS id_alumno,
    a.nombre AS alumno,
    a.empresa,
    p.nombre AS programa,
    i.fecha_inscripcion,
    i.estatus_actual,
    h.estatus_anterior,
    h.estatus_nuevo,
    h.fecha_cambio,
    h.motivo
FROM alumnos a
JOIN inscripciones i ON a.id = i.id_alumno
JOIN programas p ON i.id_programa = p.id
LEFT JOIN historial_estatus h ON i.id = h.id_inscripcion
WHERE a.id = 1  -- Cambiar por el ID del alumno deseado
ORDER BY h.fecha_cambio;

-- 5. Alumnos que pasaron de baja_empresa a activo (reingreso)
SELECT 
    a.id,
    a.nombre,
    a.empresa,
    p.nombre AS programa,
    h.estatus_anterior,
    h.estatus_nuevo,
    h.fecha_cambio,
    h.motivo
FROM alumnos a
JOIN inscripciones i ON a.id = i.id_alumno
JOIN programas p ON i.id_programa = p.id
JOIN historial_estatus h ON i.id = h.id_inscripcion
WHERE h.estatus_anterior = 'Baja de empresa' 
    AND h.estatus_nuevo = 'Activo';

-- ============================================
-- INDICADOR DE NEGOCIO
-- ============================================
/*
NOMBRE: Tasa de Retención de Alumnos
DEFINICIÓN: Porcentaje de alumnos que permanecen activos en el programa 
            respecto al total de alumnos que iniciaron en el período.
FÓRMULA: (Alumnos Activos / Total Alumnos Inscritos) * 100
JUSTIFICACIÓN: Este indicador es crucial para medir la efectividad del programa
               educativo y la satisfacción de los alumnos. Una tasa baja puede 
               indicar problemas en el contenido, metodología o soporte.
               Ayuda a tomar decisiones sobre mejoras en el programa.
*/

-- Query del indicador
SELECT 
    p.nombre AS programa,
    COUNT(DISTINCT i.id_alumno) AS total_inscritos,
    SUM(CASE WHEN i.estatus_actual = 'Activo' THEN 1 ELSE 0 END) AS activos_actuales,
    ROUND(
        SUM(CASE WHEN i.estatus_actual = 'Activo' THEN 1 ELSE 0 END) * 100.0 / 
        NULLIF(COUNT(DISTINCT i.id_alumno), 0),
        2
    ) AS tasa_retencion
FROM programas p
LEFT JOIN inscripciones i ON p.id = i.id_programa
GROUP BY p.id, p.nombre;

-- ============================================
-- STORED PROCEDURE
-- ============================================

DELIMITER //

CREATE PROCEDURE registrar_cambio_estatus(
    IN p_id_inscripcion INT,
    IN p_nuevo_estatus VARCHAR(50),
    IN p_motivo TEXT
)
BEGIN
    DECLARE v_estatus_actual VARCHAR(50);
    
    -- Verificar que la inscripción existe
    SELECT estatus_actual INTO v_estatus_actual
    FROM inscripciones
    WHERE id = p_id_inscripcion;
    
    IF v_estatus_actual IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Error: La inscripción especificada no existe';
    ELSEIF v_estatus_actual = p_nuevo_estatus THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: El nuevo estatus es igual al actual';
    ELSE
        -- Iniciar transacción
        START TRANSACTION;
        
        -- Actualizar estatus en inscripciones
        UPDATE inscripciones 
        SET estatus_actual = p_nuevo_estatus
        WHERE id = p_id_inscripcion;
        
        -- Insertar en historial
        INSERT INTO historial_estatus (
            id_inscripcion, 
            estatus_anterior, 
            estatus_nuevo, 
            motivo
        ) VALUES (
            p_id_inscripcion,
            v_estatus_actual,
            p_nuevo_estatus,
            p_motivo
        );
        
        -- Confirmar transacción
        COMMIT;
        
        SELECT CONCAT('Cambio de estatus registrado exitosamente: ', 
                     v_estatus_actual, ' -> ', p_nuevo_estatus) AS mensaje;
    END IF;
END //

DELIMITER ;

-- Ejemplo de uso del SP:
-- CALL registrar_cambio_estatus(1, 'Suspendido', 'Falta de pago');
