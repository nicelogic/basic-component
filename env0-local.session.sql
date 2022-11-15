
CREATE TABLE user_ride_counts AS SELECT u.name, COUNT(u.name) AS rides FROM "users" AS u JOIN "rides" AS r
ON (u.id=r.rider_id) GROUP BY u.name;
