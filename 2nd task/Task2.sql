
-- Run once
--CREATE PROCEDURE GetReservationsByYear
--    @input_value VARCHAR(50)
--AS
--BEGIN
--    SELECT *
--    FROM [Hotel Reservation Dataset]
--    WHERE YEAR(arrival_date) = @input_value;
--END;

-- 1-What is the total number of reservations in the dataset? assume  that the cancled booking is not taken in cosideration 
select count(*) from [Hotel Reservation Dataset]
where booking_status='Not_Canceled';


-- 2-Which meal plan is the most popular among guests?
SELECT Top 1 type_of_meal_plan, COUNT(*) AS reservation_count
FROM  [Hotel Reservation Dataset]
GROUP BY type_of_meal_plan
ORDER BY reservation_count Desc;


--3- What is the average price per room for reservations involving children?
select avg (avg_price_per_room) as avg_price_per_room_for_reservation from [Hotel Reservation Dataset]
where no_of_children>0;


--4-How many reservations were made for the year 20XX (replace XX with the desired year)?
exec GetReservationsByYear @input_value = '2017';


--5- What is the most commonly booked room type?
SELECT TOP 1 room_type_reserved ,count(*) As count_room_Reserved_Type
from [Hotel Reservation Dataset]
group by room_type_reserved 
order by count_room_Reserved_Type desc;


--6-How many reservations fall on a weekend (no_of_weekend_nights > 0)?  assume that the cancelled reservation is not considered
SELECT COUNT(*) as reservations_fall_on_a_weekend
FROM [Hotel Reservation Dataset]
WHERE no_of_weekend_nights > 0 and booking_status='Not_Canceled';



--7-What is the highest and lowest lead time for reservations? 
select max(lead_time) as max_lead_time,
min(lead_time) as min_lead_time
from [Hotel Reservation Dataset];


--8-What is the most common market segment type for reservations?
select top 1 market_segment_type, count(*) count_market_segment_type
from [Hotel Reservation Dataset]
group by market_segment_type
order by count_market_segment_type desc;


--9- How many reservations have a booking status of "Confirmed"? --if the lead is zero is this mean that is confirmed ??
select count(*) as Confirmed_Booking_status
from [Hotel Reservation Dataset]
where booking_status='Not_Canceled';


--10-What is the total number of adults and children across all reservations? assume the not cancelled reservation is required 
select sum (no_of_adults) as num_adults,sum(no_of_children) as num_children ,sum(no_of_children+no_of_adults)as total_guests
from [Hotel Reservation Dataset]
where booking_status='Not_Canceled';


--11- What is the average number of weekend nights for reservations involving children?
select avg (no_of_weekend_nights) as avg_no_of_weekend_nights_involving_children
from [Hotel Reservation Dataset]
where no_of_children>0;


--12-How many reservations were made in each month of the year?
SELECT 
    MONTH(DATEADD(day, -lead_time, arrival_date)) AS reservation_month,
    COUNT(*) AS reservations_count
FROM 
    [Hotel Reservation Dataset]
where booking_status='Not_Canceled'
GROUP BY 
    MONTH(DATEADD(day, -lead_time, arrival_date))
ORDER BY 
    reservation_month;



--13-What is the average number of nights (both weekend and weekday) spent by guests for each roomtype?
select room_type_reserved ,AVG(no_of_weekend_nights+no_of_week_nights) as avgNumOfnights

from [Hotel Reservation Dataset]

GROUP BY 
   room_type_reserved;



--14- For reservations involving children, what is the most common room type, and what is the averageprice for that room type?

WITH MostCommonRoomType AS (
    SELECT TOP 1
        room_type_reserved,
        COUNT(*) AS numberOfRoomTypesIncludeChildren
    FROM
        [Hotel Reservation Dataset]
    WHERE
        no_of_children > 0
    GROUP BY
        room_type_reserved
    ORDER BY
        numberOfRoomTypesIncludeChildren DESC
)
SELECT
    MostCommonRoomType.room_type_reserved,
    AVG(hrd.avg_price_per_room) AS average_price
FROM
    [Hotel Reservation Dataset] AS hrd
JOIN
    MostCommonRoomType
    ON hrd.room_type_reserved = MostCommonRoomType.room_type_reserved
WHERE
    hrd.no_of_children > 0
GROUP BY
    MostCommonRoomType.room_type_reserved;


--15-Find the market segment type that generates the highest average price per room.
select top 1 market_segment_type, avg(avg_price_per_room) as avg_market_segment_type
from [Hotel Reservation Dataset]
where booking_status='Not_Canceled'
group by market_segment_type
order by  avg_market_segment_type desc;
