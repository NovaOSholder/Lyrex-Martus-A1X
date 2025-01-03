section .text
    org 0x0000              ; BIOS başlangıç adresi

start:
    ; CPU başlatma işlemleri
    cli                     ; Kesme işlemlerini kapat
    xor ax, ax              ; Tüm CPU kayıtlarını sıfırla
    mov ds, ax              ; Veri segmentini ayarla
    mov es, ax              ; Ek segmenti ayarla

    ; RAM kontrolü
    mov si, test_msg
    call print_string       ; Hoşgeldiniz mesajı yazdır

    ; İleride yükleme yapılabilir
hang:
    hlt                     ; Sonsuza kadar bekle

print_string:
    mov ah, 0x0E            ; Ekrana karakter yazma fonksiyonu
print_loop:
    lodsb                   ; SI'deki veriyi al
    cmp al, 0
    je ret                  ; Null karakterde bitir
    int 0x10
    jmp print_loop
ret:
    ret

section .data
test_msg db "Lyrex Martus A1X BIOS MENU, ALL SERVICES HAS BEEN STARTED", 0
