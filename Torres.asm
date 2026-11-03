#Proyecto Torres de Hanoi
#Autores: Luis Alberto Dominguez Tejeda y Juan Diego Gonzalez Sierra
#Version: 1.2
#Cambios aplicados(Ponerlo resumido en el commit): se agrego la funcion recursiva chamoy completa
#                                                  (caso base, dos llamadas recursivas y restauracion
#                                                  del stack) y la subrutina mover_disco que pasa un
#                                                  disco de una torre a otra. Se agrego la salida del programa.

.data
#INICIAMOS TORRES EN MEMORIA(cada una con 15 espacios para 15 discros)
torre1: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
torre2: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
torre3: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
.text
 
#Iniciar N discos (esta parte es modificable)
addi s0,zero,3 #modificar inmediato para numero de discos (no mayor a 15)

lui s1,%hi(torre1) #Reservamos para torre 1
addi s1,s1,%lo(torre1)

lui s2,%hi(torre2) #Reservamos para torre 2
addi s2,s2,%lo(torre2)

lui s3,%hi(torre3)#Reservamos para torre 3 
addi s3,s3,%lo(torre3)

add t0,zero,s1 #hacemos que t0 sea un puntero a s1 para irlo moviendo en las posiciones y meterlos discos
add t1,zero,s0 #copiamos el valor N que vamos ir decrementando en un ciclo

loop_decremento:
sw t1,0(t0) #Cargar el disco en su posicion
addi t0,t0,4 #sumamos 4 para cambiar a la siguiente posicion
addi t1,t1,-1 #le restamos 1 a N para que el siguiente meta el otro valor del disco

bne t1,zero,loop_decremento # Condicion para hacer las instrucciones de arriba

#Generar los punteros a las torres y al N antes de entrar a la recursividad
add a0,zero,s0
add a1,zero,s1
add a2,zero,s2
add a3,zero,s3

jal ra, chamoy #chamoy sera el nombre de la ejecucion de los movimientos

#Cuando termina toda la recursividad se regresa aqui y cerramos el programa
addi a7,zero,10 #servicio 10 de ecall = terminar programa
ecall

#--------------------------------------------------------------------
# chamoy(N, origen, auxiliar, destino)
# a0 = N, a1 = origen, a2 = auxiliar, a3 = destino
#--------------------------------------------------------------------
chamoy:
addi sp,sp,-20 #barrer los 20 bytes que vamos a almacenar

#ORDEN DEL STACK (en el inverso orden que estan declarados)
sw ra,0(sp) #retorno
sw a0,4(sp) #N discos
sw a1,8(sp) #Torre origen
sw a2,12(sp)#Torre auxiliar
sw a3,16(sp)#Torre destino

addi t0,zero,1 #t0 = 1 para comparar
beq a0,t0,caso_base #si solo queda 1 disco ya no hay que bajar mas

#Paso 1: mover N-1 discos de origen a auxiliar (el destino pasa a ser la auxiliar)
addi a0,a0,-1 #N-1
add t1,zero,a2 #guardamos la auxiliar original en t1
add a2,zero,a3 #la nueva auxiliar es el destino original
add a3,zero,t1 #el nuevo destino es la auxiliar original
jal ra,chamoy

#Al regresar los registros a pueden venir cambiados, los recuperamos del stack
lw a0,4(sp)
lw a1,8(sp)
lw a2,12(sp)
lw a3,16(sp)

#Paso 2: mover el disco grande de origen a destino
jal ra,mover_disco

#Paso 3: mover los N-1 discos de auxiliar a destino (ahora el origen es la auxiliar)
addi a0,a0,-1 #N-1
add t1,zero,a1 #guardamos el origen original en t1
add a1,zero,a2 #el nuevo origen es la auxiliar original
add a2,zero,t1 #la nueva auxiliar es el origen original
jal ra,chamoy

jal zero,fin_chamoy #saltamos el caso base

caso_base:
jal ra,mover_disco #con un solo disco nada mas lo pasamos de origen a destino

fin_chamoy:
lw ra,0(sp) #recuperamos la direccion de retorno
addi sp,sp,20 #liberamos el espacio del stack
jalr zero,ra,0 #regresamos a quien nos llamo

#--------------------------------------------------------------------
# mover_disco: saca el disco de arriba de la torre a1 y lo pone en la torre a3
# No modifica los registros a ni s, solo usa temporales
# PONER EL BREAKPOINT EN EL jalr DE ABAJO: cada vez que se detenga es un movimiento
#--------------------------------------------------------------------
mover_disco:
add t0,zero,a1 #t0 recorre la torre origen
addi t2,a1,60 #t2 = direccion donde acaba la torre (15 espacios * 4 bytes)

buscar_tope:
beq t0,t2,tope_hallado #si llegamos al final la torre esta llena
lw t1,0(t0) #leemos la posicion actual
beq t1,zero,tope_hallado #si es 0 ya paso el ultimo disco
addi t0,t0,4 #siguiente posicion
jal zero,buscar_tope

tope_hallado:
addi t0,t0,-4 #el disco de arriba esta una posicion antes
lw t3,0(t0) #t3 = disco que vamos a mover
sw zero,0(t0) #lo quitamos de la torre origen

add t0,zero,a3 #t0 recorre la torre destino

buscar_libre:
lw t1,0(t0)
beq t1,zero,colocar #primer espacio vacio
addi t0,t0,4
jal zero,buscar_libre

colocar:
sw t3,0(t0) #ponemos el disco en el destino
jalr zero,ra,0 #<-- breakpoint aqui
