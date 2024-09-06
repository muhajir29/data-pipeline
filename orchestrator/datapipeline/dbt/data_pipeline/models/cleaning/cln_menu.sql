
{{ config(materialized='view') }}

with data as 
	(select 
		menu_id, 
		lower(trim(brand)) as brand, 
		lower(trim(name)) as name, 
		price, 
		cogs, 
		effective_date 
	from {{ ref('menu') }}
	),

clean_type as (
	select
		{{ dbt.safe_cast("menu_id", api.Column.translate_type("integer")) }} as menu_id,
		{{ dbt.safe_cast("brand", api.Column.translate_type("string")) }} as brand,
		{{ dbt.safe_cast("name", api.Column.translate_type("string")) }} as name,
		{{ dbt.safe_cast("price", api.Column.translate_type("integer")) }} as price,
		{{ dbt.safe_cast("cogs", api.Column.translate_type("integer")) }} as cogs,
		{{ dbt.safe_cast("effective_date", api.Column.translate_type("date")) }} as effective_date
	from data
),

clean_dup as (
	select distinct 
		menu_id, 
		brand, 
		name, 
		price, 
		cogs, 
		effective_date 
	from clean_type) 

select
	{{ dbt_utils.generate_surrogate_key(['menu_id', 'price', 'cogs', 'effective_date']) }} as unique_menu,
	*
from clean_dup


