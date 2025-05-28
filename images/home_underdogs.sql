CREATE TABLE home_underdogs AS
SELECT 
    game_id,
    season,
    home_team,
    home_score,
    away_team,
    away_score,
    spread,
    formatted_spread,
    over_under,
    home_moneyline,
    away_moneyline,
    NULL::double precision AS home_decimal_odds,
    week,
    CASE 
        WHEN home_score > away_score THEN 'W' 
        ELSE 'L' 
    END AS wins
FROM 
    unique_lines
WHERE 
    formatted_spread LIKE 'away_team -%';
