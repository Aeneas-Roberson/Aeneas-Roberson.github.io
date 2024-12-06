CREATE TABLE unique_lines AS
SELECT *
FROM (
    SELECT *, ROW_NUMBER() OVER (PARTITION BY game_id, season, season_type, week, home_team, away_team ORDER BY game_id) AS row_number
    FROM lines
) subquery
WHERE row_number = 1;
