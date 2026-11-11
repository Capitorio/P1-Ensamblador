# ==============================================================================
# PROYECTO TORRES DE HANOI - VERSIÓN CORREGIDA Y FUNCIONAL (RV32I ESTRICTO)
# TÉCNICAS: Punteros O(1) + Tail Call Optimization + Stack Frame Seguro (20-byte)
# ==============================================================================

.data
ptr_t1: .word 0                 # Puntero activo de T1
torre1: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

ptr_t2: .word 0                 # Puntero activo de T2
torre2: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

ptr_t3: .word 0                 # Puntero activo de T3
torre3: .word 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

.text
.globl main

main:
    addi s0, zero, 3            # N discos (modificable de 1 a 15)

    # Cargar direcciones base de los Headers
    lui s1, %hi(ptr_t1)
    addi s1, s1, %lo(ptr_t1)    # s1 = Header T1
    
    lui s2, %hi(ptr_t2)
    addi s2, s2, %lo(ptr_t2)    # s2 = Header T2
    
    lui s3, %hi(ptr_t3)
    addi s3, s3, %lo(ptr_t3)    # s3 = Header T3

    # Direcciones de datos reales (Header + 4 bytes)
    addi t0, s1, 4              # Base Torre 1
    addi t1, s2, 4              # Base Torre 2
    addi t2, s3, 4              # Base Torre 3

    # Inicializar Headers de T2 y T3
    sw t1, 0(s2)
    sw t2, 0(s3)

    # Llenado O(N) de la Torre 1
    add t3, zero, s0            # Contador discos
    add t4, zero, t0            # Puntero de escritura

loop_llenado:
    sw t3, 0(t4)
    addi t4, t4, 4
    addi t3, t3, -1
    bne t3, zero, loop_llenado

    sw t4, 0(s1)                # ptr_t1 apunta al tope libre

    # Pasar argumentos
    add a0, zero, s0            # a0 = N
    add a1, zero, s1            # a1 = Header T1 (Origen)
    add a2, zero, s2            # a2 = Header T2 (Auxiliar)
    add a3, zero, s3            # a3 = Header T3 (Destino)

    jal ra, chamoy_radical

    # Fin del programa
    addi a7, zero, 10
    ecall


# ==============================================================================
# SUBRUTINA RECURSIVA CORE (TCO + 20-byte Stack Frame)
# ==============================================================================
chamoy_radical:
    # 1. EVALUACIÓN DE CASO BASE (N == 1)
    addi t0, zero, 1
    bne a0, t0, caso_recursivo

    # Usar t6 como registro de enlace para no alterar ra
    jal t6, mover_rapido
    jalr zero, ra, 0

caso_recursivo:
    # 2. PRÓLOGO (Preservación completa del contexto de torres)
    addi sp, sp, -20
    sw ra, 0(sp)
    sw a0, 4(sp)
    sw a1, 8(sp)                # Header Origen
    sw a2, 12(sp)               # Header Auxiliar
    sw a3, 16(sp)               # Header Destino

    # 3. LLAMADA RECURSIVA 1: Hanoi(N-1, Origen, Destino, Auxiliar)
    addi a0, a0, -1
    add t0, zero, a2            # Swap(Auxiliar, Destino)
    add a2, zero, a3
    add a3, zero, t0
    jal ra, chamoy_radical

    # 4. RESTAURAR CONTEXTO COMPLETO DESDE LA PILA
    lw ra, 0(sp)
    lw a0, 4(sp)
    lw a1, 8(sp)                # Recuperar Origen
    lw a2, 12(sp)               # Recuperar Auxiliar
    lw a3, 16(sp)               # Recuperar Destino

    # 5. MOVER DISCO CENTRAL (Origen -> Destino) usando t6
    jal t6, mover_rapido

    # 6. TAIL CALL OPTIMIZATION (TCO): Hanoi(N-1, Auxiliar, Origen, Destino)
    lw a0, 4(sp)
    addi a0, a0, -1             # N - 1
    
    add a1, zero, a2            # Nuevo Origen = Auxiliar original
    lw a2, 8(sp)                # Nueva Auxiliar = Origen original
    # a3 (Destino) se mantiene intacto en su valor original

    addi sp, sp, 20             # Liberar pila ANTES de reiniciar la iteración
    jal zero, chamoy_radical


# ==============================================================================
# SUBRUTINA MOVER DISCO EN TIEMPO CONSTANTE O(1)
# ==============================================================================
mover_rapido:
    # --- EXTRAER DE ORIGEN (POP) ---
    lw t0, 0(a1)
    addi t0, t0, -4
    lw t1, 0(t0)
    sw zero, 0(t0)
    sw t0, 0(a1)

    # --- INSERTAR EN DESTINO (PUSH) ---
    lw t2, 0(a3)
    sw t1, 0(t2)
    addi t2, t2, 4
    sw t2, 0(a3)

    jalr zero, t6, 0            # Retorno mediante t6 (Breakpoint aquí en RARS)