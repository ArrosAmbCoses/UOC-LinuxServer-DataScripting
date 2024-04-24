#! /usr/bin/awk -f
#Nom i cognoms de l'alumne: Àlex Franco Granell
#Usuari de la UOC de l'alumne: afrancogranell
#Data: 03/06/2022

#Objectius de l'script: 
# Transformació final de les dades per tal de fer els calculs pertinents a l'script C
# Es trasposen dades i en general es busca una presentació preparada per generar el document HTML

#Nom i tipus dels camps manipulats: 
# Col index (String / Integer):
# S'elimina del resultat final. S'utilitza per iterar.

# Comunidades Autónomas (String):
# Es simplifica el dataset per tal que es mostren sols com capçalera, i no per cada registre.

# Días trabajados en el domicilio familiar (String):
# Es trasposen les dades a la primera columna.

# Periodo (Integer):
# Es cavia l'aparició de les dades de files a columnes, per poder observar ràpidament la 
# diferència entre l'any més gran i el més menut. El més any està guardat a la 2na columna,
# i el més menut a la 3ra.

# Total (Float):
# Es trasposen les dades del any menut a la 3ra columna.

# S'hi modifiquen els documents anteriors segons quin siga.

# Hi han moltes sentències if a més d'unes quantes seleccions per regex.

	BEGIN {
		# Primerament declare els anys i lloc relatius a l'arxiu que llig:
		any1="0";
		any2="0";
		pais="";
		comunitat1="";
		comunitat2="";
		
		# Després declare els tipus de treball que hi ha, ordenat de major a menor nombre de dies treballats/teletreballats
		ListaDies = "Total,Més de la meitat dels dies treballats,Ocasionalment,Cap dia,No ho sap"
		split(ListaDies, DiesTreballats, ",") 

	}	
	{
       	# Dividisc el dataset d'entrada en les seues columnes. Agafe sols les que m'interessen.
       	split($0,arr,";");
       	indx=arr[1]
       	comunitat=arr[2];
       	Dies=arr[4];
  	        Periode=arr[5];
  	        total=arr[6];
  	        
  	        # Assigne els anys corresponents:
  	        if (any1=="0"){
  	        	any1=Periode}
  	        else {
  	        	any2=Periode
  	        }
  	        
  	        # Assigne zones corresponents:
  	        if (indx ~ /[a-zA-Z]/){ # Si l'index correspon al d'espanya:
  	        	pais=comunitat} # S'assigna el valor d'espanya a pais
  	        else { # si no és espanya és una autonomia
  	        	if ((indx ~ /^[1-9][0-9]*/)&&(comunitat1 == "")){ # Si la autonomia 1 està buida i és un nombre (index d'autonomia)
  	        		comunitat1=comunitat} # S'assigna el lloc a autonomia 1
  	        	else {
  	        		comunitat2=comunitat # Si l'autonomia 1 no està buida, assignem a autonomia 2 el valor actual
  	        	}
  	        }
  	        
  	        # Faig la selecció de valors segons el seu lloc:     
  	        if (comunitat==pais){	# Si és espanya guarde en un array els valors segons l'any
				ValorsEs[Dies,0]=Dies; # Index dels dies treballats
				if (Periode==any1) ValorsEs[Dies,1]= (total)+0.0; # any major (m'assegure que agafa el valor com nombre)
	 			if (Periode==any2) ValorsEs[Dies,2]= (total)+0.0; # any menor (m'assegure que agafa el valor com nombre)		
		}
		else
		if (comunitat==comunitat1){ # Si és la primera autonomia faig com a espanya
				ValorsC1[Dies,0]=Dies;
				if (Periode==any1) ValorsC1[Dies,1]= (total)+0.0;
	 			if (Periode==any2) ValorsC1[Dies,2]= (total)+0.0;	 		
		} else { # Si no és la primera autonomia ha de ser la segona
				ValorsC2[Dies,0]=Dies;
				if (Periode==any1) ValorsC2[Dies,1]= (total)+0.0;
	 			if (Periode==any2) ValorsC2[Dies,2]= (total)+0.0;	
		}
	}
	END {
		# Finalment imprimiré els valors en documents diferents segons el document d'entrada
		if ( FILENAME ~ /.*td.*$/) { # Si són les dades de les dones:
			# Imprimisc el lloc i el sexe corresponent
			printf("%s;; \n", pais)>>"./valdones.csv";
			# Imprimisc la capçalera dels anys
			printf("%s;%s;%s \n", "Dies treballats",any1, any2)>>"./valdones.csv";
			# Imprimisc tots els valors guardats a l'array de cada lloc
			for (x in DiesTreballats ){
			     printf("%s;%s;%s \n",DiesTreballats[x], ValorsEs[DiesTreballats[x],1], ValorsEs[DiesTreballats[x],2] )>>"./valdones.csv";
			}
			# Repetim l'anterior per la comunitat 1
			printf("%s;; \n", comunitat1)>>"./valdones.csv";
			printf("%s;%s;%s \n", "Dies treballats",any1, any2)>>"./valdones.csv";
			for (x in DiesTreballats ){
			     printf("%s;%s;%s \n",DiesTreballats[x], ValorsC1[DiesTreballats[x],1], ValorsC1[DiesTreballats[x],2] )>>"./valdones.csv";
			}
			# Repetim l'anterior per la comunitat 2
			printf("%s;; \n", comunitat2)>>"./valdones.csv";
			printf("%s;%s;%s \n", "Dies treballats",any1, any2)>>"./valdones.csv";
			for (x in DiesTreballats ){
			     printf("%s;%s;%s \n",DiesTreballats[x], ValorsC2[DiesTreballats[x],1], ValorsC2[DiesTreballats[x],2] )>>"./valdones.csv";
			}
		}
		# Si són les dades dels homens:
		if ( FILENAME ~ /.*th.*$/) {
			printf("%s;; \n", pais)>>"./valhomes.csv";
			printf("%s;%s;%s \n", "Dies treballats",any1, any2)>>"./valhomes.csv";
			for (x in DiesTreballats ){
			     printf("%s;%s;%s \n",DiesTreballats[x], ValorsEs[DiesTreballats[x],1], ValorsEs[DiesTreballats[x],2] )>>"./valhomes.csv";
			}
			printf("%s;; \n", comunitat1)>>"./valhomes.csv";
			printf("%s;%s;%s \n", "Dies treballats",any1, any2)>>"./valhomes.csv";
			for (x in DiesTreballats ){
			     printf("%s;%s;%s \n",DiesTreballats[x], ValorsC1[DiesTreballats[x],1], ValorsC1[DiesTreballats[x],2] )>>"./valhomes.csv";
			}
			printf("%s;; \n", comunitat2)>>"./valhomes.csv";
			printf("%s;%s;%s \n", "Dies treballats",any1, any2)>>"./valhomes.csv";
			for (x in DiesTreballats ){
			     printf("%s;%s;%s \n",DiesTreballats[x], ValorsC2[DiesTreballats[x],1], ValorsC2[DiesTreballats[x],2] )>>"./valhomes.csv";
			}
		}
		# Si són les dades totals:
		if ( FILENAME ~ /.*tt.*$/) {
			printf("%s;; \n", pais)>>"./valtot.csv";
			printf("%s;%s;%s \n", "Dies treballats",any1, any2)>>"./valtot.csv";
			for (x in DiesTreballats ){
			     printf("%s;%s;%s \n",DiesTreballats[x], ValorsEs[DiesTreballats[x],1], ValorsEs[DiesTreballats[x],2] )>>"./valtot.csv";
			}
			printf("%s;; \n", comunitat1)>>"./valtot.csv";
			printf("%s;%s;%s \n", "Dies treballats",any1, any2)>>"./valtot.csv";
			for (x in DiesTreballats ){
			     printf("%s;%s;%s \n",DiesTreballats[x], ValorsC1[DiesTreballats[x],1], ValorsC1[DiesTreballats[x],2] )>>"./valtot.csv";
			}
			printf("%s;; \n", comunitat2)>>"./valtot.csv";
			printf("%s;%s;%s \n", "Dies treballats",any1, any2)>>"./valtot.csv";
			for (x in DiesTreballats ){
			     printf("%s;%s;%s \n",DiesTreballats[x], ValorsC2[DiesTreballats[x],1], ValorsC2[DiesTreballats[x],2] )>>"./valtot.csv";
			}
		}
	}
