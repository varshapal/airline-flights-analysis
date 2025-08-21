# Airline Flight Analysis (SQL + Power BI)
This project analyzes U.S. airline flight data to identify performance trends, delays, cancellations, and on-time performance metrics. Using SQL for data analysis and Power BI for visualization, it delivers actionable insights for airline operations improvement.
# Business Problems
- Identify top reasons for delay and cancellations
- Find high performing airlines and peak seasons
- provide recommendations to improve efficiency

# Dataset
- Source: https://www.kaggle.com/datasets/usdot/flight-delays
- Files: 3 csv files - airports.csv, airlines.csv, flights.csv
- Rows: 5.33M
- Columns: year, month, day, day_of_week, airline, flight_number, tail_number, origin_airport, destination_airport, scheduled_departure, departure_time, departure_delay, taxi_out, wheels_off, scheduled_time, elapsed_time, air_time, distance, wheels_on, taxi_in, scheduled_arrival, arrival_time, arrival_delay, diverted, cancellation, cancellation_reason, air_system_delay, security_delay, airline_delay, late_aircraft_delay, weather_delay 

# Tools & Technologies
- SQL: Data Cleaning, aggregation, and KPI Calculation
- Power BI: Data Modeling and visualization

# Data Analysis Process
- Data Cleaning: Remove null values, corrected data types
- Data Modeling: Create relationship in Power BI between fact and dimension tables
- KPI Calculation: Using SQL Queries and DAX Measures
- Visualization: Build Interactive dasboard for insights

# Key Insights
- The cancellation rate is **1.64%**, with ORD airport responsible for **9%** of all cancellations, mainly due to winter weather in **February**.
- On-Time Arrival rate is **82%**, with **Southwest Airlines Co. (WN)** performing best, especially in **October**.
- **Spirit Airlines (NK)** had the longest average departure delays. Average departure delay is **9.77mins**

## Dashboard
<img width="1309" height="737" alt="Screenshot 2025-08-20 170330" src="https://github.com/user-attachments/assets/bf87a548-1189-451a-aeb2-e8fe62c962e1" />
