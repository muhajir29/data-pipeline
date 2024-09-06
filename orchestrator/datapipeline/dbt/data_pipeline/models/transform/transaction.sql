{{ config(materialized='table') }}


WITH data AS (
    SELECT 
        omp.*, 
        (price * quantity) AS gross_revenue
    FROM 
        order_menu_promotion omp
), 
discount_applied as 
	(SELECT 
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
        discount_applied as da
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
	tp.disc_value as disc_presentation, 
	tp.max_disc, 
	tp.discount_applied as disc_applied, 
	tp.net_revenue,
    (tp.net_revenue - tp.cogs) AS profit, 
    (tp.net_revenue - tp.cogs) / quantity as profit_per_unit, 
    (tp.discount_applied / tp.gross_revenue) as discount_percentage_applied, 
    (tp.net_revenue - tp.cogs) / net_revenue as profit_margin, 
    ((tp.price - tp.cogs) / tp.cogs) * 100 as markup_persentation
FROM 
    total_payment as tp;
