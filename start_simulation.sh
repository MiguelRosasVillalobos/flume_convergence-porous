#!/bin/bash
#Miguel Rosas

# Lista de valores para lc
valores_lc=("100" "200" "300" "400" "500" "600")

# Leer valores desde el archivo parametros.txt
valores_n=("0.25" "0.5" "0.6" "0.75" "0.8")
valores_a=("0.05" "0" "0.436" "0.301" "0.07" "0.7" "0.25" "0" "0.25" "0")

# Bucle para crear y mover carpetas, editar y generar mallado
index_a=0
for n in "${valores_n[@]}"; do

  # Reemplaza el punto en $n con un guion bajo o elimínalo
  n_sanitizado=$(echo "$n" | sed 's/\./_/g') # O usa 's/\.//g' para eliminar el punto

  # Genera el nombre de la carpeta usando el valor sanitizado
  Case_n="Case_n$n_sanitizado"

  # Crea la carpeta del caso
  mkdir "$Case_n"

  # Seleccionar los dos valores correspondientes de 'a'
  if [ $index_a -lt ${#valores_a[@]} ]; then
    a1=${valores_a[$index_a]}
    a2=${valores_a[$((index_a + 1))]}
    a_values=("$a1" "$a2")

    for a in "${a_values[@]}"; do
      # Reemplaza el punto en $a con un guion bajo o elimínalo
      a_sanitizado=$(echo "$a" | sed 's/\./_/g') # O usa 's/\.//g' para eliminar el punto

      # Genera el nombre de la carpeta usando el valor sanitizado
      Case_a="Case_a$a_sanitizado"

      # Crea la carpeta del caso
      mkdir "$Case_n/$Case_a"
      cp -r "Case_0" "$Case_n/$Case_a"
      sed -i "s/\$nn/$n/g" "$Case_n/$Case_a/Case_0/constant/porosityProperties"
      sed -i "s/\$nn/$n/g" "$Case_n/$Case_a/Case_0/system/setFieldsDict"
      sed -i "s/\$aa/$a/g" "$Case_n/$Case_a/Case_0/system/setFieldsDict"
      sed -i "s/\$aa/$a/g" "$Case_n/$Case_a/Case_0/extractor.py"
      cd "$Case_n/$Case_a"

      for lc in "${valores_lc[@]}"; do

        # Reemplaza el punto en $lc con un guion bajo o elimínalo
        lc_sanitizado=$(echo "$lc" | sed 's/\./_/g') # O usa 's/\.//g' para eliminar el punto

        # Genera el nombre de la carpeta usando el valor sanitizado
        Case_lc="Case_lc$lc_sanitizado"

        mkdir "$Case_lc"

        # Copia carpetas del caso dentro de las carpetas generadas
        cp -r "Case_0/0/" "$Case_lc"
        cp -r "Case_0/0.orig/" "$Case_lc"
        cp -r "Case_0/constant/" "$Case_lc"
        cp -r "Case_0/system/" "$Case_lc"
        cp "Case_0/extract_freesurface_plane.py" "$Case_lc"
        cp "Case_0/extract_freesurface.sh" "$Case_lc"
        cp "Case_0/extractor.py" "$Case_lc"

        ddir=$(pwd)
        sed -i "s|\$ddir|$ddir|g" "./$Case_lc/extract_freesurface_plane.py"
        sed -i "s|\$ddir|$ddir|g" "./$Case_lc/extract_freesurface.py"

        # Copia un archivo dentro de la carpeta
        archivo_geo="Case_0/flume.geo"
        archivo_geoi="flume_Case_$lc_sanitizado.geo"
        touch "$archivo_geo"
        cp "$archivo_geo" "$Case_lc/$archivo_geoi"

        # Realiza el intercambio en el archivo
        sed -i "s/\$lcc/$lc/g" "$Case_lc/system/blockMeshDict"
        sed -i "s/\$i/lc$lc_sanitizado/g" "$Case_lc/extract_freesurface_plane.py"
        sed -i "s/\$i/lc$lc_sanitizado/g" "$Case_lc/extractor.py"

        #Generar mallado gmsh
        cd "$Case_lc/"
        # gmsh "$archivo_geoi" -3

        #Genera mallado OpenFoam
        # gmshToFoam "flume_Case_$lc_sanitizado.msh"

        #Lineas a eliminar en polymesh/boundary
        # lineas_eliminar=("24" "30" "36" "42" "48" "54")

        #Itera sobre las líneas a eliminar y utiliza sed para quitarlas
        # for numero_linea in "${lineas_eliminar[@]}"; do
        #   sed -i "${numero_linea}d" "constant/polyMesh/boundary"
        # done

        # Reemplaza "patch" por "wall"
        # sed -i '29s/patch/wall/; 35s/patch/wall/ ' "constant/polyMesh/boundary"
        # sed -i '23s/patch/empty/ ' "constant/polyMesh/boundary"
        blockMesh
        setFields
        decomposePar
        mpirun -np 6 interIsoFoam -parallel >log
        kitty --hold -e bash -c "./extract_freesurface.sh && python3 extractor.py && rm -r ./proce*; exec bash" &
        cd ..
      done
      cd ../..
    done
    # Incrementa el índice en 2 para el siguiente par de valores de 'a'
    index_a=$((index_a + 2))
  fi
done
echo "Proceso completado."
