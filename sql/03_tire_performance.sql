-- F1 Race Strategy Analysis
-- 2024 Italian Grand Prix (Monza)
-- Tire Performance Analysis

-- Compare average lap times across tire stints.
-- Exclude pit-out laps and pit-in laps.

SELECT
    d.full_name,
    s.stint_number,
    s.compound,
    s.lap_start,
    s.lap_end,
    COUNT(*) AS racing_laps,

    printf('%d:%06.3f',
        CAST(AVG(l.lap_duration) / 60 AS INTEGER),
        AVG(l.lap_duration) -
        CAST(AVG(l.lap_duration) / 60 AS INTEGER) * 60
    ) AS avg_lap_time

FROM laps l

JOIN drivers d
    ON l.session_key = d.session_key
    AND l.driver_number = d.driver_number

JOIN stints s
    ON l.session_key = s.session_key
    AND l.driver_number = s.driver_number
    AND l.lap_number BETWEEN s.lap_start AND s.lap_end

WHERE l.session_key = 9590
    AND l.lap_duration IS NOT NULL
    AND COALESCE(l.is_pit_out_lap, 0) = 0

    AND NOT EXISTS (
        SELECT 1
        FROM pit_stops p
        WHERE p.session_key = l.session_key
          AND p.driver_number = l.driver_number
          AND p.lap_number = l.lap_number
    )

GROUP BY
    d.driver_number,
    d.full_name,
    s.stint_number,
    s.compound,
    s.lap_start,
    s.lap_end

ORDER BY d.full_name, s.stint_number;