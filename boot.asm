; ============================================================
; ИСПРАВЛЕННЫЙ БУТ-СЕРВЕР - ЭТАП 1
; ============================================================

BITS 16
ORG 0x7C00

start:
    ; Настройка сегментов
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Сохраняем номер диска
    mov [boot_drive], dl

    ; Очистка экрана
    mov ax, 0x0003
    int 0x10

    ; Вывод сообщения
    mov si, msg_boot
    call print_string

    ; Загрузка второго этапа
    mov ax, 0x1000
    mov es, ax
    xor bx, bx

    mov ah, 0x02
    mov al, 33
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [boot_drive]  ; Используем сохранённый диск
    int 0x13
    jc disk_error

    ; Переход на второй этап
    jmp 0x1000:0x0000

disk_error:
    mov si, msg_error
    call print_string
    jmp $

print_string:
    lodsb
    or al, al
    jz .done
    mov ah, 0x0E
    int 0x10
    jmp print_string
.done:
    ret

msg_boot   db 'Boot loader v3.0...', 13, 10, 0
msg_error  db 'Error loading kernel!', 13, 10, 0
boot_drive db 0

times 510 - ($ - $$) db 0
dw 0xAA55