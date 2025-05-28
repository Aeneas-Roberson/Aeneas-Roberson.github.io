WITH ranked_spreads AS (
    SELECT 
        spread, 
        ROW_NUMBER() OVER (ORDER BY spread) AS row_num,
        COUNT(*) OVER () AS total_spreads
    FROM home_underdogs
    WHERE wins = 'W'
),
spread_stats AS (
    SELECT 
        AVG(spread) AS mean_spread,
        COUNT(*) AS frequency,
        spread AS mode_spread
    FROM home_underdogs
    WHERE wins = 'W'
    GROUP BY spread
    ORDER BY frequency DESC, spread
    LIMIT 1
)
SELECT 
    (SELECT AVG(spread) FROM home_underdogs WHERE wins = 'W') AS mean_spread,
    (SELECT mode_spread FROM spread_stats) AS mode_spread,
    AVG(spread) AS median_spread
FROM ranked_spreads
WHERE row_num IN (
    (total_spreads + 1) / 2,
    (total_spreads + 2 - MOD(total_spreads, 2)) / 2
);
