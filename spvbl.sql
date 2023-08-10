-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 10-08-2023 a las 05:29:16
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
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `id_cliente` int(11) NOT NULL,
  `nombre` varchar(50) DEFAULT NULL,
  `apellido` varchar(50) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`id_cliente`, `nombre`, `apellido`, `telefono`) VALUES
(1, 'Jesher', 'Mendieta', '2414137262'),
(2, 'Alicia', 'Lozada', '2411010310');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `compras`
--

CREATE TABLE `compras` (
  `id_compra` int(11) NOT NULL,
  `id_cliente` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `id_usuario` int(11) NOT NULL,
  `abono` decimal(10,0) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `compras`
--

INSERT INTO `compras` (`id_compra`, `id_cliente`, `fecha`, `total`, `id_usuario`, `abono`) VALUES
(21, 1, '2023-08-09', 560.00, 5, 560),
(22, 2, '2023-08-09', 800.00, 5, 700);

--
-- Disparadores `compras`
--
DELIMITER $$
CREATE TRIGGER `after_compras_update` AFTER INSERT ON `compras` FOR EACH ROW BEGIN
    DECLARE total_decimal DECIMAL(10, 2);
    DECLARE abono_decimal DECIMAL(10, 0);
    DECLARE vestido_id INT;
    
    SELECT total INTO total_decimal FROM compras WHERE id_compra = NEW.id_compra;
    SELECT abono INTO abono_decimal FROM compras WHERE id_compra = NEW.id_compra;
    SELECT id_producto INTO vestido_id FROM detalles_venta WHERE id_venta = NEW.id_compra LIMIT 1;
    
    IF abono_decimal >= total_decimal THEN
        UPDATE productos SET estado = 'Pagado' WHERE id_producto = vestido_id;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalles_venta`
--

CREATE TABLE `detalles_venta` (
  `id_detalle_venta` int(11) NOT NULL,
  `id_venta` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `detalles_venta`
--

INSERT INTO `detalles_venta` (`id_detalle_venta`, `id_venta`, `id_producto`) VALUES
(1, 21, 11),
(2, 22, 10);

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
(10, 'Vestido largo', 'EXG', 'Azul marino', 'Gala', 'Modelo de corte sirena con diseño de hojas brillantes del mismo color, media manga con transparencia y escote redondo.', 800.00, 'Apartado', 1, 'static\\img\\vestidos\\10.jpg'),
(11, 'Vestido largo', 'M', 'Dorado', 'Noche', 'Confeccionado en su totalidad con tejido jersey elástico de color bronce, muestra un escote V con tirantes anchos y apliques de tela fruncidos que crean una textura lujosa.', 560.00, 'Vendido', 1, 'static\\img\\vestidos\\11.jpg');

--
-- Disparadores `productos`
--
DELIMITER $$
CREATE TRIGGER `after_producto_update` AFTER UPDATE ON `productos` FOR EACH ROW BEGIN
    IF NEW.estado = 'Vendido' AND OLD.estado <> NEW.estado THEN
        INSERT INTO `vendidos` (`id_producto`, `nombre`, `talla`, `color`, `categoria`, `descripcion`, `precio`, `estado`, `cantidad`, `img_vestido`)
        VALUES (NEW.id_producto, NEW.nombre, NEW.talla, NEW.color, NEW.categoria, NEW.descripcion, NEW.precio, NEW.estado, NEW.cantidad, NEW.img_vestido);
    END IF;
END
$$
DELIMITER ;

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
(3, 'Miriam', 'Montiel', 'Flores', 'Miriam', 'admin', 'Av.del agua', '2476923880', 'pbkdf2:sha256:600000$gpp0bsDwf3MHGMQ2$2a5ab913d390abcdef954eee71a00a93679576c2f1f11b1d251d2fd21d5521dc', 'img/foto_default.jpg'),
(5, 'root', 'root', 'root', 'root', 'admin', 'root', 'root', 'pbkdf2:sha256:600000$BNxRWVQcaxQcaY6q$a0ad70521fc2ab60328c12a75f213e9e100def753eac75085f2d3b341d7f5d12', 'img/foto_default.jpg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `vendidos`
--

CREATE TABLE `vendidos` (
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
-- Volcado de datos para la tabla `vendidos`
--

INSERT INTO `vendidos` (`id_producto`, `nombre`, `talla`, `color`, `categoria`, `descripcion`, `precio`, `estado`, `cantidad`, `img_vestido`) VALUES
(11, 'Vestido largo', 'M', 'Dorado', 'Noche', 'Confeccionado en su totalidad con tejido jersey elástico de color bronce, muestra un escote V con tirantes anchos y apliques de tela fruncidos que crean una textura lujosa.', 560.00, 'Vendido', 1, 'static\\img\\vestidos\\11.jpg');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_compras_apartadas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_compras_apartadas` (
`id_compra` int(11)
,`nombre_cliente` varchar(50)
,`nombre_empleado` varchar(255)
,`cantidad_vestidos` bigint(21)
,`fecha_compra` date
,`monto_pagado` decimal(10,0)
,`restante` decimal(13,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_compras_vendidas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_compras_vendidas` (
`nombre_cliente` varchar(50)
,`nombre_empleado` varchar(255)
,`cantidad_vestidos` bigint(21)
,`fecha_compra` date
,`monto_pagado` decimal(10,0)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_compras_apartadas`
--
DROP TABLE IF EXISTS `vista_compras_apartadas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_compras_apartadas`  AS SELECT `co`.`id_compra` AS `id_compra`, `c`.`nombre` AS `nombre_cliente`, `u`.`nombre` AS `nombre_empleado`, count(`dv`.`id_detalle_venta`) AS `cantidad_vestidos`, `co`.`fecha` AS `fecha_compra`, `co`.`abono` AS `monto_pagado`, `co`.`total`- `co`.`abono` AS `restante` FROM ((((`compras` `co` join `cliente` `c` on(`co`.`id_cliente` = `c`.`id_cliente`)) join `usuarios` `u` on(`co`.`id_usuario` = `u`.`id`)) join `detalles_venta` `dv` on(`co`.`id_compra` = `dv`.`id_venta`)) join `productos` `p` on(`dv`.`id_producto` = `p`.`id_producto`)) WHERE `p`.`estado` = 'Apartado' GROUP BY `co`.`id_compra` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_compras_vendidas`
--
DROP TABLE IF EXISTS `vista_compras_vendidas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_compras_vendidas`  AS   (select `c`.`nombre` AS `nombre_cliente`,`u`.`nombre` AS `nombre_empleado`,count(`dv`.`id_detalle_venta`) AS `cantidad_vestidos`,`co`.`fecha` AS `fecha_compra`,`co`.`abono` AS `monto_pagado` from ((((`compras` `co` join `cliente` `c` on(`co`.`id_cliente` = `c`.`id_cliente`)) join `usuarios` `u` on(`co`.`id_usuario` = `u`.`id`)) join `detalles_venta` `dv` on(`co`.`id_compra` = `dv`.`id_venta`)) join `productos` `p` on(`dv`.`id_producto` = `p`.`id_producto`)) where `p`.`estado` = 'Vendido' group by `co`.`id_compra`)  ;

--
-- Índices para tablas volcadas
--

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
  ADD KEY `compras_ibfk_1` (`id_usuario`);

--
-- Indices de la tabla `detalles_venta`
--
ALTER TABLE `detalles_venta`
  ADD PRIMARY KEY (`id_detalle_venta`),
  ADD KEY `id_venta_idx` (`id_venta`),
  ADD KEY `id_producto_idx` (`id_producto`);

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
-- Indices de la tabla `vendidos`
--
ALTER TABLE `vendidos`
  ADD PRIMARY KEY (`id_producto`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `compras`
--
ALTER TABLE `compras`
  MODIFY `id_compra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `detalles_venta`
--
ALTER TABLE `detalles_venta`
  MODIFY `id_detalle_venta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `vendidos`
--
ALTER TABLE `vendidos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `compras`
--
ALTER TABLE `compras`
  ADD CONSTRAINT `compras_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuarios` (`id`);

--
-- Filtros para la tabla `detalles_venta`
--
ALTER TABLE `detalles_venta`
  ADD CONSTRAINT `detalles_venta_ibfk_1` FOREIGN KEY (`id_venta`) REFERENCES `compras` (`id_compra`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detalles_venta_ibfk_2` FOREIGN KEY (`id_producto`) REFERENCES `productos` (`id_producto`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
