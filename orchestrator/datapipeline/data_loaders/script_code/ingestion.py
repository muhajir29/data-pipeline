import json
import requests
import pandas as pd
from io import StringIO
import os
from sqlalchemy import create_engine

class Ingestion:
    def __init__(self, **kwargs):
        self.kwargs = kwargs

    @staticmethod
    def create_output_dir(output_file):
        """
        Ensures that the directory for the output file exists.
        If the directory does not exist, it is created.

        Parameters:
        - output_file (str): Path to the output file.
        """
        output_dir = os.path.dirname(output_file)
        if output_dir and not os.path.exists(output_dir):
            os.makedirs(output_dir)
            print(f"Created directory: {output_dir}")

    def api(self):
        """
        Fetches data from an API and saves it to a local JSON file.
        """
        api_url = self.kwargs.get('api_url')
        output_file = self.kwargs.get('output_file')
        
        if not api_url or not output_file:
            raise ValueError("Both 'api_url' and 'output_file' must be provided.")

        self.create_output_dir(output_file)

        try:
            response = requests.get(api_url)
            response.raise_for_status()
            data = response.json()

            with open(output_file, 'w') as file:
                json.dump(data, file, indent=4)

            print(f"Data successfully saved to {output_file}")

        except requests.exceptions.RequestException as e:
            raise Exception(f"API request failed: {e}")
        except json.JSONDecodeError:
            raise Exception("Error decoding JSON data")
        except Exception as e:
            raise Exception(f"Failed to save data: {e}")

    def csv(self):
        """
        Fetches CSV data from a URL or local file and saves it to a CSV file.
        """
        input_source = self.kwargs.get('input_source')
        output_csv_path = self.kwargs.get('output_csv_path')

        if not input_source or not output_csv_path:
            raise ValueError("Both 'input_source' and 'output_csv_path' must be provided.")

        self.create_output_dir(output_csv_path)

        try:
            if input_source.startswith(('http://', 'https://')):
                response = requests.get(input_source)
                response.raise_for_status()
                csv_data = StringIO(response.text)
                df = pd.read_csv(csv_data)
            else:
                if not os.path.exists(input_source):
                    raise FileNotFoundError(f"Local file not found: {input_source}")
                df = pd.read_csv(input_source)
                print(df.head())
            df.to_csv(output_csv_path, index=False)
            print(f"Data successfully saved to {output_csv_path}")

        except requests.exceptions.RequestException as e:
            raise Exception(f"Error fetching data from URL: {e}")
        except pd.errors.EmptyDataError:
            raise Exception("CSV data is empty or could not be read")
        except FileNotFoundError as e:
            raise Exception(f"Local file not found: {e}")
        except Exception as e:
            raise Exception(f"Failed to process and save data: {e}")

    def json(self):
        """
        Fetches JSON data from a URL or local file and saves it to a JSON file.
        """
        input_source = self.kwargs.get('input_source')
        output_json_path = self.kwargs.get('output_json_path')

        if not input_source or not output_json_path:
            raise ValueError("Both 'input_source' and 'output_json_path' must be provided.")

        self.create_output_dir(output_json_path)

        try:
            if input_source.startswith(('http://', 'https://')):
                response = requests.get(input_source)
                response.raise_for_status()
                data = response.json()
            else:
                if not os.path.exists(input_source):
                    raise FileNotFoundError(f"Local file not found: {input_source}")
                with open(input_source, 'r') as file:
                    data = json.load(file)

            with open(output_json_path, 'w') as file:
                json.dump(data, file, indent=4)

            print(f"Data successfully saved to {output_json_path}")

        except requests.exceptions.RequestException as e:
            raise Exception(f"Error fetching data from URL: {e}")
        except json.JSONDecodeError:
            raise Exception("Error decoding JSON data")
        except FileNotFoundError as e:
            raise Exception(f"File not found: {e}")
        except Exception as e:
            raise Exception(f"Failed to process and save data: {e}")

    def database(self):
        """
        Exports data from a database table or query result to a CSV file.
        """
        db_url = self.kwargs.get('db_url')
        table_or_query = self.kwargs.get('table_or_query')
        output_csv_path = self.kwargs.get('output_csv_path')
        is_query = self.kwargs.get('is_query', False)

        if not db_url or not table_or_query or not output_csv_path:
            raise ValueError("Parameters 'db_url', 'table_or_query', and 'output_csv_path' must be provided.")

        self.create_output_dir(output_csv_path)

        try:
            engine = create_engine(db_url)

            if is_query:
                df = pd.read_sql_query(table_or_query, con=engine)
            else:
                df = pd.read_sql_table(table_or_query, con=engine)

            df.to_csv(output_csv_path, index=False)
            print(f"Data successfully saved to {output_csv_path}")

        except Exception as e:
            raise Exception(f"Failed to export data to CSV: {e}")

    def main(self, type):
        """
        Main function to call the appropriate method based on 'type'.

        Parameters:
        - type (str): The type of ingestion to perform ('api', 'csv', 'json', 'database').
        """
        if type == 'api':
            self.api()
        elif type == 'csv':
            self.csv()
        elif type == 'json':
            self.json()
        elif type == 'database':
            self.database()
        else:
            raise ValueError(f"Unknown type: {type}")



# Example usage:
# ingestion = Ingestion(api_url="https://api.example.com/data", output_file="data/output/data.json")
# ingestion.main(type="api")
