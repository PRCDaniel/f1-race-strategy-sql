-- F1 Race Strategy Analysis
-- 2024 Italian Grand Prix (Monza)
-- Database Overview

-- List the drivers included in the analysis
SELECT
    full_name,
    team_name,
    driver_number
FROM drivers
ORDER BY team_name, driver_number;

-- Count recorded laps for each driver
SELECT
    d.full_name,
    COUNT(l.lap_number) AS total_laps
FROM drivers d
JOIN laps l
    ON d.session_key = l.session_key
    AND d.driver_number = l.driver_number
WHERE l.session_key = 9590
GROUP BY d.driver_number, d.full_name
ORDER BY total_laps DESC;

-- Show each driver's tire strategy
SELECT
    d.full_name,
    s.stint_number,
    s.compound,
    s.lap_start,
    s.lap_end
FROM stints s
JOIN drivers d
    ON s.session_key = d.session_key
    AND s.driver_number = d.driver_number
WHERE s.session_key = 9590
ORDER BY d.full_name, s.stint_number;