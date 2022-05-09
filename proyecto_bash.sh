#!/usr/bin/env bash 

echo "BUENOS DIAS"
            
function fpermisos {
	ruta=$(yad --width=400 --height=50 --tittle="permisos" --form --center --file) 2> /dev/null
	usuario=$(yad --list --tittle="Asignar permisos"--width=400 --height=200 --button=Cancelar:1 --button=Aceptar:0 --center \
	--text="Selecciona permisos" --checklist --column="" --column="usuario" 1 "lectura" 2 "escritura" 3 "ejecucion" \
	)
	ans=$?
	if [ $ans -eq 0 ]
	then
		for i in $usuario; 
		do 
			IFS="|" read -r -a pu <<< "$usuario"
			echo ${pu[1]}
		done
	
		#echo "Has elegido: ${ru} ${wu} ${xu} "
	else
		echo "No has elegido ningún componente"
	fi
	
	grupo=$(yad --list --tittle="Asignar permisos"--width=400 --height=200 --button=Cancelar:1 --button=Aceptar:0 --center \
	--text="Selecciona permisos" --checklist --column="" --column="grupo" 1 "lectura" 2 "escritura" 3 "ejecucion" \
	)
	ans=$?
	if [ $ans -eq 0 ]
	then
		for i in $grupo; 
		do 
			IFS="|" read -r -a pg <<< "$grupo"
			echo ${pg[1]}
		done
	else
		echo "No has elegido ningún componente"
	fi
	
	otros=$(yad --list --tittle="Asignar permisos"--width=400 --height=200 --button=Cancelar:1 --button=Aceptar:0 --center \
	--text="Selecciona permisos" --checklist --column="" --column="otros" 1 "lectura" 2 "escritura" 3 "ejecucion" \
	)
	ans=$?
	if [ $ans -eq 0 ]
	then
		for i in $otros; 
		do 
			IFS="|" read -r -a po <<< "$otros"
			echo ${po[1]}
		done
	else
		echo "No has elegido ningún componente"
	fi
    #chmod "$permiso $ruta"
    #ls -l $ruta

}
            
function ftareas {

echo "Tareas Programadas"
ls -l
read -p "ruta del fichero: " fichero
read -p "comando: " comando
read -p "usuario: " usuario
read -p "mes: " mes
read -p "dias: " dias
read -p "dia de la semana: " dsemana
read -p "hora: " hora
read -p "minuto: " minuto 
echo "$minuto $hora	$dias $mes $dsemana root 	$comando $fichero">>crontab
cat crontab
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
