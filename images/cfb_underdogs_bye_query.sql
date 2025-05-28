SELECT 
    hu.spread,
    COUNT(*) AS total_games,
    SUM(CASE WHEN hu.home_score > hu.away_score THEN 1 ELSE 0 END) AS home_wins,
    SUM(CASE WHEN hu.home_score <= hu.away_score THEN 1 ELSE 0 END) AS home_losses,
    ROUND(
        CAST(
            SUM(
                CASE 
                    WHEN hu.home_moneyline > 0 AND hu.home_score > hu.away_score THEN (hu.home_moneyline / 100.0) + 1
                    WHEN hu.home_moneyline < 0 AND hu.home_score > hu.away_score THEN (100.0 / ABS(hu.home_moneyline)) + 1
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
                        WHEN hu.home_moneyline > 0 AND hu.home_score > hu.away_score THEN (hu.home_moneyline / 100.0) + 1
                        WHEN hu.home_moneyline < 0 AND hu.home_score > hu.away_score THEN (100.0 / ABS(hu.home_moneyline)) + 1
                        ELSE 0
                    END
                ) AS NUMERIC
            ), 2
        ) - COUNT(*), 2
    ) AS value
FROM 
    home_underdogs hu
JOIN 
    season_schedules ss
ON 
    hu.home_team = ss.home_team
    AND hu.season = ss.season 
    AND hu.week = ss.week + 1
WHERE 
    ss.away_team = 'BYE'
    AND hu.spread BETWEEN 0.5 AND 10.5
GROUP BY 
    hu.spread

UNION ALL

SELECT 
    0.5 AS spread,
    0 AS total_games,
    0 AS home_wins,
    0 AS home_losses,
    0.0 AS total_decimal_odds,
    0.0 AS value

UNION ALL

SELECT 
    '00' AS spread,
    COUNT(*) AS total_games,
    SUM(CASE WHEN hu.home_score > hu.away_score THEN 1 ELSE 0 END) AS home_wins,
    SUM(CASE WHEN hu.home_score <= hu.away_score THEN 1 ELSE 0 END) AS home_losses,
    ROUND(
        CAST(
            SUM(
                CASE 
                    WHEN hu.home_moneyline > 0 AND hu.home_score > hu.away_score THEN (hu.home_moneyline / 100.0) + 1
                    WHEN hu.home_moneyline < 0 AND hu.home_score > hu.away_score THEN (100.0 / ABS(hu.home_moneyline)) + 1
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
                        WHEN hu.home_moneyline > 0 AND hu.home_score > hu.away_score THEN (hu.home_moneyline / 100.0) + 1
                        WHEN hu.home_moneyline < 0 AND hu.home_score > hu.away_score THEN (100.0 / ABS(hu.home_moneyline)) + 1
                        ELSE 0
                    END
                ) AS NUMERIC
            ), 2
        ) - COUNT(*), 2
    ) AS value
FROM 
    home_underdogs hu
JOIN 
    season_schedules ss
ON 
    hu.home_team = ss.home_team
    AND hu.season = ss.season 
    AND hu.week = ss.week + 1
WHERE 
    ss.away_team = 'BYE'
    AND hu.spread BETWEEN 0.5 AND 10.5

ORDER BY 
    spread::FLOAT NULLS LAST;
