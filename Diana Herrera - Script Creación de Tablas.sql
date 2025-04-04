-- Resetear la base de datos
DROP DATABASE IF EXISTS snow;

-- Crear base de datos snow si no existe
CREATE DATABASE IF NOT EXISTS snow;

-- Usar la base de datos para nuestro estudio
USE snow;

-- Drop table para evitar que los registros se creen multiples veces
DROP TABLE IF EXISTS JobTitle; 				-- 1
DROP TABLE IF EXISTS QualPercent; 			-- 2
DROP TABLE IF EXISTS Entity; 				-- 3
DROP TABLE IF EXISTS Employee; 				-- 4 
DROP TABLE IF EXISTS HireTermDates; 		-- 5
DROP TABLE IF EXISTS City; 					-- 6
DROP TABLE IF EXISTS WorkType; 				-- 7
DROP TABLE IF EXISTS ProjectList; 			-- 8
DROP TABLE IF EXISTS Hours; 				-- 9
DROP TABLE IF EXISTS Wages; 				-- 10
DROP TABLE IF EXISTS Tasks; 				-- 11
DROP TABLE IF EXISTS Stakeholder; 			-- 12
DROP TABLE IF EXISTS log_employee_nuevo; 	-- 13
DROP TABLE IF EXISTS log_wage_modify; 		-- 14
DROP TABLE IF EXISTS log_task_update; 		-- 15

-- ------------------------------------------------- Creación de tablas --------------------------------------------------------

-- Crear la tabla JobTitle
-- Tabla dimensional donde se guardan los datos de puestos de trabajo por empleado
CREATE TABLE IF NOT EXISTS JobTitle (
    JobCode INT PRIMARY KEY,
    JobDescription VARCHAR(255) UNIQUE
) AUTO_INCREMENT=1000;

-- Crear la tabla QualPercent
-- Tabla de hecho que contiene la calificación técnica en porcentaje de cada puesto de trabajo
CREATE TABLE IF NOT EXISTS QualPercent (
    JobCode INT,
    TechnicalQual DECIMAL (3,2),
    -- Definición de FK
	FOREIGN KEY (JobCode) REFERENCES JobTitle(JobCode)
);

-- Crear la tabla Entity
-- Tabla de hecho que contiene la información de cada entidad
CREATE TABLE IF NOT EXISTS Entity (
    EntityID INT PRIMARY KEY,
    EntityName VARCHAR(255) NOT NULL,
    IndustryType VARCHAR(100),
    Country VARCHAR(100),
    TaxID VARCHAR(50)
);

-- Crear la tabla de Empleados
-- Tabla dimensional donde se guardan los datos de ingreso al sistema de los empleados
CREATE TABLE IF NOT EXISTS Employee (
    EmployeeID INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeName VARCHAR(70),
    JobCode INT,
    EntityID INT,
    Email VARCHAR(100),
    -- Definición de FK:
	FOREIGN KEY (JobCode) REFERENCES JobTitle(JobCode),
    FOREIGN KEY (EntityID) REFERENCES Entity(EntityID)
);

-- Crear las tablas relacionadas a RRHH (Tablas de hecho con información de los empleados)
-- Tabla HireTermDates para almacenar las fechas de contratación y terminación
CREATE TABLE IF NOT EXISTS HireTermDates (
    EmployeeID INT,
    HireDate DATE NOT NULL,
    TerminationDate DATE,
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Tabla City para almacenar la ciudad
CREATE TABLE IF NOT EXISTS City (
    EmployeeID INT,
    City VARCHAR(20),
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Tabla WorkType para almacenar el tipo de trabajo
CREATE TABLE IF NOT EXISTS WorkType (
    EmployeeID INT,
    WorkType VARCHAR(20) DEFAULT "Híbrido",
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Crear Tabla ProjectList
-- Tabla dimensional donde se guardan los proyectos
CREATE TABLE IF NOT EXISTS ProjectList (
	ProjectNumber INT AUTO_INCREMENT PRIMARY KEY,
    ProjectName VARCHAR (255)
    );


-- Crear la tabla Hours
-- Tabla de hecho donde ese registran las horas pasadas por empleado en cada proyecto
CREATE TABLE IF NOT EXISTS Hours (
    EmployeeID INT,
    ProjectID INT,
    HoursWorked INT,
    PRIMARY KEY (EmployeeID, ProjectID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES ProjectList(ProjectNumber)
);


-- Crear la tabla Wages
-- Tabla de hecho donde se guardan los salarios por proyecto y empleados que lo realizan
CREATE TABLE IF NOT EXISTS Wages (
    EmployeeID INT PRIMARY KEY NOT NULL,
    Wage DECIMAL(12,2),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);


-- Crear la tabla Task
-- Tabla dimensional que registra las tareas asociadas a un proyecto
CREATE TABLE IF NOT EXISTS Tasks (
    TaskID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectNumber INT,
    TaskName VARCHAR(255),
    Description TEXT,
    Status ENUM('Pending', 'In Progress', 'Completed') NOT NULL,
    DueDate DATE,
    AssignedTo INT,
    -- Definición de las FK
    FOREIGN KEY (ProjectNumber) REFERENCES ProjectList(ProjectNumber),
    FOREIGN KEY (AssignedTo) REFERENCES Employee(EmployeeID)
);

-- Crear la tabla Stakeholders
-- Tabla dimensional que contiene los datos de los Stakeholders
CREATE TABLE IF NOT EXISTS Stakeholders (
    StakeholderID INT AUTO_INCREMENT PRIMARY KEY,
    ProjectNumber INT,
    Name VARCHAR(255),
    Type ENUM('Investor', 'Client', 'Government', 'Internal'),
    ContactInfo VARCHAR(255),
    FOREIGN KEY (ProjectNumber) REFERENCES ProjectList(ProjectNumber)
);