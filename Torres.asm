#Proyecto Torres de Hanoi
#Autores: Luis Alberto Dominguez Tejeda y Juan Diego Gonzalez Sierra
#Version: 1.1
#Cambios aplicados(Ponerlo resumido en el commit): se iniciaron Torres en memoria, Las partes de los discos
#                                                 y la reserva para las mismas torres, al igual que se hizo el loop
#                                                 que decrementa al numero de discos, se iniciaron punteros a nuestras 
#                                                  estructuras y se dejo definido el Stack al igual que su orden






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

chamoy:
addi sp,sp,-20 #barrer los 20 bytes que vamos a almacenar

#ORDEN DEL STACK (en el inverso orden que estan declarados)
sw ra,0(sp) #retorno
sw a0,4(sp) #N discos
sw a1,8(sp) #Torre origen
sw a2,12(sp)#Torre auxiliar
sw a3,16(sp)#Torre destino


