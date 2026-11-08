-- F1 Race Strategy Analysis
-- 2024 Italian Grand Prix (Monza)
-- Piastri One-Stop Strategy Simulation
--
-- Research question:
-- Could Oscar Piastri have beaten Charles Leclerc
-- if McLaren had used a one-stop strategy?
--
-- Model assumptions:
-- 1. Piastri does not make his second pit stop.
-- 2. His hypothetical pace is constant over laps 38-53.
-- 3. Leclerc's actual race time remains unchanged.
-- 4. Traffic and race-position effects are not modeled.

-- ANALYSIS 1: Three hypothetical strategies

WITH scenarios AS (
    SELECT 'Optimistic' AS scenario, 83.450 AS avg_pace
    UNION ALL
    SELECT 'Baseline', 83.602
    UNION ALL
    SELECT 'Pessimistic', 84.000
),
actual AS (
    SELECT
        SUM(lap_duration) AS actual_time
    FROM laps
    WHERE session_key = 9590
      AND driver_number = 81
      AND lap_number BETWEEN 38 AND 53
)
SELECT
    s.scenario,

    printf('%d:%06.3f',
        CAST(s.avg_pace / 60 AS INTEGER),
        s.avg_pace -
        CAST(s.avg_pace / 60 AS INTEGER) * 60
    ) AS hypothetical_avg_lap,

    ROUND(
        a.actual_time - s.avg_pace * 16,
        3
    ) AS time_saved_seconds,

    ROUND(
        a.actual_time - s.avg_pace * 16 - 2.778,
        3
    ) AS hypothetical_winning_margin

FROM scenarios s
CROSS JOIN actual a
ORDER BY s.avg_pace;


-- ANALYSIS 2: Break-even lap time
-- Determine the average lap time required
-- for Piastri to match Leclerc's total race time.

WITH actual AS (
    SELECT
        SUM(lap_duration) AS actual_time
    FROM laps
    WHERE session_key = 9590
      AND driver_number = 81
      AND lap_number BETWEEN 38 AND 53
),
race_gap AS (
    SELECT
        SUM(CASE WHEN driver_number = 81
            THEN lap_duration ELSE 0 END)
        -
        SUM(CASE WHEN driver_number = 16
            THEN lap_duration ELSE 0 END)
        AS gap_seconds
    FROM laps
    WHERE session_key = 9590
      AND driver_number IN (16, 81)
),
break_even AS (
    SELECT
        (a.actual_time - g.gap_seconds) / 16.0
            AS required_avg_lap
    FROM actual a
    CROSS JOIN race_gap g
)
SELECT
    printf('%d:%06.3f',
        CAST(required_avg_lap / 60 AS INTEGER),
        required_avg_lap -
        CAST(required_avg_lap / 60 AS INTEGER) * 60
    ) AS break_even_lap_time
FROM break_even;