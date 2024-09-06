
{{ config(materialized='view') }}

with data as 
	(select distinct
        order_id, 
        menu_id, 
        quantity, 
        sales_date
	from {{ ref('order') }}
	),

clean_type as (
	select
	    {{ dbt_utils.generate_surrogate_key(['order_id', 'menu_id', 'quantity', 'sales_date']) }} as unique_order,
		{{ dbt.safe_cast("order_id", api.Column.translate_type("integer")) }} as order_id,
		{{ dbt.safe_cast("menu_id", api.Column.translate_type("integer")) }} as menu_id,
		{{ dbt.safe_cast("quantity", api.Column.translate_type("integer")) }} as quantity,
		{{ dbt.safe_cast("sales_date", api.Column.translate_type("date")) }} as sales_date
	from data
)

select * from clean_type