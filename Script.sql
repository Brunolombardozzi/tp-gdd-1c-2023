USE [GD1C2023]

-- ELIMINACION TABLAS
IF OBJECT_ID ('cupon_descuento_x_pedido') IS NOT NULL DROP TABLE cupon_descuento_x_pedido;
IF OBJECT_ID ('cupon_descuento') IS NOT NULL DROP TABLE cupon_descuento
IF OBJECT_ID ('localidad_x_repartidor') IS NOT NULL DROP TABLE localidad_x_repartidor;
IF OBJECT_ID ('mensajeria') IS NOT NULL DROP TABLE mensajeria;
IF OBJECT_ID ('estado_mensajeria') IS NOT NULL DROP TABLE estado_mensajeria;
IF OBJECT_ID ('producto_x_pedido') IS NOT NULL DROP TABLE producto_x_pedido;
IF OBJECT_ID ('cupon_reclamo') IS NOT NULL DROP TABLE cupon_reclamo;
IF OBJECT_ID ('reclamo') IS NOT NULL DROP TABLE reclamo;
IF OBJECT_ID ('envio') IS NOT NULL DROP TABLE envio;
IF OBJECT_ID ('pedido') IS NOT NULL DROP TABLE pedido;
IF OBJECT_ID ('repartidor') IS NOT NULL DROP TABLE repartidor;
IF OBJECT_ID ('direccion_x_usuario') IS NOT NULL DROP TABLE direccion_x_usuario;
IF OBJECT_ID ('direccion') IS NOT NULL DROP TABLE direccion;
IF OBJECT_ID ('provincia') IS NOT NULL DROP TABLE provincia;
IF OBJECT_ID ('localidad') IS NOT NULL DROP TABLE localidad;
IF OBJECT_ID ('tarjeta') IS NOT NULL DROP TABLE tarjeta;
IF OBJECT_ID ('tipo_paquete') IS NOT NULL DROP TABLE tipo_paquete;
IF OBJECT_ID ('estado_reclamo') IS NOT NULL DROP TABLE estado_reclamo;
IF OBJECT_ID ('tipo_reclamo') IS NOT NULL DROP TABLE tipo_reclamo;
IF OBJECT_ID ('operador') IS NOT NULL DROP TABLE operador;
IF OBJECT_ID ('movilidad') IS NOT NULL DROP TABLE movilidad;
IF OBJECT_ID ('horario_dia_x_local') IS NOT NULL DROP TABLE horario_dia_x_local;
IF OBJECT_ID ('dia') IS NOT NULL DROP TABLE dia;
IF OBJECT_ID ('producto_x_local') IS NOT NULL DROP TABLE producto_x_local;
IF OBJECT_ID ('local') IS NOT NULL DROP TABLE local;
IF OBJECT_ID ('tipo_local') IS NOT NULL DROP TABLE tipo_local;
IF OBJECT_ID ('medio_de_pago') IS NOT NULL DROP TABLE medio_de_pago;
IF OBJECT_ID ('producto') IS NOT NULL DROP TABLE producto;
IF OBJECT_ID ('estado_pedido') IS NOT NULL DROP TABLE estado_pedido;
IF OBJECT_ID ('usuario') IS NOT NULL DROP TABLE usuario;
IF OBJECT_ID ('tipo_cupon') IS NOT NULL DROP TABLE tipo_cupon;
GO


-- Dropeo de Stored Procedures

IF EXISTS(	select
		*
	from sys.sysobjects
	where xtype = 'P' and name like 'migrar_%'
	)
	BEGIN
	
	
	PRINT 'Existen procedures de una ejecucion pasada'
	PRINT 'Se procede a borrarlos...'

	DECLARE @sql NVARCHAR(MAX) = N'';

	SELECT @sql += N'
	DROP PROCEDURE '
	  + QUOTENAME(name) + ';'
	FROM sys.sysobjects
	WHERE xtype = 'P' and name like 'migrar_%'

	--PRINT @sql;

	EXEC sp_executesql @sql

	
	END

--CREACION DE TABLAS

CREATE TABLE [medio_de_pago] (
  [id_medio_pago] int IDENTITY(1,1),
  [tipo_medio_pago] nvarchar(50),
  PRIMARY KEY ([id_medio_pago])
);

CREATE TABLE [provincia] (
  [id_provincia] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([id_provincia])
);

CREATE TABLE [localidad] (
  [id_localidad] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  [id_provincia] int,
  PRIMARY KEY ([id_localidad]),
  CONSTRAINT [FK_localidad.id_provincia]
    FOREIGN KEY ([id_provincia])
      REFERENCES [provincia]([id_provincia])
);

CREATE TABLE [direccion] (
  [id_direccion] int IDENTITY(1,1),
  [nombre] nvarchar(50) null,
  [direccion] nvarchar(255),
  [provincia] nvarchar(255),
  [id_localidad] int,
  PRIMARY KEY ([id_direccion]),
  CONSTRAINT [FK_direccion.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [localidad]([id_localidad])
);
CREATE TABLE [producto] (
  [cod_producto] nvarchar(50),
  [precio_unitario] decimal(18,2),
  [nombre] nvarchar(50),
  [descripcion] nvarchar(255),
  PRIMARY KEY ([cod_producto])
);

CREATE TABLE [estado_pedido] (
  [id_estado_pedido] int IDENTITY(1,1),
  [nombre_estado] nvarchar(50),
  PRIMARY KEY ([id_estado_pedido])
);

CREATE TABLE [tipo_local] (
  [id_tipo_local] int IDENTITY(1,1),
  --[id_categoria] int null,
  [tipo_local] nvarchar(50),
  PRIMARY KEY ([id_tipo_local])
);

CREATE TABLE [local] (
  [id_local] int IDENTITY(1,1),
  [id_tipo_local] int,
  [nombre] nvarchar(100),
  [direccion] nvarchar(255),
  [descripcion] nvarchar(255),
  [localidad] nvarchar(255),
  [provincia] nvarchar(255)
  PRIMARY KEY ([id_local]),
  CONSTRAINT [FK_local.id_tipo_local]
    FOREIGN KEY ([id_tipo_local])
      REFERENCES [tipo_local]([id_tipo_local])
);


CREATE TABLE [usuario] (
  [id_usuario] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  [apellido] nvarchar(255),                                      
  [dni] decimal(18,0),
  [telefono] decimal(18,0),
  [mail] nvarchar(255),
  [fecha_nacimiento] date,
  [fecha_registro] datetime2(3),
  PRIMARY KEY ([id_usuario])
);
CREATE TABLE [movilidad] (
  [id_movilidad] int IDENTITY(1,1),
  [tipo_movilidad] nvarchar(50),
  PRIMARY KEY ([id_movilidad])
);
CREATE TABLE [repartidor] (
  [id_repartidor] int IDENTITY(1,1),
  [id_localidad] int,
  [id_movilidad] int,
  [nombre_repartidor] nvarchar(255),
  [apellido_repartidor] nvarchar(255),
  [dni] decimal(18,0),
  [telefono] decimal(18,0),
  [direccion] nvarchar(255),
  [email] nvarchar(255),
  [fecha_nacimiento] date,
  PRIMARY KEY ([id_repartidor]),
  CONSTRAINT [FK_repartidor.id_movilidad]
    FOREIGN KEY ([id_movilidad])
      REFERENCES [movilidad]([id_movilidad]),
  CONSTRAINT [FK_repartidor.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [localidad]([id_localidad])
);

CREATE TABLE [direccion_x_usuario] (
  [id_direccion_x_usuario] int IDENTITY(1,1),
  [id_direccion] int,
  [id_usuario] int,
  PRIMARY KEY ([id_direccion_x_usuario]),
  CONSTRAINT [FK_direccion_x_usuario.id_direccion]
    FOREIGN KEY ([id_direccion])
      REFERENCES [direccion]([id_direccion]),
  CONSTRAINT [FK_direccion_x_usuario.id_usuario]
    FOREIGN KEY ([id_usuario])
      REFERENCES [usuario]([id_usuario])
);
CREATE TABLE [estado_reclamo] (
  [id_estado_reclamo] int IDENTITY(1,1),
  [estado_reclamo] nvarchar(50),
  PRIMARY KEY ([id_estado_reclamo])
);

CREATE TABLE [tipo_reclamo] (
  [id_tipo_reclamo] int IDENTITY(1,1),
  [tipo_reclamo] nvarchar(50),
  PRIMARY KEY ([id_tipo_reclamo])
);

CREATE TABLE [operador] (
  [id_operador] int IDENTITY(1,1),
  [nombre] nvarchar(255) ,
  [apellido] nvarchar(255) ,
  [direccion] nvarchar(255) ,
  [mail] nvarchar(255) ,
  [dni] decimal(18,0),
  [telefono] decimal(18,0),
  [fecha_nacimiento] date,
  PRIMARY KEY ([id_operador])
);

CREATE TABLE [pedido] (
  [id_pedido] int IDENTITY(1,1),
  [nro_pedido] decimal(18,0),
  [id_estado_pedido] int,
  [id_local] int,
  [id_medio_pago] int,
  [id_usuario] int,
  [fecha_pedido] datetime2(3),
  [observaciones] nvarchar(255),
  [fecha_entrega] datetime2(3),
  [calificacion] decimal(18,0),
  [total_productos] decimal(18,2),
  [tarifa_servicio] decimal(18,2),
  [total_cupones] decimal(18,2),
  [total_servicio] decimal(18,2),
  [total] decimal(18,2),
  PRIMARY KEY ([id_pedido]),
  CONSTRAINT [FK_pedido.id_medio_pago]
    FOREIGN KEY ([id_medio_pago])
      REFERENCES [medio_de_pago]([id_medio_pago]),
  CONSTRAINT [FK_pedido.id_estado_pedido]
    FOREIGN KEY ([id_estado_pedido])
      REFERENCES [estado_pedido]([id_estado_pedido]),
  CONSTRAINT [FK_pedido.id_local]
    FOREIGN KEY ([id_local])
      REFERENCES [local]([id_local]),
  CONSTRAINT [FK_pedido.id_usuario]
    FOREIGN KEY ([id_usuario])
      REFERENCES [usuario]([id_usuario])
);
CREATE TABLE [envio] (
  [id_envio] int IDENTITY(1,1),
  [id_repartidor] int,
  [id_direccion_x_usuario] int,
  [id_pedido] int,
  [precio_envio] decimal(18,2),
  [propina] decimal(18,2),
  [tiempo_estimado_entrega] decimal(18,2),
  PRIMARY KEY ([id_envio]),
  CONSTRAINT [FK_envio.id_direccion]
    FOREIGN KEY ([id_direccion_x_usuario])
      REFERENCES [direccion_x_usuario]([id_direccion_x_usuario]),
  CONSTRAINT [FK_envio.id_repartidor]
    FOREIGN KEY ([id_repartidor])
      REFERENCES [repartidor]([id_repartidor]),
  CONSTRAINT [FK_envio.id_pedido]
    FOREIGN KEY ([id_pedido])
      REFERENCES [pedido]([id_pedido])
);



CREATE TABLE [reclamo] (
  [id_reclamo] int IDENTITY(1,1),
  [nro_reclamo] decimal(18,0),
  [id_tipo_reclamo] int,
  [id_estado_reclamo] int,
  [id_operador] int,
  [id_pedido] int,
  [descripcion] nvarchar(255),
  [fecha_solucion] datetime2(3),
  [fecha] datetime2(3),
  [calificacion] int,
  [solucion] nvarchar(255),
  PRIMARY KEY ([id_reclamo]),
  CONSTRAINT [FK_reclamo.id_estado_reclamo]
    FOREIGN KEY ([id_estado_reclamo])
      REFERENCES [estado_reclamo]([id_estado_reclamo]),
  CONSTRAINT [FK_reclamo.id_tipo_reclamo]
    FOREIGN KEY ([id_tipo_reclamo])
      REFERENCES [tipo_reclamo]([id_tipo_reclamo]),
  CONSTRAINT [FK_reclamo.id_operador]
    FOREIGN KEY ([id_operador])
      REFERENCES [operador]([id_operador]),
  CONSTRAINT [FK_reclamo.id_pedido]
    FOREIGN KEY ([id_pedido])
      REFERENCES [Pedido]([id_pedido]),
);

CREATE TABLE [tipo_cupon] (
  [id_tipo_cupon] int IDENTITY(1,1),
  [tipo] nvarchar(50),
  PRIMARY KEY ([id_tipo_cupon])
);

CREATE TABLE [cupon_reclamo] (
  [id_cupon_reclamo] int IDENTITY(1,1),
  [nro_cupon_reclamo] decimal(18,0),
  [id_tipo_cupon] int,
  [id_reclamo] int,
  [monto] decimal(18,2),
  [fecha_alta] datetime2(3),
  [fecha_vencimiento] datetime2(3),
  PRIMARY KEY ([id_cupon_reclamo]),
  CONSTRAINT [FK_cupon_reclamo.id_tipo_cupon]
    FOREIGN KEY ([id_tipo_cupon])
      REFERENCES [tipo_cupon]([id_tipo_cupon]),
  CONSTRAINT [FK_cupon_reclamo.id_reclamo]
    FOREIGN KEY ([id_reclamo])
      REFERENCES [reclamo]([id_reclamo])
);

CREATE TABLE [cupon_descuento] (
  [id_cupon_descuento] int IDENTITY(1,1),
  [nro_cupon] decimal(18,0),
  [id_usuario] int,
  [id_tipo_cupon] int,
  [fecha_alta] datetime2(3),
  [fecha_vencimiento] datetime2(3),
  PRIMARY KEY ([id_cupon_descuento]),
  CONSTRAINT [FK_cupon_descuento.id_usuario]
    FOREIGN KEY ([id_usuario])
      REFERENCES [usuario]([id_usuario]),
  CONSTRAINT [FK_cupon_descuento.id_tipo_cupon]
    FOREIGN KEY ([id_tipo_cupon])
      REFERENCES [tipo_cupon]([id_tipo_cupon])
);

CREATE TABLE [cupon_descuento_x_pedido] (
  [id_descuento_x_pedido] int IDENTITY(1,1),
  [id_cupon_descuento] int,
  [id_pedido] int,
  [monto_descuento] decimal(18,2),
  PRIMARY KEY ([id_descuento_x_pedido]),
  CONSTRAINT [FK_cupon_descuento_x_pedido.id_pedido]
    FOREIGN KEY ([id_pedido])
      REFERENCES [Pedido]([id_pedido]),
  CONSTRAINT [FK_cupon_descuento_x_pedido.nro_cupon]
    FOREIGN KEY ([id_cupon_descuento])
      REFERENCES [cupon_descuento]([id_cupon_descuento])
);

CREATE TABLE [tarjeta] (
  [nro_tarjeta] nvarchar(50),
  [id_medio_pago] int,
  [id_usaurio] int,
  [marca_tarjeta] nvarchar(100),
  PRIMARY KEY ([nro_tarjeta]),
  CONSTRAINT [FK_tarjeta.id_medio_pago]
    FOREIGN KEY ([id_medio_pago])
      REFERENCES [medio_de_pago]([id_medio_pago]),
  CONSTRAINT [FK_tarjeta.id_usaurio]
    FOREIGN KEY ([id_usaurio])
      REFERENCES [usuario]([id_usuario])
);


CREATE TABLE [estado_mensajeria] (
  [id_estado_mensajeria] int IDENTITY(1,1),
  [nombre_estado] nvarchar(50),
  PRIMARY KEY ([id_estado_mensajeria])
);

CREATE TABLE [tipo_paquete] (
  [id_tipo_paquete] int IDENTITY(1,1),
  [nombre] nvarchar(50),
  [alto] decimal(18,2),
  [ancho] decimal(18,2),
  [largo] decimal(18,2),
  [peso_maximo] decimal(18,2),
  [precio_x_paquete] decimal(18,2),
  PRIMARY KEY ([id_tipo_paquete])
);

CREATE TABLE [mensajeria] (
  [id_mensajeria] int IDENTITY(1,1),
  [nro_envio_mensajeria] decimal(18,0),
  [id_usuario] int,
  [id_medio_de_pago] int,
  [id_estado_mensajeria] int,
  [id_tipo_paquete] int,
  [id_repartidor] int,
  [direccion_origen] nvarchar(255) ,
  [direccion_destino] nvarchar(255),
  [distancia_km] decimal(18,2),
  [valor_asegurado] decimal(18,2),
  [observaciones] nvarchar(255) ,
  [precio_seguro] decimal(18,2),
  [precio_total] decimal(18,2),
  [fecha_pedido] datetime2(3),
  [fecha_entrega] datetime2(3),
  [propina] decimal(18,2),
  [tiempo_estimado_entrega] decimal(18,2),
  [calificacion] decimal(18,0),
  PRIMARY KEY ([id_mensajeria]),
  CONSTRAINT [FK_mensajeria.id_tipo_paquete]
    FOREIGN KEY ([id_tipo_paquete])
      REFERENCES [tipo_paquete]([id_tipo_paquete]),
  CONSTRAINT [FK_mensajeria.id_medio_de_pago]
    FOREIGN KEY ([id_medio_de_pago])
      REFERENCES [medio_de_pago]([id_medio_pago]),
  CONSTRAINT [FK_mensajeria.id_estado_mensajeria]
    FOREIGN KEY ([id_estado_mensajeria])
      REFERENCES [estado_mensajeria]([id_estado_mensajeria]),
  CONSTRAINT [FK_mensajeria.id_usuario]
    FOREIGN KEY ([id_usuario])
      REFERENCES [usuario]([id_usuario]),
  CONSTRAINT [FK_mensajeria.id_repartidor]
    FOREIGN KEY ([id_repartidor])
      REFERENCES [repartidor]([id_repartidor])
);

CREATE TABLE [producto_x_pedido] (
  [id_Producto_x_Pedido] int IDENTITY(1,1),
  [cod_producto] nvarchar(50),
  [id_pedido] int,
  [total_x_producto] decimal(18,2),
  [cantidad] decimal(18,2),
  PRIMARY KEY ([id_Producto_x_Pedido]),
  CONSTRAINT [FK_producto_x_pedido.id_pedido]
    FOREIGN KEY ([id_pedido])
      REFERENCES [Pedido]([id_pedido]),
  CONSTRAINT [FK_producto_x_pedido.cod_producto]
    FOREIGN KEY ([cod_producto])
      REFERENCES [producto]([cod_producto])
);
CREATE TABLE [producto_x_local] (
  [id_producto_x_local] int IDENTITY(1,1),
  [id_local] int,
  [cod_producto] nvarchar(50),
  [id_Producto_x_Pedido] int,
  PRIMARY KEY ([id_producto_x_local]),
  CONSTRAINT [FK_producto_x_local.id_local]
    FOREIGN KEY ([id_local])
      REFERENCES [local]([id_local]),
  CONSTRAINT [FK_producto_x_local.cod_producto]
    FOREIGN KEY ([cod_producto])
      REFERENCES [producto]([cod_producto]),
  CONSTRAINT [FK_producto_x_local.id_Producto_x_Pedido]
    FOREIGN KEY ([id_Producto_x_Pedido])
      REFERENCES [producto_x_pedido]([id_Producto_x_Pedido])
);

CREATE TABLE [dia] (
  [id_dia] int IDENTITY(1,1),
  [dia] nvarchar(50),
  PRIMARY KEY ([id_dia])
);

CREATE TABLE [horario_dia_x_local] (
  [id_dia_x_local] int IDENTITY(1,1),
  [id_dia] int,
  [id_local] int,
  [hora_apertura] decimal(18,2),
  [hora_cierre] decimal(18,2),
  PRIMARY KEY ([id_dia_x_local]),
    CONSTRAINT [FK_dia_x_local.id_local]
    FOREIGN KEY ([id_local])
      REFERENCES [local]([id_local]),
    CONSTRAINT [FK_dia_x_local.id_dia]
    FOREIGN KEY ([id_dia])
      REFERENCES [dia]([id_dia])
);

CREATE TABLE [localidad_x_repartidor] (
  [id_localidad_x_repartidor] int IDENTITY(1,1),
  [dni_repartidor] decimal(18,0),
  [id_localidad] int,
  [fecha_pedido] datetime,
  PRIMARY KEY ([id_localidad_x_repartidor]),
    CONSTRAINT [FK_localidad_x_repartidor.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [localidad]([id_localidad])
);
--VERIFICADA
GO
CREATE PROCEDURE migrar_tipo_local 
AS 
BEGIN
	INSERT INTO tipo_local(tipo_local)
	SELECT DISTINCT
		LOCAL_TIPO as tipo_local
	FROM gd_esquema.Maestra
	WHERE LOCAL_TIPO is not null

	IF @@ERROR != 0
	PRINT('TIPO LOCAL FAIL!')
	ELSE
	PRINT('TIPO LOCAL OK!')
END

--VERIFICADA
GO
CREATE PROCEDURE migrar_estado_pedido
AS 
BEGIN
	INSERT INTO estado_pedido(nombre_estado)
	SELECT DISTINCT
		PEDIDO_ESTADO as nombre_estado
	FROM gd_esquema.Maestra
	WHERE PEDIDO_ESTADO is not null

	IF @@ERROR != 0
	PRINT('ESTADO PEDIDO FAIL!')
	ELSE
	PRINT('ESTADO PEDIDO OK!')
END


--VERIFICADA
GO
CREATE PROCEDURE migrar_medio_pago
AS 
BEGIN
	INSERT INTO medio_de_pago(tipo_medio_pago)
	SELECT DISTINCT
		MEDIO_PAGO_TIPO as tipo_medio_pago
	FROM gd_esquema.Maestra
	WHERE MEDIO_PAGO_TIPO is not null

	IF @@ERROR != 0
	PRINT('MEDIO_PAGO_TIPO FAIL!')
	ELSE
	PRINT('MEDIO_PAGO_TIPO OK!')
END

--VERIFICADA
GO
CREATE PROCEDURE migrar_usuario
AS 
BEGIN
	INSERT INTO usuario(nombre, apellido, dni, telefono, fecha_registro, fecha_nacimiento, mail)
	SELECT DISTINCT
		USUARIO_NOMBRE as nombre,
        USUARIO_APELLIDO as apellido,
        USUARIO_DNI as dni,
        USUARIO_TELEFONO as telefono,
        USUARIO_FECHA_REGISTRO as fecha_registro,
        USUARIO_FECHA_NAC as fecha_nacimiento,
        USUARIO_MAIL as mail
	FROM gd_esquema.Maestra
	WHERE USUARIO_NOMBRE is not null and
    USUARIO_APELLIDO is not null and
    USUARIO_DNI is not null and
    USUARIO_FECHA_REGISTRO is not null and
    USUARIO_FECHA_NAC is not null and
	USUARIO_TELEFONO is not null and
    USUARIO_MAIL is not null 

	IF @@ERROR != 0
	PRINT('usuario FAIL!')
	ELSE
	PRINT('usuario OK!')
END

--VERIFICADA
GO
CREATE PROCEDURE migrar_tipo_cupon
AS 
BEGIN
	INSERT INTO tipo_cupon(tipo)
(	SELECT DISTINCT
		CUPON_TIPO as tipo
	FROM gd_esquema.Maestra
	WHERE CUPON_TIPO is not null ) 
	UNION
(	SELECT DISTINCT
		CUPON_RECLAMO_TIPO as tipo
	FROM gd_esquema.Maestra
	WHERE CUPON_RECLAMO_TIPO is not null )
	IF @@ERROR != 0
	PRINT('tipo_cupon FAIL!')
	ELSE
	PRINT('tipo_cupon OK!')
END

--VERIFICADA
GO
CREATE PROCEDURE migrar_movilidad
AS 
BEGIN
	INSERT INTO movilidad(tipo_movilidad)
	SELECT DISTINCT
		REPARTIDOR_TIPO_MOVILIDAD as movilidad
	FROM gd_esquema.Maestra
	WHERE REPARTIDOR_TIPO_MOVILIDAD is not null 
	IF @@ERROR != 0
	PRINT('movilidad FAIL!')
	ELSE
	PRINT('movilidad OK!')
END

--POR VERIFICAR
GO
CREATE PROCEDURE migrar_provincia
AS 
BEGIN
	INSERT INTO provincia(nombre)
	/*(SELECT DISTINCT ENVIO_mensajeria_LOCALIDAD as nombre FROM gd_esquema.Maestra WHERE ENVIO_mensajeria_LOCALIDAD is not null)
    UNION */
    (SELECT DISTINCT DIRECCION_USUARIO_PROVINCIA FROM gd_esquema.Maestra WHERE DIRECCION_USUARIO_PROVINCIA is not null)
	UNION 
    (SELECT DISTINCT LOCAL_PROVINCIA FROM gd_esquema.Maestra WHERE LOCAL_PROVINCIA is not null)
	IF @@ERROR != 0
	PRINT('provincia FAIL!')
	ELSE
	PRINT('provincia OK!')
END

--POR VERIFICAR
GO
CREATE PROCEDURE migrar_localidad
AS 
BEGIN
	INSERT INTO localidad(nombre, id_provincia)
	/*(SELECT DISTINCT ENVIO_mensajeria_LOCALIDAD as nombre FROM gd_esquema.Maestra WHERE ENVIO_mensajeria_LOCALIDAD is not null)
    UNION */
    (SELECT DISTINCT DIRECCION_USUARIO_LOCALIDAD as nombre, p.id_provincia FROM gd_esquema.Maestra JOIN provincia p on p.nombre = DIRECCION_USUARIO_PROVINCIA WHERE DIRECCION_USUARIO_LOCALIDAD is not null and DIRECCION_USUARIO_PROVINCIA is not null)
	UNION 
    (SELECT DISTINCT LOCAL_LOCALIDAD, p.id_provincia as nombre FROM gd_esquema.Maestra JOIN provincia p on p.nombre = LOCAL_PROVINCIA WHERE LOCAL_LOCALIDAD is not null and LOCAL_PROVINCIA is not null)
	IF @@ERROR != 0
	PRINT('localidad FAIL!')
	ELSE
	PRINT('localidad OK!')
END

--VERIFICADA
GO
CREATE PROCEDURE migrar_cupon_descuento
AS 
BEGIN
	INSERT INTO cupon_descuento(nro_cupon, id_usuario, id_tipo_cupon, fecha_alta, fecha_vencimiento)
    SELECT DISTINCT
        CUPON_NRO as nro_cupon,
        u.id_usuario as id_usuario,
        tc.id_tipo_cupon as id_tipo_cupon,  
        CUPON_FECHA_ALTA as fecha_alta,
        CUPON_FECHA_VENCIMIENTO as fecha_vencimiento
    FROM gd_esquema.Maestra
    JOIN usuario u
    on u.dni = USUARIO_DNI
    JOIN tipo_cupon tc
    on tc.tipo = CUPON_TIPO
	WHERE CUPON_NRO is not null 
	and CUPON_FECHA_ALTA is not null
	and CUPON_FECHA_VENCIMIENTO is not null
	and USUARIO_DNI is not null
	and CUPON_TIPO is not null
	IF @@ERROR != 0
	PRINT('cupon_descuento FAIL!')
	ELSE
	PRINT('cupon_descuento OK!')
END

--POR VERIFICAR, SE TOMA EN CUENTA LA LOCALIDAD 
GO
CREATE PROCEDURE migrar_localidad_x_repartidor
AS 
BEGIN
	INSERT INTO localidad_x_repartidor(dni_repartidor,id_localidad,fecha_pedido)
    SELECT DISTINCT
		REPARTIDOR_DNI,
		l.id_localidad,
		PEDIDO_FECHA_ENTREGA
    FROM gd_esquema.Maestra
    JOIN localidad l
    on l.nombre = LOCAL_LOCALIDAD
	WHERE REPARTIDOR_DNI is not null 
	and PEDIDO_FECHA_ENTREGA is not null
	AND LOCAL_LOCALIDAD is not null
	IF @@ERROR != 0
	PRINT('localidad_x_repartidor FAIL!')
	ELSE
	PRINT('localidad_x_repartidor OK!')
END

-- POR VERIFICAR, se deja tomando la ultima direccion en la que estuvo haciendo pedidos ordenada por fecha.
GO
CREATE PROCEDURE migrar_repartidor 
AS 
BEGIN
	INSERT INTO repartidor(id_localidad, id_movilidad, nombre_repartidor, apellido_repartidor, dni, telefono, direccion, email,fecha_nacimiento)
    SELECT DISTINCT
        (SELECT TOP 1 id_localidad
		FROM localidad_x_repartidor where dni_repartidor = REPARTIDOR_DNI order by fecha_pedido DESC) as id_localidad,
        m.id_movilidad as id_movilidad,
        REPARTIDOR_NOMBRE as nombre_repartidor,
        REPARTIDOR_APELLIDO as apellido_repartidor,
        REPARTIDOR_DNI as dni, 
        REPARTIDOR_TELEFONO as telefono,
        REPARTIDOR_DIRECION as direccion, 
		REPARTIDOR_EMAIL as email, 
        REPARTIDOR_FECHA_NAC as fecha_nacimiento
    FROM gd_esquema.Maestra
    JOIN movilidad m
    on m.tipo_movilidad = REPARTIDOR_TIPO_MOVILIDAD
    JOIN localidad l
    on l.nombre = DIRECCION_USUARIO_LOCALIDAD 
	WHERE DIRECCION_USUARIO_LOCALIDAD is not null 
	and REPARTIDOR_TIPO_MOVILIDAD is not null
	and REPARTIDOR_NOMBRE is not null
    and REPARTIDOR_APELLIDO is not null
    and REPARTIDOR_DNI is not null
    and REPARTIDOR_TELEFONO is not null
    and REPARTIDOR_DIRECION is not null
    and REPARTIDOR_EMAIL is not null
    and REPARTIDOR_FECHA_NAC is not null
	IF @@ERROR != 0
	PRINT('repartidor FAIL!')
	ELSE
	PRINT('repartidor OK!')
END

GO
CREATE PROCEDURE migrar_direccion
AS 
BEGIN
	INSERT INTO direccion(nombre,direccion,provincia,id_localidad)
    (SELECT DISTINCT
        DIRECCION_USUARIO_NOMBRE,
		DIRECCION_USUARIO_DIRECCION,
		DIRECCION_USUARIO_PROVINCIA,
		l.id_localidad
    FROM gd_esquema.Maestra 
	JOIN localidad l
	on l.nombre = DIRECCION_USUARIO_LOCALIDAD
	WHERE DIRECCION_USUARIO_NOMBRE is not null 
	and DIRECCION_USUARIO_DIRECCION is not null
	and DIRECCION_USUARIO_PROVINCIA is not null
    and DIRECCION_USUARIO_LOCALIDAD is not null) UNION
	    (SELECT DISTINCT
		null,
        LOCAL_DIRECCION,
		LOCAL_PROVINCIA,
		l.id_localidad
    FROM gd_esquema.Maestra 
	JOIN localidad l
	on l.nombre = LOCAL_LOCALIDAD
	WHERE LOCAL_NOMBRE is not null 
	and LOCAL_DIRECCION is not null
    and LOCAL_PROVINCIA is not null
    and LOCAL_LOCALIDAD is not null)
	IF @@ERROR != 0
	PRINT('direccion FAIL!')
	ELSE
	PRINT('direccion OK!')
END

-- POR VERIFICAR, Todos los usuarios tienen 1 sola direccion, estara bien?
GO
CREATE PROCEDURE migrar_direccion_x_usuario
AS 
BEGIN
	INSERT INTO direccion_x_usuario(id_usuario,id_direccion)
	SELECT DISTINCT
		u.id_usuario,
		d.id_direccion
    FROM gd_esquema.Maestra
	JOIN usuario u 
	on u.dni = USUARIO_DNI
	JOIN localidad l
	on l.nombre = DIRECCION_USUARIO_LOCALIDAD
	JOIN direccion d
	on d.direccion = DIRECCION_USUARIO_DIRECCION
	and d.nombre = DIRECCION_USUARIO_NOMBRE
	and d.provincia = DIRECCION_USUARIO_PROVINCIA
	and d.id_localidad =  l.id_localidad
	WHERE USUARIO_DNI is not null 
	and DIRECCION_USUARIO_DIRECCION is not null
	and DIRECCION_USUARIO_NOMBRE is not null
	and DIRECCION_USUARIO_PROVINCIA is not null
	and DIRECCION_USUARIO_LOCALIDAD is not null
	IF @@ERROR != 0
	PRINT('direccion_x_usuario FAIL!')
	ELSE
	PRINT('direccion_x_usuario OK!')
END
GO
CREATE PROCEDURE migrar_estado_reclamo
AS 
BEGIN
	INSERT INTO estado_reclamo(estado_reclamo)
	SELECT DISTINCT
		RECLAMO_ESTADO as estado_reclamo
	FROM gd_esquema.Maestra
	WHERE RECLAMO_ESTADO is not null

	IF @@ERROR != 0
	PRINT('ESTADO RECLAMO FAIL!')
	ELSE
	PRINT('ESTADO RECLAMO OK!')
END

GO
CREATE PROCEDURE migrar_tipo_reclamo
AS 
BEGIN
	INSERT INTO tipo_reclamo(tipo_reclamo)
	SELECT DISTINCT
		RECLAMO_TIPO as tipo_reclamo
	FROM gd_esquema.Maestra
	WHERE RECLAMO_TIPO is not null

	IF @@ERROR != 0
	PRINT('TIPO RECLAMO FAIL!')
	ELSE
	PRINT('TIPO RECLAMO OK!')
END


GO
CREATE PROCEDURE migrar_dia
AS 
BEGIN
	INSERT INTO dia(dia)
	SELECT DISTINCT
		HORARIO_LOCAL_DIA
	FROM gd_esquema.Maestra
	WHERE HORARIO_LOCAL_DIA is not null 
	IF @@ERROR != 0
	PRINT('DIA FAIL!')
	ELSE
	PRINT('DIA OK!')
END


GO
CREATE PROCEDURE migrar_horario_dia_x_local
AS 
BEGIN
	INSERT INTO horario_dia_x_local(id_dia,id_local,hora_apertura,hora_cierre)
	SELECT DISTINCT
		d.id_dia,
		l.id_local,
		HORARIO_LOCAL_HORA_APERTURA,
		HORARIO_LOCAL_HORA_CIERRE
	FROM gd_esquema.Maestra
	JOIN dia d
	ON d.dia = HORARIO_LOCAL_DIA
	JOIN local l
	on l.nombre = LOCAL_NOMBRE AND l.descripcion = LOCAL_DESCRIPCION
	WHERE LOCAL_NOMBRE is not null and
	LOCAL_DESCRIPCION is not null and
	HORARIO_LOCAL_HORA_APERTURA is not null and
	HORARIO_LOCAL_HORA_CIERRE is not null and
	HORARIO_LOCAL_DIA is not null

	IF @@ERROR != 0
	PRINT('HORARIO_DIA_X_LOCAL FAIL!')
	ELSE
	PRINT('HORARIO_DIA_X_LOCAL OK!')
END

GO
CREATE PROCEDURE migrar_local
AS 
BEGIN
	INSERT INTO local(id_tipo_local, nombre, direccion, descripcion, localidad, provincia)
	SELECT DISTINCT
		tl.id_tipo_local,
		LOCAL_NOMBRE,
		LOCAL_DIRECCION,
		LOCAL_DESCRIPCION,
		LOCAL_LOCALIDAD,
		LOCAL_PROVINCIA
	FROM gd_esquema.Maestra
	JOIN tipo_local tl
	ON tl.tipo_local = LOCAL_TIPO 
	WHERE LOCAL_NOMBRE is not null and
	LOCAL_DIRECCION is not null and
	LOCAL_DESCRIPCION is not null and
	LOCAL_LOCALIDAD is not null and
	LOCAL_PROVINCIA is not null
	IF @@ERROR != 0
	PRINT('LOCAL FAIL!')
	ELSE
	PRINT('LOCAL OK!')
END

GO
CREATE PROCEDURE migrar_tarjeta
AS 
BEGIN
	INSERT INTO tarjeta(nro_tarjeta, id_medio_pago, id_usaurio, marca_tarjeta)
	SELECT DISTINCT
		MEDIO_PAGO_NRO_TARJETA,
		mp.id_medio_pago,
		u.id_usuario,
		MARCA_TARJETA
	FROM gd_esquema.Maestra
	JOIN usuario u
	ON u.dni = USUARIO_DNI
	JOIN medio_de_pago mp
	on mp.tipo_medio_pago = MEDIO_PAGO_TIPO
	WHERE MEDIO_PAGO_NRO_TARJETA is not null and
	MARCA_TARJETA is not null and
	USUARIO_DNI is not null and
	MEDIO_PAGO_TIPO is not null 
	IF @@ERROR != 0
	PRINT('TARJETA FAIL!')
	ELSE
	PRINT('TARJETA OK!')
END

GO
CREATE PROCEDURE migrar_tipo_paquete
AS 
BEGIN
	INSERT INTO tipo_paquete(nombre, alto, ancho,largo,peso_maximo,precio_x_paquete)
	SELECT DISTINCT
		PAQUETE_TIPO,
		PAQUETE_ALTO_MAX,
		PAQUETE_ANCHO_MAX,
		PAQUETE_LARGO_MAX,
		PAQUETE_PESO_MAX,
		PAQUETE_TIPO_PRECIO
	FROM gd_esquema.Maestra
	WHERE PAQUETE_TIPO is not null and
	PAQUETE_ALTO_MAX is not null and
	PAQUETE_ANCHO_MAX is not null and
	PAQUETE_LARGO_MAX is not null and
	PAQUETE_PESO_MAX is not null and
	PAQUETE_TIPO_PRECIO is not null   
	IF @@ERROR != 0
	PRINT('TIPO PAQUETE FAIL!')
	ELSE
	PRINT('TIPO PAQUETE OK!')
END
 
GO
CREATE PROCEDURE migrar_estado_mensajeria
AS 
BEGIN
	INSERT INTO estado_mensajeria(nombre_estado)
	SELECT DISTINCT
		ENVIO_MENSAJERIA_ESTADO
	FROM gd_esquema.Maestra
	WHERE ENVIO_MENSAJERIA_ESTADO is not null 
	IF @@ERROR != 0
	PRINT('ESTADO mensajeria FAIL!')
	ELSE
	PRINT('ESTADO MENSAJERIA OK!')
END

GO
CREATE PROCEDURE migrar_mensajeria
AS 
BEGIN
	INSERT INTO mensajeria(nro_envio_mensajeria,id_usuario,id_medio_de_pago,id_estado_mensajeria,id_tipo_paquete, id_repartidor, direccion_origen, 
	direccion_destino, distancia_km, valor_asegurado, observaciones, precio_seguro, precio_total, fecha_pedido, fecha_entrega, propina, tiempo_estimado_entrega, calificacion)
	SELECT DISTINCT
		ENVIO_MENSAJERIA_NRO,
		u.id_usuario,
		mp.id_medio_pago,
		em.id_estado_mensajeria,
		tp.id_tipo_paquete,
		r.id_repartidor,
		ENVIO_MENSAJERIA_DIR_ORIG,
		ENVIO_MENSAJERIA_DIR_DEST,
		ENVIO_MENSAJERIA_KM,
		ENVIO_MENSAJERIA_VALOR_ASEGURADO,
		ENVIO_MENSAJERIA_OBSERV,
		ENVIO_MENSAJERIA_PRECIO_SEGURO,
		ENVIO_MENSAJERIA_TOTAL,
		ENVIO_MENSAJERIA_FECHA,
		ENVIO_MENSAJERIA_FECHA_ENTREGA,
		ENVIO_MENSAJERIA_PROPINA,
		ENVIO_MENSAJERIA_TIEMPO_ESTIMADO,
		ENVIO_MENSAJERIA_CALIFICACION
	FROM gd_esquema.Maestra
	JOIN usuario u
	ON u.dni = USUARIO_DNI
	JOIN medio_de_pago mp
	ON mp.tipo_medio_pago = MEDIO_PAGO_TIPO
	JOIN estado_mensajeria em
	ON em.nombre_estado = ENVIO_MENSAJERIA_ESTADO
	JOIN tipo_paquete tp
	ON tp.nombre = PAQUETE_TIPO
	JOIN repartidor r
	ON r.dni = REPARTIDOR_DNI and
	REPARTIDOR_DIRECION = r.direccion
	WHERE ENVIO_MENSAJERIA_ESTADO is not null and
	ENVIO_MENSAJERIA_NRO is not null and
	ENVIO_MENSAJERIA_DIR_ORIG is not null and
	ENVIO_MENSAJERIA_DIR_DEST is not null and
	ENVIO_MENSAJERIA_KM is not null and
	ENVIO_MENSAJERIA_VALOR_ASEGURADO is not null and
	ENVIO_MENSAJERIA_OBSERV is not null and
	ENVIO_MENSAJERIA_PRECIO_SEGURO is not null and
	ENVIO_MENSAJERIA_TOTAL is not null and
	ENVIO_MENSAJERIA_FECHA is not null and
	ENVIO_MENSAJERIA_FECHA_ENTREGA is not null and
	USUARIO_DNI is not null and
	MEDIO_PAGO_TIPO is not null and
	ENVIO_MENSAJERIA_ESTADO is not null and 
	PAQUETE_TIPO is not null and
	REPARTIDOR_DNI is not null and
	REPARTIDOR_DIRECION is not null and
	ENVIO_MENSAJERIA_PROPINA is not null and
	ENVIO_MENSAJERIA_TIEMPO_ESTIMADO is not null and
	ENVIO_MENSAJERIA_CALIFICACION is not null
	IF @@ERROR != 0
	PRINT('MENSAJERIA FAIL!')
	ELSE
	PRINT('MENSAJERIA OK!')
END

GO
CREATE PROCEDURE migrar_pedido
AS 
BEGIN
	INSERT INTO pedido(nro_pedido, id_estado_pedido, id_local, id_medio_pago, id_usuario,
	fecha_pedido, observaciones, fecha_entrega, calificacion, total_productos, 
	 tarifa_servicio, total_cupones, total_servicio,total)
	SELECT DISTINCT
		PEDIDO_NRO,
		ep.id_estado_pedido,
		l.id_local,
		mp.id_medio_pago,
		u.id_usuario,
		PEDIDO_FECHA,
		PEDIDO_OBSERV,
		PEDIDO_FECHA_ENTREGA,
		PEDIDO_CALIFICACION,
		PEDIDO_TOTAL_PRODUCTOS,
		PEDIDO_TARIFA_SERVICIO,
		PEDIDO_TOTAL_CUPONES,
		PEDIDO_TOTAL_SERVICIO,
		PEDIDO_TOTAL_PRODUCTOS + PEDIDO_PRECIO_ENVIO + PEDIDO_PROPINA + PEDIDO_TARIFA_SERVICIO - PEDIDO_TOTAL_CUPONES
	FROM gd_esquema.Maestra
	JOIN estado_pedido ep
	ON ep.nombre_estado = PEDIDO_ESTADO
	JOIN local l
	ON l.nombre = LOCAL_NOMBRE and 
	l.direccion = LOCAL_DIRECCION
	JOIN medio_de_pago mp
	ON mp.tipo_medio_pago = MEDIO_PAGO_TIPO
	JOIN usuario u
	ON u.dni = USUARIO_DNI
	WHERE PEDIDO_NRO is not null and
	PEDIDO_CALIFICACION is not null and
	PEDIDO_ESTADO is not null and
	PEDIDO_FECHA is not null and
	PEDIDO_FECHA_ENTREGA is not null and
	PEDIDO_OBSERV is not null and
	PEDIDO_PRECIO_ENVIO is not null and
	PEDIDO_PROPINA is not null and
	PEDIDO_TOTAL_CUPONES is not null and
	PEDIDO_TOTAL_PRODUCTOS is not null and
	PEDIDO_TOTAL_SERVICIO is not null and
	PEDIDO_TIEMPO_ESTIMADO_ENTREGA is not null and
	PEDIDO_TARIFA_SERVICIO is not null and
	LOCAL_NOMBRE is not null and 
	LOCAL_DIRECCION is not null and 
	MEDIO_PAGO_TIPO is not null and
    USUARIO_DNI is not null
	IF @@ERROR != 0
	PRINT('PEDIDO FAIL!')
	ELSE
	PRINT('PEDIDO OK!')
END


--VERIFICADA CON EL FIX DE REPARTIDOR(POR REVISAR)
GO
CREATE PROCEDURE migrar_envio 
AS 
BEGIN
	INSERT INTO envio(id_repartidor,id_direccion_x_usuario,id_pedido, precio_envio, propina, tiempo_estimado_entrega)
    SELECT DISTINCT
        r.id_repartidor,
		du.id_direccion_x_usuario,
		p.id_pedido,
		PEDIDO_PRECIO_ENVIO,
		PEDIDO_PROPINA,
		PEDIDO_TIEMPO_ESTIMADO_ENTREGA

    FROM gd_esquema.Maestra
	JOIN localidad l
	on l.nombre = DIRECCION_USUARIO_LOCALIDAD
	JOIN direccion d
	on d.direccion = DIRECCION_USUARIO_DIRECCION
	and d.id_localidad = l.id_localidad
	JOIN usuario u
	ON u.dni = USUARIO_DNI
	JOIN direccion_x_usuario du
	ON du.id_direccion = d.id_direccion
	and du.id_usuario = u.id_usuario
	JOIN repartidor r
	ON r.dni = REPARTIDOR_DNI
	JOIN pedido p
	ON p.nro_pedido = PEDIDO_NRO
	WHERE PEDIDO_PRECIO_ENVIO is not null 
	and PEDIDO_PROPINA is not null
	and PEDIDO_TIEMPO_ESTIMADO_ENTREGA is not null
    and REPARTIDOR_DNI is not null
	and DIRECCION_USUARIO_DIRECCION is not null
	and DIRECCION_USUARIO_LOCALIDAD is not null
	and USUARIO_DNI is not null 
	and PEDIDO_NRO is not null

	IF @@ERROR != 0
	PRINT('envio FAIL!')
	ELSE
	PRINT('envio OK!')
END


GO
CREATE PROCEDURE migrar_operador
AS 
BEGIN
	INSERT INTO operador(nombre, apellido, direccion, mail, dni, telefono, fecha_nacimiento)
	SELECT DISTINCT
		OPERADOR_RECLAMO_NOMBRE,
		OPERADOR_RECLAMO_APELLIDO,
		OPERADOR_RECLAMO_DIRECCION,
		OPERADOR_RECLAMO_MAIL,
		OPERADOR_RECLAMO_DNI,
		OPERADOR_RECLAMO_TELEFONO,
		OPERADOR_RECLAMO_FECHA_NAC
	FROM gd_esquema.Maestra
	WHERE OPERADOR_RECLAMO_NOMBRE is not null and
	OPERADOR_RECLAMO_APELLIDO is not null and
	OPERADOR_RECLAMO_DIRECCION is not null and
	OPERADOR_RECLAMO_MAIL is not null and
	OPERADOR_RECLAMO_DNI is not null and
	OPERADOR_RECLAMO_TELEFONO is not null and
	OPERADOR_RECLAMO_FECHA_NAC is not null
	IF @@ERROR != 0
	PRINT('OPERADOR FAIL!')
	ELSE
	PRINT('OPERADOR OK!')
END

GO
CREATE PROCEDURE migrar_reclamo
AS 
BEGIN
	INSERT INTO reclamo(nro_reclamo, id_tipo_reclamo,id_estado_reclamo,id_operador,id_pedido,descripcion,fecha_solucion,fecha,calificacion,solucion)
	SELECT distinct
		RECLAMO_NRO,
		tr.id_tipo_reclamo,
		er.id_estado_reclamo,
		o.id_operador,
		p.id_pedido,
		RECLAMO_DESCRIPCION,
		RECLAMO_FECHA_SOLUCION,
		RECLAMO_FECHA,
		RECLAMO_CALIFICACION,
		RECLAMO_SOLUCION
	FROM gd_esquema.Maestra
	JOIN tipo_reclamo tr
	ON tr.tipo_reclamo = RECLAMO_TIPO
	JOIN estado_reclamo er
	ON er.estado_reclamo = RECLAMO_ESTADO
	JOIN operador o
	on o.dni = OPERADOR_RECLAMO_DNI 
    JOIN usuario u
    on u.dni = USUARIO_DNI
	JOIN pedido p
	ON p.nro_pedido = PEDIDO_NRO
	WHERE RECLAMO_TIPO is not null and
	RECLAMO_ESTADO is not null and
	RECLAMO_NRO is not null and
	RECLAMO_DESCRIPCION is not null and
	RECLAMO_FECHA_SOLUCION is not null and
	RECLAMO_CALIFICACION is not null and
	RECLAMO_FECHA is not null and
	RECLAMO_SOLUCION is not null and
	USUARIO_DNI is not null and
	PEDIDO_NRO is not null and
	OPERADOR_RECLAMO_DNI is not null 
	IF @@ERROR != 0
	PRINT('RECLAMO FAIL!')
	ELSE
	PRINT('RECLAMO OK!')
END


GO
CREATE PROCEDURE migrar_cupon_reclamo
AS 
BEGIN
	INSERT INTO cupon_reclamo(nro_cupon_reclamo,id_tipo_cupon,id_reclamo,monto,fecha_alta,fecha_vencimiento)
	SELECT DISTINCT
		CUPON_RECLAMO_NRO,
		tc.id_tipo_cupon,
		rec.id_reclamo,
		CUPON_RECLAMO_MONTO,
		CUPON_RECLAMO_FECHA_ALTA,
		CUPON_RECLAMO_FECHA_VENCIMIENTO
	FROM gd_esquema.Maestra
	JOIN tipo_cupon tc
	ON tc.tipo = CUPON_RECLAMO_TIPO
	JOIN reclamo rec
	ON rec.nro_reclamo = RECLAMO_NRO 
	WHERE CUPON_RECLAMO_NRO is not null and
	CUPON_RECLAMO_MONTO is not null and
	CUPON_RECLAMO_FECHA_ALTA is not null and
	CUPON_RECLAMO_FECHA_VENCIMIENTO is not null and
	CUPON_RECLAMO_TIPO is not null and
	RECLAMO_NRO is not null 

	IF @@ERROR != 0
	PRINT('CUPON_RECLAMO FAIL!')
	ELSE
	PRINT('CUPON_RECLAMO OK!')
END




GO
CREATE PROCEDURE migrar_cupon_descuento_x_pedido
AS 
BEGIN
	INSERT INTO cupon_descuento_x_pedido(id_pedido,id_cupon_descuento,monto_descuento)
	SELECT DISTINCT
		p.id_pedido,
		cd.id_cupon_descuento,
		CUPON_MONTO
	FROM gd_esquema.Maestra
	JOIN tipo_cupon tc
	ON tc.tipo = CUPON_TIPO
	JOIN cupon_descuento cd
	ON cd.nro_cupon = CUPON_NRO
	JOIN pedido p
	ON p.nro_pedido = PEDIDO_NRO
	WHERE PEDIDO_NRO is not null and
	CUPON_MONTO is not null and 
	CUPON_TIPO is not null and
	CUPON_NRO is not null
	IF @@ERROR != 0
	PRINT('cupon_descuento_x_pedido FAIL!')
	ELSE
	PRINT('cupon_descuento_x_pedido OK!')
END


GO
CREATE PROCEDURE migrar_producto
AS 
BEGIN
	INSERT INTO producto(cod_producto,precio_unitario, nombre, descripcion)
	SELECT DISTINCT
		PRODUCTO_LOCAL_CODIGO,
		PRODUCTO_LOCAL_PRECIO,
		PRODUCTO_LOCAL_NOMBRE,
		PRODUCTO_LOCAL_DESCRIPCION
	FROM gd_esquema.Maestra
	WHERE PRODUCTO_LOCAL_CODIGO is not null and
	PRODUCTO_LOCAL_PRECIO is not null and 
	PRODUCTO_LOCAL_NOMBRE is not null and
	PRODUCTO_LOCAL_DESCRIPCION is not null 

	IF @@ERROR != 0
	PRINT('producto FAIL!')
	ELSE
	PRINT('producto OK!')
END

GO
CREATE PROCEDURE migrar_producto_x_pedido
AS 
BEGIN
	INSERT INTO producto_x_pedido(cod_producto,id_pedido,total_x_producto,cantidad)
	SELECT DISTINCT
		p.cod_producto,
		pe.id_pedido,
		PRODUCTO_CANTIDAD * p.precio_unitario,
		PRODUCTO_CANTIDAD
	FROM gd_esquema.Maestra
	JOIN producto p
	on p.cod_producto = PRODUCTO_LOCAL_CODIGO
	JOIN pedido pe
	ON pe.nro_pedido = PEDIDO_NRO
	WHERE PRODUCTO_LOCAL_CODIGO is not null and
	PEDIDO_NRO is not null and 
	PRODUCTO_CANTIDAD is not null

	IF @@ERROR != 0
	PRINT('producto_x_pedido FAIL!')
	ELSE
	PRINT('producto_x_pedido OK!')
END

GO
CREATE PROCEDURE migrar_producto_x_local
AS 
BEGIN
	INSERT INTO producto_x_local(cod_producto,id_local,id_Producto_x_Pedido)
	SELECT DISTINCT
		p.cod_producto,
		l.id_local,
		ppp.id_Producto_x_Pedido
	FROM gd_esquema.Maestra
	JOIN producto p
	on p.cod_producto = PRODUCTO_LOCAL_CODIGO
	JOIN local l
	ON l.nombre = LOCAL_NOMBRE
	and l.direccion =LOCAL_DIRECCION
	and l.provincia = LOCAL_PROVINCIA
	JOIN pedido pe
	on pe.nro_pedido = PEDIDO_NRO
	JOIN producto_x_pedido ppp
	on ppp.cod_producto = p.cod_producto 
	and ppp.id_pedido = pe.id_pedido
	WHERE PRODUCTO_LOCAL_CODIGO is not null and
	LOCAL_NOMBRE is not null and 
	LOCAL_DIRECCION is not null and 
	LOCAL_PROVINCIA is not null and
	PEDIDO_NRO is not null

	IF @@ERROR != 0
	PRINT('producto_x_local FAIL!')
	ELSE
	PRINT('producto_x_local OK!')
END


GO
EXEC migrar_provincia
GO
EXEC migrar_tipo_local
GO
EXEC migrar_estado_pedido
GO
EXEC migrar_medio_pago
GO
EXEC migrar_usuario
GO
EXEC migrar_tipo_cupon
GO
EXEC migrar_movilidad
GO
EXEC migrar_localidad
GO
EXEC migrar_cupon_descuento
GO
EXEC migrar_localidad_x_repartidor
GO
EXEC migrar_repartidor
GO
EXEC migrar_direccion
GO
EXEC migrar_direccion_x_usuario
GO
EXEC migrar_estado_reclamo
GO
EXEC migrar_tipo_reclamo
GO
EXEC migrar_local
GO
EXEC migrar_dia
GO
EXEC migrar_horario_dia_x_local
GO
EXEC migrar_operador
GO
EXEC migrar_tarjeta
GO
EXEC migrar_tipo_paquete
GO
EXEC migrar_estado_mensajeria
GO
EXEC migrar_mensajeria
GO
EXEC migrar_pedido
GO
EXEC migrar_envio
GO
EXEC migrar_reclamo
GO
EXEC migrar_cupon_reclamo
GO
EXEC migrar_cupon_descuento_x_pedido
GO
EXEC migrar_producto
GO
EXEC migrar_producto_x_pedido
GO
/*EXEC migrar_producto_x_local
GO*/