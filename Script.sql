USE [GD1C2023]

-- ELIMINACION TABLAS

IF OBJECT_ID ('direccion') IS NOT NULL DROP TABLE direccion;
IF OBJECT_ID ('cupon_descuento') IS NOT NULL DROP TABLE cupon_descuento;
IF OBJECT_ID ('cupon_descuento_x_pedido') IS NOT NULL DROP TABLE cupon_descuento_x_pedido;
IF OBJECT_ID ('repartidor') IS NOT NULL DROP TABLE repartidor;
IF OBJECT_ID ('Pedido') IS NOT NULL DROP TABLE Pedido;
IF OBJECT_ID ('tarjeta') IS NOT NULL DROP TABLE tarjeta;
IF OBJECT_ID ('TipoPaquete') IS NOT NULL DROP TABLE TipoPaquete;
IF OBJECT_ID ('cupon_reclamo') IS NOT NULL DROP TABLE cupon_reclamo;
IF OBJECT_ID ('estado_reclamo') IS NOT NULL DROP TABLE estado_reclamo;
IF OBJECT_ID ('movilidad') IS NOT NULL DROP TABLE movilidad;
IF OBJECT_ID ('direccion_x_usuario') IS NOT NULL DROP TABLE direccion_x_usuario;
IF OBJECT_ID ('Localidad') IS NOT NULL DROP TABLE Localidad;
IF OBJECT_ID ('local') IS NOT NULL DROP TABLE local;
IF OBJECT_ID ('tipo_local') IS NOT NULL DROP TABLE tipo_local;
IF OBJECT_ID ('medio_de_pago') IS NOT NULL DROP TABLE medio_de_pago;
IF OBJECT_ID ('producto') IS NOT NULL DROP TABLE producto;
IF OBJECT_ID ('estado_pedido') IS NOT NULL DROP TABLE estado_pedido;
IF OBJECT_ID ('usuario') IS NOT NULL DROP TABLE usuario;
IF OBJECT_ID ('tipo_cupon') IS NOT NULL DROP TABLE tipo_cupon;
IF OBJECT_ID ('Localidad') IS NOT NULL DROP TABLE Localidad;
IF OBJECT_ID ('envio') IS NOT NULL DROP TABLE envio;
IF OBJECT_ID ('EstadoMensajeria') IS NOT NULL DROP TABLE EstadoMensajeria;
IF OBJECT_ID ('Mensajeria') IS NOT NULL DROP TABLE Mensajeria;
IF OBJECT_ID ('producto_x_pedido') IS NOT NULL DROP TABLE producto_x_pedido;
IF OBJECT_ID ('tipo_reclamo') IS NOT NULL DROP TABLE tipo_reclamo;
IF OBJECT_ID ('operador') IS NOT NULL DROP TABLE operador;
IF OBJECT_ID ('reclamo') IS NOT NULL DROP TABLE reclamo;
GO


-- Dropeo de Stored Procedures

IF EXISTS(	select
		*
	from sys.sysobjects
	where xtype = 'P' and name like '%migrar_%'
	)
	BEGIN
	
	
	PRINT 'Existen procedures de una ejecuci�n pasada'
	PRINT 'Se procede a borrarlos...'

	DECLARE @sql NVARCHAR(MAX) = N'';

	SELECT @sql += N'
	DROP PROCEDURE '
	  + QUOTENAME(name) + ';'
	FROM sys.sysobjects
	WHERE xtype = 'P' and name like '%migrar_%'

	--PRINT @sql;

	EXEC sp_executesql @sql

	
	END


--ACA IRIA EL DROP Y LA CREACION DEL ESQUEMA PARTICULAR PARA NUESTRO GRUPO.

--CREACION DE TABLAS

CREATE TABLE [medio_de_pago] (
  [id_medio_pago] int IDENTITY(1,1),
  [tipo_medio_pago] nvarchar(50),
  PRIMARY KEY ([id_medio_pago])
);
--FALTA STORED PROCEDURE
CREATE TABLE [direccion] (
  [id_direccion] int IDENTITY(1,1),
  [nombre] nvarchar(50),
  [direccion] nvarchar(255),
  [provincia] nvarchar(255),
  [localidad] nvarchar(255),
  PRIMARY KEY ([id_direccion])
);
--FALTA STORED PROCEDURE
CREATE TABLE [producto] (
  [cod_producto] int IDENTITY(1,1),
  [precio_unitario] decimal(18,2),
  [total_por_producto] int,
  [nombre] nvarchar(50),
  [descripcion] nvarchar(255),
  [precio_actual] decimal(18,2),
  PRIMARY KEY ([cod_producto])
);

CREATE TABLE [estado_pedido] (
  [id_estado_pedido] int IDENTITY(1,1),
  [nombre_estado] nvarchar(50),
  PRIMARY KEY ([id_estado_pedido])
);

CREATE TABLE [tipo_local] (
  [id_tipo_local] int IDENTITY(1,1),
  [id_categoria] int,
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
  [provincia] nvarchar(255),
  [hora_apertura] decimal(18,2),
  [hora_cierre] decimal(18,2),
  [horario_dia] nvarchar(50),
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


CREATE TABLE [Localidad] (
  [id_localidad] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([id_localidad])
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
      REFERENCES [Localidad]([id_localidad])
);

CREATE TABLE [envio] (
  [id_envio] int IDENTITY(1,1),
  [id_repartidor] int,
  [id_direccion] int,
  [precio_envio] decimal(18,2),
  [propina] decimal(18,2),
  [tiempo_estimado_entrega] decimal(18,2),
  [calificacion] decimal(18,0),
  PRIMARY KEY ([id_envio]),
  CONSTRAINT [FK_envio.id_direccion]
    FOREIGN KEY ([id_direccion])
      REFERENCES [direccion]([id_direccion]),
  CONSTRAINT [FK_envio.id_repartidor]
    FOREIGN KEY ([id_repartidor])
      REFERENCES [repartidor]([id_repartidor])
);


CREATE TABLE [Pedido] (
  [nro_pedido] decimal(18,2),
  [id_estado_pedido] int,
  [id_local] int,
  [id_medio_pago] int,
  [id_usuario] int,
  [id_envio] int,
  [fecha_pedido] datetime2(3),
  [observaciones] nvarchar(255),
  [fecha_entrega] datetime2(3),
  [calificacion] decimal(18,0),
  [total_productos] decimal(18,2),
  [tarifa_servicio] decimal(18,2),
  [total_cupones] decimal(18,2),
  [total_servicio] decimal(18,2),
  PRIMARY KEY ([nro_pedido]),
  CONSTRAINT [FK_Pedido.id_medio_pago]
    FOREIGN KEY ([id_medio_pago])
      REFERENCES [medio_de_pago]([id_medio_pago]),
  CONSTRAINT [FK_Pedido.id_estado_pedido]
    FOREIGN KEY ([id_estado_pedido])
      REFERENCES [estado_pedido]([id_estado_pedido]),
  CONSTRAINT [FK_Pedido.id_local]
    FOREIGN KEY ([id_local])
      REFERENCES [local]([id_local]),
  CONSTRAINT [FK_Pedido.id_usuario]
    FOREIGN KEY ([id_usuario])
      REFERENCES [usuario]([id_usuario]),
  CONSTRAINT [FK_Pedido.id_envio]
    FOREIGN KEY ([id_usuario])
      REFERENCES [envio]([id_envio])
);


CREATE TABLE [tipo_cupon] (
  [id_tipo_cupon] int IDENTITY(1,1),
  [tipo] nvarchar(50),
  PRIMARY KEY ([id_tipo_cupon])
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
  [nro_pedido] decimal(18,2) ,
  [monto_descuento] decimal(18,2),
  PRIMARY KEY ([id_descuento_x_pedido]),
  CONSTRAINT [FK_cupon_descuento_x_pedido.nro_pedido]
    FOREIGN KEY ([nro_pedido])
      REFERENCES [Pedido]([nro_pedido]),
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
--FALTA STORED PROCEDURE
CREATE TABLE [EstadoMensajeria] (
  [id_estado_mensajeria] int IDENTITY(1,1),
  [nombre_estado] nvarchar(50),
  PRIMARY KEY ([id_estado_mensajeria])
);
--FALTA STORED PROCEDURE
CREATE TABLE [TipoPaquete] (
  [id_tipo_paquete] int IDENTITY(1,1),
  [nombre] nvarchar(50),
  [alto] decimal(18,2),
  [ancho] decimal(18,2),
  [largo] decimal(18,2),
  [peso_maximo] decimal(18,2),
  [precio_x_paquete] decimal(18,2),
  PRIMARY KEY ([id_tipo_paquete])
);

CREATE TABLE [Mensajeria] (
  [nro_envio_mensajeria] decimal(18,0),
  [id_envio] int,
  [id_usuario] int,
  [id_medio_de_pago] int,
  [id_estado_mensajeria] int,
  [id_tipo_paquete] int,
  [direccion_origen] nvarchar(255) ,
  [direccion_destino] nvarchar(255),
  [distancia_km] decimal(18,2),
  [valor_asegurado] decimal(18,2),
  [observaciones] nvarchar(255) ,
  [precio_seguro] decimal(18,2),
  [precio_total] decimal(18,2),
  [fecha_pedido] datetime2(3),
  [fecha_entrega] datetime2(3),
  PRIMARY KEY ([nro_envio_mensajeria]),
  CONSTRAINT [FK_Mensajeria.id_tipo_paquete]
    FOREIGN KEY ([id_tipo_paquete])
      REFERENCES [TipoPaquete]([id_tipo_paquete]),
  CONSTRAINT [FK_Mensajeria.id_medio_de_pago]
    FOREIGN KEY ([id_medio_de_pago])
      REFERENCES [medio_de_pago]([id_medio_pago]),
  CONSTRAINT [FK_Mensajeria.id_estado_mensajeria]
    FOREIGN KEY ([id_estado_mensajeria])
      REFERENCES [EstadoMensajeria]([id_estado_mensajeria]),
  CONSTRAINT [FK_Mensajeria.id_usuario]
    FOREIGN KEY ([id_usuario])
      REFERENCES [usuario]([id_usuario])
);

CREATE TABLE [producto_x_pedido] (
  [id_Producto_x_Pedido] int IDENTITY(1,1),
  [cod_producto] int,
  [nro_pedido] decimal(18,2),
  [total_x_producto] decimal(18,2),
  [cantidad] decimal(18,2),
  PRIMARY KEY ([id_Producto_x_Pedido]),
  CONSTRAINT [FK_producto_x_pedido.nro_pedido]
    FOREIGN KEY ([nro_pedido])
      REFERENCES [Pedido]([nro_pedido]),
  CONSTRAINT [FK_producto_x_pedido.cod_producto]
    FOREIGN KEY ([cod_producto])
      REFERENCES [producto]([cod_producto])
);
--FALTA STORED PROCEDURE
CREATE TABLE [estado_reclamo] (
  [id_estado_reclamo] int IDENTITY(1,1),
  [estado_reclamo] nvarchar(50),
  PRIMARY KEY ([id_estado_reclamo])
);
--FALTA STORED PROCEDURE
CREATE TABLE [tipo_reclamo] (
  [id_tipo_reclamo] int IDENTITY(1,1),
  [tipo_reclamo] nvarchar(50),
  PRIMARY KEY ([id_tipo_reclamo])
);
--FALTA STORED PROCEDURE
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

CREATE TABLE [cupon_reclamo] (
  [nro_cupon_reclamo] decimal(18,0),
  [id_tipo_cupon] int,
  [monto] decimal(18,2),
  [fecha_alta] datetime2(3),
  [fecha_vencimiento] datetime2(3),
  PRIMARY KEY ([nro_cupon_reclamo]),
  CONSTRAINT [FK_cupon_reclamo.id_tipo_cupon]
    FOREIGN KEY ([id_tipo_cupon])
      REFERENCES [tipo_cupon]([id_tipo_cupon])
);

CREATE TABLE [reclamo] (
  [nro_reclamo] decimal(18,2),
  [nro_pedido] decimal(18,2),
  [id_tipo_reclamo] int,
  [id_estado_reclamo] int,
  [id_operador] int,
  [nro_cupon_reclamo] decimal(18,0),
  [descripcion] nvarchar(255) ,
  [fecha_solucion] datetime2(3),
  [calificacion] int,
  [solucion] nvarchar(255),
  PRIMARY KEY ([nro_reclamo]),
  CONSTRAINT [FK_reclamo.id_estado_reclamo]
    FOREIGN KEY ([id_estado_reclamo])
      REFERENCES [estado_reclamo]([id_estado_reclamo]),
  CONSTRAINT [FK_reclamo.id_tipo_reclamo]
    FOREIGN KEY ([id_tipo_reclamo])
      REFERENCES [tipo_reclamo]([id_tipo_reclamo]),
  CONSTRAINT [FK_reclamo.id_operador]
    FOREIGN KEY ([id_operador])
      REFERENCES [operador]([id_operador]),
  CONSTRAINT [FK_reclamo.nro_cupon_reclamo]
    FOREIGN KEY ([nro_cupon_reclamo])
      REFERENCES [cupon_reclamo]([nro_cupon_reclamo])
);

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
GO
CREATE PROCEDURE migrar_usuario
AS 
BEGIN
	INSERT INTO usuario(nombre, apellido, dni, telefono, fecha_registro, fecha_nacimiento, mail)
	SELECT DISTINCT
		usuario_NOMBRE as nombre,
        usuario_APELLIDO as apellido,
        usuario_DNI as dni,
        usuario_TELEFONO as telefono,
        usuario_FECHA_REGISTRO as fecha_registro,
        usuario_FECHA_NAC as fecha_nacimiento,
        usuario_MAIL as mail
	FROM gd_esquema.Maestra
	WHERE usuario_NOMBRE is not null and
    usuario_APELLIDO is not null and
    usuario_DNI is not null and
    usuario_FECHA_REGISTRO is not null and
    usuario_FECHA_NAC is not null and
    usuario_MAIL is not null 

	IF @@ERROR != 0
	PRINT('usuario FAIL!')
	ELSE
	PRINT('usuario OK!')
END

GO
CREATE PROCEDURE migrar_tipo_cupon
AS 
BEGIN
	INSERT INTO tipo_cupon(tipo)
	SELECT DISTINCT
		CUPON_TIPO as tipo
	FROM gd_esquema.Maestra
	WHERE CUPON_TIPO is not null 
	IF @@ERROR != 0
	PRINT('tipo_cupon FAIL!')
	ELSE
	PRINT('tipo_cupon OK!')
END

GO
CREATE PROCEDURE migrar_movilidad
AS 
BEGIN
	INSERT INTO movilidad(tipo_movilidad)
	SELECT DISTINCT
		repartidor_TIPO_MOVILIDAD as movilidad
	FROM gd_esquema.Maestra
	WHERE repartidor_TIPO_MOVILIDAD is not null 
	IF @@ERROR != 0
	PRINT('movilidad FAIL!')
	ELSE
	PRINT('movilidad OK!')
END
GO
CREATE PROCEDURE migrar_localidad
AS 
BEGIN
	INSERT INTO localidad(nombre)
	(SELECT DISTINCT
		ENVIO_MENSAJERIA_LOCALIDAD as nombre FROM gd_esquema.Maestra WHERE ENVIO_MENSAJERIA_LOCALIDAD is not null) 
        UNION
        	(SELECT DISTINCT
		LOCAL_LOCALIDAD as nombre FROM gd_esquema.Maestra WHERE LOCAL_LOCALIDAD is not null) 
	IF @@ERROR != 0
	PRINT('localidad FAIL!')
	ELSE
	PRINT('localidad OK!')
END

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
	IF @@ERROR != 0
	PRINT('cupon_descuento FAIL!')
	ELSE
	PRINT('cupon_descuento OK!')
END



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