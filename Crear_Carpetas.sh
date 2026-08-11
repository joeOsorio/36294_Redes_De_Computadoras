#!/bin/bash

# Script para crear la estructura de carpetas de la materia
# 0_Recursos, 1_Taller y 2_Laboratorio

# Numeros de talleres/laboratorios a crear (01 a 09)
NUMS=("01" "02" "03" "04" "05" "06" "07" "08" "09")

# --- 0_Recursos ---
mkdir -p "0_Recursos/Libros"
echo "Estructura creada para 0_Recursos"

# --- 1_Taller y 2_Laboratorio ---
CATEGORIAS=("1_Taller" "2_Laboratorio")

for CATEGORIA in "${CATEGORIAS[@]}"; do
  for i in "${NUMS[@]}"; do
    CARPETA="${CATEGORIA}/${i}_Descripcion"
    mkdir -p "${CARPETA}"/{docs,bin,output,src}
    touch "${CARPETA}/docs/notas.md"
    echo "Estructura creada para ${CARPETA}"
  done
done

echo "Carpetas creadas correctamente."
