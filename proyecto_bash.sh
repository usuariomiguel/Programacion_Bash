#!/usr/bin/env bash     
function fpermisos { # damos permisos
	cd /home/$USER/
	pruta=$(yad --file --tittle="permisos" --center --maximized --text="Seleccione un archivo:")					

	usuario=$(yad --form --tittle="Asignar permisos" --width=600 --height=300 --button=Cancelar:1 --button=Aceptar:0 --center \
	--text="Selecciona permisos" --column="" --field="<b>Usuario: </b>":NUM --field="<b>Grupo: </b>":NUM --field="<b>Otros: </b>":NUM \
	--text="Escribe el valor dependiendo de los permisos que quieras asignar
						
<b>Chuleta:</b>
<b>4</b> = lectura
<b>2</b> = escritura
<b>1</b> = ejecucion
<b>7</b> = lectura + escritura + ejecucion
<b>6</b> = lectura + escritura
<b>5</b> = lectura + ejecucion
<b>3</b> = escritura + ejecucion

<b>${pruta}</b>
")				
	ans=$?
	if [ $ans -eq 0 ]
		then
			IFS="|" read -r -a pu <<< "$usuario"
				user=${pu[0]}
				group=${pu[1]}
				other=${pu[2]}
			if [[ $user -le 7 && $group -le 7 && $other -le 7 ]]
				then
					permisos="$user$group$other"
					sudo chmod $permisos $pruta
					pcomp=$(ls -ld $pruta) 
					yad --form --image=gtk-ok --tittle="Permisos" --width=600 --height=150 \
					--center --text="<b>Comprobacion permisos:</b> 
					
<b>usuario</b> $user	
<b>grupo</b> $group
<b>otros</b> $other

${pcomp}"
				else
				yad --form --image=stop --tittle="Permisos" --width=600 --height=100 \
					--center --text="<b>ERROR</b> 
No puedes pasar el valor 7 en la seccion de permisos

<b>usuario</b> $user	
<b>grupo</b> $group
<b>otros</b> $other
"
					
			fi
	fi
	menu
}        
function ftareas { # programar tareas en crontab
	sudo chmod "777" /etc/crontab

	tareas=$(yad --form --tittle="Tareas Programadas" --width=1000 --height=250 \
	--button=Cancelar:1 --button=Aceptar:0 \
	--center --field="<b>Descripcion</b>" --field="<b>Comando</b>" \
	--field="<b>Dia de semana[0-6]</b>" --field="<b>Día</b>" --field="<b>Mes</b>" --field="<b>Hora</b>" --field="<b>Minuto</b>" \
	--text="Escriba <b>"*"</b> para repetir la tarea cada hora, dia, mes,etc.")
	ans=$?
	if [ $ans -eq 0 ]
	then
		IFS="|" read -r -a elementos <<< "$tareas"
			descripcion=${elementos[0]}
			comando=${elementos[1]}
			semana=${elementos[2]}
			dia=${elementos[3]}
			mes=${elementos[4]}
			hora=${elementos[5]}
			minuto=${elementos[6]}
			
		if [[ $semana != "*" && $semana -gt 6 ]]
			then 
				yad --form --image=stop --tittle="tareas" --width=600 --height=100 \
					--center --text="<b>ERROR</b> 
El valor de Dia de semana oscila entre 0-6 
Si quieres que la tarea se repita todos los dias de la semana escribe *"
		fi
		if [[ $dia != "*" && $dia -gt 31 ]]
			then
				yad --form --image=stop --tittle="tareas" --width=600 --height=100 \
					--center --text="<b>ERROR</b> 
Valor dia supera el rango 1-31
Si quieres que la tarea se repita todos los dias del mes escribe * "
		fi
		if [[ $mes != "*" && $mes -gt 12 ]]
			then
				yad --form --image=stop --tittle="tareas" --width=600 --height=100 \
					--center --text="<b>ERROR</b> 
Valor mes supera el rango 1-12
Si quieres que la tarea se repita todos los meses escribe * "
		fi
		if [[ $hora != "*" && $hora -eq 0 && $hora -gt 24 ]]
			then
				yad --form --image=stop --tittle="tareas" --width=600 --height=100 \
					--center --text="<b>ERROR</b> 
Valor hora supera el rango 00-24
Si quieres que la tarea se repita todas las horas escribe * "
		fi
		if [[ $minuto != "*" && $minuto -gt 60 ]]
			then
				yad --form --image=stop --tittle="tareas" --width=600 --height=100 \
					--center --text="<b>ERROR</b> 
Valor minuto supera el rango 0-60
Si quieres que la tarea se repita todos los minutos escribe * "
		fi
		
		if [[ $semana = "*" || $semana -le 6 && $dia = "*" || $dia -le 31 && $mes = "*" || $mes -le 12 && $hora = "*" || $hora -ge 1 || $hora -le 23 && $minuto = "*" || $minuto -le 60 ]]
			then
				sudo chmod 777 /etc/crontab
				conf=$(echo "$minuto $hora $dia $mes $semana $USER $comando") >> /etc/crontab
				tvista=$(yad --form --image=gtk-ok --tittle="Tareas Programadas" --width=400 --height=150 \
				--center --text="Configuracion realizada correctamente
${conf}")
		fi
	else
		menu
	fi

menu

}
function fborrar { # movemos el fichero/carpeta a basura
	cd /home/$USER/
	mkdir /home/$USER/papelera
	pruta=$(yad --form --width=400 --height=50 --tittle="eliminar" --center --file)
    	sudo mv $pruta /home/$USER/papelera
	cbasura=$(ls /home/$USER/papelera)
	yad --form --image=gtk-ok --center --height=300 --width=250 --text="<b>Contenido papelera:</b>
    
${cbasura}"
menu
}
function frecuperar { # buscamos la ruta antigua y si no movemos a recuperados
	cd /home/$USER/
	sudo mkdir recuperados
	cd /home/$USER/papelera
	rruta=$(yad --width=400 --height=100 --center --file )
	if [ $pruta != " " ]
		then
			sudo mv ${rruta} ${pruta}	
			yad --form --image=gtk-ok --height=300 --width=250 --text="<b>Fichero RECUPERADO</b>
ruta del fichero:
${pruta}"
		else
			sudo mv ${rruta} /home/$USER/recuperados/
			yad --form --image=gtk-ok --height=300 --width=250 --text="<b>Fichero RECUPERADO</b>
ruta del fichero:
/home/$USER/recuperados/"	
	fi
menu
}
function salir { # despedimos al usuario
	echo "Adiós"
}
function menu { # menu
op1="<span weight=\"bold\" font=\"12\">Gestion permisos</span>"
op2="<span weight=\"bold\" font=\"12\">Tareas programadas</span>"
op3="<span weight=\"bold\" font=\"12\">Borrar ficheros</span>"
op4="<span weight=\"bold\" font=\"12\">Recuperar ficheros</span>"
op5="<span weight=\"bold\" font=\"12\">Salir</span>"
op=$(yad --width=300 --height=250 --title "Menu utilidades" \
--list --column="" --column="" 1 "${op1}" 2 "${op2}" 3 "${op3}" 4 "${op4}" 5 "${op5}" \
--center) 2> /dev/null

op=`echo $op | cut -f1 -d"|"`

case $op in
	"1") fpermisos;;
	"2") ftareas;;
	"3") fborrar;;
	"4") frecuperar;;
	"5") salir;;
esac
}
menu
