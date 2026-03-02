-- Monthly transaction volumes — good for trend charts
SELECT
    sale_year,
    sale_month,
    county,
    COUNT(*)                        AS total_sales,
    SUM(price_eur)                  AS total_value,
    ROUND(AVG(price_eur), 0)        AS avg_price
FROM {{ ref('stg_ppr_sales') }}
GROUP BY sale_year, sale_month, county
ORDER BY sale_year, sale_month