SELECT 
    spread,
    COUNT(*) AS total_games,
    SUM(CASE WHEN home_score > away_score THEN 1 ELSE 0 END) AS home_wins,
    SUM(CASE WHEN home_score <= away_score THEN 1 ELSE 0 END) AS home_losses,
    ROUND(
        CAST(
            SUM(
                CASE 
                    WHEN home_moneyline > 0 AND home_score > away_score THEN (home_moneyline / 100.0) + 1
                    WHEN home_moneyline < 0 AND home_score > away_score THEN (100.0 / ABS(home_moneyline)) + 1
                    ELSE 0
                END
            ) AS NUMERIC
        ), 2
    ) AS total_decimal_odds,
    ROUND(
        ROUND(
            CAST(
                SUM(
                    CASE 
                        WHEN home_moneyline > 0 AND home_score > away_score THEN (home_moneyline / 100.0) + 1
                        WHEN home_moneyline < 0 AND home_score > away_score THEN (100.0 / ABS(home_moneyline)) + 1
                        ELSE 0
                    END
                ) AS NUMERIC
            ), 2
        ) - COUNT(*), 2
    ) AS value
FROM 
    home_underdogs
WHERE 
    spread BETWEEN 0.5 AND 10.5
GROUP BY 
    spread
ORDER BY 
    spread;
