{{ config(materialized='table') }}


select 
        om.order_id,
		om.menu_id, 
		om.quantity, 
		om.sales_date,
		om.brand, 
		om.name , 
		om.price, 
		om.cogs, 
		om.effective_date as effective_date_menu,
		cp.start_date  as start_date_promotion,
		cp.end_date as end_date_promotion,
		cp.disc_value, 
		cp.max_disc 
from  {{ ref('order_menu') }} om 
left join
 {{ ref('cln_promotion') }} cp 
on 
	om.sales_date  >= cp.start_date 
	and 
	om.sales_date <= cp.end_date 
order by om.sales_date


