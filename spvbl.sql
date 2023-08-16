-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-08-2023 a las 05:19:44
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
(1, 'Hefziba', 'Mendieta', '2411607357'),
(2, 'Laura', 'Contreras', '2467837262'),
(3, 'Fatima', 'Nava', '24179092012'),
(4, 'Alicia', 'Lozada', '2411607357'),
(5, 'Sergio', 'Ibarra', '2411219086');

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
(1, 1, '2023-08-15', 450.00, 1, 300),
(2, 2, '2023-08-14', 399.00, 1, 399),
(3, 3, '2023-08-13', 350.00, 1, 350),
(4, 4, '2023-08-12', 670.00, 1, 500),
(5, 5, '2023-08-11', 1198.00, 1, 1198);

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
(1, 1, 2),
(2, 2, 4),
(3, 3, 5),
(4, 4, 3),
(5, 5, 10),
(6, 5, 11);

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
(1, 'Vestido corto', 'CH', 'Rosa pastel', 'Noche', 'El diseño en corpiño muestra un escote ilusión de tela con transparencia decorado con encaje. La falda corta comienza con un fruncido en cintura del que se desprenden dos capas de tela rígida con volado.', 600.00, 'Disponible', 1, 'static\\img\\vestidos\\1.jpg'),
(2, 'Vestido corto', 'M', 'Negro', 'Formal', 'Confeccionado en tela elástica color negro, escote tipo barco, mangas tres cuartos y bolsas laterales.', 450.00, 'Apartado', 1, 'static\\img\\vestidos\\2.jpg'),
(3, 'Vestido corto', 'M', 'Negro', 'Gala', 'Modelo asimétrico ceñido al cuerpo, escote a un hombro y volantes exagerados que completan el diseño.', 670.00, 'Apartado', 1, 'static\\img\\vestidos\\3.jpg'),
(4, 'Vestido corto', 'CH', 'Gris', 'Formal', 'Diseño en tubo de cuello redondo, sin mangas, cintilla que acentúa la figura y una sutil abertura en pierna.\r\n', 399.00, 'Vendido', 1, 'static\\img\\vestidos\\4.jpg'),
(5, 'Vestido corto', 'M', 'Negro', 'Formal', 'Modelo recto, en un solo bloque de color, confeccionado en tela suave y ligera. Pliegues a un costado y sobrante que va desde el hombro a la cintura, dando al diseño un detalle de ligeros olanes.\r\n', 350.00, 'Vendido', 1, 'static\\img\\vestidos\\5.jpg'),
(6, 'Vestido corto', 'G', 'Negro', 'Formal', 'Confeccionado en tela elástica en color negro y forro del mismo color. Este modelo en tubo de líneas esenciales cuenta con escote redondo, manga corta y cremallera en contraste en la parte trasera.\r\n', 350.00, 'Disponible', 1, 'static\\img\\vestidos\\7.jpg'),
(7, 'Vestido corto', 'CH', 'Azul cerúleo', 'Noche', 'Modelo de escote corazón con tirantes delgados, confeccionado en tela rígida con peculiar brillo y una falda circular que se desprende de la cintura con pliegues verticales.', 599.00, 'Disponible', 1, 'static\\img\\vestidos\\6.jpg'),
(8, 'Vestido corto', 'CH', 'Índigo', 'Formal', 'Modelo de escote tipo \"Reina Anna\", manga casquillo y drapeado asimétrico lateral.\r\n', 499.00, 'Disponible', 1, 'static\\img\\vestidos\\8.jpg'),
(9, 'Vestido corto', 'M', 'Negro y dorado', 'Gala', 'Diseño de cóctel en dorado y negro con escote corazón. Bustier estructurado con forro elástico y silicón alrededor del busto para evitar que se resbale.', 600.00, 'Disponible', 1, 'static\\img\\vestidos\\9.jpg'),
(10, 'Vestido corto', 'CH', 'Latte y marfil', 'Gala', 'Modelo en tubo sin mangas, de cuello redondo y cintilla con accesorios metálicos en color dorado.\r\n', 499.00, 'Vendido', 1, 'static\\img\\vestidos\\10.jpg'),
(11, 'Vestido largo', 'CH', 'Azul cobalto', 'Gala', 'Diseño de silueta en línea A, corpiño trapeado en cintura y escote palabra de honor que ofrece un hermoso contraste con el dramatismo del vestido.', 699.00, 'Vendido', 1, 'static\\img\\vestidos\\11.jpg'),
(12, 'Vestido largo', 'CH', 'Azul bondi', 'Noche', 'Escote cruzado con cuello tipo halter y pliegues entrecruzados en el corpiño delantero. Falda larga en línea A perfeccionada con pliegues fruncidos en el centro.\r\n', 599.00, 'Disponible', 1, 'static\\img\\vestidos\\12.jpg'),
(13, 'Vestido largo', 'M', 'Azul claro', 'Gala', 'Diseño en strapless con escote palabra de honor y corpiño decorado con pliegues horizontales.\r\n', 630.00, 'Disponible', 1, 'static\\img\\vestidos\\13.jpg'),
(14, 'Vestido largo', 'M', 'Azul marino', 'Gala', 'Diseño asimétrico con escote a un hombro y cintilla ceñida a la cintura.\r\nFalda con silueta clásica en línea A de largo hasta el piso.\r\n', 599.00, 'Disponible', 1, 'static\\img\\vestidos\\16.jpg'),
(15, 'Vestido largo', 'G', 'Rojo', 'Noche', '\r\n\r\nModelo clásico en color rojo de escote asimétrico a un hombro y muescas. Silueta tipo trompera/sirena con largo hasta el piso y dobladillo asimétrico.\r\n', 655.00, 'Disponible', 1, 'static\\img\\vestidos\\18.jpg'),
(16, 'Vestido largo', 'G', 'Rosa ballet', 'Gala', 'Diseñado con escote a un hombro y ceñido hasta la cintura.\r\nFalda amplia con movimiento confeccionada en tela satín que cuenta con una elegante abertura en pierna y bolsas laterales.', 499.00, 'Disponible', 1, 'static\\img\\vestidos\\19.jpg'),
(17, 'Vestido largo', 'M', 'Negro', 'Gala', 'Modelo de silueta en línea A, confeccionado en tafetán negro drapeado del busto hasta la cadera, strapless con escote palabra de honor y forro grueso del mismo color.\r\n', 499.00, 'Disponible', 1, 'static\\img\\vestidos\\14.jpg'),
(18, 'Vestido largo', 'M', 'Negro', 'Noche', 'Modelo en línea A confeccionado en gasa color negro, diseñado con un corpiño spaghetti strap de drapeado cruzado con detalle de encaje, cintura natural y escote en espalda con tirantes cruzados.\r\n', 599.00, 'Disponible', 1, 'static\\img\\vestidos\\17.jpg'),
(19, 'Vestido largo', 'M', 'Verde oscuro', 'Gala', 'Diseño en línea A con un corpiño spaghetti strap de escote en V con ligero drapeado en busto, escote amplio en espalda con tirantes cruzados y falda de largo hasta el piso con abertura en pierna.\r\n', 499.00, 'Disponible', 1, 'static\\img\\vestidos\\15.jpg'),
(20, 'Vestido largo', 'M', 'Azul horizonte', 'Gala', 'Confeccionado en gasa con un corpiño en strapless de escote corazón y decorado con pliegues asimétricos que continúan en la falda. En este diseño, la falda se destaca por tener ligeros volantes que caen en cascada.\r\n', 350.00, 'Disponible', 1, 'static\\img\\vestidos\\20.jpg');

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
(1, 'Jesher', 'Mendieta', 'Ibarra', 'Jeshersin', 'admin', 'Privada Miguel Hidalgo #348', '2414137262', 'pbkdf2:sha256:600000$0PZiuBhdD5JFImCl$a3aa9937424db00c997583bb384387044725bdbcfdba0cf62c74ee389127832e', 'img/foto_default.jpg'),
(2, 'Miriam', 'Montiel', 'Flores', 'Miriam', 'admin', 'Av.del agua #45', '2561209862', 'pbkdf2:sha256:600000$6wHT16rIh5HSLDQ9$cbf70e4ed5a5b1ec337baa9445d4d5864ecf0da3f7adf37454ed7244703c6d8d', 'img/foto_default.jpg'),
(3, 'Evelyn', 'Garcia', 'Montiel', 'Eve', 'cajero', 'Av.del agua #45', '2414137324', 'pbkdf2:sha256:600000$HHdZ3rRCrrHNoV5A$73c15a468d274da3468de872935008e1f701d3010c1d36e0bbc57e3e3ac0fb22', 'img/foto_default.jpg');

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
(4, 'Vestido corto', 'CH', 'Gris', 'Formal', 'Diseño en tubo de cuello redondo, sin mangas, cintilla que acentúa la figura y una sutil abertura en pierna.\r\n', 399.00, 'Vendido', 1, 'static\\img\\vestidos\\4.jpg'),
(5, 'Vestido corto', 'M', 'Negro', 'Formal', 'Modelo recto, en un solo bloque de color, confeccionado en tela suave y ligera. Pliegues a un costado y sobrante que va desde el hombro a la cintura, dando al diseño un detalle de ligeros olanes.\r\n', 350.00, 'Vendido', 1, 'static\\img\\vestidos\\5.jpg'),
(10, 'Vestido corto', 'CH', 'Latte y marfil', 'Gala', 'Modelo en tubo sin mangas, de cuello redondo y cintilla con accesorios metálicos en color dorado.\r\n', 499.00, 'Vendido', 1, 'static\\img\\vestidos\\10.jpg'),
(11, 'Vestido largo', 'CH', 'Azul cobalto', 'Gala', 'Diseño de silueta en línea A, corpiño trapeado en cintura y escote palabra de honor que ofrece un hermoso contraste con el dramatismo del vestido.', 699.00, 'Vendido', 1, 'static\\img\\vestidos\\11.jpg');

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
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `compras`
--
ALTER TABLE `compras`
  MODIFY `id_compra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `detalles_venta`
--
ALTER TABLE `detalles_venta`
  MODIFY `id_detalle_venta` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
