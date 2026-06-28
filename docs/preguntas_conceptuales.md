# PREGUNTAS CONCEPTUALES - PRUEBA TÉCNICA

## SQL / MariaDB

### Pregunta 1
**Tu tabla historial_estatus crece rápido. ¿Qué harías para que las consultas de historial no se vuelvan lentas con el tiempo?**

**Respuesta:** Implementaría particionamiento por fecha (PARTITION BY RANGE), crearía índices compuestos en (id_inscripcion, fecha_cambio), utilizaría una política de archivado para mover registros antiguos a tablas históricas separadas, y configuraría el almacenamiento en caché de consultas frecuentes mediante Redis o Memcached para reducir la carga directa a la base de datos.

### Pregunta 2
**Un alumno aparece dos veces con estatus activo seguido en el historial, sin una baja intermedia. ¿Cómo detectarías ese problema y cómo lo evitarías desde el diseño?**

**Respuesta:** Para detectarlo, usaría funciones ventana (LAG/LEAD) en SQL para comparar estatus consecutivos del mismo alumno y marcar anomalías. Para prevenirlo desde el diseño, implementaría un trigger BEFORE INSERT que valide que el nuevo estatus sea diferente al actual, y agregaría una restricción CHECK en la aplicación que requiera una razón válida para cualquier cambio de estado.

## Python / Pandas

### Pregunta 3
**Tienes un DataFrame con 50,000 registros de movimientos. Al hacer un groupby por programa y mes, algunos meses no aparecen para ciertos programas. ¿Qué causa eso y cómo lo resuelves?**

**Respuesta:** La causa es que groupby solo genera filas para combinaciones existentes en los datos. Para resolverlo, creo un MultiIndex completo con todas las combinaciones posibles usando `pd.MultiIndex.from_product([programas_unicos, meses_rango])`, y luego aplico `reindex()` al DataFrame agrupado, rellenando valores ausentes con 0 mediante `fillna(0)`. Esto garantiza continuidad temporal en el análisis.

### Pregunta 4
**¿Cuál es la diferencia entre usar merge y join en pandas? ¿Cuándo usarías cada uno?**

**Respuesta:** `merge()` es más flexible y potente, permitiendo especificar columnas clave explícitamente y diferentes tipos de joins (inner, outer, left, right). `join()` se basa principalmente en índices. Usaría `merge()` cuando necesito unir por columnas específicas o cuando requiero control preciso sobre las claves de unión. Usaría `join()` cuando los DataFrames ya están indexados adecuadamente y quiero código más conciso.

## Angular

### Pregunta 5
**Tu componente de tabla de alumnos re-renderiza completo cada vez que cambias el estatus de uno solo. ¿Qué causaría eso y cómo lo optimizarías?**
*(Pista: piensa en ChangeDetectionStrategy)*

**Respuesta:** El re-renderizado completo ocurre porque Angular detecta cambios en la referencia del array completo. Lo optimizaría usando `ChangeDetectionStrategy.OnPush` en el componente, implementando `trackBy` en el ngFor para que Angular identifique elementos individualmente, y actualizando solo el objeto específico mediante inmutabilidad (creando nuevo array con spread operator pero manteniendo referencias de objetos no modificados).

### Pregunta 6
**¿Dónde guardarías el estatus actual de los alumnos en una app Angular sin backend: en el componente directamente, en un Service compartido, o en localStorage? Justifica tu elección.**

**Respuesta:** La mejor práctica es usar un Service con BehaviorSubject como fuente de verdad, combinado con localStorage para persistencia. El Service permite reactividad en tiempo real entre componentes, inyección de dependencias limpia, y fácil testing. localStorage solo sería complemento para mantener datos entre sesiones, no como almacenamiento principal, ya que no ofrece reactividad ni tipado fuerte.
