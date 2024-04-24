#! /usr/bin/awk -f
#Nom i cognoms de l'alumne: Àlex Franco Granell
#Usuari de la UOC de l'alumne: afrancogranell
#Data: 01/06/2022

#Objectius de l'script: 
# Es vol tenir unes dades llestes per poder-les inserir al informe i poder operar correctament amb elles
# Traducció de camps, correcció de valors, comprovació de nuls

#Nom i tipus dels camps manipulats:
# Comunidades Autónomas (String):
# Es tradueix el camp, es comprova si és nul. Es separa en dues columnes per la selecció correcta posterior.

# Sexo (String):
# Es tradueix el camp de gènere. Es comprova si és nul

# Días trabajados en el domicilio familiar (String):
# Es tradueix el camp que indica l'ocupació. Es comprova si és nul

# Periodo (Integer):
# Es comprova si és nul

# Total (Float):
# Es formaten tots els nombres per otorgar un format uniforme a tots ells.
# El format escollit per als valors és en milers amb punt i sense puntuació per als milions.
# Es comprova si el camp de valors té nuls.

# Finalment s'imprimeixen les dades segons el document inserit (per gènere)
# Si hi ha nuls s'avisa a l'usuari dels possibles errors que puguen sorgir al programa.
# Es modifiquen els nuls per tal de poder-los detectar fàcilment amb una inspecció visual

# Hi ha un bucle i unes quantes transformacions.

	BEGIN {
		# Separe la línia per ;
		FS=OFS=";";
		# Referència: https://unix.stackexchange.com/questions/704050/awk-split-input-csv-into-multiple-output-files-based-on-contents-of-1-column
		documentsexe=""
		contnuls=0
	}
	{
		# Declare ací les columnes del csv
       	lloc=$1;
       	genere=$2;
       	dada=$3;
  	        any=$4;
  	        valor=$5;
  	        
  	        # Faig la traducció del gènere i assigne el valor del document
  	        documentsexe=genere
  	        if (genere ~ /^Ambos .*/) {
  	        	genere="Ambdós Sexes"
  	        	}
  	        if (genere ~ /^H.*/) {
  	        	genere="Homens"
  	        	}
  	        if (genere ~ /^M.*/) {
  	        	genere="Dones"
  	        	}
  	        
  	        #Faig la traducció del tipus de treball (total no cal)
  	        if (dada ~ /^Oc.*/) {
  	        	dada="Ocasionalment"
  	        	}
  	        if (dada ~ /^Más .*/) {
  	        	dada="Més de la meitat dels dies treballats"
  	        	}
  	        if (dada ~ /^Ningún .*/) {
  	        	dada="Cap dia"
  	        	}
  	        if (dada ~ /^No .*/) {
  	        	dada="No ho sap"
  	        	}

		# Faig la traducció del lloc i separe la columna
  	        if (lloc ~ /^Total .*/) {
  	        	lloc="T;Espanya"
  	        	}
  	        if (lloc ~ /^01 .*/) {
  	        	lloc="1;Andalusia"
  	        	}
  	        if (lloc ~ /^02 .*/) {
  	        	lloc="2;Aragó"
  	        	}
  	        if (lloc ~ /^03 .*/) {
  	        	lloc="3;Principat d'Astúries"
  	        	}
  	        if (lloc ~ /^04 .*/) {
  	        	lloc="4;Illes Balears"
  	        	}
  	        if (lloc ~ /^05 .*/) {
  	        	lloc="5;Illes Canàries"
  	        	}
  	        if (lloc ~ /^06 .*/) {
  	        	lloc="6;Cantàbria"
  	        	}
  	        if (lloc ~ /^07 .*/) {
  	        	lloc="7;Castella i Lleó"
  	        	}
  	        if (lloc ~ /^08 .*/) {
  	        	lloc="8;Castella la Manxa"
  	        	}
  	        if (lloc ~ /^09 .*/) {
  	        	lloc="9;Catalunya"
  	        	}
  	        if (lloc ~ /^10 .*/) {
  	        	lloc="10;País Valencià"
  	        	}
  	        if (lloc ~ /^11 .*/) {
  	        	lloc="11;Extremadura"
  	        	}
  	        if (lloc ~ /^12 .*/) {
  	        	lloc="12;Galícia"
  	        	}
  	        if (lloc ~ /^13 .*/) {
  	        	lloc="13;Comunitat de Madrid"
  	        	}
  	        if (lloc ~ /^14 .*/) {
  	        	lloc="14;Múrcia"
  	        	}
  	        if (lloc ~ /^15 .*/) {
  	        	lloc="15;Navarra"
  	        	}
  	        if (lloc ~ /^16 .*/) {
  	        	lloc="16;País Basc"
  	        	}
  	        if (lloc ~ /^17 .*/) {
  	        	lloc="17;La Rioja"
  	        	}
  	        if (lloc ~ /^18 .*/) {
  	        	lloc="18;Ceuta"
  	        	}
  	        if (lloc ~ /^19 .*/) {
  	        	lloc="19;Melilla"
  	        	}
  	        
  	        # Ara corregisc la columna de les dades:
  	        # Si té sols una coma sense decimals
  	        if ((valor ~ /[0-9]{1,20},/)&&!(valor ~ /\./)&&!(valor ~ /[0-9]{1,20},[0-9]/))  {
  	        	gsub(/,/,"",valor)
  	        	}
  	        # Si té dos punts sense decimals
  	        if ((valor ~ /[0-9]+\.[0-9]{3}\./)&&!(valor ~ /,[0-9]/))  {
  	        	gsub(/\./,"",valor)
  	        	gsub(/,/,"",valor)
  	        	}
  	        # Si té dos punts i decimals
  	        if ((valor ~ /[0-9]+\.[0-9]{3}\.[0-9]/)||(valor ~ /[0-9]+\.[0-9]{3},[0-9]/)) {
  	        	gsub(/,/,".",valor)
  	        	sub(/\./,"",valor)
  	        	}
  	        # Si té una coma i decimals
  	        if (!(valor ~ /[0-9]+\.[0-9]{3}\.[0-9]/)&&(valor ~ /[0-9]{1,3}\.[0-9]/)||(valor ~ /[0-9]{1,3},[0-9]/)&&!(valor ~ /.*\.[0-9]{2,3}/)) {
  	        	gsub(/,/,".",valor)
  	        	}
  	        # Si és un integer major de 1000
  	        if (!(valor ~ /[0-9]+\.[0-9]{3}\.[0-9]/)&&(valor ~ /[0-9]{1,3}\.[0-9]{3}/)&&!(valor ~ /[0-9]{1,3}\.[0-9]{2}0/)) {
  	        	gsub(/\./,"",valor)
  	        	}
  	        # Si té un punt i dos decimals s'interpreta que és un milio (Error detectat a Dones 2019 de Espanya)
  	        if (valor ~ /[0-9]\.[0-9]{2}/) {
  	        	valor=valor*1000
  	        	}
  	       
  	        # Corregisc els buits
  	        if (( lloc == "")||( lloc == " ")) {
  	        	lloc="Nul"
  	        	}
  	        if (( genere == "")||( genere == " ")) {
  	        	genere="Nul"
  	        	}
  	        if (( dada == "")||( dada == " ")) {
  	        	dada="Nul"
  	        	}
  	        if (( any == "")||( any == " ")||( any == "..")) {
  	        	any="Nul"
  	        	}
  	        if ( valor == "..") {
  	        	valor="Nul"
  	        	}
  	       
  	        # Faig un bucle per contar els nuls de cada línia
  	        { i = 0 }
  	        { while (i < 5 )
  	        	{ i++ ; if ( $i ~ /\.\./) { # Els nuls estan marcats com ..
  	        		contnuls++
  	        		};
  	        		if (( $i == "")||( $i == " ")) { # Si hi ha espais buits
  	        		contnuls++
  	        		}
  	        	}
  	        }
  	        
  	        # Ara, segons el sexe del document, imprimiré les dades a un csv traduit
  	        if (documentsexe ~ /^Ambos .*/) {
  	        	printf "%s;%s;%s;%s;%s\n",lloc,genere,dada,any,valor >> "./ttotes.csv"
  	        	}
  	        if (documentsexe ~ /^H.*/) {
  	        	printf "%s;%s;%s;%s;%s\n",lloc,genere,dada,any,valor >> "./thomens.csv"
  	        	}
  	        if (documentsexe ~ /^M.*/) {
  	        	printf "%s;%s;%s;%s;%s\n",lloc,genere,dada,any,valor >> "./tdones.csv"
  	        	}
	}
	END {
		# Finalment, si trobe nuls imprimisc l'advertència a l'usuari
		if (contnuls > 0) {
			print "Atenció! S'han detectat nuls al dataset. Possible causa d'error al realitzar els càlculs."
			printf "En total s'han detectat %s valors nuls.\n", contnuls
			printf "Seria convenient revisar el document de traducció de %s per saber com actuar.\n",documentsexe
  	        	}
	}
