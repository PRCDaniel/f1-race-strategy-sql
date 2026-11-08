-- F1 Race Strategy Analysis
-- 2024 Italian Grand Prix (Monza)
-- Pit Stop Analysis

-- Compare pit stop counts and total pit-lane duration
-- for Ferrari and McLaren drivers.

SELECT
    d.full_name,
    d.team_name,
    COUNT(p.lap_number) AS total_pit_stops,
    ROUND(SUM(p.lane_duration), 2)
        AS total_pit_lane_seconds
FROM drivers d
JOIN pit_stops p
    ON d.session_key = p.session_key
    AND d.driver_number = p.driver_number
WHERE d.session_key = 9590
    AND d.team_name IN ('Ferrari', 'McLaren')
GROUP BY
    d.session_key,
    d.driver_number,
    d.full_name,
    d.team_name
ORDER BY total_pit_lane_seconds ASC;