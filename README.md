# Optimización de las Torres de Hanói con IA (RISC-V)

Este repositorio contiene la Práctica 2 de Organización y Arquitectura de Computadoras (ITESO). Se compara la versión iterativa original de las Torres de Hanói (Práctica 1) con una versión altamente optimizada en ensamblador RISC-V puro (RV32I).

## Autores
* Luis Alberto Dominguez Tejeda (763724)
* Juan Diego Gonzalez Sierra (764366)
* IA Participante: Google Gemini (Modelo 2026)

## Optimizaciones Implementadas
1. **Punteros O(1):** Se eliminaron los bucles de búsqueda en memoria. Ahora cada torre tiene un puntero de cabecera (`ptr_t1`, `ptr_t2`, `ptr_t3`) que rastrea la cima de la pila en tiempo real.
2. **Tail Call Optimization (TCO):** La segunda llamada recursiva reutiliza el *stack frame* de 20 bytes, evitando saltos de retorno anidados y liberando la pila antes de iterar.

## Instrucciones de Ejecución
1. Abrir el simulador **RARS (RISC-V Assembler and Runtime Simulator)**.
2. Cargar el archivo `hanoi_optimizado.s`.
3. Para cambiar el número de discos, modificar la instrucción en la línea 17: `addi s0, zero, 3` (reemplazar el 3 por el valor deseado, máx 15).
4. Para visualizar los movimientos:
   * Ir a la ventana de *Data Segment*.
   * Cambiar el visualizador a base Hexadecimal.
   * Colocar un **Breakpoint** en la instrucción de la línea 112: `jalr zero, t6, 0` (retorno de la subrutina `mover_rapido`).
5. Ensamblar (F3) y ejecutar paso a paso (Run / Continue) para ver cómo los discos (valores de 1 a N) saltan entre las torres de memoria separadas por punteros.
