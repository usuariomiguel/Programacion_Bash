# PROGRAMCION BASH

## IF

```sh
if [condicion] then 
        sentencia
    else
        sentencia
fi
```
## CASE

```sh
case $op in 
    a)  sentencia;;
    b)  sentencia
    c)  sentencia
    d)  sentencia;;
    default) sentencia_por_defecto
esac
```

## FOR
```sh
for i in lista
    do 
        sentencias
    done
```
```sh
for i in uno,dos,tres,cuatro
for i in $*
```

```sh
for (( variable=inicio;condicion;incremento))
    do+
        sentencia
    done
```
## WHILE 

```sh
while [condicion]

    do
        sentencias
    done

campo1$campo2$campo3$campo4
```



```sh
OIFS=$IFS

IFS=$

while read var1 var2 var3 var4
    do
        sentencias
    done < $fichero

IFS= 
```

## UNTIL

```sh
until lista_órdenes
do
    lista órdenes
done        
```

## FUNCIONES 

```sh

#!/bin/bash  
            

function terminar {
    exit 0
}
            

function saludo {
    echo ¡Hola Mundo!
}

saludo
terminar

```

## ACCESO A BASE DE DATOS

```sh
MYSQL='mysql -u root -pContraseña'
$MYSQL << END
    use tabla;
    update $dato1 set tabla2='$dato2' where tabla3='$dato3'; 
    (variables entre comillas simples)
END


MYSQL='mysql -u root -pContraseña'
$MYSQL << END
    use tabla;
    select * into outfile '/var/lib/mysql_files/tmp.txt'
    fields terminated by "$"
    from empleados where apellidos like "%a";
END
```