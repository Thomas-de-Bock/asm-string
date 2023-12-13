section .text

; --- strlen ---
; string
strlen:
  ;restore
  push rdi
  push rsi


  mov rsi, rdi

  find_null:
    cmp byte [rdi], 0
    je found_null
    inc rdi
    jmp find_null

  found_null:
    sub rdi, rsi
    mov rax, rdi
    ;restore
    pop rsi
    pop rdi
    ret

; --- strcpy ---
; desination, source
strcpy:
  ;restore
  push rdi
  push rsi

  strcpy_loop:
    mov al, [rsi]
    mov byte [rdi], al
    cmp byte [rsi], 0
    je strcpy_end
    inc rdi
    inc rsi
    jmp strcpy_loop
   
  strcpy_end:
    ;restore
    pop rsi
    pop rdi
    ret

; --- strcat ---
; desination, source
strcat:
  ;restore
  push rdi

  call strlen   ; dest currently in rdi, get length

  add rdi, rax  ; rdi now points to end of destination string

  call strcpy   ; copy source into end of destination string

  ;restore
  pop rdi
  ret

; --- tolower ---
; char
tolower:
  ;restore
  push rdi

  ; is upper case character if 65-90
  cmp dil, 65
  jl tolower_end
  cmp byte dil, 90
  jg tolower_end

  add dil, 32

  tolower_end:
    mov rax, rdi
    
    ;restore
    pop rdi
    ret

; --- toupper ---
; char
toupper:
  ;restore
  push rdi

  ; is upper case character if 65-90
  cmp dil, 97
  jl toupper_end
  cmp byte dil, 122
  jg toupper_end

  sub dil, 32

  toupper_end:
    mov rax, rdi

    ;restore
    pop rdi
    ret

; --- strlwr ---
; string
strlwr:
  ;restore
  push rsi
  push rdi

  mov rsi, rdi
  
  strlwr_loop:
    mov dil, byte [rsi]
    call tolower
    mov byte [rsi], dil
    inc rsi
    cmp byte [rsi], 0
    je strlwr_end
    jmp strlwr_loop
  
  strlwr_end:
    ;restore
    pop rdi
    pop rsi

    ret

; --- strupr ---
; string
strupr:
  ;restore
  push rsi
  push rdi

  mov rsi, rdi
  
  strupr_loop:
    mov dil, byte [rsi]
    call toupper
    mov byte [rsi], dil
    inc rsi
    cmp byte [rsi], 0
    je strupr_end
    jmp strupr_loop
  
  strupr_end:
    ;restore
    pop rdi
    pop rsi

    ret

; --- strcspn ---
; str, keys
strcspn:
  ;restore
  push rbx
  push rcx
  push rdi
  push rsi

  mov rax, rdi  ;rax = start of str
  mov rbx, rsi  ;rbx = start of keys

  strcspn_loop:
    mov cl, byte [rsi]
    cmp byte [rdi], cl  ;if crntstr* == crntkey*
    je strcspn_end
    
    inc rsi
    cmp byte [rsi], 0   ;if end of keys
    je next_char
    jmp strcspn_loop

    next_char:
      mov rsi, rbx
      inc rdi
      cmp byte [rdi], 0   ;if end of str
      je strcspn_end
      jmp strcspn_loop

  strcspn_end:
    sub rdi, rax
    mov rax, rdi

    ;restore
    pop rsi
    pop rdi
    pop rcx
    pop rbx

    ret
