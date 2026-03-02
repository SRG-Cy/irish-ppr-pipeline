-- Median and average sale price per county per year
-- This powers the main dashboard chart
SELECT
    county,
    sale_year,
    COUNT(*)                                    AS total_sales,
    ROUND(AVG(price_eur), 0)                    AS avg_price,
    ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price_eur) AS NUMERIC), 0) AS median_price,
    ROUND(MIN(price_eur), 0)                    AS min_price,
    ROUND(MAX(price_eur), 0)                    AS max_price
FROM {{ ref('stg_ppr_sales') }}
GROUP BY county, sale_year
ORDER BY county, sale_year