SELECT
    DATE_TRUNC('year', sales_date) AS year_start,
    COUNT(DISTINCT order_id) AS total_order,
    SUM(disc_applied) AS total_discount_applied,
    SUM(gross_revenue) AS total_gross_revenue,
    SUM(net_revenue) AS total_net_revenue,
    SUM(net_profit) AS total_profit,  
    SUM(COGS) AS COGS
FROM {{ ref('analytic_data')}}
WHERE sales_date >= DATE_TRUNC('year', sales_date)
  AND sales_date <= sales_date
GROUP BY year_start
ORDER BY year_start