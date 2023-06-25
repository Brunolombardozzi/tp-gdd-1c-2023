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

	DROP FUNCTION QUEMA2.pedidosPorLocalidadPorEdadRepartidorPorMes
GO
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


--CREACION DE TABLAS
GO
-- DROP TABLAS
IF OBJECT_ID ('QUEMA2.rango_etario') IS NOT NULL DROP TABLE QUEMA2.rango_etario;

CREATE TABLE [QUEMA2].[rango_etario] (
  [id_rango_etario] int IDENTITY(1,1),
  [fecha_base] int,
  [fecha_limite] int,
  PRIMARY KEY ([id_rango_etario])
);

GO
CREATE PROCEDURE [QUEMA2].migrar_rango_etario
AS 
BEGIN
	INSERT INTO [QUEMA2].rango_etario(fecha_base, fecha_limite) VALUES(0,25)
	INSERT INTO [QUEMA2].rango_etario(fecha_base, fecha_limite) VALUES(25,35)
	INSERT INTO [QUEMA2].rango_etario(fecha_base, fecha_limite) VALUES(35,55)
	INSERT INTO [QUEMA2].rango_etario(fecha_base, fecha_limite) VALUES(55,75)
	IF @@ERROR != 0
	PRINT('SP RANGO ETARIO FAIL!')
	ELSE
	PRINT('SP RANGO ETARIO OK!')
END
EXEC QUEMA2.migrar_rango_etario

GO

-- VISTAS

	/* 1  Día de la semana y franja horaria con mayor cantidad de pedidos 
	según la localidad y categoría del local, para cada mes de cada año.*/ 
	--TIEMPO EJECUCION: 3 min 40 seg REVISAR MEJORAS
	GO
	CREATE VIEW QUEMA2.dia_hora_x_localidad_x_categoria
	AS 
		SELECT
		localidad.nombre as Localidad,
		loc.id_tipo_local as TipoLocal,
		MONTH(ped.fecha_pedido) as Mes, 
		YEAR(ped.fecha_pedido) as Anio,
		hdl.hora_apertura as HoraApertura, 
		hdl.hora_cierre as HoraCierre,
		d.dia as Dia,
		COUNT(ped.id_pedido) as CantidadPedidos
	FROM QUEMA2.local loc
	LEFT JOIN QUEMA2.pedido ped
	on ped.id_local = loc.id_local
	JOIN QUEMA2.localidad localidad
	ON localidad.id_localidad = loc.id_localidad
	JOIN QUEMA2.dia d
	ON d.id_dia = DATEPART(dw, convert(date,ped.fecha_pedido))
	JOIN QUEMA2.horario_dia_x_local hdl
	ON hdl.id_local = loc.id_local
	and hdl.id_dia = d.id_dia
	group by localidad.nombre, loc.id_tipo_local, MONTH(ped.fecha_pedido), YEAR(ped.fecha_pedido),hdl.hora_apertura, hdl.hora_cierre, d.dia
	GO

	USE [GD1C2023];
	GO
	CREATE VIEW QUEMA2.dia_hora_de_mayor_pedidos_x_localidad_x_categoria
	AS 
		SELECT
		localidad.nombre as Localidad,
		loc.id_tipo_local as TipoLocal,
		MONTH(ped.fecha_pedido) as Mes, 
		YEAR(ped.fecha_pedido) as Anio,
		(SELECT TOP 1 
				Dia 
		FROM [QUEMA2].dia_hora_x_localidad_x_categoria 
		where Localidad = localidad.nombre
		and TipoLocal = loc.id_tipo_local  
		and Mes = MONTH(ped.fecha_pedido)
		and Anio = YEAR(ped.fecha_pedido) 
		ORDER BY CantidadPedidos DESC) as DiaDeMayorPedido,
		(SELECT TOP 1 
				HoraApertura
		FROM [QUEMA2].dia_hora_x_localidad_x_categoria 
		where Localidad = localidad.nombre 
		and TipoLocal = loc.id_tipo_local  
		and Mes = MONTH(ped.fecha_pedido)
		and Anio = YEAR(ped.fecha_pedido) 
		ORDER BY CantidadPedidos DESC) as HoraAperturaConMasPedido,
		(SELECT TOP 1 
				HoraCierre 
		FROM [QUEMA2].dia_hora_x_localidad_x_categoria 
		where Localidad = localidad.nombre
		and TipoLocal = loc.id_tipo_local  
		and Mes = MONTH(ped.fecha_pedido)
		and Anio = YEAR(ped.fecha_pedido) 
		ORDER BY CantidadPedidos DESC) as HoraCierreConMasPedido

	FROM QUEMA2.local loc
	LEFT JOIN QUEMA2.pedido ped
	on ped.id_local = loc.id_local
	JOIN QUEMA2.dia d
	ON d.id_dia = DATEPART(dw, convert(date,ped.fecha_pedido))
	JOIN QUEMA2.localidad localidad
	ON localidad.id_localidad = loc.id_localidad
	group by localidad.nombre, loc.id_tipo_local, MONTH(ped.fecha_pedido), YEAR(ped.fecha_pedido)
	GO


	/* 2 Monto total no cobrado por cada local en función de los pedidos cancelados según el día de la semana y la franja horaria
	 (cuentan como pedidos cancelados tant o los que cancela el usuario como el local). */  
	 --TIEMPO EJECUCION: VUELA
	CREATE VIEW QUEMA2.monto_no_cobrado_por_pedido_cancelado_x_dia_x_franja_horaria
	AS
	SELECT 
		loc.id_local as LocalId,
		d.dia as Dia,
		hdl.hora_apertura as HoraApertura,
		hdl.hora_cierre as HoraCierre,
		SUM(ped.total) as MontoTotalNoCobrado
	FROM QUEMA2.pedido ped
	JOIN QUEMA2.estado_pedido ep
	ON ep.id_estado_pedido = ped.id_estado_pedido
	and ep.nombre_estado = 'Estado Mensajeria Cancelado'
	JOIN QUEMA2.dia d
	ON d.id_dia = DATEPART(dw, convert(date,ped.fecha_pedido))
	JOIN QUEMA2.local loc
	ON loc.id_local = ped.id_local
	JOIN QUEMA2.horario_dia_x_local hdl
	ON hdl.id_dia = d.id_dia
	and hdl.id_local = loc.id_local
	GROUP BY loc.id_local, d.dia, hdl.hora_apertura, hdl.hora_cierre
	
	GO
	/* 3 Valor promedio mensual que tienen los envíos de pedidos en cada localidad. */ 
	 --TIEMPO EJECUCION: VUELA	
	CREATE VIEW QUEMA2.promedio_mensual_precio_envio_x_localidad
	AS 
	SELECT 
		local.id_localidad,
		((SUM(env.precio_envio))/(COUNT(env.id_envio))) as valorPromedioMensualDeEnvio
	FROM QUEMA2.envio env
	JOIN QUEMA2.pedido ped
	on ped.id_pedido = env.id_pedido
	JOIN QUEMA2.local local
	on local.id_local = ped.id_local
	GROUP BY local.id_localidad
	                                                        
	

    /* 4 
	Desvío promedio en tiempo de entrega según el tipo de movilidad, el día de la semana y la franja horaria.
	El desvío debe calcularse en minutos y representa la diferencia entre la fecha/hora en que se realizó el pedido
	 y la fecha/hora que se entregó en comparación con los minutos de tiempo estimados.
	Este indicador debe tener en cuenta todos los envíos, es decir, sumar tanto los envíos de pedidos como los de mensajería.*/

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

	/* 5 Monto total de los cupones utilizados por mes en función del rango etario de los usuarios */ 
	--TIEMPO EJECUCION: VUELA
	GO
	CREATE VIEW [QUEMA2].monto_cupones_x_rango_etario_usuario
	AS
	SELECT 
		re.fecha_base,
		re.fecha_limite,
		MONTH(ped.fecha_pedido) Mes,
		SUM(dxp.monto_descuento) as MontoTotalCupones
	FROM QUEMA2.cupon_descuento_x_pedido dxp
	JOIN QUEMA2.pedido ped
	ON ped.id_pedido = dxp.id_pedido
	JOIN QUEMA2.usuario u
	ON u.id_usuario = ped.id_usuario
	JOIN QUEMA2.rango_etario re
	ON DATEDIFF(YEAR, u.fecha_nacimiento, GETDATE()) <= re.fecha_limite
	AND DATEDIFF(YEAR, u.fecha_nacimiento, GETDATE()) >= re.fecha_base
	GROUP BY re.fecha_base, re.fecha_limite, MONTH(ped.fecha_pedido)
	/* 6 Promedio de calificación mensual por local. */ 	
	--TIEMPO EJECUCION: VUELA

	GO
	CREATE VIEW [QUEMA2].promedio_calificacion_mensual_por_local
	AS
	SELECT
		loc.id_local,
		((SUM(ped.calificacion))/(COUNT(ped.id_pedido))) as Promedio
	FROM QUEMA2.local loc
	JOIN QUEMA2.pedido ped 
	ON ped.id_local = loc.id_local
	GROUP BY loc.id_local
	
	GO

	/* 7 Porcentaje de pedidos y mensajería entregados mensualmente según el rango etario de los repartidores y la localidad.
	Este indicador se debe tener en cuenta y sumar tanto los envíos de pedidos como los de mensajería.
	El porcentaje se calcula en función del total general de pedidos y envíos mensuales entregados */
	--TIEMPO EJECUCION: SE VUELA
	--POR HACER(Revisar si hacer una vista que tenga los datos de la tabla de pedidos/mensajeria entregados y no entregados)

	GO
	CREATE FUNCTION QUEMA2.pedidosPorLocalidadPorEdadRepartidorPorMes(@id_localidad int,@fecha_base int,@fecha_limite int,@mes int)
		RETURNS decimal(18,2)
		AS
			BEGIN	
				DECLARE @cantPedidos decimal(18,2) = 0.00;	
				SELECT
					@cantPedidos = cantidad_pedidos
				FROM pedidos_por_localidad_por_edad_repartidor_por_mes
				WHERE mes_pedido = @mes and @id_localidad = localidad and @fecha_base = edad_base and @fecha_limite = edad_limite
				RETURN @cantPedidos;
			END
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
	join QUEMA2.rango_etario re
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
	join QUEMA2.rango_etario re
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
	join QUEMA2.rango_etario re
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
	join QUEMA2.rango_etario re
	ON DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) <= re.fecha_limite
	and DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) >= re.fecha_base
	GROUP BY local.id_localidad, re.fecha_base,re.fecha_limite, MONTH(ped.fecha_pedido)
	GO
	


	GO
	CREATE VIEW [QUEMA2].porcentaje_pedidos_mensaj_x_localidad_x_edad_repartidor
	AS
	SELECT
		local.id_localidad as Localidad,
		re.fecha_base,
		re.fecha_limite,
		MONTH(ped.fecha_pedido) as MesPedido,
/*		QUEMA2.pedidosPorLocalidadPorEdadRepartidorPorMes(loc.id_localidad, re.fecha_base, re.fecha_limite, MONTH(ped.fecha_pedido))*/
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
	JOIN QUEMA2.pedido ped
	ON ped.id_pedido = env.id_pedido
	JOIN QUEMA2.local local
	ON local.id_local = ped.id_local 
	join QUEMA2.rango_etario re
	ON DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) <= re.fecha_limite
	and DATEDIFF(YEAR, repar.fecha_nacimiento, GETDATE()) >= re.fecha_base
	GROUP BY local.id_localidad, re.fecha_base,re.fecha_limite, MONTH(ped.fecha_pedido)

	/* 8 Promedio mensual del valor asegurado (valor declarado por el usuario) de los paquetes enviados 
	a través del servicio de mensajería en función del tipo de paquete. */
	--TIEMPO EJECUCION: VUELA

	GO
	CREATE VIEW [QUEMA2].promedio_mensual_valor_asegurado_x_tipo_paquete
	AS 
	SELECT 
		tp.nombre,
		MONTH(mensaj.fecha_pedido) Mes,
		((SUM(mensaj.valor_asegurado))/COUNT(mensaj.id_mensajeria)) as promedioMensualValorAsegurado
	FROM QUEMA2.mensajeria mensaj
	JOIN QUEMA2.tipo_paquete tp
	on tp.id_tipo_paquete = mensaj.id_tipo_paquete
	GROUP BY tp.nombre,MONTH(mensaj.fecha_pedido)
	
	GO
	/* 9 Cantidad de reclamos mensuales recibidos por cada local en función del día de la semana y rango horario. */
	--TIEMPO EJECUCION: VUELA 
	--TODO : VERIFICAR EL RANGO HORARIO.

	GO
	CREATE VIEW [QUEMA2].cantidad_Reclamos_por_local_por_dia
	AS 
	SELECT
		MONTH(rec.fecha) as Mes, 
		loc.nombre as NombreLocal, 
		d.dia as Dia, 
		hdl.hora_apertura as HoraApertura, 
		hdl.hora_cierre as HoraCierre,
		COUNT(rec.id_reclamo) as CantidadReclamos
	FROM QUEMA2.reclamo rec
	JOIN QUEMA2.cupon_reclamo cr
	ON rec.id_pedido = cr.id_reclamo
	JOIN QUEMA2.pedido ped
	ON ped.id_pedido = rec.id_pedido
	JOIN QUEMA2.local loc
	ON loc.id_local = ped.id_local
	JOIN QUEMA2.horario_dia_x_local hdl
	ON hdl.id_dia = DATEPART(dw, convert(date,ped.fecha_pedido))
	and hdl.id_local = loc.id_local
	JOIN QUEMA2.dia d
	ON d.id_dia = hdl.id_dia
	GROUP BY MONTH(rec.fecha), loc.nombre, d.dia, hdl.hora_apertura, hdl.hora_cierre 

	/* 10
	Tiempo promedio de resolución de reclamos mensual según cada tipo de reclamo 
	y rango etario de los operadores.
	El tiempo de resolución debe calcularse en minutos y representa la diferencia entre la fecha/hora en que se realizó el reclamo 
	y la fecha/hora que se resolvió.  */
	GO	
	CREATE VIEW [QUEMA2].promedio_resolucion_reclamo_x_mes_x_rango_etario_operador_x_tipo_reclamo
	AS 
	SELECT 
		MONTH(rec.fecha) as Mes,
		re.fecha_base,
		re.fecha_limite,
		tr.tipo_reclamo as TipoReclamo,
		((SUM(DATEDIFF(MINUTE,rec.fecha,rec.fecha_solucion)))/(COUNT(rec.id_reclamo))) as minutosPromedioDeResolucion
	FROM QUEMA2.reclamo rec
	JOIN QUEMA2.tipo_reclamo tr
	ON tr.id_tipo_reclamo = rec.id_tipo_reclamo
	JOIN QUEMA2.operador op
	ON op.id_operador = rec.id_operador	join QUEMA2.rango_etario re
	ON DATEDIFF(YEAR, op.fecha_nacimiento, GETDATE()) <= re.fecha_limite
	and DATEDIFF(YEAR, op.fecha_nacimiento, GETDATE()) >= re.fecha_base
	GROUP BY re.fecha_base,re.fecha_limite,tr.tipo_reclamo,MONTH(rec.fecha)
	
	
	/* 11 Monto mensual generado en cupones a partir de reclamos. */
	GO
	CREATE VIEW [QUEMA2].monto_mensual_por_cupones_reclamo
	AS
	SELECT
		MONTH(rec.fecha) as Mes,
		YEAR(rec.fecha) as Anio,
		SUM(cr.monto) as MontoMensual
	FROM QUEMA2.cupon_reclamo cr
	JOIN QUEMA2.reclamo rec
	ON rec.id_pedido = cr.id_reclamo
	GROUP BY MONTH(rec.fecha),YEAR(rec.fecha)