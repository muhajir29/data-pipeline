if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

from datapipeline.data_loaders.script_code.ingestion import Ingestion

@data_loader
def load_data(*args, **kwargs):
    list_table_name = ['menu.csv', 'order.csv', 'promotion.csv']
    link_source = "https://raw.githubusercontent.com/muhajir29/data-pipeline/main/data"
    folder_output = "/home/src/datapipeline/dbt/data_pipeline/seeds"

    for table in list_table_name:
        input_source = f"{link_source}/{table}"
        output_csv_path = f"{folder_output}/{table}"
        ingest = Ingestion(input_source = input_source, output_csv_path =output_csv_path)
        ingest.main('csv')
