**Instrucciones** 

El problema de las Torres de Hanói consiste en desplazar una columna hecha a base de discos concéntricos de diferentes diámetros, apilados del de mayor diámetro al de menor diámetro, desde su posición original A hasta su posición destino C,
teniendo el punto B disponible para movimientos intermedios. Dicho desplazamiento cuenta con la restricción de que solo se puede mover un disco a la vez, y que en ningún momento puede un disco de mayor diámetro estar sobre un disco de menor diámetro.

Existen varios algoritmos para su solución, pero uno de los más eficientes es el algoritmo recursivo. Este consiste en lo
siguiente:

Para mover una torre de N discos de A a C:

Mover los N-1 discos superiores de la torre de A a B, siendo B la posición que no corresponde ni al origen ni al destino.
Mover el disco restante (el más grande) de A a C.
Mover los N-1 discos de B a C, colocándolos encima del disco de mayor diámetro.
Como no se pueden mover N-1 en un solo movimiento, a menos que N-1 sea igual a 1, entonces se repiten los pasos
anteriores para mover los N-1 discos de A a B, y luego de B a C.

Generalmente se construye una función que recibe como parámetros el número de discos a mover (N), y las posiciones
origen y destino para ese movimiento. Si el número de discos a mover no es 1, entonces se llama recursivamente la misma
función para mover N-1 discos.

Actividades a realizar

Construir un programa en lenguaje ensamblador de RISC-V, que pueda ser ensamblado y simulado con el programa RARS, para resolver el problema de las Torres de Hanói. La solución debe ser a través de una implementación con código recursivo.

Durante la simulación del programa en RARS, deberá ser posible observar los movimientos de los discos en la ventana que despliega el contenido de la memoria de datos (data segment). Si se pone un breakpoint en el lugar adecuado del código, se deberá poder observar el movimiento de cada disco.

Entregables

Archivo .asm con la implementación de programa con las siguientes características:

Código ampliamente documentado con comentarios que permitan inferir la intención de las líneas de
código de la implementación. 
El programa debe comenzar con un encabezado con los nombres de los integrantes del equipo.
El programa debe soportar N discos para su ejecución.
Cambiando una constante que se almacena en el $s0 el programa se debe poder seleccionar el número de discos e inicializarlos en la torre orígen.
Un reporte en formato PDF que contenga:

Presentación con los nombres y números de expediente de los integrantes del equipo con páginas
numeradas.
Diagrama de flujo del programa implementado realizado en Visio o programa equivalente.
Las decisiones que se tomaron al diseñar su programa, se puede tomar como referencia el diagrama de flujo del programa.
Una simulación en el RARS para 3 discos (La simulación son impresiones de pantalla de data segment del RARS) .
Análisis del comportamiento del stack para el caso de 3 discos.
Incluir en el instruction count (IC) y especificar el porcentaje de instrucciones de tipo R, I y J para 8 discos.
Una grafica que muestre como se incrementa el IC para las torres de hanoi en los casos de 4 a 15 discos.
Conclusiones de cada integrante del equipo.
El código funete y el reporte se deben entregar en canvas.

Restricciones:

Esta práctica deberá realizarse en equipos de 2 personas los cuales ya están formados en canvas. Excepcionalmente se aceptará que se realice individualmente (si el número de personas inscritas en un grupo es impar, una persona deberá trabajar sola).
La solución al algoritmo se debe implementar de manera recursiva (tomar como referencia la implementación de Fibonacci vista en clase). No se aceptarán prácticas que NO resuelvan el problema de manera recursiva.
La solución de la práctica tiene que hacer uso del stack para implementar los llamados recursivos, deben almacenar ra, el número de discos y los apuntadores las 3 torres.
No se puede hacer equipo con integrantes de otro grupo de Organización y Arquitectura de Computadoras.
Se debe emplear solo las instrucciones del RV32I Base Integer Instructions. No se aceptarán prácticas que empleen otras instrucciones, o que empleen pseudo-instrucciones.
 