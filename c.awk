#! /usr/bin/awk -f
#Nom i cognoms de l'alumne: Àlex Franco Granell
#Usuari de la UOC de l'alumne: afrancogranell
#Data: 05/06/2022

#Objectiu: Generar un html a partir del resultat de les transformacions anteriors. Calcular la variació anual de cada lloc i la proporció de cada tipus de treballador al context espanyol.

#Nom i tipus dels camps d'entrada:
# Comunidades Autonomas (String)
# Días trabajados en el domicilio familiar (String)
# Periodo (Integer)
# Total (float) 

#Operacions realitzades:
# Es calcula la variació anual, i dues proporcions (de cada any) de les autonomies segons el pes que tenen a espanya per tipus de treballador
# Pel que fa a l'html, es genera una capçalera amb el gènere corresponent, es destaquen les autonomies i espanya, i es guarda en negreta la capçalera de cada taula.

#Nom i tipus de els nou camps generats:
# Variació anual (String): Realment és un float però al tenir el % inserit s'interpreta com string
# Proporció 'Any1' (String): igual que l'anterior, realment és un float
# Proporció 'Any2' (String): ==

# Mostre que els camps realment són float perquè amb prous facilitats es podria eliminar el %
# del print i ja funcionarien com a tal. Per a l'informe, però, trobe que aporta qualitat el fet d'imprimir el %, ja que és més visual

BEGIN {
	# Primerament guarde el gènere del document i prepare el títol
	sexe="";	    	
	Titol="Teletreball fet per ";    	
	printf("<!DOCTYPE html>\n<html>\n<head>\n")

	# Guarde a una array les diferents amplituds de la taula html
	split("80,80,150,150,150,", widths, ",");
	
	# Guarde el nom del document per imprimir el gènere correcte al títol
	if ( ARGV[1] ~ /.*dones.*$/) {sexe="Dones"};
	if ( ARGV[1] ~ /.*homes.*$/) {sexe="Homes"};
	if ( ARGV[1] ~ /.*tot.*$/) {sexe="Ambdós Sexes"};
	
	# Prepare l'estil de l'html
	print "<style>\n"
	print ".my_table {font-size:8.0pt; font-family:\"Verdana\",\"sans-serif\"; border-bottom:3px double black; border-collapse: collapse; }\n"
	print ".my_table tr.header{border-bottom:3px double black;}\n"			
	print "h2   {color: blue;}\n"
	print "p    {color: red;}\n"
	# Estil de l'alineació de les cel·les de la taula
	print ".right { text-align: right; margin-right: 1em;}\n"
	print ".left  { text-align: left; margin-left: 1em;}\n"
	print "</style>\n"
	print "</head>\n<body>\n"
	
	# Mostre el títol
	printf("<h1><p>%s %s</p></h1>",Titol,sexe);	

	# Contador per saber en quin tipus de treballador es tracta
	LineaDies = 0;	
	}	
	{
	# Guarde les columnes del csv d'entrada
	split($0,arr,";");
	v0=arr[1];
	v1=arr[2];
	v2=arr[3];

	if (v1=="") { # Si és la primera línia és un lloc nou 
		comunitat=arr[1];  
		if (comunitat!="Espanya") printf ("</table>\n"); # Si és una autonomia tanque la taula d'Espanya
		printf("\n<h2>%s</h2>\n",comunitat); # Pose després el nom de la comunitat actual
		LineaDies=0;

	} else { # Si no és un lloc nou, estem a una taula
		if (v0=="Dies treballats") { # Segona línia de la taula (capçalera taula)
			# Guarde els anys
			any1=v1
			any2=v2
			# Imprimisc la capçalera de la taula
			printf "<table class=\"my_table\">\n"
			printf "<tr class=\"header\">\n"
			
			if (comunitat=="Espanya")   # Si és espanya imprimisc les columnes corresponents a espanya
				printf "<th class=left>%s</th><th class=right>%s</th><th class=right>%s</th><th class=right>Variació anual</th>",v0,v1,v2;
			else # Si no és espanya imprimisc les columnes corresponents a una autonomia
				printf "<th class=left>%s</th><th class=right>%s</th><th class=right>%s</th><th class=right>Variació anual</th><th class=right>Proporció %s</th><th class=right>Proporció %s</th>",v0,v1,v2,v1,v2;
			printf "\n</tr>"; 
		} else { # Si és la tercera línia o més (dades taula)
			if (v1!="") { # M'assegure que no és la primera línia
				if (comunitat=="Espanya") { # Si és Espanya calcule la variació anual i imprimisc les dades de la fila      					   			       				
		       			printf "<tr>\n";
		       			printf "<td width=\"" widths[0] "\" class=left> %s </td>\n", v0;
						printf "<td width=\"" widths[1] "\" class=right> %s </td>\n", v1;
						printf "<td width=\"" widths[2] "\" class=right> %s </td>\n", v2;  
						# Calcule la variació 
						variacio=(v1/v2-1)*100;
						printf "<td width=\"" widths[3] "\" class=right> %.2f % </td>\n", variacio; 
		       			printf "</tr>\n";
		       			
		       			# Guarde dades de Espanya
		       			ValorsEs[LineaDies,0]=v1;
		       			ValorsEs[LineaDies,1]=v2;
		       			LineaDies++;		       			
		       			
		       		} else { # Si no és Espanya calcule la variació anual i la proporcio amb Espanya. I imprimisc les dades de la fila
		       		
		       			printf "<tr>\n";
		       			printf "<td width=\"" widths[0] "\" class=left>%s </td>\n", v0;
						printf "<td width=\"" widths[1] "\" class=right> %s </td>\n", v1;
						printf "<td width=\"" widths[2] "\" class=right> %s </td>\n", v2;  
						# Calcule la variació
						variacio=(v1/v2-1)*100;
						printf "<td width=\"" widths[3] "\" class=right> %.2f %</td>\n", variacio; 
						# Calcule la proporció respecte Espanya
						VariaAny1=v1*100/ValorsEs[LineaDies,0];
						VariaAny2=v2*100/ValorsEs[LineaDies,1];
						printf "<td width=\"" widths[4] "\"  class=right > %.2f % </td>\n", VariaAny1; 
						printf "<td width=\"" widths[5] "\"  class=right> %.2f % </td>\n", VariaAny2; 
						LineaDies++;
		       			printf "</tr>\n";
		       		}
			}
		}
	}	
	}
	END {
		# Imprimisc el final del document
		print "</table>"
		printf("</body></html>");
	}
# Referències:
# https://www.cyberciti.biz/faq/how-to-print-filename-with-awk-on-linux-unix/
# https://stackoverflow.com/questions/41676045/how-to-format-text-in-html-using-awk
# https://www.w3schools.com/html/html_tables.asp
# https://www.w3schools.com/html/html_styles.asp
