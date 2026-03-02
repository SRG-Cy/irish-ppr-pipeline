-- Sales breakdown by property type
SELECT
    property_type,
    sale_year,
    COUNT(*)                                    AS total_sales,
    ROUND(AVG(price_eur), 0)                    AS avg_price,
    ROUND(CAST(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY price_eur) AS NUMERIC), 0) AS median_price
FROM {{ ref('stg_ppr_sales') }}
WHERE property_type IS NOT NULL
GROUP BY property_type, sale_year