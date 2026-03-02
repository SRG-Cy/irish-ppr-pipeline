WITH source AS (
    SELECT * FROM {{ source('bronze', 'bronze_ppr_raw') }}
),

cleaned AS (
    SELECT
        -- Parse date
        TO_DATE("date_of_sale_dd/mm/yyyy", 'DD/MM/YYYY')                    AS sale_date,
        EXTRACT(YEAR FROM TO_DATE("date_of_sale_dd/mm/yyyy", 'DD/MM/YYYY')) AS sale_year,
        EXTRACT(MONTH FROM TO_DATE("date_of_sale_dd/mm/yyyy", 'DD/MM/YYYY')) AS sale_month,

        -- Clean address and location
        TRIM(address)                                AS address,
        INITCAP(TRIM(county))                        AS county,
        UPPER(TRIM(eircode))                         AS eircode,

        -- Parse price: remove €, commas, cast to numeric
        CAST(
            REGEXP_REPLACE(
                REPLACE("price_€", ',', ''),
                '[^0-9.]', '', 'g'
            ) AS NUMERIC
        )                                            AS price_eur,

        -- Property flags
        CASE WHEN LOWER(not_full_market_price) = 'yes'
             THEN TRUE ELSE FALSE END                AS is_not_full_market_price,
        CASE WHEN LOWER(vat_exclusive) = 'yes'
             THEN TRUE ELSE FALSE END                AS is_vat_exclusive,

        TRIM(description_of_property)               AS property_type,
        TRIM(property_size_description)              AS property_size

    FROM source
    WHERE "price_€" IS NOT NULL
      AND county IS NOT NULL
)

SELECT * FROM cleaned
WHERE price_eur > 0
  AND price_eur < 50000000