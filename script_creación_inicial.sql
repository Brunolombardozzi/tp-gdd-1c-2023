USE [GD1C2023]

DECLARE @borrarFKs NVARCHAR(MAX) = N'';

SELECT @borrarFKs  += N'
ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys;
EXEC sp_executesql @borrarFKs 
GO

-- DROP TABLAS
IF OBJECT_ID ('QUEMA2.cupon_descuento_x_pedido') IS NOT NULL DROP TABLE QUEMA2.cupon_descuento_x_pedido;
IF OBJECT_ID ('QUEMA2.cupon_descuento') IS NOT NULL DROP TABLE QUEMA2.cupon_descuento
IF OBJECT_ID ('QUEMA2.localidad_x_repartidor') IS NOT NULL DROP TABLE QUEMA2.localidad_x_repartidor;
IF OBJECT_ID ('QUEMA2.producto_x_pedido') IS NOT NULL DROP TABLE QUEMA2.producto_x_pedido;
IF OBJECT_ID ('QUEMA2.cupon_reclamo') IS NOT NULL DROP TABLE QUEMA2.cupon_reclamo;
IF OBJECT_ID ('QUEMA2.reclamo') IS NOT NULL DROP TABLE QUEMA2.reclamo;
IF OBJECT_ID ('QUEMA2.envio') IS NOT NULL DROP TABLE QUEMA2.envio;
IF OBJECT_ID ('QUEMA2.producto_x_local_x_pedido') IS NOT NULL DROP TABLE QUEMA2.producto_x_local_x_pedido;
IF OBJECT_ID ('QUEMA2.pedido') IS NOT NULL DROP TABLE QUEMA2.pedido;
IF OBJECT_ID ('QUEMA2.repartidor') IS NOT NULL DROP TABLE QUEMA2.repartidor;
IF OBJECT_ID ('QUEMA2.direccion_x_usuario') IS NOT NULL DROP TABLE QUEMA2.direccion_x_usuario;
IF OBJECT_ID ('QUEMA2.direccion') IS NOT NULL DROP TABLE QUEMA2.direccion;
IF OBJECT_ID ('QUEMA2.mensajeria') IS NOT NULL DROP TABLE QUEMA2.mensajeria;
IF OBJECT_ID ('QUEMA2.direcciones_mensajeria') IS NOT NULL DROP TABLE QUEMA2.direcciones_mensajeria;
IF OBJECT_ID ('QUEMA2.estado_mensajeria') IS NOT NULL DROP TABLE QUEMA2.estado_mensajeria;
IF OBJECT_ID ('QUEMA2.localidad') IS NOT NULL DROP TABLE QUEMA2.localidad;
IF OBJECT_ID ('QUEMA2.provincia') IS NOT NULL DROP TABLE QUEMA2.provincia;
IF OBJECT_ID ('QUEMA2.tarjeta') IS NOT NULL DROP TABLE QUEMA2.tarjeta;
IF OBJECT_ID ('QUEMA2.tipo_paquete') IS NOT NULL DROP TABLE QUEMA2.tipo_paquete;
IF OBJECT_ID ('QUEMA2.estado_reclamo') IS NOT NULL DROP TABLE QUEMA2.estado_reclamo;
IF OBJECT_ID ('QUEMA2.tipo_reclamo') IS NOT NULL DROP TABLE QUEMA2.tipo_reclamo;
IF OBJECT_ID ('QUEMA2.operador') IS NOT NULL DROP TABLE QUEMA2.operador;
IF OBJECT_ID ('QUEMA2.movilidad') IS NOT NULL DROP TABLE QUEMA2.movilidad;
IF OBJECT_ID ('QUEMA2.horario_dia_x_local') IS NOT NULL DROP TABLE QUEMA2.horario_dia_x_local;
IF OBJECT_ID ('QUEMA2.dia') IS NOT NULL DROP TABLE QUEMA2.dia;
IF OBJECT_ID ('QUEMA2.producto_x_local') IS NOT NULL DROP TABLE QUEMA2.producto_x_local;
IF OBJECT_ID ('QUEMA2.local') IS NOT NULL DROP TABLE QUEMA2.local;
IF OBJECT_ID ('QUEMA2.tipo_local') IS NOT NULL DROP TABLE QUEMA2.tipo_local;
IF OBJECT_ID ('QUEMA2.medio_de_pago') IS NOT NULL DROP TABLE QUEMA2.medio_de_pago;
IF OBJECT_ID ('QUEMA2.producto') IS NOT NULL DROP TABLE QUEMA2.producto;
IF OBJECT_ID ('QUEMA2.estado_pedido') IS NOT NULL DROP TABLE QUEMA2.estado_pedido;
IF OBJECT_ID ('QUEMA2.usuario') IS NOT NULL DROP TABLE QUEMA2.usuario;
IF OBJECT_ID ('QUEMA2.tipo_cupon') IS NOT NULL DROP TABLE QUEMA2.tipo_cupon;
GO


-- DROP de SPs

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
	DROP PROCEDURE [QUEMA2].'
	  + QUOTENAME(name) + ';'
	FROM sys.sysobjects
	WHERE xtype = 'P' and name like '%migrar_%'

	--PRINT @sql;

	EXEC sp_executesql @sql

	
	END

--CREACION DE ESQUEMA
IF EXISTS(
SELECT * FROM sys.schemas where name = 'QUEMA2'
)
BEGIN
	DROP SCHEMA [QUEMA2]

END
GO
CREATE SCHEMA [QUEMA2];
GO

--CREACION DE TABLAS

CREATE TABLE [QUEMA2].[medio_de_pago] (
  [id_medio_pago] int IDENTITY(1,1),
  [tipo_medio_pago] nvarchar(50),
  PRIMARY KEY ([id_medio_pago])
);

CREATE TABLE [QUEMA2].[provincia] (
  [id_provincia] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  PRIMARY KEY ([id_provincia])
);

CREATE TABLE [QUEMA2].[localidad] (
  [id_localidad] int IDENTITY(1,1),
  [nombre] nvarchar(255),
  [id_provincia] int,
  PRIMARY KEY ([id_localidad]),
  CONSTRAINT [FK_localidad.id_provincia]
    FOREIGN KEY ([id_provincia])
      REFERENCES [QUEMA2].[provincia]([id_provincia])
);

CREATE TABLE [QUEMA2].[direccion] (
  [id_direccion] int IDENTITY(1,1),
  [nombre] nvarchar(50) null,
  [direccion] nvarchar(255),
  [provincia] nvarchar(255),
  [id_localidad] int,
  PRIMARY KEY ([id_direccion]),
  CONSTRAINT [FK_direccion.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [QUEMA2].[localidad]([id_localidad])
);
CREATE TABLE [QUEMA2].[producto] (
  [cod_producto] nvarchar(50),
  [precio_unitario] decimal(18,2),
  [nombre] nvarchar(50),
  [descripcion] nvarchar(255),
  PRIMARY KEY ([cod_producto])
);

CREATE TABLE [QUEMA2].[estado_pedido] (
  [id_estado_pedido] int IDENTITY(1,1),
  [nombre_estado] nvarchar(50),
  PRIMARY KEY ([id_estado_pedido])
);

CREATE TABLE [QUEMA2].[tipo_local] (
  [id_tipo_local] int IDENTITY(1,1),
  [tipo_local] nvarchar(50), 
  PRIMARY KEY ([id_tipo_local])
);

CREATE TABLE [QUEMA2].[local] (
  [id_local] int IDENTITY(1,1),
  [id_tipo_local] int,
  [id_localidad] int,
  [nombre] nvarchar(100),
  [direccion] nvarchar(255),
  [descripcion] nvarchar(255),
  [provincia] nvarchar(255)
  PRIMARY KEY ([id_local]),
  CONSTRAINT [FK_local.id_tipo_local]
    FOREIGN KEY ([id_tipo_local])
      REFERENCES [QUEMA2].[tipo_local]([id_tipo_local]),
  CONSTRAINT [FK_localidad.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [QUEMA2].[localidad]([id_localidad])
);


CREATE TABLE [QUEMA2].[usuario] (
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
CREATE TABLE [QUEMA2].[movilidad] (
  [id_movilidad] int IDENTITY(1,1),
  [tipo_movilidad] nvarchar(50),
  PRIMARY KEY ([id_movilidad])
); 
CREATE TABLE [QUEMA2].[repartidor] (
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
      REFERENCES [QUEMA2].[movilidad]([id_movilidad]),
  CONSTRAINT [FK_repartidor.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [QUEMA2].[localidad]([id_localidad])
);

CREATE TABLE [QUEMA2].[direccion_x_usuario] (
  [id_direccion_x_usuario] int IDENTITY(1,1),
  [id_direccion] int,
  [id_usuario] int,
  PRIMARY KEY ([id_direccion_x_usuario]),
  CONSTRAINT [FK_direccion_x_usuario.id_direccion]
    FOREIGN KEY ([id_direccion])
      REFERENCES [QUEMA2].[direccion]([id_direccion]),
  CONSTRAINT [FK_direccion_x_usuario.id_usuari o]
    FOREIGN KEY ([id_usuario]) 
      REFERENCES [QUEMA2].[usuario]([id_usuario])
);
CREATE TABLE [QUEMA2].[estado_reclamo] (
  [id_estado_reclamo] int IDENTITY(1,1),
  [estado_reclamo] nvarchar(50),
  PRIMARY KEY ([id_estado_reclamo])
);

CREATE TABLE [QUEMA2].[tipo_reclamo] (
  [id_tipo_reclamo] int IDENTITY(1,1),
  [tipo_reclamo] nvarchar(50),
  PRIMARY KEY ([id_tipo_reclamo]) 
);

CREATE TABLE [QUEMA2].[operador] (
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

CREATE TABLE [QUEMA2].[pedido] (
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
      REFERENCES [QUEMA2].[medio_de_pago]([id_medio_pago]),
  CONSTRAINT [FK_pedido.id_estado_pedido]
    FOREIGN KEY ([id_estado_pedido])
      REFERENCES [QUEMA2].[estado_pedido]([id_estado_pedido]),
  CONSTRAINT [FK_pedido.id_local]
    FOREIGN KEY ([id_local])
      REFERENCES [QUEMA2].[local]([id_local]),
  CONSTRAINT [FK_pedido.id_usuario]
    FOREIGN KEY ([id_usuario]) 
      REFERENCES [QUEMA2].[usuario]([id_usuario])
);
CREATE TABLE [QUEMA2].[envio] (
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
      REFERENCES [QUEMA2].[direccion_x_usuario]([id_direccion_x_usuario]),
  CONSTRAINT [FK_envio.id_repartidor]
    FOREIGN KEY ([id_repartidor])
      REFERENCES [QUEMA2].[repartidor]([id_repartidor]),
  CONSTRAINT [FK_envio.id_pedido]
    FOREIGN KEY ([id_pedido])
      REFERENCES [QUEMA2].[pedido]([id_pedido])
);

CREATE TABLE [QUEMA2].[reclamo] (
  [id_reclamo] int IDENTITY(1,1),
  [nro_reclamo] decimal(18,0),
  [id_tipo_reclamo] int,
  [id_estado_reclamo] int,
  [id_operador] int,
  [descripcion] nvarchar(255),
  [fecha_solucion] datetime2(3),
  [fecha] datetime2(3),
  [calificacion] int,
  [solucion] nvarchar(255),
  [id_pedido] int,
  PRIMARY KEY ([id_reclamo]),
  CONSTRAINT [FK_reclamo.id_estado_reclamo]
    FOREIGN KEY ([id_estado_reclamo])
      REFERENCES [QUEMA2].[estado_reclamo]([id_estado_reclamo]),
  CONSTRAINT [FK_reclamo.id_tipo_reclamo]
    FOREIGN KEY ([id_tipo_reclamo])
      REFERENCES [QUEMA2].[tipo_reclamo]([id_tipo_reclamo]),
  CONSTRAINT [FK_reclamo.id_operador]
    FOREIGN KEY ([id_operador])
      REFERENCES [QUEMA2].[operador]([id_operador]),
  CONSTRAINT [FK_reclamo.id_pedido]
    FOREIGN KEY ([id_pedido])
      REFERENCES [QUEMA2].[Pedido]([id_pedido]),
);

CREATE TABLE [QUEMA2].[tipo_cupon] (
  [id_tipo_cupon] int IDENTITY(1,1),
  [tipo] nvarchar(50),
  PRIMARY KEY ([id_tipo_cupon])
);

CREATE TABLE [QUEMA2].[cupon_reclamo] (
  [id_cupon_reclamo] int IDENTITY(1,1),
  [nro_cupon_reclamo] decimal(18,0),
  [tipo_cupon] nvarchar(50),
  [id_reclamo] int,
  [monto] decimal(18,2),
  [fecha_alta] datetime2(3),
  [fecha_vencimiento] datetime2(3),
  PRIMARY KEY ([id_cupon_reclamo]),
  CONSTRAINT [FK_cupon_reclamo.id_reclamo]
    FOREIGN KEY ([id_reclamo])
      REFERENCES [QUEMA2].[reclamo]([id_reclamo])
);

CREATE TABLE [QUEMA2].[cupon_descuento] (
  [id_cupon_descuento] int IDENTITY(1,1),
  [nro_cupon] decimal(18,0),
  [id_usuario] int,
  [id_tipo_cupon] int,
  [fecha_alta] datetime2(3),
  [fecha_vencimiento] datetime2(3),
  PRIMARY KEY ([id_cupon_descuento]),
  CONSTRAINT [FK_cupon_descuento.id_usuario]
    FOREIGN KEY ([id_usuario])
      REFERENCES [QUEMA2].[usuario]([id_usuario]),
  CONSTRAINT [FK_cupon_descuento.id_tipo_cupon]
    FOREIGN KEY ([id_tipo_cupon])
      REFERENCES [QUEMA2].[tipo_cupon]([id_tipo_cupon])
);

CREATE TABLE [QUEMA2].[cupon_descuento_x_pedido] (
  [id_descuento_x_pedido] int IDENTITY(1,1),
  [id_cupon_descuento] int,
  [id_pedido] int,
  [monto_descuento] decimal(18,2),
  PRIMARY KEY ([id_descuento_x_pedido]),
  CONSTRAINT [FK_cupon_descuento_x_pedido.id_pedido]
    FOREIGN KEY ([id_pedido])
      REFERENCES [QUEMA2].[Pedido]([id_pedido]),
  CONSTRAINT [FK_cupon_descuento_x_pedido.nro_cupon]
    FOREIGN KEY ([id_cupon_descuento])
      REFERENCES [QUEMA2].[cupon_descuento]([id_cupon_descuento])
);

CREATE TABLE [QUEMA2].[tarjeta] (
  [nro_tarjeta] nvarchar(50),
  [id_medio_pago] int,
  [id_usaurio] int,
  [marca_tarjeta] nvarchar(100),
  PRIMARY KEY ([nro_tarjeta]),
  CONSTRAINT [FK_tarjeta.id_medio_pago]
    FOREIGN KEY ([id_medio_pago])
      REFERENCES [QUEMA2].[medio_de_pago]([id_medio_pago]),
  CONSTRAINT [FK_tarjeta.id_usaurio]
    FOREIGN KEY ([id_usaurio])
      REFERENCES [QUEMA2].[usuario]([id_usuario])
);


CREATE TABLE [QUEMA2].[estado_mensajeria] (
  [id_estado_mensajeria] int IDENTITY(1,1),
  [nombre_estado] nvarchar(50),
  PRIMARY KEY ([id_estado_mensajeria])
);

CREATE TABLE [QUEMA2].[tipo_paquete] (  
  [id_tipo_paquete] int IDENTITY(1,1),
  [nombre] nvarchar(50),
  [alto] decimal(18,2),
  [ancho] decimal(18,2),
  [largo] decimal(18,2),
  [peso_maximo] decimal(18,2),
  [precio_x_paquete] decimal(18,2),
  PRIMARY KEY ([id_tipo_paquete])
);

CREATE TABLE [QUEMA2].[direcciones_mensajeria] (
  [id_direcciones_mensajeria] int IDENTITY(1,1),
  [direccion_origen] nvarchar(255),
  [direccion_destino] nvarchar(255),
  [id_localidad] int
  PRIMARY KEY ([id_direcciones_mensajeria]),
  CONSTRAINT [FK_direcciones_mensajeria.id_localidad]
   FOREIGN KEY ([id_localidad])
    REFERENCES [QUEMA2].[localidad]([id_localidad])
);

CREATE TABLE [QUEMA2].[mensajeria] (
  [id_mensajeria] int IDENTITY(1,1),
  [nro_envio_mensajeria] decimal(18,0),
  [id_usuario] int,
  [id_medio_de_pago] int,
  [id_estado_mensajeria] int,
  [id_tipo_paquete] int,
  [id_repartidor] int,
  [id_direcciones_mensajeria] int,
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
      REFERENCES [QUEMA2].[tipo_paquete]([id_tipo_paquete]),
  CONSTRAINT [FK_mensajeria.id_medio_de_pago]
    FOREIGN KEY ([id_medio_de_pago])
      REFERENCES [QUEMA2].[medio_de_pago]([id_medio_pago]),
  CONSTRAINT [FK_mensajeria.id_estado_mensajeria]
    FOREIGN KEY ([id_estado_mensajeria])
      REFERENCES [QUEMA2].[estado_mensajeria]([id_estado_mensajeria]),
  CONSTRAINT [FK_mensajeria.id_usuario]
    FOREIGN KEY ([id_usuario])
      REFERENCES [QUEMA2].[usuario]([id_usuario]),
  CONSTRAINT [FK_mensajeria.id_repartidor]
    FOREIGN KEY ([id_repartidor])
      REFERENCES [QUEMA2].[repartidor]([id_repartidor]),
  CONSTRAINT [FK_mensajeria.id_direcciones_mensajeria]
    FOREIGN KEY ([id_direcciones_mensajeria])
      REFERENCES [QUEMA2].[direcciones_mensajeria]([id_direcciones_mensajeria])
);

CREATE TABLE [QUEMA2].[producto_x_pedido] (
  [id_producto_x_Pedido] int IDENTITY(1,1),
  [cod_producto] nvarchar(50),
  [id_pedido] int,
  [precio_producto] decimal(18,2),
  [cantidad] decimal(18,2),
  PRIMARY KEY ([id_producto_x_Pedido]),
  CONSTRAINT [FK_producto_x_pedido.id_pedido]
    FOREIGN KEY ([id_pedido])
      REFERENCES [QUEMA2].[Pedido]([id_pedido]),
  CONSTRAINT [FK_producto_x_pedido.cod_producto]
    FOREIGN KEY ([cod_producto])
      REFERENCES [QUEMA2].[producto]([cod_producto])
);



CREATE TABLE [QUEMA2].[producto_x_local] (
  [id_producto_x_local] int IDENTITY(1,1),
  [id_local] int,
  [cod_producto] nvarchar(50),
  [precio_producto] decimal(18,2), 
  PRIMARY KEY ([id_producto_x_local]),
  CONSTRAINT [FK_producto_x_local.id_local]
    FOREIGN KEY ([id_local])
      REFERENCES [QUEMA2].[local]([id_local]),
  CONSTRAINT [FK_producto_x_local.cod_producto]
    FOREIGN KEY ([cod_producto])
      REFERENCES [QUEMA2].[producto]([cod_producto])
);

CREATE TABLE [QUEMA2].[producto_x_local_x_pedido] (
  [id_producto_x_local_x_pedido] int IDENTITY(1,1),
  [id_producto_x_local] int,
  [id_producto_x_pedido] int
  PRIMARY KEY ([id_producto_x_local_x_pedido]),
  CONSTRAINT [FK_producto_x_local_x_pedido.id_producto_x_local]
    FOREIGN KEY ([id_producto_x_local])
      REFERENCES [QUEMA2].[producto_x_local]([id_producto_x_local]),
  CONSTRAINT [FK_producto_x_local_x_pedido.id_producto_x_Pedido]
    FOREIGN KEY ([id_producto_x_pedido])
      REFERENCES [QUEMA2].[producto_x_pedido]([id_producto_x_Pedido])
);

CREATE TABLE [QUEMA2].[dia] (
  [id_dia] int IDENTITY(0,1),
  [dia] nvarchar(50),
  PRIMARY KEY ([id_dia])
);

CREATE TABLE [QUEMA2].[horario_dia_x_local] (
  [id_dia_x_local] int IDENTITY(1,1),
  [id_dia] int,
  [id_local] int,
  [hora_apertura] decimal(18,2),
  [hora_cierre] decimal(18,2),
  PRIMARY KEY ([id_dia_x_local]),
    CONSTRAINT [FK_dia_x_local.id_local]
    FOREIGN KEY ([id_local])
      REFERENCES [QUEMA2].[local]([id_local]),
    CONSTRAINT [FK_dia_x_local.id_dia]
    FOREIGN KEY ([id_dia])
      REFERENCES [QUEMA2].[dia]([id_dia])
);

CREATE TABLE [QUEMA2].[localidad_x_repartidor] (
  [id_localidad_x_repartidor] int IDENTITY(1,1),
  [dni_repartidor] decimal(18,0),
  [id_localidad] int,
  [fecha_pedido] datetime,
  PRIMARY KEY ([id_localidad_x_repartidor]),
    CONSTRAINT [FK_localidad_x_repartidor.id_localidad]
    FOREIGN KEY ([id_localidad])
      REFERENCES [QUEMA2].[localidad]([id_localidad])
);

-- NORMALIZACION DE DATOS - STORED PROCEDURES
GO
CREATE PROCEDURE [QUEMA2].migrar_tipo_local 
AS 
BEGIN
	INSERT INTO [QUEMA2].tipo_local(tipo_local)
	SELECT DISTINCT
		LOCAL_TIPO as tipo_local
	FROM gd_esquema.Maestra
	WHERE LOCAL_TIPO is not null

	IF @@ERROR != 0
	PRINT('SP TIPO LOCAL FAIL!')
	ELSE
	PRINT('SP TIPO LOCAL OK!')
END

--VERIFICADA
GO
CREATE PROCEDURE [QUEMA2].migrar_estado_pedido
AS 
BEGIN
	INSERT INTO [QUEMA2].estado_pedido(nombre_estado)
	SELECT DISTINCT
		PEDIDO_ESTADO as nombre_estado
	FROM gd_esquema.Maestra
	WHERE PEDIDO_ESTADO is not null

	IF @@ERROR != 0
	PRINT('SP ESTADO PEDIDO FAIL!')
	ELSE
	PRINT('SP ESTADO PEDIDO OK!')
END


--VERIFICADA
GO
CREATE PROCEDURE [QUEMA2].migrar_medio_pago
AS 
BEGIN
	INSERT INTO [QUEMA2].medio_de_pago(tipo_medio_pago)
	SELECT DISTINCT
		MEDIO_PAGO_TIPO as tipo_medio_pago
	FROM gd_esquema.Maestra
	WHERE MEDIO_PAGO_TIPO is not null

	IF @@ERROR != 0
	PRINT('SP TIPO MEDIO PAGO FAIL!')
	ELSE
	PRINT('SP TIPO MEDIO PAGO OK!')
END

--VERIFICADA
GO
CREATE PROCEDURE [QUEMA2].migrar_usuario
AS 
BEGIN
	INSERT INTO [QUEMA2].usuario(nombre, apellido, dni, telefono, fecha_registro, fecha_nacimiento, mail)
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
	PRINT('SP USUARIO FALLO!')
	ELSE
	PRINT('SP USUARIO OK!')
END

--VERIFICADA
GO
CREATE PROCEDURE [QUEMA2].migrar_tipo_cupon
AS 
BEGIN
	INSERT INTO [QUEMA2].tipo_cupon(tipo)
	SELECT DISTINCT
		CUPON_TIPO as tipo
	FROM gd_esquema.Maestra
	WHERE CUPON_TIPO is not null 
	IF @@ERROR != 0
	PRINT('SP TIPO CUPON FAIL!')
	ELSE
	PRINT('SP TIPO CUPON OK!')
END

--VERIFICADA
GO
CREATE PROCEDURE [QUEMA2].migrar_movilidad
AS 
BEGIN
	INSERT INTO [QUEMA2].movilidad(tipo_movilidad)
	SELECT DISTINCT
		REPARTIDOR_TIPO_MOVILIDAD as movilidad
	FROM gd_esquema.Maestra
	WHERE REPARTIDOR_TIPO_MOVILIDAD is not null 
	IF @@ERROR != 0
	PRINT('SP MOVILIDAD FAIL!')
	ELSE
	PRINT('SP MOVILIDAD OK!')
END

--POR VERIFICAR
GO
CREATE PROCEDURE [QUEMA2].migrar_provincia
AS 
BEGIN
	INSERT INTO [QUEMA2].provincia(nombre)
	(SELECT DISTINCT ENVIO_MENSAJERIA_PROVINCIA as nombre 
	FROM gd_esquema.Maestra 
	WHERE ENVIO_MENSAJERIA_PROVINCIA is not null)
    UNION 
    (SELECT DISTINCT DIRECCION_USUARIO_PROVINCIA
	 FROM gd_esquema.Maestra 
	 WHERE DIRECCION_USUARIO_PROVINCIA is not null)
	UNION 
    (SELECT DISTINCT LOCAL_PROVINCIA
	 FROM gd_esquema.Maestra 
	 WHERE LOCAL_PROVINCIA is not null)
	IF @@ERROR != 0
	PRINT('SP PROVINCIA FAIL!')
	ELSE
	PRINT('SP PROVINCIA OK!')
END

--POR VERIFICAR
GO
CREATE PROCEDURE [QUEMA2].migrar_localidad
AS 
BEGIN
	INSERT INTO [QUEMA2].localidad(nombre, id_provincia)
	(SELECT DISTINCT ENVIO_MENSAJERIA_LOCALIDAD, p.id_provincia FROM gd_esquema.Maestra
	 JOIN provincia p on p.nombre = ENVIO_MENSAJERIA_PROVINCIA
	 WHERE ENVIO_MENSAJERIA_LOCALIDAD is not null
	 and ENVIO_MENSAJERIA_PROVINCIA is not null)
     UNION 
    (SELECT DISTINCT DIRECCION_USUARIO_LOCALIDAD, p.id_provincia 
	FROM gd_esquema.Maestra
	 JOIN provincia p on p.nombre = DIRECCION_USUARIO_PROVINCIA
	 WHERE DIRECCION_USUARIO_LOCALIDAD is not null
	 and DIRECCION_USUARIO_PROVINCIA is not null)
	UNION 
    (SELECT DISTINCT LOCAL_LOCALIDAD, p.id_provincia
	 FROM gd_esquema.Maestra 
	 JOIN QUEMA2.provincia p on p.nombre = LOCAL_PROVINCIA
	 WHERE LOCAL_LOCALIDAD is not null
	 and LOCAL_PROVINCIA is not null)
	IF @@ERROR != 0
	PRINT('SP LOCALIDAD FAIL!')
	ELSE
	PRINT('SP LOCALIDAD OK!')
END


GO
CREATE PROCEDURE [QUEMA2].migrar_localidad_x_repartidor
AS 
BEGIN
	INSERT INTO [QUEMA2].localidad_x_repartidor(dni_repartidor,id_localidad,fecha_pedido)
    SELECT DISTINCT
		REPARTIDOR_DNI,
		l.id_localidad,
		PEDIDO_FECHA_ENTREGA
    FROM gd_esquema.Maestra
    JOIN localidad l
    on l.nombre = LOCAL_LOCALIDAD
	WHERE REPARTIDOR_DNI is not null 
	and PEDIDO_FECHA_ENTREGA is not null
	and LOCAL_LOCALIDAD is not null
	and PEDIDO_NRO is not null
	IF @@ERROR != 0
	PRINT('SP LOCALIDAD POR REPARTIDOR FAIL!')
	ELSE
	PRINT('SP LOCALIDAD POR REPARTIDOR OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_repartidor 
AS 
BEGIN
	INSERT INTO [QUEMA2].repartidor(id_localidad, id_movilidad, nombre_repartidor, apellido_repartidor, dni, telefono, direccion, email,fecha_nacimiento)
    SELECT DISTINCT
        (SELECT TOP 1 id_localidad
		FROM [QUEMA2].localidad_x_repartidor lp
		where lp.dni_repartidor = REPARTIDOR_DNI
		order by fecha_pedido DESC) as id_localidad,
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
	PRINT('SP REPARTIDOR FAIL!')
	ELSE
	PRINT('SP REPARTIDOR OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_direccion
AS 
BEGIN
	INSERT INTO [QUEMA2].direccion(nombre,direccion,provincia,id_localidad)
    (SELECT DISTINCT
        DIRECCION_USUARIO_NOMBRE,
		DIRECCION_USUARIO_DIRECCION,
		DIRECCION_USUARIO_PROVINCIA,
		l.id_localidad
    FROM gd_esquema.Maestra 
	JOIN provincia prov
	on prov.nombre = DIRECCION_USUARIO_PROVINCIA
	JOIN localidad l
	on l.nombre = DIRECCION_USUARIO_LOCALIDAD
	AND l.id_provincia = prov.id_provincia
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
	JOIN provincia prov
	on prov.nombre = LOCAL_PROVINCIA
	JOIN localidad l
	on l.nombre = LOCAL_LOCALIDAD
	AND l.id_provincia = prov.id_provincia
	WHERE LOCAL_NOMBRE is not null 
	and LOCAL_DIRECCION is not null
    and LOCAL_PROVINCIA is not null
    and LOCAL_LOCALIDAD is not null)
	IF @@ERROR != 0
	PRINT('SP DIRECCION FAIL!')
	ELSE
	PRINT('SP DIRECCION OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_direccion_x_usuario
AS 
BEGIN
	INSERT INTO [QUEMA2].direccion_x_usuario(id_usuario,id_direccion)
	SELECT DISTINCT
		u.id_usuario,
		d.id_direccion
    FROM gd_esquema.Maestra
	JOIN usuario u 
	on u.dni = USUARIO_DNI
	JOIN provincia prov
	on prov.nombre = DIRECCION_USUARIO_PROVINCIA
	JOIN direccion d
	on d.direccion = DIRECCION_USUARIO_DIRECCION
	and d.nombre = DIRECCION_USUARIO_NOMBRE
	and d.id_localidad = (SELECT TOP 1 id_localidad
							 FROM [QUEMA2].localidad loc 
								where loc.nombre = DIRECCION_USUARIO_LOCALIDAD
								and loc.id_provincia = prov.id_provincia)
	WHERE USUARIO_DNI is not null 
	and DIRECCION_USUARIO_DIRECCION is not null
	and DIRECCION_USUARIO_NOMBRE is not null
	and DIRECCION_USUARIO_PROVINCIA is not null
	and DIRECCION_USUARIO_LOCALIDAD is not null
	IF @@ERROR != 0
	PRINT('SP DIRECCION POR USUARIO FAIL!')
	ELSE
	PRINT('SP DIRECCION POR USUARIO OK!')
END
GO
CREATE PROCEDURE [QUEMA2].migrar_estado_reclamo
AS 
BEGIN
	INSERT INTO [QUEMA2].estado_reclamo(estado_reclamo)
	SELECT DISTINCT
		RECLAMO_ESTADO as estado_reclamo
	FROM gd_esquema.Maestra
	WHERE RECLAMO_ESTADO is not null

	IF @@ERROR != 0
	PRINT('SP ESTADO RECLAMO FAIL!')
	ELSE
	PRINT('SP ESTADO RECLAMO OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_tipo_reclamo
AS 
BEGIN
	INSERT INTO [QUEMA2].tipo_reclamo(tipo_reclamo)
	SELECT DISTINCT
		RECLAMO_TIPO as tipo_reclamo
	FROM gd_esquema.Maestra
	WHERE RECLAMO_TIPO is not null

	IF @@ERROR != 0
	PRINT('SP TIPO RECLAMO FAIL!')
	ELSE
	PRINT('SP TIPO RECLAMO OK!')
END


GO
CREATE PROCEDURE [QUEMA2].migrar_dia
AS 
BEGIN
	INSERT INTO [QUEMA2].dia(dia) VALUES('Lunes')
	INSERT INTO [QUEMA2].dia(dia) VALUES('Martes')
	INSERT INTO [QUEMA2].dia(dia) VALUES('Miercoles')
	INSERT INTO [QUEMA2].dia(dia) VALUES('Jueves')
	INSERT INTO [QUEMA2].dia(dia) VALUES('Viernes')
	INSERT INTO [QUEMA2].dia(dia) VALUES('Sabado')
	INSERT INTO [QUEMA2].dia(dia) VALUES('Domingo')
	
	
/*	SELECT DISTINCT
		HORARIO_LOCAL_DIA
	FROM gd_esquema.Maestra
	WHERE HORARIO_LOCAL_DIA is not null */


	IF @@ERROR != 0
	PRINT('SP DIA FAIL!')
	ELSE
	PRINT('SP DIA OK!')
END


GO
CREATE PROCEDURE [QUEMA2].migrar_horario_dia_x_local
AS 
BEGIN
	INSERT INTO [QUEMA2].horario_dia_x_local(id_dia,id_local,hora_apertura,hora_cierre)
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
	PRINT('SP HORARIO Y DIA DE LOCAL FAIL!')
	ELSE
	PRINT('SP HORARIO Y DIA DE LOCAL OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_local
AS 
BEGIN
	INSERT INTO [QUEMA2].local(id_tipo_local, id_localidad, nombre, direccion, descripcion, provincia)
	SELECT DISTINCT
		tl.id_tipo_local,
		loc.id_localidad,
		LOCAL_NOMBRE,
		LOCAL_DIRECCION,
		LOCAL_DESCRIPCION,
		LOCAL_PROVINCIA
	FROM gd_esquema.Maestra
	JOIN tipo_local tl
	ON tl.tipo_local = LOCAL_TIPO 
	JOIN localidad loc
	ON loc.nombre = LOCAL_LOCALIDAD
	WHERE LOCAL_NOMBRE is not null and
	LOCAL_DIRECCION is not null and
	LOCAL_DESCRIPCION is not null and
	LOCAL_LOCALIDAD is not null and
	LOCAL_PROVINCIA is not null
	IF @@ERROR != 0
	PRINT('SP LOCAL FAIL!')
	ELSE
	PRINT('SP LOCAL OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_tarjeta
AS 
BEGIN
	INSERT INTO [QUEMA2].tarjeta(nro_tarjeta, id_medio_pago, id_usaurio, marca_tarjeta)
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
	MEDIO_PAGO_TIPO is not null and
	mp.tipo_medio_pago != 'Efectivo'
	IF @@ERROR != 0
	PRINT('SP TARJETA FAIL!')
	ELSE
	PRINT('SP TARJETA OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_tipo_paquete
AS 
BEGIN
	INSERT INTO [QUEMA2].tipo_paquete(nombre, alto, ancho,largo,peso_maximo,precio_x_paquete)
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
	PRINT('SP TIPO PAQUETE FAIL!')
	ELSE
	PRINT('SP TIPO PAQUETE OK!')
END
 
GO
CREATE PROCEDURE [QUEMA2].migrar_estado_mensajeria
AS 
BEGIN
	INSERT INTO [QUEMA2].estado_mensajeria(nombre_estado)
	SELECT DISTINCT
		ENVIO_MENSAJERIA_ESTADO
	FROM gd_esquema.Maestra
	WHERE ENVIO_MENSAJERIA_ESTADO is not null 
	IF @@ERROR != 0
	PRINT('SP ESTADO MENSAJERIA FAIL!')
	ELSE
	PRINT('SP ESTADO MENSAJERIA OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_direcciones_mensajeria
AS 
BEGIN
	INSERT INTO [QUEMA2].direcciones_mensajeria(id_localidad, direccion_origen, direccion_destino)
    SELECT DISTINCT
        l.id_localidad,
		ENVIO_MENSAJERIA_DIR_ORIG,
		ENVIO_MENSAJERIA_DIR_DEST
    FROM gd_esquema.Maestra 
	JOIN provincia p 
	on p.nombre = ENVIO_MENSAJERIA_PROVINCIA
	JOIN localidad l
	on l.nombre = ENVIO_MENSAJERIA_LOCALIDAD
	WHERE ENVIO_MENSAJERIA_LOCALIDAD is not null 
	and ENVIO_MENSAJERIA_DIR_ORIG is not null
	and ENVIO_MENSAJERIA_DIR_DEST is not null
	and ENVIO_MENSAJERIA_PROVINCIA is not null
	and ENVIO_MENSAJERIA_NRO is not null
	IF @@ERROR != 0
	PRINT('SP DIRECCIONES MENSAJERIA FAIL!')
	ELSE
	PRINT('SP DIRECCIONES MENSAJERIA OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_mensajeria
AS 
BEGIN
	INSERT INTO [QUEMA2].mensajeria(nro_envio_mensajeria,id_usuario,
	id_medio_de_pago,id_estado_mensajeria,
	id_tipo_paquete, id_repartidor,id_direcciones_mensajeria, distancia_km, valor_asegurado,
	observaciones, precio_seguro, precio_total, fecha_pedido, 
	fecha_entrega, propina, tiempo_estimado_entrega, calificacion)
	SELECT DISTINCT
		ENVIO_MENSAJERIA_NRO,
		u.id_usuario,
		mp.id_medio_pago,
		em.id_estado_mensajeria,
		tp.id_tipo_paquete,
		r.id_repartidor,
		(SELECT TOP 1 dm.id_direcciones_mensajeria 
		FROM [QUEMA2].direcciones_mensajeria dm
		where dm.direccion_origen = ENVIO_MENSAJERIA_DIR_ORIG 
		and dm.direccion_destino = ENVIO_MENSAJERIA_DIR_DEST
		and dm.id_localidad = l.id_localidad),
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
	ON r.dni = REPARTIDOR_DNI
	JOIN provincia p 
	on p.nombre = ENVIO_MENSAJERIA_PROVINCIA
	JOIN localidad l
	on l.nombre = ENVIO_MENSAJERIA_LOCALIDAD
	WHERE ENVIO_MENSAJERIA_ESTADO is not null and
	ENVIO_MENSAJERIA_NRO is not null and
	ENVIO_MENSAJERIA_KM is not null and
	ENVIO_MENSAJERIA_VALOR_ASEGURADO is not null and
	ENVIO_MENSAJERIA_OBSERV is not null and
	ENVIO_MENSAJERIA_PRECIO_SEGURO is not null and
	ENVIO_MENSAJERIA_TOTAL is not null and
	ENVIO_MENSAJERIA_FECHA is not null and
	ENVIO_MENSAJERIA_FECHA_ENTREGA is not null and
	ENVIO_MENSAJERIA_PROPINA is not null and
	ENVIO_MENSAJERIA_TIEMPO_ESTIMADO is not null and
	ENVIO_MENSAJERIA_CALIFICACION is not null and
	ENVIO_MENSAJERIA_DIR_ORIG is not null and
	ENVIO_MENSAJERIA_DIR_DEST is not null and
	ENVIO_MENSAJERIA_PROVINCIA is not null and
	ENVIO_MENSAJERIA_LOCALIDAD is not null and
	USUARIO_DNI is not null and
	MEDIO_PAGO_TIPO is not null and
	PAQUETE_TIPO is not null and
	REPARTIDOR_DNI is not null
	IF @@ERROR != 0
	PRINT('SP MENSAJERIA FAIL!')
	ELSE
	PRINT('SP MENSAJERIA OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_pedido
AS 
BEGIN
	INSERT INTO [QUEMA2].pedido(nro_pedido, id_estado_pedido, id_local, id_medio_pago, id_usuario,
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
	PRINT('SP PEDIDO FAIL!')
	ELSE
	PRINT('SP PEDIDO OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_cupon_descuento
AS 
BEGIN
	INSERT INTO [QUEMA2].cupon_descuento(nro_cupon, id_usuario, id_tipo_cupon, fecha_alta, fecha_vencimiento)
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
	JOIN pedido p
	on p.nro_pedido = PEDIDO_NRO
	WHERE CUPON_NRO is not null 
	and CUPON_FECHA_ALTA is not null
	and CUPON_FECHA_VENCIMIENTO is not null
	and USUARIO_DNI is not null
	and CUPON_TIPO is not null
	and PEDIDO_NRO is not null
	IF @@ERROR != 0
	PRINT('SP CUPON DESCUENTO FAIL!')
	ELSE
	PRINT('SP CUPON DESCUENTO OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_envio 
AS 
BEGIN
	INSERT INTO [QUEMA2].envio(id_repartidor,id_direccion_x_usuario,id_pedido,
	 precio_envio, propina, tiempo_estimado_entrega)
    SELECT DISTINCT
        r.id_repartidor,
		du.id_direccion_x_usuario,
		p.id_pedido,
		PEDIDO_PRECIO_ENVIO,
		PEDIDO_PROPINA,
		PEDIDO_TIEMPO_ESTIMADO_ENTREGA
    FROM gd_esquema.Maestra
	JOIN provincia prov
	on prov.nombre = DIRECCION_USUARIO_PROVINCIA
	JOIN localidad l
	on l.nombre = DIRECCION_USUARIO_LOCALIDAD
	and l.id_provincia = prov.id_provincia
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
	and DIRECCION_USUARIO_PROVINCIA is not null
	and USUARIO_DNI is not null 
	and PEDIDO_NRO is not null

	IF @@ERROR != 0
	PRINT('SP ENVIO FAIL!')
	ELSE
	PRINT('SP ENVIO OK!')
END


GO
CREATE PROCEDURE [QUEMA2].migrar_operador
AS 
BEGIN
	INSERT INTO [QUEMA2].operador(nombre, apellido, direccion, mail, dni, telefono, fecha_nacimiento)
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
	PRINT('SP OPERADOR FAIL!')
	ELSE
	PRINT('SP OPERADOR OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_reclamo
AS 
BEGIN
	INSERT INTO [QUEMA2].reclamo(nro_reclamo, id_tipo_reclamo,id_estado_reclamo,id_operador,id_pedido,descripcion,fecha_solucion,fecha,calificacion,solucion)
	SELECT distinct
		RECLAMO_NRO,
		tr.id_tipo_reclamo,
		er.id_estado_reclamo,
		(SELECT TOP 1 id_operador FROM [QUEMA2].operador o where o.dni = OPERADOR_RECLAMO_DNI),
		(SELECT TOP 1 ped.id_pedido FROM [QUEMA2].pedido ped where ped.nro_pedido = PEDIDO_NRO),
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
    JOIN usuario u
    on u.dni = USUARIO_DNI
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
	PRINT('SP RECLAMO FAIL!')
	ELSE
	PRINT('SP RECLAMO OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_cupon_reclamo
AS 
BEGIN
	INSERT INTO [QUEMA2].cupon_reclamo(nro_cupon_reclamo,tipo_cupon,id_reclamo,monto,fecha_alta,fecha_vencimiento)
	SELECT DISTINCT
		CUPON_RECLAMO_NRO,
		CUPON_RECLAMO_TIPO,
		rec.id_reclamo,
		CUPON_RECLAMO_MONTO,
		CUPON_RECLAMO_FECHA_ALTA,
		CUPON_RECLAMO_FECHA_VENCIMIENTO
	FROM gd_esquema.Maestra
	JOIN reclamo rec
	ON rec.nro_reclamo = RECLAMO_NRO 
	WHERE CUPON_RECLAMO_NRO is not null and
	CUPON_RECLAMO_MONTO is not null and
	CUPON_RECLAMO_FECHA_ALTA is not null and
	CUPON_RECLAMO_FECHA_VENCIMIENTO is not null and
	CUPON_RECLAMO_TIPO is not null and
	RECLAMO_NRO is not null 

	IF @@ERROR != 0
	PRINT('SP CUPON_RECLAMO FAIL!')
	ELSE
	PRINT('SP CUPON_RECLAMO OK!')
END


GO
CREATE PROCEDURE [QUEMA2].migrar_cupon_descuento_x_pedido
AS 
BEGIN
	INSERT INTO [QUEMA2].cupon_descuento_x_pedido(id_pedido,id_cupon_descuento,monto_descuento)
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
	PRINT('SP CUPON DESCUENTO X PEDIDO FAIL!')
	ELSE
	PRINT('SP CUPON DESCUENTO X PEDIDO OK!')
END


GO
CREATE PROCEDURE [QUEMA2].migrar_producto
AS 
BEGIN
	INSERT INTO [QUEMA2].producto(cod_producto,precio_unitario, nombre, descripcion)
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
	PRINT('SP PRODUCTO FAIL!')
	ELSE
	PRINT('SP PRODUCTO OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_producto_x_pedido
AS 
BEGIN
	INSERT INTO [QUEMA2].producto_x_pedido(cod_producto,id_pedido,precio_producto,cantidad)
	SELECT DISTINCT
		p.cod_producto,
		pe.id_pedido,
		p.precio_unitario,
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
	PRINT('SP PRODUCTO POR PEDIDO FAIL!')
	ELSE
	PRINT('SP PRODUCTO POR PEDIDO OK!')
END


GO
CREATE PROCEDURE [QUEMA2].migrar_producto_x_local
AS 
BEGIN
	INSERT INTO [QUEMA2].producto_x_local(cod_producto,id_local,precio_producto)
	SELECT DISTINCT
		p.cod_producto,
		l.id_local,
		p.precio_unitario
	FROM gd_esquema.Maestra
	JOIN producto p
	on p.cod_producto = PRODUCTO_LOCAL_CODIGO
	JOIN local l
	ON l.nombre = LOCAL_NOMBRE
	and l.provincia = LOCAL_PROVINCIA
	JOIN pedido pe
	on pe.nro_pedido = PEDIDO_NRO
	WHERE PRODUCTO_LOCAL_CODIGO is not null and
	LOCAL_NOMBRE is not null and 
	LOCAL_PROVINCIA is not null and
	PEDIDO_NRO is not null

	IF @@ERROR != 0
	PRINT('SP PRODUCTO POR LOCAL FAIL!')
	ELSE
	PRINT('SP PRODUCTO POR LOCAL OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_producto_x_local_x_pedido
AS 
BEGIN
	INSERT INTO [QUEMA2].producto_x_local_x_pedido(id_producto_x_local,id_producto_x_Pedido)
	SELECT DISTINCT
		ppl.id_producto_x_local,
		ppp.id_producto_x_Pedido
	FROM gd_esquema.Maestra
	JOIN local l
	on l.nombre = LOCAL_NOMBRE
	and l.direccion = LOCAL_DIRECCION
	JOIN producto pr
	on pr.cod_producto = PRODUCTO_LOCAL_CODIGO
	JOIN producto_x_local ppl
	ON ppl.id_local = l.id_local and
	ppl.cod_producto = pr.cod_producto
	JOIN pedido pe
	ON pe.nro_pedido = PEDIDO_NRO
	JOIN producto_x_pedido ppp
	ON ppp.cod_producto = pr.cod_producto
	and ppp.id_pedido = pe.id_pedido
	WHERE PRODUCTO_LOCAL_CODIGO is not null and
	PEDIDO_NRO is not null and 
	LOCAL_NOMBRE is not null and 
	LOCAL_DIRECCION is not null

	IF @@ERROR != 0
	PRINT('SP PRODUCTO POR LOCAL Y PEDIDO FAIL!')
	ELSE
	PRINT('SP PRODUCTO POR LOCAL Y PEDIDO OK!')
END

GO
EXEC QUEMA2.migrar_provincia
GO
EXEC QUEMA2.migrar_tipo_local
GO
EXEC QUEMA2.migrar_estado_pedido
GO
EXEC QUEMA2.migrar_medio_pago
GO
EXEC QUEMA2.migrar_usuario
GO
EXEC QUEMA2.migrar_tipo_cupon
GO
EXEC QUEMA2.migrar_movilidad
GO
EXEC QUEMA2.migrar_localidad
GO
EXEC QUEMA2.migrar_localidad_x_repartidor
GO
EXEC QUEMA2.migrar_repartidor
GO
EXEC QUEMA2.migrar_direccion
GO
EXEC QUEMA2.migrar_direccion_x_usuario
GO
EXEC QUEMA2.migrar_estado_reclamo
GO
EXEC QUEMA2.migrar_tipo_reclamo
GO
EXEC QUEMA2.migrar_local
GO
EXEC QUEMA2.migrar_dia
GO
EXEC QUEMA2.migrar_horario_dia_x_local
GO
EXEC QUEMA2.migrar_tarjeta
GO
EXEC QUEMA2.migrar_tipo_paquete
GO
EXEC QUEMA2.migrar_estado_mensajeria
GO
EXEC QUEMA2.migrar_direcciones_mensajeria
GO
EXEC QUEMA2.migrar_mensajeria
GO
EXEC QUEMA2.migrar_pedido
GO
EXEC QUEMA2.migrar_cupon_descuento
GO
EXEC QUEMA2.migrar_envio
GO
EXEC QUEMA2.migrar_operador
GO
EXEC QUEMA2.migrar_reclamo
GO
EXEC QUEMA2.migrar_cupon_reclamo
GO
EXEC QUEMA2.migrar_cupon_descuento_x_pedido
GO
EXEC QUEMA2.migrar_producto
GO
EXEC QUEMA2.migrar_producto_x_pedido
GO
EXEC QUEMA2.migrar_producto_x_local
GO
EXEC QUEMA2.migrar_producto_x_local_x_pedido
GO

