# Equipo: Ricardo Cuevas, Misael Martin Vazquez
# ---------------------------------------------------------------
# Practica 1 - Torres de Hanoi
.data
datos: .word 6  # Número de discos 
.text

# Inicialización de registros
addi s0 x0 3  # Inicializa la cantidad de discos en 3
addi s1 x0 3
addi s9 x0 3
addi s10 x0 3
addi t3 x0 1  # Para realizar comparaciones

add t6 s0 x0
add t5 s0 x0

main:
    # Calcula direcciones de las tres torres en el segmento de datos
    slli s5 s0 3  # Desplaza el valor de s0 a la izquierda (equivalente a una multiplicación por 8)
    lui a0 %hi(datos)  # Carga la parte alta de la dirección de datos en a0
    add a1 a0 s5  # Suma a0 y s5 y guarda el resultado en a1 (dirección de la torre intermedia)
    add a2 a1 s5  # Suma a1 y s5 y guarda el resultado en a2 (dirección de la torre final)

    add t6 s0 x0
    add t5 s0 x0

start:
    # Inicializa la torre origen con discos
    sw t6 0(a0)  # Almacena el valor de t6 en la dirección de memoria a0
    addi t6 t6 -1  # Decrementa t6 en 1
    addi a0 a0 4  # Incrementa la dirección de memoria a0 en 4 bytes
    bne t6 x0 start  # Salta a "start" si t6 no es igual a 0

    jal hanoi  # Llama a la función hanoi
    jal exit  # Llama a la función de salida

hanoi:
    # Guarda dirección de retorno en la pila
    addi sp sp -4  # Disminuye el puntero de la pila en 4 bytes
    sw ra 0(sp)  # Almacena el registro de retorno (ra) en la pila

    # Comprueba caso base (s10 es el contador de discos restantes)
    beq s10 t3 base  # Salta a "base" si s10 es igual a 1

    # Llama recursivamente a hanoi para mover discos a través de las torres
    addi s10 s10 -1  # Decrementa s10 en 1
    add t6 x0 a2  # Mueve el valor de a2 a t6
    add a2 x0 a1  # Mueve el valor de a1 a a2
    add a1 x0 t6  # Mueve el valor de t6 a a1
    jal hanoi  # Llama a la función hanoi de manera recursiva

    add t6 x0 a2  # Mueve el valor de a2 a t6
    add a2 x0 a1  # Mueve el valor de a1 a a2
    add a1 x0 t6  # Mueve el valor de t6 a a1
    jal disk  # Llama a la función "disk" para mover un disco

    add t6 x0 a0  # Mueve el valor de a0 a t6
    add a0 x0 a1  # Mueve el valor de a1 a a0
    add a1 x0 t6  # Mueve el valor de t6 a a1
    jal hanoi  # Llama a la función hanoi de manera recursiva

    add t6 x0 a0  # Mueve el valor de a0 a t6
    add a0 x0 a1  # Mueve el valor de a1 a a0
    add a1 x0 t6  # Mueve el valor de t6 a a1
    addi s10 s10 1  # Incrementa s10 en 1 (restaura el valor)
    lw ra 0(sp)  # Carga el registro de retorno (ra) desde la pila
    addi sp sp 4  # Incrementa el puntero de la pila en 4 bytes
    jalr ra  # Llama a la función de retorno

disk:
    # Guarda dirección de retorno en la pila
    addi sp sp -4  # Disminuye el puntero de la pila en 4 bytes
    sw ra 0(sp)  # Almacena el registro de retorno (ra) en la pila

    # Llama a la función "acomodos" para mover un disco
    jal acomodos

    # Decrementa el contador de discos
    addi s10 s10 -1  # Decrementa s10 en 1
    jal completo  # Llama a la función "completo"

base:
    # Llama a la función "acomodos" en el caso base
    jal acomodos

    # Incrementa el contador de discos
    addi s10 s10 1  # Incrementa s10 en 1
    jal completo  # Llama a la función "completo"

acomodos:
    # Guarda dirección de retorno en la pila
    addi sp sp -4  # Disminuye el puntero de la pila en 4 bytes
    sw ra 0(sp)  # Almacena el registro de retorno (ra) en la pila

    # Mueve discos entre las torres
    addi a0 a0 -4  # Resta 4 bytes a la dirección de a0 para apuntar al disco anterior
    lw t4 0(a0)  # Carga el valor del disco en t4
    sw s10 0(a0)  # Almacena el valor de s10 en la dirección de a0
    sw t4 0(a2)  # Almacena el valor de t4 en la dirección de a2
    addi a2 a2 4  # Suma 4 bytes a la dirección de a2 para apuntar al siguiente disco

fin:
    sw x0 0(a0)  # Almacena 0 en la dirección de a0, lo que representa un disco borrado
    jal completo  # Llama a la función "completo"

completo:
    # Restaura la dirección de retorno y retorna
    lw ra 0(sp)  # C