#!/bin/bash
#Nom i cognoms de l'alumne: Àlex Franco Granell
#Usuari de la UOC de l'alumne: afrancogranell
#Data: 31/05/2022

#Objectius de l'script:
# Es vol una primera simplificació de les dades per al seu posterior tractament.
# Filtrar per any, filtrar per Comunitat, Filtrar per gènere per generar tres documents diferents

#Nom i tipus dels camps manipulats:
# Sexo (String):
# Es trasposa la columna de gènere. Passa de la 1 a la 2 i viceversa.

# Periodo (Integer):
# Es filtra per any.

# Comunidades Autónomas (String):
# Es filtra per comunitat autònoma i espanya.

# Sexo (String):
# Es generen tres documents diferents a partir del gènere.

# Hi ha un total de 8 filtratges

# Es pot canviar els anys observats modificant els seguents valors:
anyactual='2021'
anyanterior='2019'


# Index per seleccionar autonomies:
# 01 Andalusia
# 02 Aragó
# 03 Astúries
# 04 Illes Balears
# 05 Canàries
# 06 Cantàbria
# 07 Castella i lleó
# 08 Castella la mancha
# 09 Catalunya
# 10 País Valencià
# 11 Extremadura
# 12 Galícia
# 13 Madrid
# 14 Múrcia
# 15 Navarra
# 16 País Basc
# 17 La Rioja
# 18 Ceuta
# 19 Melilla

# Es pot canviar d'autonomia modificant el codi d'index:
autonomia1='^09 .*'
autonomia2='^10 .*'
espanya='Total Nacional'


# Bucle demanat
while IFS=";" read -r col1 col2 col3 col4 col5
do
	# Selecció d'any:
	if (( $col4 == $anyactual )) || (( $col4 == $anyanterior )); then
	# Selecció d'autonomia:
	if [[ $col2 =~ $espanya ]] || [[ $col2 =~ $autonomia1 ]] || [[ $col2 =~ $autonomia2 ]];
	then
	# Filtratge per gènere:
	if [[ $col1 =~ 'Ambos sexos' ]]; then
	echo "$col2;$col1;$col3;$col4;$col5" >> ./dtotes.csv
	elif [[ $col1 =~ 'Hombres' ]]; then
	echo "$col2;$col1;$col3;$col4;$col5" >> ./dhomes.csv
	elif [[ $col1 =~ 'Mujeres' ]]; then
	echo "$col2;$col1;$col3;$col4;$col5" >> ./ddones.csv
	fi # Acaba el filtratge per gènere
	fi # Acaba el filtratge per autonomia
	fi # Acaba el filtratge per any
done < <(tail -n +2 $1)

# Nota: Hi ha 5 sentències if per filtrar les dades, però en conjunt s'opera 8 vegades.
# Trobe que s'hauria de contar com 8 transformacions perquè he volgut deixar el codi senzill.
# Perfectament haguera pogut generar un condicional per cadascun i després unir-los als documents
# de gènere, però crec que el codi així és més bonic. No voldria enredrar-lo a propòsit.
