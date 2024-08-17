import pandas as pd


# Número de archivos
n = 3000

# Crear una lista con los nombres de archivo
file_names = [f"data_case$i_{i}.csv" for i in range(n)]

# Procesar cada archivo
for file_name in file_names:
    file_path = file_name
    # Cargar el archivo CSV
    df = pd.read_csv(file_path)
    # Ordenar el DataFrame por la primera columna (asumiendo que es la columna 0)
    df_sorted = df.sort_values(by=df.columns[0], ascending=True)
    # Guardar el DataFrame ordenado en un nuevo archivo CSV
    sorted_file_path = f"freesurface/{file_name}"
    df_sorted.to_csv(sorted_file_path, index=False)
