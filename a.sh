#!/bin/bash
#Nom i cognoms de l'alumne: Àlex Franco Granell
#Usuari de la UOC de l'alumne: afrancogranell
#Data: 30/05/2022

# Ací es podria modificar el link de ser necessàri:
link='https://www.ine.es/jaxiT3/files/t/csv_bdsc/37024.csv'

# Baixe el document
curl $link > ./dades.csv

# Mostre el link:
echo "L'enllaç de descàrrega és:" $link

# Mostre el nombre de columnes:
columnes=$(head -1 ./dades.csv | sed 's/[^;]//g' | wc -c)
echo "Nombre de columnes:" $columnes
# Referència: https://linuxconfig.org/how-to-count-number-of-columns-in-csv-file-using-bash-shell

# Mostre el nombre de registres:
registres=$(wc -l ./dades.csv | cut -c 1-5)
echo "Nombre de registres:" $registres

# Cree una funció que m'indique el tipus de les dades:
tipusvar () {
	str='^[a-zA-Z]+'
	enter='^[+-]?[0-9]+$'
	numericcoma='^[+-]?[0-9]+\.?([0-9]+)?,[0-9]*'
	numericpunt='^[+-]?[0-9]+\.?([0-9]+)?\.[0-9]*'
	data='^[0-9]{1,2}\-[0-9]{1,2}\-[1-2][0-9]{3}$'
	
	if [[ "$1" =~ $str ]]; then
	echo "String"
	elif [[ "$1" =~ $enter ]]; then
	echo "Integer"
	elif [[ "$1" =~ $numericcoma ]]; then
	echo "Float"
	elif [[ "$1" =~ $numericpunt ]]; then
	echo "Float"
	elif [[ "$1" =~ $data ]]; then
	echo "Date"
	else
	echo "No data"
	# Referència: https://www.codegrepper.com/code-examples/shell/bash+check+data+type
	fi
}

# Cree un argument que genera més informació, com es demana:
while getopts "v" option; do
	case $option in
		v)  # Mostre el tipus de fitxer
		tipus=$(file -b ./dades.csv)
		echo "Tipus de fitxer:" $tipus
		# Mostrar el tipus de les dades
		col1=$(head -2 ./dades.csv | tail -1 | cut -d ';' -f1)
		col2=$(head -2 ./dades.csv | tail -1 | cut -d ';' -f2)
		col3=$(head -2 ./dades.csv | tail -1 | cut -d ';' -f3)
		col4=$(head -2 ./dades.csv | tail -1 | cut -d ';' -f4)
		col5=$(head -2 ./dades.csv | tail -1 | cut -d ';' -f5)
		echo "La primera columna és de tipus:"
		tipusvar $col1;
		echo "La segona columna és de tipus:"
		tipusvar $col2;
		echo "La tercera columna és de tipus:"
		tipusvar $col3;
		echo "La quarta columna és de tipus:"
		tipusvar $col4;
		echo "La quinta columna és de tipus:"
		tipusvar $col5;
		exit;;
	esac
done
# Referència: https://www.delftstack.com/es/howto/linux/use-getopts-in-bash-script/

