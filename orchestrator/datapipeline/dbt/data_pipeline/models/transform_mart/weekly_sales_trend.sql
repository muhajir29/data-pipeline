SELECT
    DATE_TRUNC('week', sales_date) AS week_start,
    SUM(quantity) AS total_items_sold,
    COUNT(distinct order_id) as total_order, 
    SUM(disc_applied) as total_discount_applied,
    SUM(gross_revenue) AS total_gross_revenue,
    SUM(net_revenue) AS total_net_revenue,
    SUM(net_profit) AS total_profit,
    SUM(COGS) as COGS
FROM {{ ref('analytic_data') }}
GROUP BY week_start
ORDER BY week_start