#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
	echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
	tput cnorm
	exit 1
}

#Ctrl+c
trap ctrl_c INT

function helpPanel(){
	echo -e "\n\n${yellowColour}[?]${endColour}${grayColour} Ayuda:${endColour}\n"
	echo -e "\t${turquoiseColour}m)${endColour}${grayColour} Dinero con el que empezamos la apuesta.${endColour}" 
	echo -e "\t${turquoiseColour}t)${endColour}${grayColour} Técnica empleada para jugar (martingala/inverselabrouchere)${endColour}\n"
	exit 1
}

function funcionmartingala(){
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${ednColour}${blueColour} $money€${endColour}"
	echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuanto dinero vas a apostar? -> ${endColour}" && read initial_bet
	echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A que deseas apostar continuamente? (par/impar) -> ${endColour}"  && read par_impar

	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar una cantidad de${endColour}${blueColour} $initial_bet€${endColour}${grayColour} a${endColour}${blueColour} $par_impar${endColour}\n"
	backup_bet="$initial_bet"
	contador_jugadas=1
	numeros_perdida=""
	tput civis
	while true; do
		money="$(($money-$initial_bet))"
		echo -e "${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour}${blueColour} $initial_bet€${endColour}${grayColour} y tienes${endColour}${blueColour} $money€${endColour}\n"
		random_number="$(($RANDOM % 37))"
		echo -e "\t${yellowColour}[+]${endColour}${grayColour} Ha salido el número${endColour}${blueColour} $random_number${endColour}"
		if [ ! "$money" -lt 0 ]; then	
			if [ "$par_impar" == "par" ]; then
				if [ "$(($random_number % 2))" -eq 0 ]; then
					if [ "$random_number" -eq 0 ]; then
						echo -e "\t${redColour}[x] Ha salido el número 0, has perdido${endColour}\n"
						initial_bet="$(($initial_bet*2))"
                        			echo -e "${yellowColour}[+]${endColour}${grayColour} Tu dinero actual es${endColour}${blueColour} $money€${endColour}\n"
						numeros_perdida+="$random_number "
	
					else
						echo -e "\t${yellowColour}[+]${endColour}${greenColour} El número que ha salido es par, ¡HAS GANADO!${endColour}\n"
						ganancia="$(($initial_bet*2))"
						echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour}${blueColour} $ganancia€${endColour}"
						money="$(($money+$ganancia))"
						echo -e "${yellowColour}[+]${endColour}${grayColour} Tu dinero actual es${endColour}${blueColour} $money€${enColour}\n"
						initial_bet="$backup_bet"
						numeros_perdida=""
						maximo_dinero="$money"
					fi
				else
					echo -e "\t${yellowColour}[+]${endColour}${redColour} El número que ha salido es impar, ¡HAS PERDIDO!${endColour}\n"
					initial_bet="$(($initial_bet*2))"
					echo -e "${yellowColour}[+]${endColour}${grayColour} Tu dinero actual es${endColour}${blueColour} $money€${endColour}\n"
			        	numeros_perdida+="$random_number " 

				fi
			else
				if [ "$(($random_number % 2))" -eq 1 ]; then
          
                                          echo -e "\t${yellowColour}[+]${endColour}${greenColour} El número que ha salido es impar, ¡HAS GANADO!${endColour}\n"
                                          ganancia="$(($initial_bet*2))"
                                          echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour}${blueColour} $ganancia€${endColour}"
                                          money="$(($money+$ganancia))"
                                          echo -e "${yellowColour}[+]${endColour}${grayColour} Tu dinero actual es${endColour}${blueColour} $money€${enColour}\n"
                                          initial_bet="$backup_bet"
                                          numeros_perdida=""
					  maximo_dinero="$money"
                                  else
                                          echo -e "\t${yellowColour}[+]${endColour}${redColour} El número que ha salido es par, ¡HAS PERDIDO!${endColour}\n"
                                          initial_bet="$(($initial_bet*2))"
                                          echo -e "${yellowColour}[+]${endColour}${grayColour} Tu dinero actual es${endColour}${blueColour} $money€${endColour}\n"
                                          numeros_perdida+="$random_number " 
  
                                  fi
			fi

		else
				echo -e "\n${redColour}[!]${endColour}${grayColour} Nos hemos quedado sin dinero para apostar${endColour}\n"
				echo -e "${yellowColour}[+]${endColour}${grayColour} Ha habido un total de${endColour}${blueColour} $play_counter${endColour}${grayColour} jugadas${endColour}"
				echo -e "${yellowColour}[+]${endColour}${grayColour} Los números consecutivos que han salido con pérdida son:${endColour}${blueColour}[ $numeros_perdida]${endColour}\n"
					if [ "$maximo_dinero" > "$money" ];then
                	        		money="$maximo_dinero"
	                              		echo -e "${yellowColour}[+]${endColour}${grayColour} Maximo dinero ganado${endColour}${blueColour} $maximo_dinero€${endColour}\n"
                              		else
                        			echo -e "Pierdo"
                              		fi

				tput cnorm; exit 1
		fi
				let play_counter+=1

	done
	tput cnorm
	
}

function funcionlabrouchere(){
	echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${ednColour}${blueColour} $money€${endColour}"
	echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A que deseas apostar continuamente? (par/impar) -> ${endColour}"  && read par_impar
	
	declare -a misecuencia=(1 2 3 4)
	apuesta="$((${misecuencia[0]} + ${misecuencia[-1]}))"
	echo -e "${yellowColour}[+]${endColour}${grayColour} Comenzamos con la secuencia${endColour}${purpleColour} [${misecuencia[@]}]${endColour}"
	jugadas_totales=0
	apuesta_renew=$(($money + 50))
	echo -e "${yellowColour}[+]${endColour}${grayColour} El tope ha renovar la secuencia está establecido en${endColour}${blueColour} $apuesta_renew€${endColour}"

	tput civis	
	while true; do
	let jugadas_totales+=1
	numero_random=$(($RANDOM % 37))
	money="$(($money - $apuesta))"
	if [ ! "$money" -lt 0 ]; then	
		echo -e "${yellowColour}[+]${endColour}${grayColour} Vamos a apostar${endColour}${blueColour} $apuesta€${endColour}"
		echo -e "${yellowColour}[+]${endcolour}${grayColour} Tenemos${endColour}${blueColour} $money€${endColour}"
		echo -e "${yellowColour}[+]${endColour}${grayColour} El numero que ha salido es${endColour}${purpleColour} $numero_random${endColour}"
			if [ "$par_impar" == "par" ]; then
				if [ "$((numero_random % 2))" -eq 0 ] && [ "$numero_random" -ne 0 ]; then
					echo -e "\n${yellowColour}[+]${endColour}${greenColour} Ha salido par, ¡GANAS!${endColour}"
					ganancia=$(($apuesta*2))
					let money+=$ganancia
					echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes${endColour}${blueColour} $money€${endColour}"

					if [ $money -gt $apuesta_renew ]; then
						echo -e "${yellowColour}[+]${endColour}${grayColour} Nuestro dinero ha superado el tope de${endColour}${blueColour} $apuesta_renew€${endColour}${grayColour} establecido para renovar la secuencia${endColour}"
						apuesta_renew=$(($apuesta_renew + 50))
						echo -e "${yellowColour}[+]${endcolour}${grayColour} El tope se ha establecido en${endColour}${blueColour} $apuesta_renew€${endcolour}"
						misecuencia=(1 2 3 4)
						apuesta=$((${misecuencia[0]} + ${misecuencia[-1]}))
						echo -e "${yellowColour}[+]${endcolour}${grayColour} La secuencia se ha restablecido a:${endColour}${purpleColour} [${misecuencia[@]}]${endColour}"

					else

					misecuencia+=($apuesta)
					misecuencia=(${misecuencia[@]})
					
					echo -e "${yellowColour}[+]${endColour}${grayColour} Mi secuencia es${endColour}${purpleColour} [${misecuencia[@]}]${endColour}\n"
				
					if [ "${#misecuencia[@]}" -ne 1 ]; then
						apuesta=$((${misecuencia[0]} + ${misecuencia[-1]}))
					elif [ "${#misecuencia[@]}" -eq 1 ]; then
						apuesta=${misecuencia[0]}
						else
                                                    echo -e "${yellowColour}[+]${endColour}${grayColour}Hemos perdido nuestra secuencia${endColour}"
                                                    misecuencia=(1 2 3 4)
                                                    echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a${endColour}${purpleColour} [${misecuencia[@]}]${endColour}\n"
                                                    apuesta=$((${misecuencia[0]} + ${misecuencia[-1]}))
					fi
					fi
				elif [ "$numero_random" -eq 0 ] || [ "$((numero_random % 2))" -eq 1 ]; then
					if [ "$numero_random" -eq 0 ]; then
						echo -e "\n${redColour}[!] Ha salido el cero, ¡PIERDES!${endColour}"
					else
						echo -e "\n${redColour}[!] Ha salido impar, ¡PIERDES!${endColour}"
					fi
					unset misecuencia[0]
					unset misecuencia[-1] 2>/dev/null
					misecuencia=(${misecuencia[@]})
					echo -e "${yellowColour}[+]${endColour}${grayColour} Te quedas con${endColour}${blueColour} $money€${endColour}"
					echo -e "${yellowColour}[+]${endColour}${grayColour} La secuencia se queda de la siguiente forma:${endColour}${purpleColour} [${misecuencia[@]}]${endColour}\n"
						if [ "${#misecuencia[@]}" -ne 1 ] && [ "${#misecuencia[@]}" -ne 0 ]; then
						  apuesta=$((${misecuencia[0]} + ${misecuencia[-1]}))
						elif [ "${#misecuencia[@]}" -eq 1 ]; then 
						  apuesta=${misecuencia[0]}
						else
						  echo -e "${yellowColour}[+]${endColour}${grayColour}Hemos perdido nuestra secuencia${endColour}"
						  misecuencia=(1 2 3 4)
						  echo -e "${yellowColour}[+]${endColour}${grayColour} Restablecemos la secuencia a${endColour}${purpleColour} [${misecuencia[@]}]${endColour}\n"
						  apuesta=$((${misecuencia[0]} + ${misecuencia[-1]}))
						fi
				fi
			else
				echo -e "Adiós"
			fi
	else
		echo -e "\n${yellowColour}[+]${endColour}${grayColour} Te has quedado sin dinero!!!!${endColour}\n"
		echo -e "${yellowColour}[+]${endColour}${grayColour} En total has jugado${endColour}${purpleColour} $jugadas_totales${endColour}${grayColour} jugadas totales${endColour}\n"
		tput cnorm; exit 1
	fi
	done
	tput cnorm

}


while getopts "m:t:h" arg; do
	case $arg in
	m) money=$OPTARG;;
	t) technique=$OPTARG;;
	h) helPanel;;
	esac
done

if [ "$money" ] && [ "$technique" ]; then
	echo -e "La cantidad que apostamos es "$money" y la técnica "$technique""
	if [ "$technique" == "martingala" ]; then
		funcionmartingala
	elif [ "$technique" == "inverselabrouchere" ]; then
		funcionlabrouchere
	else
		echo -e " \n${yellowColour}[+]${endColour}${grayColour} La técnica indicada no existe.${endColour}\n"
	fi
else
	helpPanel
fi
