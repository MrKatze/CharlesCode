-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Jun 18, 2025 at 04:41 AM
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
(2, 'Prueba de Usuario 2', 'usuario2', 'example2@.com', 'prueba2', 'Maestro');

--
-- Indexes for dumped tables
--

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
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `temario`
--
ALTER TABLE `temario`
  ADD CONSTRAINT `temario_ibfk_1` FOREIGN KEY (`lenguaje_id`) REFERENCES `lenguajes` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
