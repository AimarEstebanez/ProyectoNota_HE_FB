#!/bin/bash
#FOTPRINTING
#Menu exiftool
function fun_exif (){
	clear
	echo -e "${AZUL}========================${ND}"
	echo -e " ${ROJO}Metadatos con exiftool${ND} "
	echo -e "${AZUL}========================${ND}"
	echo -e "${CIAN}1.${ND} Metadatos de los ficheros de la ruta acutal."
	echo -e "${CIAN}2.${ND} Metadatos de la ruta especifica."
	echo -e "${CIAN}3.${ND} Metadatos de fichero especifico."
	echo -e "${CIAN}4.${ND} The Harvester."
	echo -e "${ROJO}5.Volver atras.${ROJO}"
	echo -e "${AZUL}========================${ND}"
}
#Variables para colorear
NARANJA='\033[0;33m'
AZUL='\033[0;34m'
CIAN='\033[0;36m'
ROJO='\033[0;31m'
ND='\033[0m' # nada	
#copiar de aqui hacia abajo
# | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
# | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
# v v v v v v v v v v v v v v v v v v v v v v v v v v v v v v 
fun_meta_edit(){
	read -p "Introduzca la ruta del fichero: " pathFichero
	until [[ -n $pathFichero && -f $pathFichero ]]; do
		read -p "Introduzca la ruta del fichero: " pathFichero
	done
}

fun_meta_param(){
	read -p "Introduzca el nuevo valor del parametro $1: " valorParametro
	return $valorParametro 2>/dev/null	
}
i_metadatos=0
while true
do
	clear
	echo -e "${AZUL}========================${ND}"
	echo -e "${CIAN}1.${ND}Consultar metadatos."
	echo -e "${CIAN}2.${ND}Modificar metadatos."
	echo -e "${AZUL}========================${ND}"
	read -p $'\e[33mElige una opcion\e[0m: ' i_metadatos 
	case $i_metadatos in
		1)
			echo "CONSULTAR METADATOS"
			#CONSULTAR METADATOS
			i_exif=0
			while true
			do
				fun_exif
				read -p $'\e[33mElige una opcion\e[0m: ' i_exif
				#Case para las funcionalidades del menu
				case $i_exif in
					1)#Metadatos de la ruta actual
						echo "Mostrando los metadatos de los archivos de la ruta actual:"
						exiftool *			
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					2)#Metadatos de la ruta especifica
						read -p "ESpecifique la ruta de la cual quiera obterner los metadatos: " ruta_metadatos
						exiftool $ruta_metadatos/ *			
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					3)#Metadatosm de fichero especifico
						read -p "Especifique el fichero del cual quiera obterner los metadatos: " fichero_metadatos
						exiftool -U $fichero_metadatos			
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					4)#TheHarvester
						echo "THEHARVESTER"
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					5)#Salida del submenu
						break
					;;
					*)
						echo "ERROR: OPCION NO CONTEMPLADA"
						sleep 0.5
					;;
				esac
			done	
		;;
		2)
			#EDITAR METADATOS
			i_editar=0
			while true
			do
				clear
				echo -e "${AZUL}========================${ND}"
				echo -e "${CIAN}1.${ND}Eliminar TODOS los metadatos."
				echo -e "${CIAN}2.${ND}Modificar CREADOR."
				echo -e "${CIAN}3.${ND}Modificar AUTOR."
				echo -e "${CIAN}4.${ND}Modificar IDIOMA."
				echo -e "${CIAN}5.${ND}Modificar FECHA DE CREACION."
				echo -e "${ROJO}6.Volver atras.${ND}"
				echo -e "${AZUL}========================${ND}"
				read -p $'\e[33mElige una opcion\e[0m: ' i_editar
				case $i_editar in
					1)#Eliminar todos
						
						fun_meta_edit
						exiftool -all= $pathFichero
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;	
					2)#Editar CREATOR
						fun_meta_edit
						fun_meta_param "CREADOR"
						sudo exiftool -creator=$valorParametro $pathFichero
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					3)#Editar AUTHOR
						fun_meta_edit
						fun_meta_param "AUTOR"
						sudo exiftool -author=$valorParametro $pathFichero
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					4)#Editar LANGUAGE
						fun_meta_edit
						fun_meta_param "IDIOMA"
						sudo exiftool -language=$valorParametro $pathFichero
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					5)#Editar CREATE DATE
						fun_meta_edit
						fun_meta_param "FECHA DE CREACION"
						sudo exiftool -createdate=$valorParametro $pathFichero
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					6)#VolverAtras
						break
					;;
					*)
						echo "Opcion no valida"
						sleep 0.5
					;;
				esac
			done
		;;
		*)
			echo "OPCION NO VALIDA"
			sleep 0.5
		;;
	esac
done
###########################################3
#Bucle while para el submenu 
			i_exif=0
			while true
			do
				fun_exif
				read -p $'\e[33mElige una opcion\e[0m: ' i_exif
				#Case para las funcionalidades del menu
				case $i_exif in
					1)#Metadatos de la ruta actual
						echo "Mostrando los metadatos de los archivos de la ruta actual:"
						exiftool *			
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					2)#Metadatos de la ruta especifica
						read -p "ESpecifique la ruta de la cual quiera obterner los metadatos: " ruta_metadatos
						exiftool $ruta_metadatos/ *			
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					3)#Metadatosm de fichero especifico
						read -p "Especifique el fichero del cual quiera obterner los metadatos: " fichero_metadatos
						exiftool $fichero_metadatos			
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					4)#TheHarvester
						echo "4"
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					5)#Salida del submenu
						break
					;;
					*)
						echo "ERROR: OPCION NO CONTEMPLADA"
						sleep 0.5
					;;
				esac
			done	
