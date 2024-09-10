SELECT
    DATE_TRUNC('month', sales_date) AS month_start,
    COUNT(distinct order_id) as total_order, 
    SUM(disc_applied) as total_discount_applied,
    SUM(gross_revenue) AS total_gross_revenue,
    SUM(net_revenue) AS total_net_revenue,
    SUM(net_profit) AS total_profit,
    SUM(COGS) as COGS
FROM {{ ref('analytic_data')}}
WHERE sales_date BETWEEN DATE_TRUNC('month', sales_date ) AND sales_date
GROUP BY month_start
ORDER BY month_start