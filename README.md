# 🏥 Clínica Universitaria — Base de Datos

## Diagrama Entidad-Relación

![Diagrama E-R Clínica Universitaria](https://i.ibb.co/L4gcP8Z/E-R-Clinica-universitaria.png)

---

## 📋 Descripción General

La base de datos `clinica_universitaria` gestiona la información de pacientes, médicos, citas médicas, recetas y medicamentos dentro de un entorno clínico universitario. También incluye una tabla de log para registrar errores producidos durante la ejecución de procedimientos almacenados.

---

## 🗂️ Tablas Principales

| Tabla        | Descripción                                              |
|--------------|----------------------------------------------------------|
| `facultad`   | Facultades universitarias a las que pertenecen los médicos |
| `paciente`   | Información personal de los pacientes                    |
| `medico`     | Médicos con su especialidad y facultad asociada          |
| `hospital`   | Sedes o centros médicos disponibles                      |
| `cita`       | Citas médicas que relacionan paciente, médico y hospital |
| `medicamento`| Catálogo de medicamentos disponibles                     |
| `receta`     | Medicamentos recetados en una cita, con su dosis         |
| `log_errores`| Registro automático de errores generados en los SP       |

---

## ⚙️ Procedimientos Almacenados (Stored Procedures)

Cada entidad principal cuenta con cuatro procedimientos: **insertar**, **actualizar**, **eliminar** y **consultar**. Todos incluyen manejo de errores que registran automáticamente en `log_errores`.

### 👤 Paciente

```sql
-- Insertar un nuevo paciente
CALL sp_insert_paciente('P-001', 'Nombre', 'Apellido', '300-0000');

-- Actualizar un paciente existente
CALL sp_update_paciente('P-001', 'NuevoNombre', 'NuevoApellido', '300-1111');

-- Eliminar un paciente (falla si tiene citas asociadas)
CALL sp_delete_paciente('P-001');

-- Consultar un paciente por ID
CALL sp_get_paciente('P-001');
```

### 🏛️ Facultad

```sql
CALL sp_insert_facultad('F-03', 'Odontología', 'Dr. Ramírez');
CALL sp_update_facultad('F-03', 'Odontología General', 'Dr. Gómez');
CALL sp_delete_facultad('F-03');
CALL sp_get_facultad('F-01');
```

### 🩺 Médico

```sql
CALL sp_insert_medico('M-50', 'Dra. Torres', 'Pediatría', 'F-01');
CALL sp_update_medico('M-50', 'Dra. Torres', 'Neonatología', 'F-02');
CALL sp_delete_medico('M-50');
CALL sp_get_medico('M-10');
```

> ⚠️ Un médico **no puede eliminarse** si tiene citas registradas (`ON DELETE RESTRICT`).

### 🏨 Hospital

```sql
CALL sp_insert_hospital('H-03', 'Clínica Sur', 'Calle 80 #20');
CALL sp_update_hospital('H-03', 'Clínica Sur Actualizada', 'Calle 85 #21');
CALL sp_delete_hospital('H-03');
CALL sp_get_hospital('H-01');
```

### 📅 Cita

```sql
CALL sp_insert_cita('C-010', '2024-07-01', 'Fiebre Alta', 'P-501', 'M-22', 'H-01');
CALL sp_update_cita('C-010', '2024-07-02', 'Fiebre Moderada', 'P-501', 'M-22', 'H-02');
CALL sp_delete_cita('C-010');
CALL sp_get_cita('C-001');
```

> ℹ️ Al eliminar una cita, sus recetas asociadas se eliminan automáticamente (`ON DELETE CASCADE`).

### 💊 Medicamento

```sql
CALL sp_insert_medicamento('MED-10', 'Metformina');
CALL sp_update_medicamento('MED-10', 'Metformina XR');
CALL sp_delete_medicamento('MED-10');
CALL sp_get_medicamento('MED-01');
```

### 📝 Receta

```sql
CALL sp_insert_receta('R-10', 'C-001', 'MED-02', '200mg');
CALL sp_update_receta('R-10', 'C-001', 'MED-01', '500mg');
CALL sp_delete_receta('R-10');
CALL sp_get_receta('R-01');
```

---

## 🔢 Funciones Disponibles

### `fn_doctores_por_especialidad`
Retorna el número de médicos registrados en una especialidad dada.

```sql
SELECT fn_doctores_por_especialidad('Infectología') AS total;
SELECT fn_doctores_por_especialidad('Cardiología') AS total;
```

---

### `fn_pacientes_por_medico`
Retorna el número de pacientes distintos atendidos por un médico específico.

```sql
SELECT fn_pacientes_por_medico('M-10') AS total_pacientes;
```

---

### `fn_pacientes_por_sede`
Retorna el número de pacientes distintos atendidos en un hospital específico.

```sql
SELECT fn_pacientes_por_sede('H-01') AS pacientes_sede;
SELECT fn_pacientes_por_sede('H-02') AS pacientes_sede;
```

---

## 🔍 Consultas de Ejemplo Incluidas

El script incluye varias llamadas de prueba que ilustran el comportamiento del sistema:

```sql
-- Inserción exitosa
CALL sp_insert_paciente('P-900', 'Carlos', 'Lopez', '300999');

-- Error: paciente duplicado (ID ya existe)
CALL sp_insert_paciente('P-501', 'Juan', 'Rivas', '600-111');

-- Error: FK inválida (facultad F-99 no existe)
CALL sp_insert_medico('M-99', 'Dr Error', 'Oncología', 'F-99');

-- Error: paciente P-999 no existe
CALL sp_insert_cita('C-999', '2024-06-01', 'Prueba', 'P-999', 'M-10', 'H-01');

-- Error: médico M-10 tiene citas, no se puede eliminar
CALL sp_delete_medico('M-10');

-- Error: medicamento MED-999 no existe
CALL sp_insert_receta('R-999', 'C-001', 'MED-999', '500mg');

-- Error: nombre NULL en hospital
CALL sp_insert_hospital('H-99', NULL, 'Direccion prueba');
```

---

## 🚨 Tabla de Log de Errores

Todos los errores capturados por los procedimientos se almacenan automáticamente. Para consultarlos:

```sql
SELECT * FROM log_errores ORDER BY fecha_hora DESC;
```

| Campo          | Descripción                              |
|----------------|------------------------------------------|
| `id_error`     | ID autoincremental del error             |
| `objeto`       | Nombre del procedimiento o función       |
| `nombre_tabla` | Tabla involucrada                        |
| `codigo_error` | Código interno (1=insert, 2=update, 3=delete) |
| `mensaje`      | Descripción del error                    |
| `fecha_hora`   | Timestamp del momento del error          |

---

## 🚀 Uso base de datos

1. El script en el cual se encuentra todo es Clinica universitaria.sql
2. Ejecuta el script completo en tu cliente MySQL

## Particones y tablas a las que se le realizaron

1. La tabla informe_diario_citas fue particionada debido a que almacena información histórica generada diariamente sobre la cantidad de pacientes atendidos por médico y sede hospitalaria. Este tipo de tabla posee características analíticas y de crecimiento continuo en el tiempo, lo que la convierte en una candidata ideal para la implementación de particiones.

La partición se realizó utilizando el campo fecha, mediante una estrategia de particionamiento por rangos (RANGE), permitiendo separar los registros por años.

2. La tabla cita_historial fue particionada debido a que almacena información histórica de citas médicas que se utiliza principalmente para análisis, reportes y consultas por rangos de tiempo. Este tipo de información presenta un crecimiento continuo y un patrón de consulta basado en fechas, lo que la convierte en una candidata adecuada para la implementación de particiones.

El particionamiento se realizó utilizando la columna fecha, mediante una estrategia de partición por rangos (RANGE), separando los registros por años.

Esta tabla se creo debido a que no se podia particionar la tabla citas ya que debido a limitaciones técnicas del motor de base de datos MySQL y a la naturaleza transaccional de la información que contiene no fue posible realizarla.

El problema esta en que una tabla con FOREIGN KEY no se pueden particionar.

## 👨‍💻 Autor

Desarrollado por **Kevin Santiago Sierra**