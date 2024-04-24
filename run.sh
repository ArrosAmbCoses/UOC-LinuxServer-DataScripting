#!/bin/bash
#Nom i cognoms de l'alumne: Àlex Franco Granell
#Usuari de la UOC de l'alumne: afrancogranell
#Data: 01/06/2022

# Arranque l'script de baixada de les dades:
./a.sh

# Arranque l'script de primer filtratge de les dades:
./b.sh ./dades.csv

echo "S'han filtrat les dades correctament"

# Arranque l'script de traducció i adeqüació de les dades per a cada document de gènere:
gawk -f ./b.awk ./dtotes.csv

gawk -f ./b.awk ./dhomes.csv

gawk -f ./b.awk ./ddones.csv

echo "S'han traduït les dades correctament"

# Estructura final
gawk -f ./b1.awk ./tdones.csv

gawk -f ./b1.awk ./thomens.csv

gawk -f ./b1.awk ./ttotes.csv

echo "S'ha generat l'estructura final correctament"

# Genere els informes en format html
gawk -f ./c.awk ./valdones.csv > TeletreballDones.html

gawk -f ./c.awk ./valhomes.csv > TeletreballHomens.html

gawk -f ./c.awk ./valtot.csv > Teletreball.html

echo "Operació completa."
echo "S'ha generat un informe HTML per gènere de les dades sol·licitades"

# Cree una opció per eliminar els documents de cada pas. La cree senzillament per deixar més neta la carpeta del programa
while getopts "dD" option; do
	case $option in
		d)  # Elimine els arxius secundaris
		rm ./ddones.csv;
		rm ./dhomes.csv;
		rm ./dtotes.csv;
		rm ./tdones.csv;
		rm ./thomens.csv;
		rm ./ttotes.csv;
		rm ./valdones.csv;
		rm ./valhomes.csv;
		rm ./valtot.csv;
		echo "S'han eliminat els documents temporals correctament"
		;;
		D) # Aquest també elimina l'arxiu de dades original
		rm ./dades.csv;
		rm ./ddones.csv;
		rm ./dhomes.csv;
		rm ./dtotes.csv;
		rm ./tdones.csv;
		rm ./thomens.csv;
		rm ./ttotes.csv;
		rm ./valdones.csv;
		rm ./valhomes.csv;
		rm ./valtot.csv;
		echo "S'han eliminat els documents temporals i l'original correctament:"
		exit;;
	esac
done

