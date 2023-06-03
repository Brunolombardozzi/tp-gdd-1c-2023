USE [GD1C2023];

GO
	IF EXISTS(select * FROM sys.views where name = 'dia_hora_de_mayor_pedidos_x_localidad_x_categoria')
	DROP VIEW [QUEMA2].dia_hora_de_mayor_pedidos_x_localidad_x_categoria;
	
	IF EXISTS(select * FROM sys.views where name = 'promedio_resolucion_reclamo_x_mes_x_rango_etario_operador_x_tipo_reclamo')
	DROP VIEW [QUEMA2].promedio_resolucion_reclamo_x_mes_x_rango_etario_operador_x_tipo_reclamo;
	
	IF EXISTS(select * FROM sys.views where name = 'promedio_mensual_valor_asegurado_x_tipo_paquete')
	DROP VIEW [QUEMA2].promedio_mensual_valor_asegurado_x_tipo_paquete;
	
	IF EXISTS(select * FROM sys.views where name = 'promedio_mensual_precio_envio_x_localidad')
	DROP VIEW [QUEMA2].promedio_mensual_precio_envio_x_localidad;
	
	IF EXISTS(select * FROM sys.views where name = 'promedio_calificacion_mensual_por_local')
	DROP VIEW [QUEMA2].promedio_calificacion_mensual_por_local;

	IF EXISTS(select * FROM sys.views where name = 'monto_no_cobrado_por_pedido_cancelado_x_dia_x_franja_horaria')
	DROP VIEW [QUEMA2].monto_no_cobrado_por_pedido_cancelado_x_dia_x_franja_horaria;
	
GO
ALTER FUNCTION QUEMA2.getDataMayoresPedidos(@localidad nvarchar(255),@mes int,@id_tipo_local int,
	@anio int, @tipoRetorno int)  
	RETURNS nvarchar(50)
		AS 
		BEGIN
			 DECLARE @nombreDia nvarchar(50) = '';
			 DECLARE @horaCierre decimal(18,2) = 0.00;
			 DECLARE @horaApertura decimal(18,2) = 0.00;

			SELECT TOP 1	
				@nombreDia = di.dia,
				@horaCierre = hdl.hora_cierre,
				@horaApertura = hdl.hora_apertura
			FROM QUEMA2.horario_dia_x_local hdl
			JOIN QUEMA2.dia di
			ON di.id_dia = hdl.id_dia
			JOIN QUEMA2.local loc
			ON loc.id_local = hdl.id_local
			and loc.localidad = @localidad
			and loc.id_tipo_local = @id_tipo_local
			JOIN QUEMA2.pedido p
			on p.id_local = loc.id_local
			and YEAR(p.fecha_pedido) = @anio
			and MONTH(p.fecha_pedido) = @mes
			group by di.dia,hdl.hora_apertura,hdl.hora_cierre, p.id_pedido
			order by count(p.id_pedido) DESC

			if(@tipoRetorno = 1)
			BEGIN 
			 RETURN @nombreDia; 
			END
			ELSE 
			if(@tipoRetorno = 2)
			BEGIN 
			 RETURN @horaCierre; 
			END
			ELSE 		
			if(@tipoRetorno = 3)
			BEGIN 
			 RETURN @horaApertura; 
			END

			RETURN NULL;
		END
GO
-- VISTAS

	/* 1  Día de la semana y franja horaria con mayor cantidad de pedidos 
	según la localidad y categoría del local, para cada mes de cada año.*/
	GO
	CREATE VIEW QUEMA2.dia_hora_de_mayor_pedidos_x_localidad_x_categoria
	AS 
		SELECT
		loc.localidad as Localidad,
		loc.id_tipo_local as TipoLocal,
		MONTH(ped.fecha_pedido) as Mes,
		YEAR(ped.fecha_pedido) as Anio,
		QUEMA2.getDataMayoresPedidos(loc.localidad,MONTH(ped.fecha_pedido),loc.id_tipo_local,YEAR(ped.fecha_pedido),1) as Dia
	FROM QUEMA2.local loc
	LEFT JOIN QUEMA2.pedido ped
	on ped.id_local = loc.id_local
	JOIN QUEMA2.dia d
	ON d.id_dia = DATEPART(dw, convert(date,ped.fecha_pedido))
	group by loc.localidad, loc.id_tipo_local, MONTH(ped.fecha_pedido), YEAR(ped.fecha_pedido)
	
	
	GO

	/* 2
	Monto total no cobrado por cada local en función de los pedidos
	cancelados según el día de la semana y la franja horaria (cuentan como
	pedidos cancelados tanto los que cancela el usuario como el local).*/
	
	
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
	--3 Valor promedio mensual que tienen los envíos de pedidos en cada localidad.
		CREATE VIEW QUEMA2.promedio_mensual_precio_envio_x_localidad
	AS 	SELECT 		loc.nombre,		((SUM(env.precio_envio))/(COUNT(env.id_envio))) as valorPromedioMensualDeEnvio	FROM QUEMA2.envio env	JOIN QUEMA2.pedido ped	on ped.id_pedido = env.id_pedido	JOIN QUEMA2.local local	on local.id_local = ped.id_local	JOIN QUEMA2.localidad loc	on loc.nombre = local.localidad	GROUP BY loc.nombre	                                                        	
    /* 4
	Desvío promedio en tiempo de entrega según el tipo de movilidad, el día
	de la semana y la franja horaria.
	El desvío debe calcularse en minutos y representa la diferencia entre la
	fecha/hora en que se realizó el pedido y la fecha/hora que se entregó en
	comparación con los minutos de tiempo estimados.
	Este indicador debe tener en cuenta todos los envíos, es decir, sumar tanto
	los envíos de pedidos como los de mensajería.
	*/

	/*5
	Monto total de los cupones utilizados por mes en función del rango etario
	de los usuarios
	*/

	/* 6
	Promedio de calificación mensual por local.
	*/
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

	/* 7
	Porcentaje de pedidos y mensajería entregados mensualmente según el
	rango etario de los repartidores y la localidad.
	Este indicador se debe tener en cuenta y sumar tanto los envíos de pedidos
	como los de mensajería.
	El porcentaje se calcula en función del total general de pedidos y envíos
	mensuales entregados
	*/


	/* 8
	Promedio mensual del valor asegurado (valor declarado por el usuario) de los paquetes enviados 	 a través del servicio de mensajería en función del tipo de paquete.
	*/
	GO
	CREATE VIEW [QUEMA2].promedio_mensual_valor_asegurado_x_tipo_paquete
	AS 	SELECT 		tp.nombre,		MONTH(mensaj.fecha_pedido) Mes,		((SUM(mensaj.valor_asegurado))/COUNT(mensaj.id_mensajeria)) as promedioMensualValorAsegurado	FROM QUEMA2.mensajeria mensaj	JOIN QUEMA2.tipo_paquete tp	on tp.id_tipo_paquete = mensaj.id_tipo_paquete	GROUP BY tp.nombre,MONTH(mensaj.fecha_pedido)
	
	GO
	/* 9
	Cantidad de reclamos mensuales recibidos por cada local en función del
	día de la semana y rango horario.
	*/


	/* 10
	Tiempo promedio de resolución de reclamos mensual según cada tipo de
	reclamo y rango etario de los operadores.
	El tiempo de resolución debe calcularse en minutos y representa la
	diferencia entre la fecha/hora en que se realizó el reclamo y la fecha/hora
	que se resolvió.
	*/

	GO	
	CREATE VIEW [QUEMA2].promedio_resolucion_reclamo_x_mes_x_rango_etario_operador_x_tipo_reclamo
	AS 
	SELECT 
		MONTH(rec.fecha) Mes,
		DATEDIFF(YEAR, op.fecha_nacimiento, GETDATE()) as EdadOperador,
		tr.tipo_reclamo,
		((SUM(DATEDIFF(MINUTE,rec.fecha,rec.fecha_solucion)))/(COUNT(rec.id_reclamo))) as minutosPromedioDeResolucion
	FROM QUEMA2.reclamo rec
	JOIN QUEMA2.tipo_reclamo tr
	ON tr.id_tipo_reclamo = rec.id_tipo_reclamo
	JOIN QUEMA2.operador op
	ON op.id_operador = rec.id_operador
	GROUP BY DATEDIFF(YEAR, op.fecha_nacimiento, GETDATE()),tr.tipo_reclamo,MONTH(rec.fecha)
	
	
	/* 11
	Monto mensual generado en cupones a partir de reclamos.
	*/
 