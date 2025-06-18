-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 18, 2025 at 05:44 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aprendizaje_aplicacion`
--

-- --------------------------------------------------------

--
-- Table structure for table `actividades`
--

CREATE TABLE `actividades` (
  `id` int(11) NOT NULL,
  `titulo` varchar(255) NOT NULL,
  `descripcion` text NOT NULL,
  `fecha_entrega` date DEFAULT NULL,
  `id_maestro` int(11) NOT NULL,
  `id_lenguaje` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `actividades`
--

INSERT INTO `actividades` (`id`, `titulo`, `descripcion`, `fecha_entrega`, `id_maestro`, `id_lenguaje`) VALUES
(1, 'Ejercicios de Control de Flujo', 'Resolver 10 ejercicios sobre if, else, y bucles en Python.', '2025-06-30', 2, 1),
(2, 'Proyecto Flutter Básico', 'Crear una aplicación móvil con navegación entre dos pantallas.', '2025-07-05', 2, 2);

-- --------------------------------------------------------

--
-- Table structure for table `actividades_respuestas`
--

CREATE TABLE `actividades_respuestas` (
  `id` int(11) NOT NULL,
  `id_actividad` int(11) NOT NULL,
  `id_estudiante` int(11) NOT NULL,
  `respuesta` text NOT NULL,
  `fecha_entrega` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lenguajes`
--

CREATE TABLE `lenguajes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lenguajes`
--

INSERT INTO `lenguajes` (`id`, `nombre`, `descripcion`) VALUES
(1, 'Python', 'Python es un lenguaje de programación fácil de aprender, ampliamente usado en ciencia de datos, automatización, desarrollo web y más.'),
(2, 'Flutter (Dart)', 'Flutter es un framework de Google que permite crear aplicaciones móviles, web y de escritorio desde una sola base de código usando Dart.');

-- --------------------------------------------------------

--
-- Table structure for table `temario`
--

CREATE TABLE `temario` (
  `id` int(11) NOT NULL,
  `lenguaje_id` int(11) NOT NULL,
  `tema` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `temario`
--

INSERT INTO `temario` (`id`, `lenguaje_id`, `tema`) VALUES
(1, 1, 'Introducción a Python'),
(2, 1, 'Variables y tipos de datos'),
(3, 1, 'Estructuras de control'),
(4, 1, 'Funciones'),
(5, 1, 'Manejo de errores'),
(6, 1, 'Módulos y paquetes'),
(7, 1, 'Proyecto práctico'),
(8, 2, 'Fundamentos de Dart'),
(9, 2, 'Widgets en Flutter'),
(10, 2, 'Diseño de interfaces responsivas'),
(11, 2, 'Navegación entre pantallas'),
(12, 2, 'Estado y manejo de datos'),
(13, 2, 'Consumo de APIs'),
(14, 2, 'Proyecto final');

-- --------------------------------------------------------

--
-- Table structure for table `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre` text NOT NULL,
  `usuario` text NOT NULL,
  `correo` text NOT NULL,
  `password` text NOT NULL,
  `rol` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre`, `usuario`, `correo`, `password`, `rol`) VALUES
(1, 'Prueba de Usuario 1', 'usuario1', 'aexmaple@gmail.com', 'prueba1', 'Estudiante'),
(2, 'Prueba de Usuario 2', 'usuario2', 'example2@.com', 'prueba2', 'Maestro'),
(3, 'Ana Torres', 'ana.torres', 'ana@example.com', 'claveana', 'Estudiante'),
(4, 'Luis Gómez', 'luis.gomez', 'luis@example.com', 'claveluis', 'Estudiante'),
(5, 'Carlos Rivas', 'carlos.rivas', 'carlos@example.com', 'clavecarlos', 'Estudiante'),
(6, 'María López', 'maria.lopez', 'maria@example.com', 'clavemaria', 'Estudiante'),
(7, 'Jorge Herrera', 'jorge.herrera', 'jorge@example.com', 'clavejorge', 'Estudiante'),
(8, 'Pancho', 'que te importa', 'exampl33e@gamil.com', '123456', 'Estudiante');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `actividades`
--
ALTER TABLE `actividades`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_maestro` (`id_maestro`),
  ADD KEY `id_lenguaje` (`id_lenguaje`);

--
-- Indexes for table `actividades_respuestas`
--
ALTER TABLE `actividades_respuestas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id_actividad` (`id_actividad`),
  ADD KEY `id_estudiante` (`id_estudiante`);

--
-- Indexes for table `lenguajes`
--
ALTER TABLE `lenguajes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `temario`
--
ALTER TABLE `temario`
  ADD PRIMARY KEY (`id`),
  ADD KEY `lenguaje_id` (`lenguaje_id`);

--
-- Indexes for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `actividades`
--
ALTER TABLE `actividades`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `actividades_respuestas`
--
ALTER TABLE `actividades_respuestas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `lenguajes`
--
ALTER TABLE `lenguajes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `temario`
--
ALTER TABLE `temario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `actividades`
--
ALTER TABLE `actividades`
  ADD CONSTRAINT `actividades_ibfk_1` FOREIGN KEY (`id_maestro`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE,
  ADD CONSTRAINT `actividades_ibfk_2` FOREIGN KEY (`id_lenguaje`) REFERENCES `lenguajes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `actividades_respuestas`
--
ALTER TABLE `actividades_respuestas`
  ADD CONSTRAINT `actividades_respuestas_ibfk_1` FOREIGN KEY (`id_actividad`) REFERENCES `actividades` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `actividades_respuestas_ibfk_2` FOREIGN KEY (`id_estudiante`) REFERENCES `usuarios` (`id_usuario`) ON DELETE CASCADE;

--
-- Constraints for table `temario`
--
ALTER TABLE `temario`
  ADD CONSTRAINT `temario_ibfk_1` FOREIGN KEY (`lenguaje_id`) REFERENCES `lenguajes` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
