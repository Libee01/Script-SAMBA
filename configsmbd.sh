#!/bin/bash

if [ $# -eq 0 ]; then
	ip=$(ip addr show | grep -E "inet" |grep -E "\b(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\/(?:3[0-2]|[12]?[0-9])\b brd" | cut -d" " -f6)
	estado=$(systemctl status cron.service | grep -E "Active: " | cut -d" " -f7)
	echo "Tu dirección IP es: $ip"
	echo "El estado del servicio en este momento es: $estado"
	printf "\n"
	while true
	do
		echo "1. Instalación del servicio"
		echo "2. Eliminar el servicio"
		echo "3. Activar el servicio"
		echo "4. Parar el servicio"
		echo "5. Configuración"
		printf "\n"
		read -p "Elige una opción" opcion
		case $opcion in
			1)
				printf "\n"
				while true
				do
					echo "a. Instalar con comandos"
					echo "b. Instalar con Ansible"
					echo "c. Instalar con Docker"
					read -p "Instalar el servicio con: "  instalar
					case $instalar in
					a)
						echo "opcion a"
					;;
	                                b)
	                                        echo "opcion b"
	                                ;;
	                                c)
	                                        echo "opcion c"
	                                ;;
	                                *)
	                                        exit 0
	                                ;;
					esac
				done
				printf "\n"
			;;
			2)
                                printf "\n"
                                echo "2"
                                printf "\n"

		        ;;
			3)
                                printf "\n"
                                echo "3"
                                printf "\n"
		        ;;
			4)
                                printf "\n"
                                echo "4"
                                printf "\n"

		        ;;
			5)
		                exit 0
		        ;;
		esac
	done
else
	echo "con parametros"
fi
