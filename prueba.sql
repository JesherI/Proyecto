-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-07-2023 a las 16:19:04
-- Versión del servidor: 10.4.28-MariaDB
-- Versión de PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `prueba`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellido_paterno` varchar(255) NOT NULL,
  `apellido_materno` varchar(255) NOT NULL,
  `nombre_de_usuario` varchar(255) NOT NULL,
  `tipo_usuario` varchar(255) NOT NULL,
  `direccion` varchar(255) NOT NULL,
  `telefono` varchar(255) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `foto_perfil` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id`, `nombre`, `apellido_paterno`, `apellido_materno`, `nombre_de_usuario`, `tipo_usuario`, `direccion`, `telefono`, `contrasena`, `foto_perfil`) VALUES
(1, 'Jesher', 'Mendiera', 'Ibarra', 'Jehsersin_09', 'admin', 'asiujudihas', '2414137262', 'pbkdf2:sha256:600000$qW8HxS9cqA6GhdRx$24d77d0649b10d4317415dc5a32da7cd4961990e4da4a1661e1fb32870239ac2', ''),
(2, 'flor', 'Pérez', 'Toltecatl', 'flor', 'admin', 'vhjvhj', '2411106326', 'pbkdf2:sha256:600000$xyPdI7GX36Cye9Xx$7037a9d3c1a0ae3fea608a6755ef15dccac6f5a8e8cd0a2369728e6c36b504d9', ''),
(3, 'lassms', 'asmklxm', 'lasmklx', 'ksapk', 'cajero', 'la,sklmsd', '1289128912', 'pbkdf2:sha256:600000$PYSaFYPSrFd3XQXL$be5cbda6f3db653617064235b379d11b00440f7a216c80f88be52ddecdbbf57e', ''),
(4, 'Jehser', 'oisioa', 'oasioasj', 'Jesher', 'admin', 'askjjkd', '27781872', 'pbkdf2:sha256:600000$KT2SJFCVy5ZrMZOI$167a4fa19cc9d333a1bab9cce40aaa3d2dd28d39dfc5c0dee6cc9056ba5afbc7', '');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
