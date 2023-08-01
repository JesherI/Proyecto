-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-08-2023 a las 03:56:35
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
-- Base de datos: `spvbl`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `apartado`
--

CREATE TABLE `apartado` (
  `id_apartado` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `fecha_control` date DEFAULT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `id_cliente` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compras`
--

CREATE TABLE `compras` (
  `id_compra` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `id_usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `id_producto` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `talla` varchar(20) DEFAULT NULL,
  `color` varchar(20) DEFAULT NULL,
  `categoria` varchar(50) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) DEFAULT NULL,
  `estado` varchar(20) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `img_vestido` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`id_producto`, `nombre`, `talla`, `color`, `categoria`, `descripcion`, `precio`, `estado`, `cantidad`, `img_vestido`) VALUES
(1, 'Vestido largo', 'M', 'Negro', 'Noche', 'Confeccionado en tafetán negro drapeado del busto hasta la cadera, strapless con escote palabra de honor y forro grueso del mismo color.', 500.00, 'Disponible', 1, 'static\\img\\vestidos\\1.jpg'),
(2, 'Vestido largo', 'G', 'Mauve', 'Gala', 'Confeccionado en gasa de color morado mauve, corpiño spaghetti strap y escote en V con detalle de encaje en contorno del busto.', 499.00, 'Disponible', 1, 'static\\img\\vestidos\\2.jpg'),
(3, 'Vestido chico', 'CH', 'Negro', 'Formal', 'Diseño en tubo de cuello redondo, sin mangas, cintilla que acentúa la figura y una sutil abertura en pierna.', 430.00, 'Disponible', 1, 'static\\img\\vestidos\\3.jpg'),
(4, 'Vestido largo', 'CH', 'Triada', 'Casual', 'Diseño de corte recto, strapless escote spaguetti strap, confeccionado en organza de color anaranjado con diseño vertical de grecas en tonalidades morado y verde', 399.00, 'Disponible', 1, 'static\\img\\vestidos\\4.jpg'),
(5, 'Vestido largo', 'CH', 'Colorido', 'Noche', 'Modelo largo de corte recto, strapless escote semi corazón, top con relieve en color beige y falda de organza con diseño de grecas horizontales en colores tropicales', 450.00, 'Disponible', 1, 'static\\img\\vestidos\\5.jpg'),
(6, 'Vestido largo', 'EXG', 'Blanco y negro', 'Gala', 'Confeccionado con fondo grueso y un exterior de encaje elástico con aplicaciones de lentejuelas en color blanco y negro.', 620.00, 'Disponible', 1, 'static\\img\\vestidos\\6.jpg'),
(7, 'Vestido largo', 'CH', 'Azul rey', 'Gala', 'Volantes en hombro y silueta tipo trompeta/sirena de largo hasta el suelo.', 700.00, 'Disponible', 1, 'static\\img\\vestidos\\7.jpg'),
(8, 'Vestido chico', 'M', 'Negro y dorado', 'Formal', 'Bustier estructurado con forro elástico y silicón alrededor del busto para evitar que se resbale.', 780.00, 'Disponible', 1, 'static\\img\\vestidos\\8.jpg'),
(9, 'Vestido chico', 'CH', 'Colorido', 'Casual', 'Modelo recto de escote tipo barco sin mangas, confeccionado en tela suave y ligera tipo satín con estampado de colores vibrantes.', 399.00, 'Disponible', 1, 'static\\img\\vestidos\\9.jpg'),
(10, 'Vestido largo', 'EXG', 'Azul marino', 'Gala', 'Modelo de corte sirena con diseño de hojas brillantes del mismo color, media manga con transparencia y escote redondo.', 800.00, 'Disponible', 1, 'static\\img\\vestidos\\10.jpg'),
(11, 'Vestido largo', 'M', 'Bronce', 'Noche', 'Confeccionado en su totalidad con tejido jersey elástico de color bronce, muestra un escote V con tirantes anchos y apliques de tela fruncidos que crean una textura lujosa.', 560.00, 'Disponible', 1, 'static\\img\\vestidos\\11.jpg');

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
(1, 'root', 'root', 'root', 'root', 'admin', 'root', 'root', 'pbkdf2:sha256:600000$QAU0SJ751dkyCu5X$36e11db4c90ea78d99daa4143078aa6fec7f4aa852c1562d61ddfbb6b56da79b', 'img/foto_default.jpg'),
(2, 'Evelyn', 'Garcia', 'Montiel', 'Eve', 'cajero', 'Av.del agua', '24747758865', 'pbkdf2:sha256:600000$jNqGKIQtdDbtxQvl$5c7b427d3f668e36425705890219a8f3b9a2d499698e0afee54ee7875da0d758', 'img/foto_default.jpg'),
(3, 'Miriam', 'Montiel', 'Flores', 'Miriam', 'admin', 'Av.del agua', '2476923880', 'pbkdf2:sha256:600000$gpp0bsDwf3MHGMQ2$2a5ab913d390abcdef954eee71a00a93679576c2f1f11b1d251d2fd21d5521dc', 'img/foto_default.jpg');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `apartado`
--
ALTER TABLE `apartado`
  ADD PRIMARY KEY (`id_apartado`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_producto` (`id_producto`),
  ADD KEY `apartado_ibfk_3` (`id_usuario`);

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id_cliente`);

--
-- Indices de la tabla `compras`
--
ALTER TABLE `compras`
  ADD PRIMARY KEY (`id_compra`),
  ADD KEY `id_cliente` (`id_cliente`),
  ADD KEY `id_producto` (`id_producto`),
  ADD KEY `compras_ibfk_1` (`id_usuario`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`id_producto`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `apartado`
--
ALTER TABLE `apartado`
  MODIFY `id_apartado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `compras`
--
ALTER TABLE `compras`
  MODIFY `id_compra` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `apartado`
--
ALTER TABLE `apartado`
  ADD CONSTRAINT `apartado_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id_cliente`),
  ADD CONSTRAINT `apartado_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`),
  ADD CONSTRAINT `apartado_ibfk_3` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`id_cliente`) REFERENCES `compras` (`id_cliente`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`),
  ADD CONSTRAINT `compras_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
