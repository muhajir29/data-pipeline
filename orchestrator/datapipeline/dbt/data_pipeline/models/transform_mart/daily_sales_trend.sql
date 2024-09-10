SELECT
    sales_date,
    SUM(quantity) AS total_items_sold,
    COUNT(DISTINCT order_id) AS total_order, 
    SUM(disc_applied) AS total_discount_applied,
    SUM(gross_revenue) AS total_gross_revenue,
    SUM(net_revenue) AS total_net_revenue,
    SUM(net_profit) AS total_profit,  -- ensure this column name matches the actual one in the table
    SUM(COGS) AS COGS
FROM {{ ref('analytic_data') }}
GROUP BY sales_date
ORDER BY sales_date