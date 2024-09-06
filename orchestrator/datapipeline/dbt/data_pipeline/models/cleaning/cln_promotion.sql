
{{ config(materialized='view') }}

with data as 
	(select distinct
        id, 
        start_date, 
        end_date, 
        disc_value, 
        max_disc
	from {{ ref('promotion') }}
	),

clean_type as (
	select
		{{ dbt.safe_cast("id", api.Column.translate_type("integer")) }} as id,
		{{ dbt.safe_cast("start_date", api.Column.translate_type("date")) }} as start_date,
		{{ dbt.safe_cast("end_date", api.Column.translate_type("date")) }} as end_date,
		{{ dbt.safe_cast("disc_value", api.Column.translate_type("float")) }} as disc_value,
		{{ dbt.safe_cast("max_disc", api.Column.translate_type("integer")) }} as max_disc
	from data
)

select * from clean_type