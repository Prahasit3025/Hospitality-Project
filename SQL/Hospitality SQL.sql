-- 1. Total Revenue

SELECT SUM(revenue_realized) AS total_revenue FROM fact_booking;

-- 2. Occupancy (%)

SELECT f.property_id, d.city, SUM(successful_bookings) AS total_bookings, SUM(capacity) AS total_capacity,
       (SUM(successful_bookings) * 100.0) / SUM(capacity) AS occupancy_rate
FROM fact_aggregated_booking f
JOIN dim_hotels d ON f.property_id = d.property_id
GROUP BY f.property_id, d.city
ORDER BY property_id ASC;

-- 3. Cancellation Rate

SELECT COUNT(*) AS total_bookings,
       SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancelled_bookings,
       (SUM(CASE WHEN booking_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0) / COUNT(booking_id) AS cancellation_rate
FROM fact_booking;

-- 4. Total Bookings

SELECT COUNT(booking_id) AS total_bookings FROM fact_booking;

-- 5. Utilize Capacity

SELECT property_id, SUM(successful_bookings) AS total_bookings, SUM(capacity) AS total_capacity,
       (SUM(successful_bookings) * 100.0) / SUM(capacity) AS utilization_rate
FROM fact_aggregated_booking
GROUP BY property_id;

-- 6. Trend Analysis (Monthly Revenue, Booking)

SELECT booking_month, SUM(revenue_realized) AS monthly_revenue, COUNT(booking_id) AS monthly_bookings
FROM fact_booking
GROUP BY booking_month
ORDER BY booking_month;

-- 7. Weekday & Weekend Revenue and Booking

SELECT d.day_type, SUM(b.revenue_realized) AS total_revenue, COUNT(b.booking_id) AS total_bookings
FROM fact_booking b
JOIN dim_date d ON b.check_in_date = d.date
GROUP BY d.day_type;

-- 8. Revenue by State & Hotel

SELECT h.city, h.property_name, SUM(b.revenue_realized) AS total_revenue
FROM fact_booking b
JOIN dim_hotels h ON b.property_id = h.property_id
GROUP BY h.city, h.property_name
ORDER BY total_revenue DESC;

-- 9. Class Wise Revenue

SELECT r.room_class, SUM(b.revenue_realized) AS total_revenue 
FROM fact_booking b
JOIN dim_rooms r 
ON b.room_category = r.room_id
GROUP BY r.room_class
ORDER BY total_revenue DESC;

-- 10. booking status Counts

SELECT booking_status, COUNT(booking_id) AS total_count
FROM fact_booking
GROUP BY booking_status;

-- 11. Weekly Key Trends (Revenue, Bookings, Occupancy)

SELECT d.week_no, 
       SUM(b.revenue_realized) AS total_revenue, 
       COUNT(b.booking_id) AS total_bookings, 
       (SUM(f.successful_bookings) * 100.0) / SUM(f.capacity) AS occupancy_rate
FROM fact_booking b
JOIN dim_date d ON b.check_in_date = d.date
JOIN fact_aggregated_booking f ON b.property_id = f.property_id AND b.room_category = f.room_category
GROUP BY d.week_no
ORDER BY d.week_no asc;

-- 12. Top 5 Performing Hotels by Revenue

SELECT h.property_name, h.city,h.category, SUM(b.revenue_realized) AS total_revenue
FROM fact_booking b
JOIN dim_hotels h ON b.property_id = h.property_id
GROUP BY h.property_name, h.city,h.category
ORDER BY total_revenue DESC
limit 5;

-- 13. Platform-wise Booking Distribution

SELECT booking_platform, COUNT(booking_id) AS total_bookings, SUM(revenue_realized) AS total_revenue
FROM fact_booking
GROUP BY booking_platform
ORDER BY total_bookings asc;

-- 14. Day-wise Cancellation Trend

select d.day_type, COUNT(*) AS total_cancellations
FROM fact_booking b
JOIN dim_date d ON b.check_in_date = d.date
WHERE b.booking_status = 'Cancelled'
GROUP BY d.day_type;

-- 15. revenue loss
select sum(revenue_generated) as Total_revenue_generated,sum(revenue_realized) as Total_revenue_realized,
(sum(revenue_generated)-sum(revenue_realized)) as Revenue_loss 
from fact_booking;