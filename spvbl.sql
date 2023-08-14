-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 14-08-2023 a las 03:14:03
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

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ContarProductosApartados` ()   BEGIN
    SELECT 
        COUNT(p.id_producto) AS cantidad_apartados
    FROM productos p
    WHERE p.estado = 'Apartado';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ContarProductosDisponibles` ()   BEGIN
    SELECT 
        COUNT(p.id_producto) AS cantidad_disponibles
    FROM productos p
    WHERE p.estado = 'Disponible';
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ContarProductosTotales` ()  DETERMINISTIC COMMENT 'Cuenta todos los festitos que hay.' SELECT COUNT(productos.id_producto) AS 'Productos_totales' FROM productos$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ContarProductosVendidos` ()   BEGIN
    SELECT 
        COUNT(vp.id_producto) AS cantidad_vendida
    FROM vendidos vp
    WHERE vp.estado = 'Vendido';
END$$

DELIMITER ;

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
(1, 'yolo', 'yolo', '1234567890'),
(2, 'lala', 'lala', '1234512345'),
(3, 'Jesher', 'Mendieta', '2414137262'),
(4, 'Hefziba', 'Mendieta', '2411607357'),
(5, 'Hefziba', 'Mendieta', '27781872'),
(6, 'alejandrino', 'magno', '1234789'),
(7, 'alfredo', 'del arco', '2412020711'),
(8, 'laslapsda', 'sgbshdbsaa', '123456789'),
(9, 'sahuidhis', 'asjñndsjandj', '23456789'),
(10, 'holasas', 'omaja', '1234567890');

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
(1, 1, '2023-08-19', 1280.00, 5, 1280),
(2, 1, '2023-08-18', 430.00, 5, 430),
(3, 2, '2023-08-17', 450.00, 5, 330),
(4, 3, '2023-07-16', 620.00, 5, 620),
(5, 4, '2023-08-12', 0.00, 5, 399),
(6, 5, '2023-08-12', 399.00, 5, 399),
(7, 6, '2023-08-14', 780.00, 5, 780),
(8, 7, '2023-08-15', 499.00, 5, 499),
(9, 8, '2023-08-13', 600.00, 5, 200),
(10, 9, '2023-08-20', 540.00, 5, 200),
(11, 10, '2023-08-13', 800.00, 5, 400);

--
-- Disparadores `compras`
--
DELIMITER $$
CREATE TRIGGER `after_compras_update` AFTER UPDATE ON `compras` FOR EACH ROW BEGIN
    DECLARE total_decimal DECIMAL(10, 2);
    DECLARE abono_decimal DECIMAL(10, 0);
    DECLARE vestido_id INT;
    
    SELECT total INTO total_decimal FROM compras WHERE id_compra = NEW.id_compra;
    SELECT abono INTO abono_decimal FROM compras WHERE id_compra = NEW.id_compra;
    SELECT id_producto INTO vestido_id FROM detalles_venta WHERE id_venta = NEW.id_compra LIMIT 1;
    
    IF abono_decimal >= total_decimal THEN
        UPDATE productos SET estado = 'Vendido' WHERE id_producto = vestido_id;
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
(1, 1, 1),
(2, 1, 25),
(3, 2, 3),
(4, 3, 5),
(5, 4, 6),
(6, 6, 4),
(7, 7, 8),
(8, 8, 2),
(9, 9, 27),
(10, 10, 26),
(11, 11, 10);

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
(1, 'Vestido largo', 'M', 'Negro', 'Noche', 'Confeccionado en tafetán negro drapeado del busto hasta la cadera, strapless con escote palabra de honor y forro grueso del mismo color.', 700.00, 'Vendido', 1, 'static\\img\\vestidos\\Equipo_con_poster.jpg'),
(2, 'Vestido largo', 'G', 'Mauve', 'Gala', 'Confeccionado en gasa de color morado mauve, corpiño spaghetti strap y escote en V con detalle de encaje en contorno del busto.', 499.00, 'Vendido', 1, 'static\\img\\vestidos\\2.jpg'),
(3, 'Vestido corto', 'CH', 'Negro', 'Formal', 'Diseño en tubo de cuello redondo, sin mangas, cintilla que acentúa la figura y una sutil abertura en pierna.', 430.00, 'Vendido', 1, 'static\\img\\vestidos\\3.jpg'),
(4, 'Vestido largo', 'CH', 'Triada', 'Casual', 'Diseño de corte recto, strapless escote spaguetti strap, confeccionado en organza de color anaranjado con diseño vertical de grecas en tonalidades morado y verde', 399.00, 'Vendido', 1, 'static\\img\\vestidos\\4.jpg'),
(5, 'Vestido largo', 'CH', 'Colorido', 'Noche', 'Modelo largo de corte recto, strapless escote semi corazón, top con relieve en color beige y falda de organza con diseño de grecas horizontales en colores tropicales', 450.00, 'Apartado', 1, 'static\\img\\vestidos\\5.jpg'),
(6, 'Vestido largo', 'EXG', 'Blanco y negro', 'Gala', 'Confeccionado con fondo grueso y un exterior de encaje elástico con aplicaciones de lentejuelas en color blanco y negro.', 620.00, 'Vendido', 1, 'static\\img\\vestidos\\6.jpg'),
(7, 'Vestido largo', 'CH', 'Azul rey', 'Gala', 'Volantes en hombro y silueta tipo trompeta/sirena de largo hasta el suelo.', 700.00, 'Disponible', 1, 'static\\img\\vestidos\\7.jpg'),
(8, 'Vestido corto', 'M', 'Negro y dorado', 'Formal', 'Bustier estructurado con forro elástico y silicón alrededor del busto para evitar que se resbale.', 780.00, 'Vendido', 1, 'static\\img\\vestidos\\8.jpg'),
(9, 'Vestido corto', 'CH', 'Colorido', 'Casual', 'Modelo recto de escote tipo barco sin mangas, confeccionado en tela suave y ligera tipo satín con estampado de colores vibrantes.', 499.00, 'Disponible', 1, 'static\\img\\vestidos\\9.jpg'),
(10, 'Vestido largo', 'EXG', 'Azul marino', 'Gala', 'Modelo de corte sirena con diseño de hojas brillantes del mismo color, media manga con transparencia y escote redondo.', 800.00, 'Apartado', 1, 'static\\img\\vestidos\\10.jpg'),
(11, 'Vestido largo', 'M', 'Dorado', 'Noche', 'Confeccionado en su totalidad con tejido jersey elástico de color bronce, muestra un escote V con tirantes anchos y apliques de tela fruncidos que crean una textura lujosa.', 560.00, 'Disponible', 1, 'static\\img\\vestidos\\11.jpg'),
(23, 'Vestido largo', 'M', 'Negro', 'Gala', 'Confeccionado en tafetá nego drapeado del busto hasta la cadera,strapless con escote palabra de honor y forro grueso del mismo color', 700.00, 'Disponible', 1, 'static\\img\\vestidos\\1.jpg'),
(25, 'Vestido corto', 'G', 'Negro', 'Formal', 'Modelo en tubo de líneas esenciales cuenta con escote redondo,manga corta y cremallera', 580.00, 'Vendido', 1, 'static\\img\\vestidos\\23.jpg'),
(26, 'Vestido Corto', 'CH', 'Índigo', 'Formal', 'Modelo de escote tipo \"Reina Anna\",manga casquillo y drapeado ', 540.00, 'Apartado', 1, 'static\\img\\vestidos\\24.jpg'),
(27, 'Vestido largo', 'M', 'Verde oscuro', 'Gala', 'Corpiño spaghetti strap de escote en V con ligero drapeado en busto, escote amplio en espalda con tirantes cruzados y falda de largo hasta el piso con abertura en pierna.', 600.00, 'Apartado', 1, 'static\\img\\vestidos\\25.jpg');

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
(5, 'root', 'root', 'root', 'root', 'admin', 'root', '12345679', 'pbkdf2:sha256:600000$eGQMzy0wOJE7xoTB$65f99a257d20ca2377d2cc48d85ecf325a8fc4b4589a048d41318d5f8d204608', 'img/foto_default.jpg'),
(6, 'Jesher', 'Medieta', 'Ibarra', 'Jeshersin', 'admin', 'Privada Miguel Hidalgo #348', '2414137262', 'pbkdf2:sha256:600000$WcdhcpTEGO3REeGr$a705b1b967fcb5f28aae3cfc393fe2770021975f7e17843ee1c693e0381678a1', 'img/foto_default.jpg'),
(8, '12', '12', '12', '12', 'cajero', '2', '12', 'pbkdf2:sha256:600000$cQKmhk1XFG4uJLgC$3636a692b9cc437115d4932d651c0709cfbde200308a740b2413af9919f19a26', 'img/foto_default.jpg');

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
(1, 'Vestido largo', 'M', 'Negro', 'Noche', 'Confeccionado en tafetán negro drapeado del busto hasta la cadera, strapless con escote palabra de honor y forro grueso del mismo color.', 700.00, 'Vendido', 1, 'static\\img\\vestidos\\Equipo_con_poster.jpg'),
(2, 'Vestido largo', 'G', 'Mauve', 'Gala', 'Confeccionado en gasa de color morado mauve, corpiño spaghetti strap y escote en V con detalle de encaje en contorno del busto.', 499.00, 'Vendido', 1, 'static\\img\\vestidos\\2.jpg'),
(3, 'Vestido corto', 'CH', 'Negro', 'Formal', 'Diseño en tubo de cuello redondo, sin mangas, cintilla que acentúa la figura y una sutil abertura en pierna.', 430.00, 'Vendido', 1, 'static\\img\\vestidos\\3.jpg'),
(4, 'Vestido largo', 'CH', 'Triada', 'Casual', 'Diseño de corte recto, strapless escote spaguetti strap, confeccionado en organza de color anaranjado con diseño vertical de grecas en tonalidades morado y verde', 399.00, 'Vendido', 1, 'static\\img\\vestidos\\4.jpg'),
(6, 'Vestido largo', 'EXG', 'Blanco y negro', 'Gala', 'Confeccionado con fondo grueso y un exterior de encaje elástico con aplicaciones de lentejuelas en color blanco y negro.', 620.00, 'Vendido', 1, 'static\\img\\vestidos\\6.jpg'),
(8, 'Vestido corto', 'M', 'Negro y dorado', 'Formal', 'Bustier estructurado con forro elástico y silicón alrededor del busto para evitar que se resbale.', 780.00, 'Vendido', 1, 'static\\img\\vestidos\\8.jpg'),
(25, 'Vestido corto', 'G', 'Negro', 'Formal', 'Modelo en tubo de líneas esenciales cuenta con escote redondo,manga corta y cremallera', 580.00, 'Vendido', 1, 'static\\img\\vestidos\\23.jpg');

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_abonos_ultimos_7_dias`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_abonos_ultimos_7_dias` (
`fecha` date
,`total_abonos` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_compras_apartadas`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_compras_apartadas` (
`id_compra` int(11)
,`nombre_cliente` varchar(50)
,`apellido_cliente` varchar(50)
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
,`apellido_cliente` varchar(50)
,`nombre_empleado` varchar(255)
,`cantidad_vestidos` bigint(21)
,`fecha_compra` date
,`monto_pagado` decimal(10,2)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_suma_apartados`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_suma_apartados` (
`estado` varchar(20)
,`total_apartados` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_suma_disponibles`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_suma_disponibles` (
`estado` varchar(20)
,`total_disponibles` bigint(21)
);

-- --------------------------------------------------------

--
-- Estructura Stand-in para la vista `vista_suma_vendidos`
-- (Véase abajo para la vista actual)
--
CREATE TABLE `vista_suma_vendidos` (
`estado` varchar(20)
,`total_vendidos` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_abonos_ultimos_7_dias`
--
DROP TABLE IF EXISTS `vista_abonos_ultimos_7_dias`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_abonos_ultimos_7_dias`  AS SELECT `co`.`fecha` AS `fecha`, sum(`co`.`abono`) AS `total_abonos` FROM `compras` AS `co` WHERE `co`.`fecha` >= curdate() - interval 7 day GROUP BY `co`.`fecha` ORDER BY `co`.`fecha` DESC LIMIT 0, 7 ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_compras_apartadas`
--
DROP TABLE IF EXISTS `vista_compras_apartadas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_compras_apartadas`  AS SELECT `co`.`id_compra` AS `id_compra`, `c`.`nombre` AS `nombre_cliente`, `c`.`apellido` AS `apellido_cliente`, `u`.`nombre` AS `nombre_empleado`, count(`dv`.`id_venta`) AS `cantidad_vestidos`, `co`.`fecha` AS `fecha_compra`, `co`.`abono` AS `monto_pagado`, `co`.`total`- `co`.`abono` AS `restante` FROM ((((`compras` `co` join `cliente` `c` on(`co`.`id_cliente` = `c`.`id_cliente`)) join `usuarios` `u` on(`co`.`id_usuario` = `u`.`id`)) join `detalles_venta` `dv` on(`co`.`id_compra` = `dv`.`id_venta`)) join `productos` `p` on(`dv`.`id_producto` = `p`.`id_producto`)) WHERE `p`.`estado` = 'Apartado' GROUP BY `co`.`id_compra` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_compras_vendidas`
--
DROP TABLE IF EXISTS `vista_compras_vendidas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_compras_vendidas`  AS SELECT `cliente`.`nombre` AS `nombre_cliente`, `cliente`.`apellido` AS `apellido_cliente`, `usuarios`.`nombre` AS `nombre_empleado`, count(`detalles_venta`.`id_venta`) AS `cantidad_vestidos`, `compras`.`fecha` AS `fecha_compra`, `compras`.`total` AS `monto_pagado` FROM ((((`compras` join `usuarios` on(`compras`.`id_usuario` = `usuarios`.`id`)) join `detalles_venta` on(`compras`.`id_compra` = `detalles_venta`.`id_venta`)) join `cliente` on(`compras`.`id_cliente` = `cliente`.`id_cliente`)) join `productos` on(`detalles_venta`.`id_producto` = `productos`.`id_producto`)) WHERE `productos`.`estado` = 'Vendido' GROUP BY `compras`.`id_compra`, `cliente`.`nombre`, `cliente`.`apellido`, `usuarios`.`nombre`, `compras`.`fecha`, `compras`.`total` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_suma_apartados`
--
DROP TABLE IF EXISTS `vista_suma_apartados`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_suma_apartados`  AS SELECT `productos`.`estado` AS `estado`, sum(`productos`.`cantidad`) AS `total_apartados` FROM `productos` WHERE `productos`.`estado` = 'Apartado' GROUP BY `productos`.`estado` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_suma_disponibles`
--
DROP TABLE IF EXISTS `vista_suma_disponibles`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_suma_disponibles`  AS SELECT `productos`.`estado` AS `estado`, count(`productos`.`id_producto`) AS `total_disponibles` FROM `productos` WHERE `productos`.`estado` = 'Disponible' GROUP BY `productos`.`estado` ;

-- --------------------------------------------------------

--
-- Estructura para la vista `vista_suma_vendidos`
--
DROP TABLE IF EXISTS `vista_suma_vendidos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vista_suma_vendidos`  AS SELECT `productos`.`estado` AS `estado`, sum(`productos`.`cantidad`) AS `total_vendidos` FROM `productos` WHERE `productos`.`estado` = 'Vendido' GROUP BY `productos`.`estado` ;

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
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `compras`
--
ALTER TABLE `compras`
  MODIFY `id_compra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `detalles_venta`
--
ALTER TABLE `detalles_venta`
  MODIFY `id_detalle_venta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `vendidos`
--
ALTER TABLE `vendidos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

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
