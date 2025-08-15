--Create Table

CREATE TABLE airlines (
	IATA_CODE TEXT,
	AIRLINE TEXT
)

CREATE TABLE airports (
	IATA_CODE TEXT,
	AIRPORT TEXT,
	CITY TEXT,
	STATE TEXT,
	COUNTRY TEXT,
	LATITUDE DOUBLE PRECISION,
	LONGITUDE DOUBLE PRECISION
)

CREATE TABLE flights (
	YEAR INT,
	MONTH INT,
	DAY INT,
	DAY_OF_WEEK INT,
	AIRLINE VARCHAR(50),
	FLIGHT_NUMBER INT,
	TAIL_NUMBER VARCHAR(50),
	ORIGIN_AIRPORT VARCHAR(50),
	DESTINATION_AIRPORT VARCHAR(50),
	SCHEDULED_DEPARTURE INT,
	DEPARTURE_TIME INT,
	DEPARTURE_DELAY INT,
	TAXI_OUT INT,
	WHEELS_OFF INT,
	SCHEDULED_TIME INT,
	ELAPSED_TIME INT,
	AIR_TIME INT,
	DISTANCE INT,
	WHEELS_ON INT,
	TAXI_IN INT,
	SCHEDULED_ARRIVAL INT,
	ARRIVAL_TIME INT,
	ARRIVAL_DELAY INT,
	DIVERTED INT,
	CANCELLED INT,
	CANCELLATION_REASON VARCHAR(50),
	AIR_SYSTEM_DELAY INT,
	SECURITY_DELAY INT,
	AIRLINE_DELAY INT,
	LATE_AIRCRAFT_DELAY INT,
	WEATHER_DELAY INT
)

-- Check the table records

SELECT * FROM airlines;
SELECT * FROM airports;
SELECT * FROM flights LIMIT 20;


-------------Data Cleaning----------------

-- check null/missing values

SELECT COUNT(*) FROM flights
WHERE airline_delay IS NULL;

-- Fill the missing value

SELECT * FROM flights LIMIT 20;

UPDATE flights
SET cancellation_reason = 'N'
WHERE cancellation_reason IS NULL;


UPDATE flights
SET air_system_delay = 0
WHERE air_system_delay IS NULL;

UPDATE flights
SET security_delay = 0
WHERE security_delay IS NULL;

UPDATE flights
SET airline_delay = 0
WHERE airline_delay IS NULL;

UPDATE flights
SET late_aircraft_delay = 0
WHERE late_aircraft_delay IS NULL;

UPDATE flights
SET weather_delay = 0
WHERE weather_delay IS NULL;
 

--Create new column scheduled_departure_ts

ALTER TABLE flights 
ADD COLUMN scheduled_departure_ts TIMESTAMP;

UPDATE flights
SET scheduled_departure_ts = 
	TO_TIMESTAMP(
		CONCAT(
			year, '-',
			LPAD(month::TEXT, 2, '0'), '-',
			LPAD(day::TEXT, 2, '0'), ' ',
			LPAD((scheduled_departure / 100)::TEXT, 2, '0'), ':',
			LPAD((scheduled_departure % 100)::TEXT, 2, '0')
		),
		'YYYY-MM-DD HH24:MI'
	);
	

----Create new column departure_time_ts

ALTER TABLE flights 
ADD COLUMN departure_time_ts TIMESTAMP;

UPDATE flights
SET departure_time_ts = 
	TO_TIMESTAMP(
		CONCAT(
			year, '-',
			LPAD(month::TEXT, 2, '0'), '-',
			LPAD(day::TEXT, 2, '0'), ' ',
			LPAD((departure_time / 100)::TEXT, 2, '0'), ':',
			LPAD((departure_time % 100)::TEXT, 2, '0')
		),
		'YYYY-MM-DD HH24:MI'
	)
WHERE departure_time IS NOT NULL AND (departure_time % 100) < 60 AND (departure_time / 100) < 24;


----Create new column scheduled_arrival_ts
ALTER TABLE flights 
ADD COLUMN scheduled_arrival_ts TIMESTAMP;

UPDATE flights
SET scheduled_arrival_ts = 
	TO_TIMESTAMP(
		CONCAT(
			year, '-',
			LPAD(month::TEXT, 2, '0'), '-',
			LPAD(day::TEXT, 2, '0'), ' ',
			LPAD((scheduled_arrival / 100)::TEXT, 2, '0'), ':',
			LPAD((scheduled_arrival % 100)::TEXT, 2, '0')
		),
		'YYYY-MM-DD HH24:MI'
	)
WHERE scheduled_arrival IS NOT NULL AND (scheduled_arrival % 100) < 60 AND (scheduled_arrival / 100) < 24;


----Create new column arrival_time_ts
ALTER TABLE flights 
ADD COLUMN arrival_time_ts TIMESTAMP;

UPDATE flights
SET arrival_time_ts = 
	TO_TIMESTAMP(
		CONCAT(
			year, '-',
			LPAD(month::TEXT, 2, '0'), '-',
			LPAD(day::TEXT, 2, '0'), ' ',
			LPAD((arrival_time / 100)::TEXT, 2, '0'), ':',
			LPAD((arrival_time % 100)::TEXT, 2, '0')
		),
		'YYYY-MM-DD HH24:MI'
	)
WHERE arrival_time IS NOT NULL AND (arrival_time % 100) < 60 AND (arrival_time / 100) < 24;

-- create new column departure_delay_time
ALTER TABLE flights
ADD COLUMN departure_delay_time TEXT;

UPDATE flights
SET departure_delay_time = CASE
	WHEN departure_delay IS NULL THEN NULL
	WHEN departure_delay < 0 THEN 
	'-' || TO_CHAR(ABS(departure_delay) / 60, 'FM00') || ':' || TO_CHAR(ABS(departure_delay) % 60, 'FM00')
	ELSE
	TO_CHAR(departure_delay / 60, 'FM00') || ':' || TO_CHAR(departure_delay % 60, 'FM00')
	END;



--Create new column cancellation_reason_desc

ALTER TABLE flights 
ADD COLUMN cancellation_reason_desc TEXT;

UPDATE flights
SET cancellation_reason_desc = 
	CASE cancellation_reason
		WHEN 'A' THEN 'Airline/Carrier'
		WHEN 'B' THEN 'Weather'
		WHEN 'C' THEN 'National Air System'
		WHEN 'D' THEN 'Security'
		ELSE 'Not Cancelled'
	END;


-- create flight_date column

ALTER TABLE flights
ADD COLUMN flight_date DATE;

UPDATE flights
SET flight_date = TO_DATE(
	CONCAT(year, '-', LPAD(month::TEXT, 2, '0'), '-', LPAD(day::TEXT, 2, '0')),
	'YYYY-MM-DD'
);





---------Exploratory Data Analysis------------------

--1. Count total number of flights

SELECT COUNT(*) AS total_flights FROM flights;


--2. Count total  cancelled flights and flights cancelled by reasons

SELECT 
	COUNT(*) FILTER(WHERE cancelled = 1) AS total_cancelled_flights,
	COUNT(*) FILTER(WHERE cancellation_reason_desc = 'Airline/Carrier') AS flight_cancelled_by_carrier,
	COUNT(*) FILTER(WHERE cancellation_reason_desc = 'Weather') AS flight_cancelled_by_weather,
	COUNT(*) FILTER(WHERE cancellation_reason_desc = 'National Air System') AS flight_cancelled_by_air_system,
	COUNT(*) FILTER(WHERE cancellation_reason_desc = 'Security') AS flight_cancelled_by_security
FROM flights;


--3. Count total flight diversions

SELECT COUNT(*) AS total_flight_diverted 
FROM flights
WHERE diverted = 1;



--4. Departure Delay (min, max)
SELECT 
	MIN(departure_delay) AS min_departure_delay,
	MAX(departure_delay) AS max_departure_delay
FROM flights
WHERE departure_delay IS NOT NULL;

-- OR 
SELECT
  TO_CHAR(INTERVAL '1 minute' * MIN(departure_delay), 'HH24:MI') AS min_departure_delay_time,
  TO_CHAR(INTERVAL '1 minute' * MAX(departure_delay), 'HH24:MI') AS max_departure_delay_time
FROM flights
WHERE departure_delay IS NOT NULL;

--5. Arrival Delay (min, max)
SELECT 
	MIN(arrival_delay) AS min_arrival_delay,
	MAX(arrival_delay) AS max_arrival_delay
FROM flights
WHERE arrival_delay IS NOT NULL;

OR

SELECT
  TO_CHAR(INTERVAL '1 minute' * MIN(arrival_delay), 'HH24:MI') AS min_arrival_delay_time,
  TO_CHAR(INTERVAL '1 minute' * MAX(arrival_delay), 'HH24:MI') AS max_arrival_delay_time
FROM flights
WHERE arrival_delay IS NOT NULL;





-----KPI-----

--6 Percentage of flights that arriving with in 15 mins of the schedule

SELECT COUNT(*) AS total_flights,
	COUNT(*) FILTER(WHERE arrival_delay <=15) AS on_time_flights,
	ROUND( 100 * COUNT(*) FILTER(WHERE arrival_delay <=15) / COUNT(*), 2) AS percentage_ontime_flight
FROM flights;


--7 Average arrival delay

SELECT ROUND(AVG(arrival_delay), 2) AS avg_arrival_delay
FROM flights
WHERE arrival_delay IS NOT NULL;

--8 Average departure delay

SELECT ROUND(AVG(departure_delay), 2) AS avg_departure_delay
FROM flights
WHERE departure_delay IS NOT NULL;

--9 Cnacellation Rate (%)

SELECT COUNT(*) FILTER(WHERE cancelled = 1) AS cancelled_flight,
	COUNT(*) AS total_flight,
	ROUND(100 * COUNT(*) FILTER(WHERE cancelled = 1) / COUNT(*), 2) AS cancellation_rate
FROM flights;

--10 Delay share percent
SELECT 	COUNT(*) AS total_flight,
		ROUND( 100.0 * COUNT(*) FILTER(WHERE weather_delay > 0) / COUNT(*), 2) AS weather_delay_percent,
		ROUND( 100.0 * COUNT(*) FILTER(WHERE security_delay > 0) / COUNT(*), 2) AS security_delay_percent,
		ROUND( 100.0 * COUNT(*) FILTER(WHERE air_system_delay > 0) / COUNT(*), 2) AS air_system_delay_percent,
		ROUND( 100.0 * COUNT(*) FILTER(WHERE airline_delay > 0) / COUNT(*), 2) AS airline_delay_percent,
		ROUND( 100.0 * COUNT(*) FILTER(WHERE late_aircraft_delay > 0) / COUNT(*), 2) AS late_aircraft_delay_percent
FROM flights;




--11 Total Number of flights, total cancellation flights, and total diverted flights by each airlines
SELECT 	a.airline, 
		COUNT(f.flight_number) AS number_of_flights, 
		COUNT(f.cancelled) FILTER(WHERE f.cancelled = 1) AS flights_cancelled,
		COUNT(f.diverted) FILTER(WHERE f.diverted = 1) AS diverted_flights
FROM airlines AS a
JOIN flights AS f
ON a.iata_code = f.airline
GROUP BY a.airline
ORDER BY number_of_flights DESC
LIMIT 5;

--11 Total Number of flights, total cancellation flights, and total diverted flights by each airports
SELECT 	a.airport, 
		COUNT(f.flight_number) AS number_of_flights,
		COUNT(f.cancelled) FILTER(WHERE f.cancelled = 1) AS cancelled_flights,
		COUNT(f.diverted) FILTER(WHERE f.diverted = 1) AS diverted_flights
FROM airports AS a
JOIN flights AS f
ON a.iata_code = f.origin_airport
GROUP BY a.airport
ORDER BY number_of_flights DESC
LIMIT 5;


--12 Number of flights, number of cancelled flights, number of diverted flights in each month.
SELECT 	month, 
		COUNT(flight_number) AS total_flights, 
		COUNT(cancelled) FILTER(WHERE cancelled = 1) AS cancelled_flights,
		COUNT(diverted) FILTER(WHERE diverted = 1) AS diverted_flights
FROM flights
GROUP BY month
ORDER BY month
LIMIT 5;


--13 Flight cancellation rate, which airport cause more cancellation, which weather cause more cancellation
SELECT 
	ROUND(100.0* SUM(CASE WHEN cancelled = 1 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS cancellation_rate
FROM flights;

SELECT 	origin_airport,
		COUNT(*) cancelled_flights,
		ROUND(100.0 * COUNT(*)/ (SELECT COUNT(*) FROM flights WHERE cancelled = 1), 2) share_cancellation_pct
FROM flights
WHERE cancelled = 1
GROUP BY origin_airport
ORDER BY share_cancellation_pct DESC;

SELECT 
    cancellation_reason, 
    COUNT(*) AS CancelledFlights
FROM flights
WHERE Cancelled = 1
GROUP BY cancellation_reason
ORDER BY CancelledFlights DESC;

--14 On-time arrival maximum by which airline 

SELECT 	airline,
		COUNT(*) total_flights,
		ROUND(100.0 * COUNT(*)/ (SELECT COUNT(*) FROM flights WHERE arrival_delay <= 15), 2) shareonlinepct
FROM flights
WHERE arrival_delay <=15
GROUP BY airline
ORDER BY shareonlinepct DESC;

--15 Diversion rate, which airport has maxmum diversion rate, which airline has highest diversion rate

SELECT 
	ROUND(100.0* SUM(CASE WHEN diverted = 1 THEN 1 ELSE 0 END)/ COUNT(*), 2) AS diversion_rate
FROM flights;

SELECT 	origin_airport,
		COUNT(*) total_flights,
		ROUND(100.0 * COUNT(*)/ (SELECT COUNT(*) FROM flights WHERE diverted = 1), 2) shareonlinepct
FROM flights
WHERE diverted = 1
GROUP BY origin_airport
ORDER BY shareonlinepct DESC;

SELECT 	airline,
		COUNT(*) total_flights,
		ROUND(100.0 * COUNT(*)/ (SELECT COUNT(*) FROM flights WHERE diverted = 1), 2) shareonlinepct
FROM flights
WHERE diverted = 1
GROUP BY airline
ORDER BY shareonlinepct DESC;







		

