-- 1. Total Revenue

SELECT CONCAT(ROUND(SUM(revenue_realized)  / 1000000, 2),'M') AS total_revenue_in_Million FROM fact_booking;

-- 6. Trend Analysis (Monthly Revenue, Booking)

SELECT booking_month, CONCAT(round(SUM(revenue_realized)/1000000,2),'M') AS monthly_revenue_in_Million, COUNT(booking_id) AS monthly_bookings
FROM fact_booking
GROUP BY booking_month
ORDER BY booking_month;

-- 7. Weekday & Weekend Revenue and Booking

SELECT d.day_type,CONCAT(round(SUM(b.revenue_realized)/1000000,2),'M') AS total_revenue_in_million, COUNT(b.booking_id) AS total_bookings
FROM fact_booking b
JOIN dim_date d ON b.check_in_date = d.date
GROUP BY d.day_type;

-- 8. Revenue by State & Hotel

SELECT h.city, h.property_name, CONCAT(round(SUM(b.revenue_realized)/1000000,2),'M') AS total_revenue_in_million
FROM fact_booking b
JOIN dim_hotels h ON b.property_id = h.property_id
GROUP BY h.city, h.property_name
ORDER BY total_revenue_in_million DESC;

-- 9. Class Wise Revenue

SELECT r.room_class, concat(round(SUM(b.revenue_realized)/1000000,2),'M') AS total_revenue_in_million 
FROM fact_booking b
JOIN dim_rooms r ON b.room_category = r.room_id
GROUP BY r.room_class
ORDER BY total_revenue_in_million DESC;

-- 11. Weekly Key Trends (Revenue, Bookings, Occupancy)

SELECT d.week_no, 
       concat(round(SUM(b.revenue_realized)/1000000,2),'M') AS total_revenue_in_million, 
       concat(round(COUNT(b.booking_id)/1000000,2),'M') AS total_bookings_in_million, 
       concat((SUM(f.successful_bookings) * 100.0) / SUM(f.capacity),'%') AS occupancy_rate
FROM fact_booking b
JOIN dim_date d ON b.check_in_date = d.date
JOIN fact_aggregated_booking f ON b.property_id = f.property_id AND b.room_category = f.room_category
GROUP BY d.week_no
ORDER BY d.week_no asc;

-- 13. Top 5 Performing Hotels by Revenue

SELECT h.property_name, h.city,h.category, concat(round(SUM(b.revenue_realized)/1000000,2),'M') AS total_revenue_in_million
FROM fact_booking b
JOIN dim_hotels h ON b.property_id = h.property_id
GROUP BY h.property_name, h.city,h.category
ORDER BY total_revenue_in_million DESC
limit 5;

-- 14. Platform-wise Booking Distribution

SELECT booking_platform, COUNT(booking_id) AS total_bookings, concat(round(SUM(revenue_realized)/1000000,2),'M') AS total_revenue_in_million
FROM fact_booking
GROUP BY booking_platform
ORDER BY total_bookings asc;

-- 17. revenue loss
select concat(round(sum(revenue_generated)/1000000,2),'M') as Total_revenue_generated_in_million,CONCAT(round(sum(revenue_realized)/1000000,2),'M') as Total_revenue_realized_in_million,
CONCAT(round((sum(revenue_generated)-sum(revenue_realized))/1000000,2),'M') as Revenue_loss_in_million
from fact_booking;