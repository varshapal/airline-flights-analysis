# Airline Flight Analysis (SQL + Power BI)
This project analyzes U.S. airline flight data to identify performance trends, delays, cancellations, and on-time performance metrics. Using SQL for data analysis and Power BI for visualization, it delivers actionable insights for airline operations improvement.
# Business Problems
- Identify top reasons for delay and cancellations
- Find high performing airlines and peak seasons
- provide recommendations to improve efficiency

# Dataset
Files: 3 csv files - airports.csv, airlines.csv, flights.csv
Rows: 5.79M
Columns: year, month, day, day_of_week, airline, flight_number, tail_number, origin_airport, destination_airport, scheduled_departure, departure_time, departure_delay, taxi_out, wheels_off, scheduled_time, elapsed_time, air_time, distance, wheels_on, taxi_in, scheduled_arrival, arrival_time, arrival_delay, diverted, cancellation, cancellation_reason, air_system_delay, security_delay, airline_delay, late_aircraft_delay, weather_delay 

# Tools & Technologies
- SQL: Data Cleaning, aggregation, and KPI Calculation
- Power BI: Data Modeling and visualization

# Data Analysis Process
- Data Cleaning: Remove null values, corrected data types
- Data Modeling: Create relationship in Power BI between fact and dimension tables
- KPI Calculation: Using SQL Queries and DAX Measures
- Visualization: Build Interactive dasboard for insights

# Key Insights
- The cancellation rate is **1.54%**, with ORD airport responsible for **9%** of all cancellations, mainly due to winter weather in **February**.
- On-Time Arrival rate is **82%**, with **Southwest Airlines Co. (WN)** performing best, especially in **October**.
- **Spirit Airlines (NK)** had the longest average departure delays. Average departure delay is **9.37mins**

## Dashboard
<img width="1151" height="662" alt="Screenshot 2025-08-15 211556" src="https://github.com/user-attachments/assets/0795c68c-9c0c-46ef-bdd6-d9cb22085d13" />
