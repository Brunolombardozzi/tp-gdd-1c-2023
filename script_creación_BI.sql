USE [GD1C2023];

GO
		IF EXISTS(select * FROM sys.views where name = 'dia_hora_de_mayor_pedidos_x_localidad_x_categoria')
	DROP VIEW [QUEMA2].dia_hora_de_mayor_pedidos_x_localidad_x_categoria;

		IF EXISTS(select * FROM sys.views where name = 'dia_hora_x_localidad_x_categoria')
	DROP VIEW [QUEMA2].dia_hora_x_localidad_x_categoria;

			IF EXISTS(select * FROM sys.views where name = 'monto_no_cobrado_por_pedido_cancelado_x_dia_x_franja_horaria')
	DROP VIEW [QUEMA2].monto_no_cobrado_por_pedido_cancelado_x_dia_x_franja_horaria;

		IF EXISTS(select * FROM sys.views where name = 'promedio_mensual_precio_envio_x_localidad')
	DROP VIEW [QUEMA2].promedio_mensual_precio_envio_x_localidad;

		IF EXISTS(select * FROM sys.views where name = 'desvio_promedio_por_movilidad_x_dia_hora')
	DROP VIEW [QUEMA2].desvio_promedio_por_movilidad_x_dia_hora;

		IF EXISTS(select * FROM sys.views where name = 'monto_cupones_x_rango_etario_usuario')
	DROP VIEW [QUEMA2].monto_cupones_x_rango_etario_usuario;

		IF EXISTS(select * FROM sys.views where name = 'pedidos_por_localidad_por_edad_repartidor_por_mes')
	DROP VIEW [QUEMA2].pedidos_por_localidad_por_edad_repartidor_por_mes;

		IF EXISTS(select * FROM sys.views where name = 'promedio_calificacion_mensual_por_local')
	DROP VIEW [QUEMA2].promedio_calificacion_mensual_por_local;

			IF EXISTS(select * FROM sys.views where name = 'porcentaje_pedidos_mensaj_x_localidad_x_edad_repartidor')
	DROP VIEW [QUEMA2].porcentaje_pedidos_mensaj_x_localidad_x_edad_repartidor;

		IF EXISTS(select * FROM sys.views where name = 'mensajerias_por_localidad_por_edad_repartidor_por_mes')
	DROP VIEW [QUEMA2].mensajerias_por_localidad_por_edad_repartidor_por_mes;

		IF EXISTS(select * FROM sys.views where name = 'mensajerias_entregadas_por_localidad_por_edad_repartidor_por_mes')
	DROP VIEW [QUEMA2].mensajerias_entregadas_por_localidad_por_edad_repartidor_por_mes;

		IF EXISTS(select * FROM sys.views where name = 'pedidos_entregados_por_localidad_por_edad_repartidor_por_mes')
	DROP VIEW [QUEMA2].pedidos_entregados_por_localidad_por_edad_repartidor_por_mes;

		IF EXISTS(select * FROM sys.views where name = 'promedio_mensual_valor_asegurado_x_tipo_paquete')
	DROP VIEW [QUEMA2].promedio_mensual_valor_asegurado_x_tipo_paquete;

		IF EXISTS(select * FROM sys.views where name = 'promedio_resolucion_reclamo_x_mes_x_rango_etario_operador_x_tipo_reclamo')
	DROP VIEW [QUEMA2].promedio_resolucion_reclamo_x_mes_x_rango_etario_operador_x_tipo_reclamo;

		IF EXISTS(select * FROM sys.views where name = 'monto_mensual_por_cupones_reclamo')
	DROP VIEW [QUEMA2].monto_mensual_por_cupones_reclamo;

		IF EXISTS(select * FROM sys.views where name = 'cantidad_Reclamos_por_local_por_dia')
	DROP VIEW [QUEMA2].cantidad_Reclamos_por_local_por_dia;

	IF EXISTS(select * FROM sys.views where name = 'cantidad_Reclamos_por_local_por_dia')
	DROP FUNCTION QUEMA2.pedidosPorLocalidadPorEdadRepartidorPorMes
GO


DECLARE @borrarFKs NVARCHAR(MAX) = N'';

SELECT @borrarFKs  += N'
ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(parent_object_id))
    + '.' + QUOTENAME(OBJECT_NAME(parent_object_id)) + 
    ' DROP CONSTRAINT ' + QUOTENAME(name) + ';'
FROM sys.foreign_keys;
EXEC sp_executesql @borrarFKs 
GO


-- DROP TABLES

IF OBJECT_ID ('QUEMA2.rango_etario_bi')				IS NOT NULL DROP TABLE QUEMA2.rango_etario_bi;
IF OBJECT_ID ('QUEMA2.rango_horario_bi') 			IS NOT NULL DROP TABLE QUEMA2.rango_horario_bi;
IF OBJECT_ID ('QUEMA2.tiempo_bi')					IS NOT NULL DROP TABLE QUEMA2.tiempo_bi;
IF OBJECT_ID ('QUEMA2.reclamo_bi')					IS NOT NULL DROP TABLE QUEMA2.reclamo_bi; 
IF OBJECT_ID ('QUEMA2.pedido_bi')					IS NOT NULL DROP TABLE QUEMA2.pedido_bi;
IF OBJECT_ID ('QUEMA2.mensajeria_bi')					IS NOT NULL DROP TABLE QUEMA2.mensajeria_bi;
IF OBJECT_ID ('QUEMA2.estado_mensajeria_bi')		IS NOT NULL DROP TABLE QUEMA2.estado_mensajeria_bi;
IF OBJECT_ID ('QUEMA2.localidad_x_provincia_bi')	IS NOT NULL DROP TABLE QUEMA2.localidad_x_provincia_bi;
IF OBJECT_ID ('QUEMA2.tipo_paquete_bi')				IS NOT NULL DROP TABLE QUEMA2.tipo_paquete_bi;
IF OBJECT_ID ('QUEMA2.estado_reclamo_bi')			IS NOT NULL DROP TABLE QUEMA2.estado_reclamo_bi;
IF OBJECT_ID ('QUEMA2.movilidad_bi')				IS NOT NULL DROP TABLE QUEMA2.movilidad_bi; 
IF OBJECT_ID ('QUEMA2.dia_bi')						IS NOT NULL DROP TABLE QUEMA2.dia_bi;
IF OBJECT_ID ('QUEMA2.tipo_local_bi')				IS NOT NULL DROP TABLE QUEMA2.tipo_local_bi;
IF OBJECT_ID ('QUEMA2.local_bi')					IS NOT NULL DROP TABLE QUEMA2.local_bi;
IF OBJECT_ID ('QUEMA2.medio_pago_bi')			IS NOT NULL DROP TABLE QUEMA2.medio_pago_bi;
IF OBJECT_ID ('QUEMA2.estado_pedido_bi')			IS NOT NULL DROP TABLE QUEMA2.estado_pedido_bi; 
IF OBJECT_ID ('QUEMA2.tipo_reclamo_bi')					IS NOT NULL DROP TABLE QUEMA2.tipo_reclamo_bi;

--CREACION DE TABLAS

CREATE TABLE [QUEMA2].[rango_etario_bi] (
  [rango_etario_bi_id] int IDENTITY(1,1),
  [fecha_base] int,
  [fecha_limite] int,
  PRIMARY KEY ([rango_etario_bi_id])
);

CREATE TABLE [QUEMA2].[tipo_reclamo_bi] (
  [tipo_reclamo_bi_id] int,
  [tipo_reclamo] nvarchar(50),
  PRIMARY KEY ([tipo_reclamo_bi_id])
);

CREATE TABLE [QUEMA2].[tipo_local_bi] (
  [tipo_local_bi_id] int,
  [tipo_local] nvarchar(50),
  PRIMARY KEY ([tipo_local_bi_id])
);
CREATE TABLE [QUEMA2].[localidad_x_provincia_bi] (
  [localidad_x_provincia_bi_id] int IDENTITY(1,1),
  [localidad_bi_id] int,
  [provincia_bi_id] int,
  [nombreProvincia] nvarchar(255),
  [nombreLocalidad] nvarchar(255),
  PRIMARY KEY ([localidad_x_provincia_bi_id])
);

CREATE TABLE [QUEMA2].[local_bi] (
  [local_bi_id] int,
  [tipo_local_bi_id] int,
  [nombre] nvarchar(100),
  [direccion] nvarchar(255),
  [descripcion] nvarchar(255),
  [localidad_x_provincia_bi_id] int,
  [provincia] nvarchar(255),
  PRIMARY KEY ([local_bi_id]),
  CONSTRAINT [FK_local_bi.tipo_local_bi_id]
    FOREIGN KEY ([tipo_local_bi_id])
      REFERENCES [QUEMA2].[tipo_local_bi]([tipo_local_bi_id]),
  CONSTRAINT [FK_localidad_x_provincia_bi.tipo_local_bi_id]
    FOREIGN KEY ([localidad_x_provincia_bi_id])
      REFERENCES [QUEMA2].[localidad_x_provincia_bi]([localidad_x_provincia_bi_id])
);

CREATE TABLE [QUEMA2].[medio_pago_bi] (
  [medio_pago_bi_id] int,
  [medio_pago] nvarchar(50),
  PRIMARY KEY ([medio_pago_bi_id])
);

CREATE TABLE [QUEMA2].[estado_pedido_bi] (
  [estado_pedido_bi_id] int,
  [estado_pedido] nvarchar(50),
  PRIMARY KEY ([estado_pedido_bi_id])
);

CREATE TABLE [QUEMA2].[pedido_bi] (
  [pedido_bi_id] int,
  [estado_pedido_bi_id] int,
  [id_usuario] int,
  [local_bi_id] int,
  [medio_pago_bi_id] int,
  [fecha_pedido] datetime2(3),
  [fecha_entrega] datetime2(3),
  [total_productos] decimal(18,2),
  [total] decimal(18,2),
  PRIMARY KEY ([pedido_bi_id]),
  CONSTRAINT [FK_pedido_bi.local_bi_id]
    FOREIGN KEY ([local_bi_id])
      REFERENCES [QUEMA2].[local_bi]([local_bi_id]),
  CONSTRAINT [FK_pedido_bi.medio_pago_bi_id]
    FOREIGN KEY ([medio_pago_bi_id])
      REFERENCES [QUEMA2].[medio_pago_bi]([medio_pago_bi_id]),
  CONSTRAINT [FK_pedido_bi.estado_pedido_bi_id]
    FOREIGN KEY ([estado_pedido_bi_id])
      REFERENCES [QUEMA2].[estado_pedido_bi]([estado_pedido_bi_id])
);

CREATE TABLE [QUEMA2].[reclamo_bi] (
  [reclamo_bi_id] int,
  [tipo_reclamo_bi_id] int,
  [estado_reclamo_bi_id] int,
  [id_operador] int,
  [id_usuario] int,
  [pedido_bi_id] int,
  [nro_reclamo] decimal(18,2),
  [descripcion] nvarchar(255) ,
  [fecha_solucion] datetime2(3),
  [calificacion] int,
  [solucion] nvarchar(255),
  [fecha_reclamo] datetime,
  PRIMARY KEY ([reclamo_bi_id]),
  CONSTRAINT [FK_reclamo_bi.tipo_reclamo_bi_id]
    FOREIGN KEY ([tipo_reclamo_bi_id])
      REFERENCES [QUEMA2].[tipo_reclamo_bi]([tipo_reclamo_bi_id]),
  CONSTRAINT [FK_reclamo_bi.pedido_bi_id]
    FOREIGN KEY ([pedido_bi_id])
      REFERENCES [QUEMA2].[pedido_bi]([pedido_bi_id])
);

CREATE TABLE [QUEMA2].[tiempo_bi] (
  [tiempo_bi_id] int IDENTITY(1,1),
  [anio] int,
  [mes] int,
  PRIMARY KEY ([tiempo_bi_id])
);

CREATE TABLE [QUEMA2].[tipo_paquete_bi] (
  [tipo_paquete_bi_id] int,
  [nombre] nvarchar(50),
  [alto] decimal(18,2),
  [ancho] decimal(18,2),
  [largo] decimal(18,2),
  [peso_maximo] decimal(18,2),
  [precio_x_paquete] decimal(18,2),
  PRIMARY KEY ([tipo_paquete_bi_id])
);

CREATE TABLE [QUEMA2].[estado_mensajeria_bi] (
  [estado_mensajeria_bi_id] int ,
  [estado_mensajeria] nvarchar(50),
  PRIMARY KEY ([estado_mensajeria_bi_id])
);

CREATE TABLE [QUEMA2].[mensajeria_bi] (
  [mensajeria_bi_id] int,
  [id_repartidor] int,
  [id_usuario] int,
  [medio_de_pago_bi_id] int,
  [estado_mensajeria_bi_id] int,
  [tipo_paquete_bi_id] int,
  [nro_envio_mensajeria] decimal(18,2),
  [id_direcciones_mensjaeria] int,
  [distancia_km] decimal(18,2),
  [valor_asegurado] decimal(18,2),
  [observaciones] nvarchar(255) ,
  [precio_seguro] decimal(18,2),
  [precio_total] decimal(18,2),
  [fecha_pedido] datetime2(3),
  [fecha_entrega] datetime2(3),
  [precio_envio] decimal(18,2),
  [propina] decimal(18,2),
  [tiempo_estimado_entrega] decimal(18,2),
  [calificacion] decimal(18,0),
  PRIMARY KEY ([mensajeria_bi_id]),
  CONSTRAINT [FK_mensajeria_bi.tipo_paquete_bi_id ]
    FOREIGN KEY ([tipo_paquete_bi_id])
      REFERENCES [QUEMA2].[tipo_paquete_bi]([tipo_paquete_bi_id]),
  CONSTRAINT [FK_mensajeria_bi.estado_mensajeria_bi_id]
    FOREIGN KEY ([estado_mensajeria_bi_id])
      REFERENCES [QUEMA2].[estado_mensajeria_bi]([estado_mensajeria_bi_id]),
  CONSTRAINT [FK_mensajeria_bi.medio_de_pago_bi_id]
    FOREIGN KEY ([medio_de_pago_bi_id])
      REFERENCES [QUEMA2].[medio_pago_bi]([medio_pago_bi_id])
);

CREATE TABLE [QUEMA2].[rango_horario_bi] (
  [rango_horario_bi_id] int IDENTITY(1,1),
  [hora_desde] nvarchar(10),
  [hora_hasta] nvarchar(10),
  PRIMARY KEY ([rango_horario_bi_id])
);

CREATE TABLE [QUEMA2].[dia_bi] (
  [dia_bi_id] int,
  [hora_desde] Datetime,
  [hora_hasta] Datetime,
  PRIMARY KEY ([dia_bi_id])
);

CREATE TABLE [QUEMA2].[movilidad_bi] (
  [movilidad_bi_id] int,
  [tipo_movilidad] nvarchar(50),
  PRIMARY KEY ([movilidad_bi_id])
);

-- DROPEO DE STORED PROCEDURES

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


--STORED PROCEDURES

GO
CREATE PROCEDURE [QUEMA2].migrar_estado_mensajeria_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].estado_mensajeria_bi(estado_mensajeria_bi_id,estado_mensajeria)
	SELECT 
		mensaj.id_estado_mensajeria,
		mensaj.nombre_estado
	FROM [QUEMA2].estado_mensajeria mensaj
	IF @@ERROR != 0
	PRINT('SP ESTADO MENSAJERIA BI FAIL!')
	ELSE
	PRINT('SP ESTADO MENSAJERIA BI OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_dia_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].dia_bi(dia_bi_id)
	SELECT DISTINCT 
		d.id_dia
	FROM [QUEMA2].dia d

	IF @@ERROR != 0
	PRINT('SP DIA BI FAIL!')
	ELSE
	PRINT('SP DIA BI OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_medio_pago_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].medio_pago_bi(medio_pago_bi_id,medio_pago)
	SELECT DISTINCT 
		id_medio_pago,
		tipo_medio_pago
	FROM [QUEMA2].medio_de_pago

	IF @@ERROR != 0
	PRINT('SP TIPO MEDIO PAGO BI FAIL!')
	ELSE
	PRINT('SP TIPO MEDIO PAGO BI OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_estado_pedido_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].estado_pedido_bi(estado_pedido_bi_id,estado_pedido)
	SELECT DISTINCT
		id_estado_pedido,
		nombre_estado
	FROM [QUEMA2].estado_pedido
	IF @@ERROR != 0
	PRINT('SP ESTADO PEDIDO BI FAIL!')
	ELSE
	PRINT('SP ESTADO PEDIDO BI OK!')
END


GO 
CREATE PROCEDURE [QUEMA2].migrar_rango_etario_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].rango_etario_bi(fecha_base, fecha_limite) VALUES(0,25)
	INSERT INTO [QUEMA2].rango_etario_bi(fecha_base, fecha_limite) VALUES(25,35)
	INSERT INTO [QUEMA2].rango_etario_bi(fecha_base, fecha_limite) VALUES(35,55)
	INSERT INTO [QUEMA2].rango_etario_bi(fecha_base, fecha_limite) VALUES(55,75)
	IF @@ERROR != 0
	PRINT('SP RANGO ETARIO BI FAIL!')
	ELSE
	PRINT('SP RANGO ETARIO BI OK!')
END


GO
CREATE PROCEDURE [QUEMA2].migrar_rango_horario_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].rango_horario_bi(hora_desde, hora_hasta) VALUES('8','10')
	INSERT INTO [QUEMA2].rango_horario_bi(hora_desde, hora_hasta) VALUES('10','12')
	INSERT INTO [QUEMA2].rango_horario_bi(hora_desde, hora_hasta) VALUES('12','14')
	INSERT INTO [QUEMA2].rango_horario_bi(hora_desde, hora_hasta) VALUES('14','16')
	INSERT INTO [QUEMA2].rango_horario_bi(hora_desde, hora_hasta) VALUES('16','18')
	INSERT INTO [QUEMA2].rango_horario_bi(hora_desde, hora_hasta) VALUES('20','22')
	INSERT INTO [QUEMA2].rango_horario_bi(hora_desde, hora_hasta) VALUES('22','0')
	IF @@ERROR != 0
	PRINT('SP RANGO HORARIO BI FAIL!')
	ELSE
	PRINT('SP RANGO HORARIO BI OK!')
END
GO

GO
CREATE PROCEDURE [QUEMA2].migrar_tipo_paquete_bi
AS 
BEGIN
    INSERT INTO [QUEMA2].tipo_paquete_bi(tipo_paquete_bi_id,nombre, alto, ancho,largo,peso_maximo, precio_x_paquete)
    SELECT DISTINCT
		id_tipo_paquete,
        nombre,
        alto,
        ancho,
        largo,
        peso_maximo,
        precio_x_paquete
    FROM [QUEMA2].tipo_paquete
    IF @@ERROR != 0
    PRINT('SP TIPO PAQUETE BI FAIL!')
    ELSE
    PRINT('SP TIPO PAQUETE BI OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_tipo_reclamo_bi
AS 
BEGIN
    INSERT INTO [QUEMA2].tipo_reclamo_bi(tipo_reclamo_bi_id,tipo_reclamo)
    SELECT DISTINCT
		id_tipo_reclamo,
        tipo_reclamo
    FROM [QUEMA2].tipo_reclamo
    IF @@ERROR != 0
    PRINT('SP TIPO RECLAMO BI FAIL!')
    ELSE
    PRINT('SP TIPO RECLAMO BI OK!')
END

GO
CREATE PROCEDURE [QUEMA2].migrar_movilidad_bi
AS 
BEGIN
    INSERT INTO [QUEMA2].movilidad_bi(movilidad_bi_id,tipo_movilidad)
    SELECT DISTINCT 
		id_movilidad,
        tipo_movilidad
    FROM [QUEMA2].movilidad
    IF @@ERROR != 0
    PRINT('SP MOVILIDAD BI FAIL!')
    ELSE
    PRINT('SP MOVILIDAD BI OK!')
END


GO
CREATE PROCEDURE [QUEMA2].migrar_tipo_local_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].tipo_local_bi(tipo_local_bi_id ,tipo_local)
	SELECT DISTINCT
		tl.id_tipo_local,
		tl.tipo_local
	FROM QUEMA2.tipo_local tl
	IF @@ERROR != 0
	PRINT('SP TIPO LOCAL BI FAIL!')
	ELSE
	PRINT('SP TIPO LOCAL BI OK!')
END
GO
GO
CREATE PROCEDURE [QUEMA2].migrar_localidad_x_provincia_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].localidad_x_provincia_bi(localidad_bi_id,provincia_bi_id)
	SELECT DISTINCT
		loc.id_localidad,
		loc.id_provincia
	FROM QUEMA2.localidad loc
	IF @@ERROR != 0
	PRINT('SP LOCALIDAD POR PROVINCIA BI FAIL!')
	ELSE
	PRINT('SP LOCALIDAD POR PROVINCIA BI OK!')
END
GO

GO
CREATE PROCEDURE [QUEMA2].migrar_local_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].local_bi(local_bi_id,tipo_local_bi_id,nombre, direccion, descripcion,localidad_x_provincia_bi_id, provincia)
	SELECT DISTINCT
		loc.id_local,
		loc.id_tipo_local,
		loc.nombre,
		loc.direccion,
		loc.descripcion,
		lxp.localidad_x_provincia_bi_id,
		loc.provincia
	FROM QUEMA2.local loc
	JOIN QUEMA2.localidad localidad
	ON localidad.id_localidad = loc.id_localidad
	JOIN QUEMA2.localidad_x_provincia_bi lxp
	ON lxp.localidad_bi_id = localidad.id_localidad
	AND lxp.provincia_bi_id = localidad.id_provincia
	IF @@ERROR != 0
	PRINT('SP LOCAL BI FAIL!')
	ELSE
	PRINT('SP LOCAL BI OK!')
END
GO

GO
CREATE PROCEDURE [QUEMA2].migrar_pedido_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].pedido_bi(pedido_bi_id,estado_pedido_bi_id, id_usuario, local_bi_id,
	 medio_pago_bi_id, fecha_pedido, fecha_entrega, total_productos, total)
	SELECT DISTINCT
		ped.id_pedido,
		ped.id_estado_pedido,
		ped.id_usuario,
		ped.id_local,
		ped.id_medio_pago,
		ped.fecha_pedido,
		ped.fecha_entrega,
		ped.total_productos,
		ped.total
	FROM [QUEMA2].pedido ped
	IF @@ERROR != 0
	PRINT('SP PEDIDO BI FAIL!')
	ELSE
	PRINT('SP PEDIDO BI OK!')
END

GO

GO
CREATE PROCEDURE [QUEMA2].migrar_mensajeria_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].mensajeria_bi(mensajeria_bi_id, id_repartidor, id_usuario, medio_de_pago_bi_id, 
	estado_mensajeria_bi_id, tipo_paquete_bi_id, nro_envio_mensajeria, id_direcciones_mensjaeria, distancia_km,
	valor_asegurado, observaciones, precio_seguro, precio_total, fecha_pedido, fecha_entrega,
	propina, tiempo_estimado_entrega, calificacion)
	SELECT DISTINCT
		mensaj.id_mensajeria,
		mensaj.id_repartidor,
		mensaj.id_usuario,
		mensaj.id_medio_de_pago,
		mensaj.id_estado_mensajeria,
		mensaj.id_tipo_paquete,
		mensaj.nro_envio_mensajeria,
		mensaj.id_direcciones_mensajeria,
		mensaj.distancia_km,
		mensaj.valor_asegurado,
		mensaj.observaciones,
		mensaj.precio_seguro,
		mensaj.precio_total,
		mensaj.fecha_pedido,
		mensaj.fecha_entrega,
		mensaj.propina,
		mensaj.tiempo_estimado_entrega,
		mensaj.calificacion
	FROM [QUEMA2].mensajeria mensaj
	IF @@ERROR != 0
	PRINT('SP MENSAJERIA BI FAIL!')
	ELSE
	PRINT('SP MENSAJERIA BI OK!')
END
GO


GO
CREATE PROCEDURE [QUEMA2].migrar_reclamo_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].reclamo_bi(reclamo_bi_id,tipo_reclamo_bi_id,estado_reclamo_bi_id,id_operador, nro_reclamo
	,descripcion,fecha_solucion, calificacion, solucion, fecha_reclamo, pedido_bi_id)
	SELECT DISTINCT
		id_reclamo,
		id_tipo_reclamo,
		id_estado_reclamo,
		id_operador,
		nro_reclamo,
		descripcion,
		fecha_solucion,
		calificacion,
		solucion,
		fecha,
		id_pedido
	FROM [QUEMA2].reclamo 
	IF @@ERROR != 0
	PRINT('SP RECLAMO BI FAIL!')
	ELSE
	PRINT('SP RECLAMO BI OK!')
END
GO

GO
CREATE PROCEDURE [QUEMA2].migrar_tiempo_bi
AS 
BEGIN
	INSERT INTO [QUEMA2].tiempo_bi(anio, mes)
	(SELECT
		YEAR(fecha_pedido), 
		MONTH(fecha_pedido)
	FROM [QUEMA2].pedido_bi
	GROUP BY YEAR(fecha_pedido), MONTH(fecha_pedido))
	UNION
	(SELECT
		YEAR(fecha_pedido), 
		MONTH(fecha_pedido)
	FROM [QUEMA2].mensajeria_bi
	GROUP BY YEAR(fecha_pedido), MONTH(fecha_pedido))
	IF @@ERROR != 0
	PRINT('SP TIEMPO BI FAIL!')
	ELSE
	PRINT('SP TIEMPO BI OK!')
END
GO

GO
EXEC QUEMA2.migrar_localidad_x_provincia_bi
GO
EXEC QUEMA2.migrar_movilidad_bi
GO
EXEC QUEMA2.migrar_estado_mensajeria_bi
GO
EXEC QUEMA2.migrar_medio_pago_bi
GO
EXEC QUEMA2.migrar_estado_pedido_bi
GO
EXEC QUEMA2.migrar_rango_etario_bi
GO
EXEC QUEMA2.migrar_rango_horario_bi
GO
EXEC QUEMA2.migrar_tipo_local_bi;
GO
EXEC QUEMA2.migrar_local_bi
GO
EXEC QUEMA2.migrar_pedido_bi
GO
EXEC QUEMA2.migrar_tipo_paquete_bi
GO
EXEC QUEMA2.migrar_mensajeria_bi
GO
EXEC QUEMA2.migrar_tipo_reclamo_bi
GO
EXEC QUEMA2.migrar_reclamo_bi
GO
EXEC QUEMA2.migrar_dia_bi
GO
EXEC QUEMA2.migrar_tiempo_bi
GO
-- VISTAS AUXILIARES
	GO
	CREATE VIEW QUEMA2.dia_hora_x_localidad_x_categoria
	AS 
		SELECT
		localidad.localidad_bi_id as Localidad,
		loc.tipo_local_bi_id as TipoLocal,
		MONTH(ped.fecha_pedido) as Mes, 
		YEAR(ped.fecha_pedido) as Anio,
		hdl.hora_apertura as HoraApertura, 
		hdl.hora_cierre as HoraCierre,
		d.dia as Dia,
		COUNT(ped.id_pedido) as CantidadPedidos
	FROM QUEMA2.local_bi loc
	LEFT JOIN QUEMA2.pedido ped
	on ped.id_local = loc.local_bi_id
	JOIN QUEMA2.localidad_x_provincia_bi localidad
	ON localidad.localidad_x_provincia_bi_id = loc.localidad_x_provincia_bi_id
	JOIN QUEMA2.dia d
	ON d.id_dia = DATEPART(dw, convert(date,ped.fecha_pedido))
	JOIN QUEMA2.horario_dia_x_local hdl
	ON hdl.id_local = loc.local_bi_id
	and hdl.id_dia = d.id_dia
	group by localidad.localidad_bi_id, loc.tipo_local_bi_id, MONTH(ped.fecha_pedido), YEAR(ped.fecha_pedido),hdl.hora_apertura, hdl.hora_cierre, d.dia
	GO

		GO
		GO
	CREATE VIEW [QUEMA2].pedidos_por_localidad_por_edad_repartidor_por_mes
	AS
	SELECT
		local.id_localidad as localidad,
		re.fecha_base as edad_base,
		re.fecha_limite as edad_limite,
		MONTH(ped.fecha_pedido) as mes_pedido,
		COUNT(ped.id_pedido) as cantidad_pedidos
	FROM QUEMA2.repartidor repar
	JOIN QUEMA2.envio env
	ON env.id_repartidor = repar.id_repartidor
	JOIN QUEMA2.pedido ped
	ON ped.id_pedido = env.id_pedido
	JOIN QUEMA2.local local
	ON local.id_local = ped.id_local
	join QUEMA2.rango_etario_bi re
	ON DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) <= re.fecha_limite
	and DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) >= re.fecha_base
	GROUP BY local.id_localidad, re.fecha_base,re.fecha_limite, MONTH(ped.fecha_pedido)
	GO


	GO
	CREATE VIEW [QUEMA2].mensajerias_por_localidad_por_edad_repartidor_por_mes
	AS
	SELECT
		dm.id_localidad as localidad,
		re.fecha_base as edad_base,
		re.fecha_limite as edad_limite,
		MONTH(mensaj.fecha_pedido) as mes_pedido,
		COUNT(mensaj.id_mensajeria) as cantidad_mensajerias
	FROM QUEMA2.repartidor repar
	JOIN QUEMA2.mensajeria mensaj
	ON mensaj.id_repartidor = repar.id_repartidor
	JOIN QUEMA2.direcciones_mensajeria dm
	ON dm.id_direcciones_mensajeria = mensaj.id_direcciones_mensajeria 
	join QUEMA2.rango_etario_bi re
	ON DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) <= re.fecha_limite
	and DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) >= re.fecha_base
	GROUP BY dm.id_localidad, re.fecha_base,re.fecha_limite, MONTH(mensaj.fecha_pedido)
	GO

	GO
	CREATE VIEW [QUEMA2].mensajerias_entregadas_por_localidad_por_edad_repartidor_por_mes
	AS
	SELECT
		dm.id_localidad as localidad,
		re.fecha_base as edad_base,
		re.fecha_limite as edad_limite,
		MONTH(mensaj.fecha_pedido) as mes_pedido,
		COUNT(mensaj.id_mensajeria) as cantidad_mensajerias
	FROM QUEMA2.repartidor repar
	JOIN QUEMA2.estado_mensajeria em
	ON em.nombre_estado = 'Estado Mensajeria Entregado'
	JOIN QUEMA2.mensajeria mensaj
	ON mensaj.id_repartidor = repar.id_repartidor
	AND mensaj.id_estado_mensajeria = em.id_estado_mensajeria
	JOIN QUEMA2.direcciones_mensajeria dm
	ON dm.id_direcciones_mensajeria = mensaj.id_direcciones_mensajeria
	join QUEMA2.rango_etario_bi re
	ON DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) <= re.fecha_limite
	and DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) >= re.fecha_base
	GROUP BY dm.id_localidad, re.fecha_base,re.fecha_limite, MONTH(mensaj.fecha_pedido)
	GO

	

	GO
	CREATE VIEW [QUEMA2].pedidos_entregados_por_localidad_por_edad_repartidor_por_mes
	AS
	SELECT
		local.id_localidad as localidad,
		re.fecha_base as edad_base,
		re.fecha_limite as edad_limite,
		MONTH(ped.fecha_pedido) as mes_pedido,
		COUNT(ped.id_pedido) as cantidad_pedidos
	FROM QUEMA2.repartidor repar
	JOIN QUEMA2.envio env
	ON env.id_repartidor = repar.id_repartidor
	JOIN QUEMA2.estado_pedido ep
	ON ep.nombre_estado = 'Estado Mensajeria Entregado'
	JOIN QUEMA2.pedido ped
	ON ped.id_pedido = env.id_pedido
	and ped.id_estado_pedido = ep.id_estado_pedido
	JOIN QUEMA2.local local
	ON local.id_local = ped.id_local
	join QUEMA2.rango_etario_bi re
	ON DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) <= re.fecha_limite
	and DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) >= re.fecha_base
	GROUP BY local.id_localidad, re.fecha_base,re.fecha_limite, MONTH(ped.fecha_pedido)
	GO

-- VISTAS OBLIGATORIAS


	USE [GD1C2023];
	GO
	CREATE VIEW QUEMA2.dia_hora_de_mayor_pedidos_x_localidad_x_categoria
	AS 
		SELECT
		lxp.localidad_bi_id as Localidad,
		loc.tipo_local_bi_id as TipoLocal,
		MONTH(ped.fecha_pedido) as Mes, 
		YEAR(ped.fecha_pedido) as Anio,
		(SELECT TOP 1 
				Dia 
		FROM [QUEMA2].dia_hora_x_localidad_x_categoria 
		where Localidad = lxp.localidad_bi_id
		and TipoLocal = loc.tipo_local_bi_id  
		and Mes = MONTH(ped.fecha_pedido)
		and Anio = YEAR(ped.fecha_pedido) 
		ORDER BY CantidadPedidos DESC) as DiaDeMayorPedido,
		(SELECT TOP 1 
				HoraApertura
		FROM [QUEMA2].dia_hora_x_localidad_x_categoria 
		where Localidad = lxp.localidad_bi_id 
		and TipoLocal = loc.tipo_local_bi_id  
		and Mes = MONTH(ped.fecha_pedido)
		and Anio = YEAR(ped.fecha_pedido) 
		ORDER BY CantidadPedidos DESC) as HoraAperturaConMasPedido,
		(SELECT TOP 1 
				HoraCierre 
		FROM [QUEMA2].dia_hora_x_localidad_x_categoria 
		where Localidad = lxp.localidad_bi_id
		and TipoLocal = loc.tipo_local_bi_id  
		and Mes = MONTH(ped.fecha_pedido)
		and Anio = YEAR(ped.fecha_pedido) 
		ORDER BY CantidadPedidos DESC) as HoraCierreConMasPedido

	FROM QUEMA2.local_bi loc
	LEFT JOIN QUEMA2.pedido ped
	on ped.id_local = loc.local_bi_id
	JOIN QUEMA2.localidad_x_provincia_bi lxp
	ON lxp.localidad_x_provincia_bi_id = loc.localidad_x_provincia_bi_id
	JOIN QUEMA2.dia d
	ON d.id_dia = DATEPART(dw, convert(date,ped.fecha_pedido))
	group by lxp.localidad_bi_id, loc.tipo_local_bi_id, MONTH(ped.fecha_pedido), YEAR(ped.fecha_pedido)
	GO



	CREATE VIEW QUEMA2.monto_no_cobrado_por_pedido_cancelado_x_dia_x_franja_horaria
	AS
	SELECT 
		loc.local_bi_id as Local,
		d.dia as Dia,
		hdl.hora_apertura as HoraApertura,
		hdl.hora_cierre as HoraCierre,
		SUM(ped.total) as MontoTotalNoCobrado
	FROM QUEMA2.pedido_bi ped
	JOIN QUEMA2.estado_pedido ep
	ON ep.id_estado_pedido = ped.pedido_bi_id
	and ep.nombre_estado = 'Estado Mensajeria Cancelado'
	JOIN QUEMA2.dia d
	ON d.id_dia = DATEPART(dw, convert(date,ped.fecha_pedido))
	JOIN QUEMA2.local_bi loc
	ON loc.local_bi_id = ped.local_bi_id
	JOIN QUEMA2.horario_dia_x_local hdl
	ON hdl.id_dia = d.id_dia
	and hdl.id_local = loc.local_bi_id
	GROUP BY loc.local_bi_id, d.dia, hdl.hora_apertura, hdl.hora_cierre
	
	GO



	CREATE VIEW QUEMA2.promedio_mensual_precio_envio_x_localidad
	AS 
	SELECT 
		local.localidad_x_provincia_bi_id,
		((SUM(env.precio_envio))/(COUNT(env.id_envio))) as valorPromedioMensualDeEnvio
	FROM QUEMA2.envio env
	JOIN QUEMA2.pedido_bi ped
	on ped.pedido_bi_id = env.id_pedido
	JOIN QUEMA2.local_bi local
	on local.local_bi_id = ped.local_bi_id
	JOIN QUEMA2.localidad_x_provincia_bi lxp
	on lxp.localidad_x_provincia_bi_id = local.localidad_x_provincia_bi_id
	GROUP BY local.localidad_x_provincia_bi_id
	                                                        
	

	GO
	CREATE VIEW [QUEMA2].desvio_promedio_por_movilidad_x_dia_hora
	AS
	SELECT
		mov.id_movilidad, 
		hdl.id_dia, 
		hdl.hora_apertura, 
		hdl.hora_cierre,
		SUM(DATEDIFF(minute,ped.fecha_pedido,ped.fecha_entrega)) as HoraEnMinutos
	FROM QUEMA2.pedido ped
	JOIN QUEMA2.envio env
	ON env.id_pedido = ped.id_pedido
	JOIN QUEMA2.repartidor rep
	ON rep.id_repartidor = env.id_repartidor
	JOIN QUEMA2.movilidad mov
	ON mov.id_movilidad = rep.id_movilidad
	JOIN QUEMA2.horario_dia_x_local hdl
	ON hdl.id_dia = DATEPART(dw, convert(date,ped.fecha_pedido))
	AND hdl.id_local = ped.id_local
	GROUP BY  mov.id_movilidad, hdl.id_dia, hdl.hora_apertura, hdl.hora_cierre



	GO
	CREATE VIEW [QUEMA2].monto_cupones_x_rango_etario_usuario
	AS
	SELECT 
		re.fecha_base,
		re.fecha_limite,
		MONTH(ped.fecha_pedido) Mes,
		SUM(dxp.monto_descuento) as MontoTotalCupones
	FROM QUEMA2.cupon_descuento_x_pedido dxp
	JOIN QUEMA2.pedido_bi ped
	ON ped.pedido_bi_id = dxp.id_pedido
	JOIN QUEMA2.usuario u
	ON u.id_usuario = ped.id_usuario
	JOIN QUEMA2.rango_etario_bi re
	ON DATEDIFF(YEAR, u.fecha_nacimiento, GETDATE()) <= re.fecha_limite
	AND DATEDIFF(YEAR, u.fecha_nacimiento, GETDATE()) >= re.fecha_base
	GROUP BY re.fecha_base, re.fecha_limite, MONTH(ped.fecha_pedido)



	GO
	CREATE VIEW [QUEMA2].promedio_calificacion_mensual_por_local
	AS
	SELECT
		loc.local_bi_id,
		((SUM(ped.calificacion))/(COUNT(ped.id_pedido))) as Promedio
	FROM QUEMA2.local_bi loc
	JOIN QUEMA2.pedido ped 
	ON ped.id_local = loc.local_bi_id
	GROUP BY loc.local_bi_id
	GO



	GO
	CREATE VIEW [QUEMA2].porcentaje_pedidos_mensaj_x_localidad_x_edad_repartidor
	AS
	SELECT
		local.id_localidad as Localidad,
		re.fecha_base,
		re.fecha_limite,
		MONTH(ped.fecha_pedido) as MesPedido,
		((CONVERT(FLOAT,(SELECT
			cantidad_pedidos
		FROM [QUEMA2].pedidos_entregados_por_localidad_por_edad_repartidor_por_mes
		WHERE mes_pedido = MONTH(ped.fecha_pedido)
		and local.id_localidad = localidad 
		and re.fecha_base = edad_base 
		and re.fecha_limite = edad_limite)))/
	    (SELECT
			cantidad_pedidos
		FROM [QUEMA2].pedidos_por_localidad_por_edad_repartidor_por_mes
		WHERE mes_pedido = MONTH(ped.fecha_pedido)
		and local.id_localidad = localidad 
		and re.fecha_base = edad_base
		and re.fecha_limite = edad_limite)) * 100 as porcentaje_pedidos_entregados,
		((CONVERT(FLOAT,(SELECT
			cantidad_mensajerias
		FROM [QUEMA2].mensajerias_entregadas_por_localidad_por_edad_repartidor_por_mes
		WHERE mes_pedido = MONTH(ped.fecha_pedido)
		and local.id_localidad = localidad 
		and re.fecha_base = edad_base 
		and re.fecha_limite = edad_limite)))/
	    (SELECT
			cantidad_mensajerias
		FROM [QUEMA2].mensajerias_por_localidad_por_edad_repartidor_por_mes
		WHERE mes_pedido = MONTH(ped.fecha_pedido)
		and local.id_localidad = localidad 
		and re.fecha_base = edad_base
		and re.fecha_limite = edad_limite)) * 100 as porcentaje_mensajerias_entregadas 
	FROM QUEMA2.repartidor repar
	JOIN QUEMA2.envio env
	ON env.id_repartidor = repar.id_repartidor
	JOIN QUEMA2.pedido_bi ped
	ON ped.pedido_bi_id = env.id_pedido
	JOIN QUEMA2.local local
	ON local.id_local = ped.pedido_bi_id 
	join QUEMA2.rango_etario_bi re
	ON DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) <= re.fecha_limite
	and DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) >= re.fecha_base
	GROUP BY local.id_localidad, re.fecha_base,re.fecha_limite, MONTH(ped.fecha_pedido)



	GO
	CREATE VIEW [QUEMA2].promedio_mensual_valor_asegurado_x_tipo_paquete
	AS 
	SELECT 
		tp.nombre,
		MONTH(mensaj.fecha_pedido) Mes,
		((SUM(mensaj.valor_asegurado))/COUNT(mensaj.mensajeria_bi_id)) as promedioMensualValorAsegurado
	FROM QUEMA2.mensajeria_bi mensaj
	JOIN QUEMA2.tipo_paquete_bi tp
	on tp.tipo_paquete_bi_id = mensaj.tipo_paquete_bi_id
	GROUP BY tp.nombre,MONTH(mensaj.fecha_pedido)
	GO



	GO
	CREATE VIEW [QUEMA2].cantidad_Reclamos_por_local_por_dia
	AS 
	SELECT
		MONTH(rec.fecha_reclamo) as Mes, 
		loc.nombre as NombreLocal, 
		d.dia as Dia, 
		rh.hora_desde as HoraApertura, 
		rh.hora_hasta as HoraCierre,
		COUNT(rec.reclamo_bi_id) as CantidadReclamos
	FROM QUEMA2.reclamo_bi rec
	JOIN QUEMA2.cupon_reclamo cr
	ON rec.pedido_bi_id = cr.id_reclamo
	JOIN QUEMA2.pedido ped
	ON ped.id_pedido = rec.pedido_bi_id
	JOIN QUEMA2.local_bi loc
	ON loc.local_bi_id = ped.id_local
	JOIN QUEMA2.rango_horario_bi rh
	ON DATENAME(HOUR, rec.fecha_reclamo) <= rh.hora_hasta
	and DATENAME(HOUR, rec.fecha_reclamo) >= rh.hora_desde
	JOIN QUEMA2.dia d
	ON d.id_dia = DATEPART(dw, convert(date,ped.fecha_pedido))
	GROUP BY MONTH(rec.fecha_reclamo), loc.nombre, d.dia, rh.hora_desde, rh.hora_hasta



	GO	
	CREATE VIEW [QUEMA2].promedio_resolucion_reclamo_x_mes_x_rango_etario_operador_x_tipo_reclamo
	AS 
	SELECT 
		MONTH(rec.fecha_reclamo) as Mes,
		re.fecha_base,
		re.fecha_limite,
		tr.tipo_reclamo as TipoReclamo,
		((SUM(DATEDIFF(MINUTE,rec.fecha_reclamo,rec.fecha_solucion)))/(COUNT(rec.reclamo_bi_id))) as minutosPromedioDeResolucion
	FROM QUEMA2.reclamo_bi rec
	JOIN QUEMA2.tipo_reclamo_bi tr
	ON tr.tipo_reclamo_bi_id = rec.tipo_reclamo_bi_id
	JOIN QUEMA2.operador op
	ON op.id_operador = rec.id_operador	
	JOIN QUEMA2.rango_etario_bi re
	ON DATEDIFF(YEAR, op.fecha_nacimiento, GETDATE()) <= re.fecha_limite
	and DATEDIFF(YEAR, op.fecha_nacimiento, GETDATE()) >= re.fecha_base
	GROUP BY re.fecha_base,re.fecha_limite,tr.tipo_reclamo,MONTH(rec.fecha_reclamo)
	
	

	GO
	CREATE VIEW [QUEMA2].monto_mensual_por_cupones_reclamo
	AS
	SELECT
		MONTH(rec.fecha_reclamo) as Mes,
		YEAR(rec.fecha_reclamo) as Anio,
		SUM(cr.monto) as MontoMensual
	FROM QUEMA2.cupon_reclamo cr
	JOIN QUEMA2.reclamo_bi rec
	ON rec.pedido_bi_id = cr.id_reclamo
	GROUP BY MONTH(rec.fecha_reclamo),YEAR(rec.fecha_reclamo)