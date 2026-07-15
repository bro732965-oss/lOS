; ============================================================
; ИСПРАВЛЕННЫЙ БУТ-СЕРВЕР - ЭТАП 2
; ============================================================

BITS 16
ORG 0x0000

section .data
    msg_enter       db 13, 10, 'Entering protected mode...', 13, 10, 0
    msg_long        db 'Entering long mode...', 13, 10, 0
    msg_kernel      db 'Loading kernel...', 13, 10, 0
    msg_done        db 'Kernel loaded!', 13, 10, 0
    msg_error       db 'Kernel load error!', 13, 10, 0
    
    ; ПРАВИЛЬНАЯ GDT для 64-bit
    gdt_start:
        dq 0x0000000000000000  ; Нулевой дескриптор
        dq 0x00209A0000000000  ; 64-bit код (Ring 0)
        dq 0x0000920000000000  ; 64-bit данные (Ring 0)
        dq 0x00CF9A000000FFFF  ; 32-bit код (Ring 0) 
        dq 0x00CF92000000FFFF  ; 32-bit данные (Ring 0)
    gdt_end:
    
    gdt_desc:
        dw gdt_end - gdt_start - 1
        dq gdt_start          ; 64-bit адрес (исправлено!)
    
    ; ПРАВИЛЬНЫЕ таблицы страниц
    align 4096
    pml4_table:
        times 512 dq 0
    pdp_table:
        times 512 dq 0
    pd_table:
        times 512 dq 0
    
    kernel_buffer times 131072 db 0  ; Увеличен буфер

section .text
global start

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x9000
    
    mov ax, 0x0003
    int 0x10
    
    mov si, msg_enter
    call print_string
    
    ; ЗАГРУЗКА ЯДРА (исправлено)
    call load_kernel
    
    ; ПРОВЕРКА A20 (исправлено)
    call check_a20
    
    ; НАСТРОЙКА GDT (исправлено)
    call setup_gdt
    
    ; ПЕРЕХОД В ЗАЩИЩЁННЫЙ РЕЖИМ
    call enter_protected
    
    ; НАСТРОЙКА СТРАНИЦ
    call setup_paging
    
    ; ПЕРЕХОД В LONG MODE
    call enter_long_mode

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

load_kernel:
    mov si, msg_kernel
    call print_string
    
    ; Читаем ядро с диска
    mov ax, 0x2000
    mov es, ax
    xor bx, bx
    
    mov ah, 0x02
    mov al, 64
    mov ch, 0
    mov cl, 35
    mov dh, 0
    mov dl, 0x80          ; Исправлено: HDD
    int 0x13
    jc kernel_error
    
    mov si, msg_done
    call print_string
    ret
    
kernel_error:
    mov si, msg_error
    call print_string
    cli
    hlt
    jmp $

check_a20:
    ; ПРОВЕРКА A20 через BIOS
    mov ax, 0x2401
    int 0x15
    ret

setup_gdt:
    lgdt [gdt_desc]
    ret

enter_protected:
    cli
    
    ; Включение A20
    in al, 0x92
    or al, 2
    out 0x92, al
    
    ; Включение защищённого режима
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    
    ; ДАЛЬНИЙ ПРЫЖОК в 32-bit
    jmp 0x18:.protected_mode
    BITS 32

.protected_mode:
    mov ax, 0x20
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000
    
    mov esi, msg_long
    call print_string_pm
    ret

print_string_pm:
    pusha
    mov edx, 0xB8000
.loop:
    lodsb
    or al, al
    jz .done
    mov [edx], al
    add edx, 2
    jmp .loop
.done:
    popa
    ret

setup_paging:
    ; Очистка таблиц
    mov edi, pml4_table
    mov ecx, 512 * 3
    xor eax, eax
    rep stosd
    
    ; PML4 → PDP
    mov eax, pdp_table
    or eax, 0x03
    mov [pml4_table], eax
    
    ; PDP → PD
    mov eax, pd_table
    or eax, 0x03
    mov [pdp_table], eax
    
    ; PD → 2MB страницы
    mov edi, pd_table
    mov eax, 0x83
    mov ecx, 512
.setup_pd:
    mov [edi], eax
    add eax, 0x00200000
    add edi, 8
    loop .setup_pd
    
    mov eax, pml4_table
    mov cr3, eax
    ret

enter_long_mode:
    ; PAE
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax
    
    ; Long Mode
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr
    
    ; Paging
    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax
    
    ; Переход в 64-bit
    jmp 0x08:.long_mode
    BITS 64

.long_mode:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov rsp, 0x90000
    
    ; Очистка экрана (64-bit)
    mov rax, 0x0720072007200720
    mov rdi, 0xB8000
    mov rcx, 2000
    rep stosq
    
    ; ЗАПУСК ЯДРА
    mov rax, 0x20000
    jmp rax

times 32768 - ($ - $$) db 0