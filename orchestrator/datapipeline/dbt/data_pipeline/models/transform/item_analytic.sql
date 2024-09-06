{{ config(materialized='table') }}

WITH data AS (
    SELECT 
        omp.*, 
        (price * quantity) AS gross_revenue
    FROM 
        {{ ref('order_menu_promotion') }} omp
), 
discount_applied AS (
    SELECT 
        data.*, 
        CASE 
            WHEN (gross_revenue * disc_value) > max_disc 
            THEN max_disc 
            ELSE (gross_revenue * disc_value)
        END AS discount_applied
    FROM 
        data
), 
total_payment AS (
    SELECT 
        da.*, 
        da.gross_revenue - da.discount_applied AS net_revenue
    FROM 
        discount_applied da
)
SELECT
    tp.order_id,
    tp.sales_date, 
    tp.menu_id,
    tp.brand, 
    tp.name, 
    tp.price, 
    tp.quantity,
    tp.cogs, 
    tp.gross_revenue,
    tp.disc_value AS disc_percentage, 
    tp.max_disc, 
    tp.discount_applied AS disc_applied, 
    tp.net_revenue,
    (tp.net_revenue - tp.cogs) AS profit, 
    (tp.net_revenue - tp.cogs) / tp.quantity AS profit_per_unit, 
    (tp.discount_applied / tp.gross_revenue) AS discount_percentage_applied, 
    (tp.net_revenue - tp.cogs) / tp.net_revenue AS profit_margin, 
    ((tp.price - tp.cogs) / tp.cogs) * 100 AS markup_percentage
FROM 
    total_payment tp
