#!/usr/bin/env bash 
            
function fpermisos {
	pruta=$(yad --width=400 --height=50 --tittle="permisos" --form --center --file)
	
	usuario=$(yad --form --tittle="Asignar permisos" --width=1000 --height=250 --button=Cancelar:1 --button=Aceptar:0 --center \
	--text="Selecciona permisos" --column="" --field="usuario":NUM --field="grupo":NUM --field="otros":NUM \
	--text="Escribe el valor dependiendo de los permisos que quieras asignar
	
<b>Chuleta:</b>
<b>4</b> = lectura
<b>2</b> = escritura
<b>1</b> = ejecucion
<b>7</b> = lectura + escritura + ejecucion
<b>6</b> = lectura + escritura
<b>5</b> = lectura + ejecucion
<b>3</b> = escritura + ejecucion
")
	ans=$?
	if [ $ans -eq 0 ]
	then
			IFS="|" read -r -a pu <<< "$usuario"
			user=${pu[0]}
			group=${pu[1]}
			other=${pu[2]}
	
		permisos="$user$group$other"
		echo ${permisos}
	else
		echo "No has elegido ningún componente"
	fi
    chmod $permisos $pruta
    ls -l $ruta

}
            
function ftareas {
	truta=$(yad --width=400 --height=50 --tittle="permisos" --form --center --file)

	tareas=$(yad --form --tittle="Tareas Programadas"--width=1000 --height=250 \
	--button=Cancelar:1 --button=Aceptar:0 \
	--center --field="<b>Descripcion</b>" --field="<b>Comado</b>" \
	--text="<br>"--field="<b>Dia de semana</b>[0-6]" --field="<b>Día</b>" --field="<b>Mes</b>" --field="<b>Hora</b>":NUM --field="<b>Minuto</b>":NUM \
	--text="Escribe el valor dependiendo de los permisos que quieras asignar
Escriba "*" para repetir la tarea cada hora, dia, mes,etc.
buenas tardes")
	ans=$?
	if [ $ans -eq 0 ]
	then

			IFS="|" read -r -a elementos <<< "$tareas"
				descripcion=${elementos[0]}
				comando=${elementos[1]}
				fecha=${elementos[2]}
				hora=${elementos[3]}
				minuto=${elementos[4]}

			IFS="/" read -r -a fech <<< "$fecha"
				dia=${fech[0]}
				mes=${fech[1]}

		#echo "$tareas"
		sudo echo "$minuto $hora $dia $mes $anyo $usuario $comando" >> /etc/crontab
	else
		echo "No has elegido ningún componente"
	fi

#echo "$minuto $hora	$dias $mes $dsemana root 	$comando $tfichero">>crontab
#cat crontab
}

function fborrar {
    echo "Borrar ficheros o carpetas"
	ls -l
    read -p "que deseas borrar: " borrar
    mv $borrar ~/Escritorio/mibasura
    ls -l ~/Escritorio/mibasura
}

function frecuperar {
    echo "Recuperaremos ese fichero o carpeta"
    tree ~/Escritorio/mibasura
    read -p "nombre del archivo/carpeta" n 
    mv $n ~/Escritorio/
}

function salir {
    echo "¡Adiós!"
}

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
