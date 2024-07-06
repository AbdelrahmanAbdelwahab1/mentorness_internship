CREATE PROCEDURE GetReservationsByYear
    @input_value VARCHAR(50)
AS
BEGIN
    SELECT *
    FROM [Hotel Reservation Dataset]
    WHERE YEAR(arrival_date) = @input_value;
END;
