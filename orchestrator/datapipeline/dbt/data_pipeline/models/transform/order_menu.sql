
{{ config(materialized='table') }}

select 	
        co.order_id,
		co.menu_id, 
		co.quantity, 
		co.sales_date,
		cm.brand, 
		cm.name , 
		cm.price, 
		cm.cogs, 
		cm.effective_date
from {{ ref('cln_order') }} as co 
left join 
{{ ref('cln_menu') }} as cm 
on 
	co.menu_id  = cm.menu_id 
	and 
	cm.effective_date = (
			select max(cm2.effective_date)
			from {{ ref('cln_menu') }} cm2 
			where cm2.menu_id = co.menu_id 
			and cm2.effective_date <= co.sales_date 
			)
 order by menu_id 

 