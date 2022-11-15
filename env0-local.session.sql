INSERT INTO rides (
		id,
		city,
		city,
		vehicle_city,
		rider_id,
		vehicle_id,
		start_address,
		end_address,
		start_time,
		end_time,
		revenue
	  )
	VALUES (
		'id:uuid',
		'city:character varying',
		'city:character varying',
		'vehicle_city:character varying',
		'rider_id:uuid',
		'vehicle_id:uuid',
		'start_address:character varying',
		'end_address:character varying',
		'start_time:timestamp without time zone',
		'end_time:timestamp without time zone',
		revenue:numeric
	  );;