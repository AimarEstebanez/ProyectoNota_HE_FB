#!/bin/bash
#Autor: Aimar Estebanez Gaston
#bash-version:5.2.15(1)-release
#Scrip para la ejecucion de diferentes herramientas.
#FUNCIONES:

#Funcion test existencia fichero
function fun_meta_edit(){
	read -p "Introduzca la ruta del fichero: " pathFichero
	until [[ -n $pathFichero && -f $pathFichero ]]; do
		read -p "Introduzca la ruta del fichero: " pathFichero
	done
}

#Funcion eleccion de parametros en exiftool
function fun_meta_param(){
	read -p "Introduzca el nuevo valor del parametro $1: " valorParametro
	return $valorParametro 2>/dev/null	
}

#Control de nombre de usuarios
function fun_ctrl_usu(){
	local nombre=$1
	while true; do
		#Comprueba si usuario existe
		if id "$nombre" >/dev/null 2>&1; then
			echo $nombre
			break
		else
			read -p "ERROR: el usuario no existe, introduzca uno nuevo: " nombre
		fi
	done
}

#Funcion eleccion de diccionario
function fun_elec_dicc(){
	i_dic=0
			while true
			do
				clear
				fun_menu_general "ATAQUE DE DICCIONARIO"
				fun_menu_fingerprinting_dic "$(whoami)"
				read -p "Indique el diccionario que desea emplear: " i_dic
				
				case $i_dic in 
					1)#Password.lst
						if [[ -e /usr/share/john/password.lst ]]
						then
							pathdiccionario="/usr/share/john/password.lst"
							break
						else
							echo "ERROR: No se encuentra el diccionario"
							sleep 0.5
							break
						fi
					;;
					2)#rockyou.txt
						if [[ -e /home/$(whoami)/rockyou.txt ]]
						then
							pathdiccionario="/home/$(whoami)/rockyou.txt"
							break
						else
							echo "ERROR: No se encuentra el diccionario"
							sleep 0.5
							break
						fi
					;;
					3)#especifica la ruta
						read -p "Introduzca la ruta del diccionario: " pathdiccionario
						until [[ -e $pathdiccionario ]]; do
							read -p "Introduzca la ruta del diccionario: " pathdiccionario
						done
						break
					;;
					4)
						break
					;;
					*)
						echo "Opcion no valia"
						sleep 0.5
					;;
				esac
			done
			return $pathdiccionario 2>/dev/null
	}

#Menu busqueda de ficheros
function fun_menu_busqueda(){
	echo -e "${CIAN}1.${ND}Busqueda con FIND."
	echo -e "${CIAN}2.${ND}Busqueda con LOCATE."
	echo -e "${CIAN}3.${ND}Busqueda de ejecutable con WHICH."
	echo -e "${CIAN}4.${ND}Busqueda de ejecutable con WHEREIS."
	echo -e "${ROJO}5.Volver atras.${ND} "
	echo -e "${AZUL}========================${ND}"
}

#Menu ataque de diccionaro
function fun_menu_fingerprinting_atac(){
	echo -e "${CIAN}1.${ND}Crear HASH."
	echo -e "${CIAN}2.${ND}Ataque de diccionario con John The Ripper."
	echo -e "${CIAN}3.${ND}Ataque de diccionario con Hascat."
	echo -e "${ROJO}4.Volver atras.${ND} "
	echo -e "${AZUL}========================${ND}"
}

#Menu diccionario
function fun_menu_fingerprinting_dic(){
	echo 			"Eleccion de Diccionario"
	echo -e "${AZUL}========================${ND}"
	echo -e "${CIAN}1.${ND} password.lst en /usr/share/john."
	echo -e "${CIAN}2.${ND} rockyou en /home/$1."
	echo -e "${CIAN}3.${ND} Otro en otra localizacion."
	echo -e "${ROJO}4.Volver atras.${ND} "
	echo -e "${AZUL}========================${ND}"
}

#Menu Modificacion de usuarios
function fun_menu_usr_mod(){
	clear
	fun_menu_general "Modificar usuarios"
	echo -e "${CIAN}1.${ND} Nombre de usuario."	
	echo -e "${CIAN}2.${ND} Cambiar Home."
	echo -e "${CIAN}3.${ND} Fecha de caducidad."
	echo -e "${CIAN}4.${ND} Añadir a grupos."	
	echo -e "${CIAN}5.${ND} Contrasena."	
	echo -e "${CIAN}6.${ND} Shell."	
	echo -e "${CIAN}7.${ND} Bloquear."	
	echo -e "${CIAN}8.${ND} Desbloquear."	
	echo -e "${ROJO}9.${ND} Volver atras."
	echo -e "${AZUL}========================${ND}"
}

#Menu Gestion de usuarios
function fun_menu_usr (){
	clear
	fun_menu_general "Gestion de usuarios"
	echo -e "${CIAN}1.${ND} Crear usuario."
	echo -e "${CIAN}2.${ND} Editar Usuario."
	echo -e "${CIAN}3.${ND} Eliminar usuario."	
	echo -e "${ROJO}4.${ND} Volver atras."
	echo -e "${AZUL}========================${ND}"
}

#Menu Fingerprint
function fun_menu_fingerprinting(){
	echo -e "${CIAN}1.${ND}Herramienta nmap."
	echo -e "${CIAN}2.${ND}Iniciar OpenVas."
	echo -e "${CIAN}3.${ND}Detener OpenVas."
	echo -e "${ROJO}4.Volver atras.${ND}"
	echo -e "${AZUL}========================${ND}"
	}
#Menu metadatos
function fun_menu_footprintin(){
	
	echo -e "${CIAN}1.${ND}Consultar metadatos."
	echo -e "${CIAN}2.${ND}Modificar metadatos."
	echo -e "${CIAN}3.${ND}The Harvester."
	echo -e "${ROJO}4.Volver atras.${ND}"
	echo -e "${AZUL}========================${ND}"
}

#Menu edicion metadatos
function fun_menu_metasploit_edit(){
	echo -e "${CIAN}1.${ND}Eliminar TODOS los metadatos."
	echo -e "${CIAN}2.${ND}Modificar CREADOR."
	echo -e "${CIAN}3.${ND}Modificar AUTOR."
	echo -e "${CIAN}4.${ND}Modificar IDIOMA."
	echo -e "${CIAN}5.${ND}Modificar FECHA DE CREACION."
	echo -e "${ROJO}6.Volver atras.${ND}"
	echo -e "${AZUL}========================${ND}"
	read -p $'\e[33mElige una opcion\e[0m: ' i_editar	
}

#Menu exiftool
function fun_menu_metasploit_show (){
	echo -e "${CIAN}1.${ND} Metadatos de los ficheros de la ruta acutal."
	echo -e "${CIAN}2.${ND} Metadatos de la ruta especifica."
	echo -e "${CIAN}3.${ND} Metadatos de fichero especifico."
	echo -e "${CIAN}4.${ND} The Harvester."
	echo -e "${ROJO}5.Volver atras.${ND}"
	echo -e "${AZUL}========================${ND}"
}

#Menu general 
function fun_menu_general (){
	clear
	echo -e "${AZUL}========================${ND}"
	echo -e "----- ${ROJO}$1${ND} ------"
	echo -e "${AZUL}========================${ND}"
}

#Menu principal 
 function fun_menu_principal (){	 
	clear
	#Parte bonita menu
	figlet -f Double menu
	echo -e "${AZUL}========================${ND}"
	echo -e "--------- ${AZUL}MENU${ND} ---------"
	echo -e "${AZUL}========================${ND}"
	echo -e "${CIAN}1.${ND} Saludar."
	echo -e "${CIAN}2.${ND} Buscador de ficheros."
	echo -e "${CIAN}3.${ND} Ataque de diccionario."
	echo -e "${CIAN}4.${ND} Fingerprinting."
	echo -e "${CIAN}5.${ND} Footprinting."
	echo -e "${CIAN}6.${ND} Gestion de usuarios."
	echo -e "${CIAN}7.${ND} Ataque con metasploit."
	echo -e "${ROJO}8. Salir.${ND}"
	echo -e "${AZUL}========================${ND}"
}

#Variables para colorear
NARANJA='\033[0;33m'
AZUL='\033[0;34m'
CIAN='\033[0;36m'
ROJO='\033[0;31m'
ND='\033[0m' # nada	


#Script:

#Comprobacion Instalacion de paquetes

#Funcionalidad Principal

#Bucle principal del programa
i=0
while true
do
	fun_menu_principal
	
	#Bucle control valor variable i dentro de parametros
		read -p $'\e[33mElige una opcion\e[0m: ' i
	case $i in
		1) #Saludar
			# Elige una de las dos condiciones de manera aleatoria	
			if (( RANDOM % 2 )); 
			then 
				figlet -f Fuzzy Hola campeon
			else 
				figlet -f maxiwi Deja de tocar pesao
			fi
			
			# Confirmacion para avanzar
			read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla			
		;;
		2) #Busqueda de ficheros
			i_fich=0
			while true
			do 
				clear
				fun_menu_general "Busqueda de ficheros"
				fun_menu_busqueda
				read -p $'\e[33mElige una opcion\e[0m: ' i_fich
				case $i_fich in
					1)#Busqueda con find
						echo "BUSCANDO CON FIND: "
						read -p "Intrduzca el nombre del fichero que desea encontrar: " nombrefichero
						find / -name *$nombrefichero* 2>/dev/null
						
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla	
					;;
					2)#Busqueda con locate
						echo "BUSCANDO CON LOCATE:"
						read -p "Intrduzca el nombre del fichero que desea encontrar: " nombrefichero
						sudo updatedb 2>/dev/null
						locate -i $nombrefichero 2>/dev/null
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla	
					;;
					3)#Busqueda Ejecutable con which 
						echo "BUSCANDO EJECUTABLE CON WHICH:"
						read -p "Intrduzca el nombre del ejecutable que desea encontrar: " nombrefichero
						sudo which $nombrefichero 2>/dev/null
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla	
					;;
					4)#Busqueda con whereis
						echo "BUSCANDO EJECUTABLE CON WHEREIS:"
						read -p "Intrduzca el nombre del ejecutable que desea encontrar: " nombrefichero
						sudo whereis $nombrefichero 2>/dev/null
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla	
					;;
					5)
						break
					;;
					*)
						echo "Opcion no valida"
						sleep 0.5
					;;
				esac
			done 		
		;;
		3) #Ataque de diccionario
			i_ataque=0
			while true
			do
				clear
				fun_menu_general "ATAQUE DE DICCIONARIO "
				fun_menu_fingerprinting_atac 
				read -p $'\e[33mElige una opcion\e[0m: ' i_ataque
				case $i_ataque in
					1)#Creacion del hash
						read -p "Introduzca la cadena a HASH-ar: " cadena
						echo -n $cadena | md5sum | awk '{print $1}' > temp.txt  #Fichero temporal
						cat temp.txt
						vhash=$(cat temp.txt) 		
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla	
					;;
					2)#Ataque con JOHN 
						#Comprobacion del tipo de encriptacion
						hashid -m $vhash
						#Control valor variable formato
						read -p "Introduzca el algoritmo [md5, sha1, sha256 o sha512]: " formato
						while [[ "$formato" != "md5" && "$formato" != "sha1" && "$formato" != "sha256" && "$formato" != "sha512" ]]
						do
							echo -e "${ROJO}Opcion incorrecta, introduzca uno de los especificados${ND}"
							read -p "Introduzca el algoritmo [md5, sha1, sha256 o sha512]: " formato
						done 
						
						fun_elec_dicc 
						
						#Ataque de diccionario
						john --wordlist=$pathdiccionario --format=Raw-$formato temp.txt 2>&1>/dev/null
						resultado=$(john --show temp.txt --format=Raw-$formato | cut -d ":" -f2)
						
						#Resultado
						echo "La contrasenia es: $resultado" > $(date '+%F-%H-%S')_resultado.txt
						echo "La contrasenia es: $resultado"
					
						
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla		
					;;
					3)#Ataque con HASCAT
					
						fun_elec_dicc
						
						hashcat -m 0 -a 0 temp.txt $pathdiccionario |grep $vhash| awk -F: '{print "La contrasenia es: " $2}'| grep -v '^$'| head -n 1 > resultado.txt
						cat resultado.txt
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla	
					;;
					4)
						break
					;;
					*)
						echo "Opcion no valida"
						seleep 0.5
					;;
					
				esac
			done
			rm -f temp.txt 2>&1>/dev/null
			#827ccb0eea8a706c4c34a16891f84e7b
			#311020666a5776c57d265ace682dc46d
			#8afa847f50a716e64932d995c8e7435a
		;;
		4) #Fingerprint
			
			i_finger=0
			while true
			do
				clear
				#Menu fingerprint
				fun_menu_general "Fingerprint"
				fun_menu_fingerprinting
				read -p $'\e[33mElige una opcion\e[0m: ' i_finger 
				
				case $i_finger in
					1)#NMAP
						fun_menu_general "NMAP"
						read -p "Especifique el objetivo: " objetivo_nmap
						#Control varible parametros
						read -p "Introduzca el algoritmo [ sX, sC, sV  o sN ]: " parametros
						while [[ "$parametros" != "sX" && "$parametros" != "sC" && "$parametros" != "sV" && "$parametros" != "sN" ]]
						do
							echo -e "${ROJO}Opcion incorrecta, introduzca uno de los especificados${ND}"
							read -p "Introduzca el algoritmo [ sX, sC, sV  o sN ]: " parametros
						done 
						
						echo "Puertos abiertos de la IP: $objetivo_nmap"
						ficheronmap=$(date '+%F-%H-%S')nmap__resultado.txt
						echo "PORT     STATE SERVICE      VERSION" > $ficheronmap
						#Ejecucion comando nmap
						#sudo nmap -$parametros $objetivo_nmap | egrep -e [0-9][0-9]*/ >> $ficheronmap
						sudo nmap -$parametros $objetivo_nmap | grep open >> $ficheronmap
						cat $ficheronmap
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla	
					;;
					2)#Iniciar OpenVas
						fun_menu_general "OPENVAS"
						sudo gvm-start 
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					3)#Detener OpenVas
						sudo gvm-stop 2>&1>/dev/null
						echo "Openvas detenido"
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					4)
						break
					;;
					*)
						echo "Opcion no valida"
						seleep 0.5
					;;
				esac
			done
						
									
					
		;;
		5) #Footprinting			
			i_metadatos=0
			while true
			do
				fun_menu_general "FOOTPRINTING"
				fun_menu_footprintin
				read -p $'\e[33mElige una opcion\e[0m: ' i_metadatos 
				case $i_metadatos in
					1)
						echo "CONSULTAR METADATOS"
						#CONSULTAR METADATOS
						i_exif=0
						while true
						do
							fun_menu_general "FOOTPRINTING"
							fun_menu_metasploit_show
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
							fun_menu_general "FOOTPRINTING"
							fun_menu_metasploit_edit
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
					3)#THE HARVESTER
						fun_menu_general "THE HARVESTER"
						
						read -p "Introduzca el dominio objetivo: " dominioObjetivo
						
						read -p "Introduzca el algoritmo [ bing, brave, yahoo o duckduckgo ]: " buscador
						while [[ "$buscador" != "bing" && "$buscador" != "brave" && "$buscador" != "yahoo" && "$buscador" != "duckduckgo" ]]
						do
							echo -e "${ROJO}Opcion incorrecta, introduzca uno de los especificados${ND}"
							read -p "Introduzca el algoritmo [ bing, brave, yahoo o duckduckgo ]: " buscador
						done 
						
						read -p "Introduzca la cantidad de busquedas que desea hacer: " numeroBusquedas
						
						sudo theHarvester -d $dominioObjetivo -l $numeroBusquedas -b $buscador
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					4)
						break
					;;
					*)
						echo "OPCION NO VALIDA"
						sleep 0.5
					;;
				esac
			done
		;;
		6) #Gestion de usuarios
			#While para el submenu de usuarios
			i_usu=0
			while true
			do
				fun_menu_usr
				read -p $'\e[33mElige una opcion\e[0m: ' i_usu
				case $i_usu in
					1)#Creacion de usuario
						fun_menu_general "Ceracion de usuario"
					
						read -p "Introduzca el nombre de usuario: " nombreusuario
						read -sp "Introduzca la contrasenia: " contrasena
						echo " "
						read -sp "Repita la contrasenia: " contrasena2
						
						#Comprobacion contrasenia
						if [ "$contrasena" = "$contrasena2" ]
						then 
							contrasena=$(openssl passwd $contrasena)
							sudo useradd $nombreusuario --password $contrasena					
						else
							echo "Las contrasenas no coinciden"
						fi
					
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					2)#Modificar usuario
						fun_menu_general "modifica usuario"
						i_usu_mod=0
						while true
						do 
							fun_menu_usr_mod
							read -p $'\e[33mElige una opcion\e[0m: ' i_usu_mod
							case $i_usu_mod in
							1) #Cambio de nombre 
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreviejo
								
								#Comprovacion si usuario existe
								nombreviejo=$(fun_ctrl_usu "$nombreviejo")
								read -p "Introduzca el nuevo nombre de usuario: " nuevonombre
								
								sudo usermod -l $nuevonombre $nombreviejo
								echo "NOMBRE DE USUARIO ACTUALIZADO"
				
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							2)#Cambiar HOME
								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								#Comprovacion directorio existe
								read -p "Introduzca la ruta del nuevo home del usuario: " nuevohome
								until [[ -n $nuevohome && -d $nuevohome ]]; do
									read -p "Introduzca la ruta del nuevo home del usuario: " nuevohome
								done
								
								#Cambio
								sudo usermod --home $nuevohome $nombreusu
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							3)#Fecha caducidad
								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								#Comprovacion fecha en formato YYYY-MM-DD
								read -p "Introduzca la nueva fecha de caducidad en formato YYYY-MM-DD: " fechacad
								if [[ $fechacad =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && date -d "$fechacad" >/dev/null 2>&1
								then
									echo "Modificando usuario: "
									sudo usermod --expiredate $fechacad $nombreusu
								else 
									echo "Fecha no valida o en formato incorrecto"
								fi
								#comprobacion con chage -l
								
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							4)#Añadir a grupo
								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								read -p "Introduzca los grupos a los que quiere añadir: " grupos 
								sudo usermod -a --groups $grupos $nombreusu
								
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							5)#Contraseña
								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								#Peticion de contraseñas a usuario	
								read -sp "Introduzca la contrasenia: " contrasena
								echo " "
								read -sp "Repita la contrasenia: " contrasena2
								echo ""
								
								#Comprobacion contrasenia
								if [ "$contrasena" = "$contrasena2" ]
								then 
									contrasena=$(openssl passwd $contrasena)
									sudo usermod --password $contrasena $nombreusu					
								else
									echo "Las contrasenas no coinciden"
								fi
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							6)#Cambio de shell

								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								#Comprovacion de shell correcta
								read -p "Introduzca la nueva shell para el usuario [/bin/bash, /bin/sh, /bin/zsh]: " nuevashell
								while [[ "$nuevashell" != "/bin/bash" && "$nuevashell" != "/bin/sh" && "$nuevashell" != "/bin/zsh" ]]
								do
									echo -e "${ROJO}Opcion incorrecta, introduzca una de los especificados${ND}"
									read -p "Introduzca la nueva shell para el usuario [/bin/bash, /bin/sh, /bin/zsh]: " nuevashell
								done 
								
								sudo usermod --shell $nuevashell $nombreusu 
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							7)#Bloquear	
								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								sudo usermod --lock $nombreusu
								
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							8)#Desbloquear	
								#Comprovacion si usuario existe
								read -p "Introduzca el nombre del usuario que desea modificar: " nombreusu
								nombreusu=$(fun_ctrl_usu "$nombreusu")
								
								sudo usermod --unlock $nombreusu
						
								# Confirmacion para avanzar
								read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
							;;
							9)
								break
							;;
							*)
								echo "ERROR: OPCION NO CONTEMPLADA"
								sleep 0.5
							;;
							esac
						done
					;;
					3)#Eliminacion de usuario
						fun_menu_general "Eliminar usuario"
						read -p "Introduzca el nombre de usuario que desea eliminar: " nombreusuario
						
						#Confirmacion de eliminacion de usuario
						read -p "CONFIRMACION: realmente quiere eliminar el usuario? (s/n)" confirmacion
						if [ "$confirmacion" = "s" ] || [ "$confirmacion" = "S" ]
						then 
							sudo userdel $nombreusuario
						else
							echo "Operacion abortada"
						fi
						# Confirmacion para avanzar
						read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla
					;;
					4)
						break
					;;
					*)
						echo "ERROR: OPCION NO CONTEMPLADA"
						sleep 0.5
					;;
				esac
			done		
		;;
		
		7) #Ataque con metasploit
			echo "7"
			
			
			# Confirmacion para avanzar
			read -rsp $'Pulsa cualquier tecla para continuar...\n' -n1 tecla			
		;;
		
		8) #Salir
			exit
		;;
		
		*)
			echo "Opcion no valida"
			sleep 0.5
		;;
	esac
done
