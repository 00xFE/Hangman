STDIN equ 0
STDOUT equ 1
SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
secret_len equ 64

%macro write_string 2
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, %1
	mov edx, %2
	int 0x80 
%endmacro

%macro push_all 0
	push eax
	push ebx
	push ecx
	push edx
%endmacro

%macro pop_all 0
	pop edx
	pop ecx
	pop ebx
	pop eax
%endmacro

segment .data
	icon_0 db '  ----- ', 0xA
	       db	'  |   o ', 0xA
	       db	'  |  -|-', 0xA
	       db	'  |  / \', 0xA
	       db	'-----   ', 0xA
	icon_len equ $ - icon_0

	icon_1 db '  ----- ', 0xA
	       db	'  |   o ', 0xA
	       db	'  |  -|-', 0xA
	       db	'  |    \', 0xA
	       db	'-----   ', 0xA
	icon_2 db '  ----- ', 0xA
	       db	'  |   o ', 0xA
	       db	'  |  -|-', 0xA
	       db	'  |     ', 0xA
	       db	'-----   ', 0xA
	icon_3 db '  ----- ', 0xA
	       db	'  |   o ', 0xA
	       db	'  |   |-', 0xA
	       db	'  |     ', 0xA
	       db	'-----   ', 0xA
	icon_4 db '  ----- ', 0xA
	       db	'  |   o ', 0xA
	       db	'  |   | ', 0xA
	       db	'  |     ', 0xA
	       db	'-----   ', 0xA
	icon_5 db '  ----- ', 0xA
	       db	'  |   o ', 0xA
	       db	'  |     ', 0xA
	       db	'  |     ', 0xA
	       db	'-----   ', 0xA
	icon_6 db '  ----- ', 0xA
	       db	'  |     ', 0xA
	       db	'  |     ', 0xA
	       db	'  |     ', 0xA
	       db	'-----   ', 0xA
	icon_7 db '        ', 0xA
	       db	'  |     ', 0xA
	       db	'  |     ', 0xA
	       db	'  |     ', 0xA
	       db	'-----   ', 0xA
	icon_8 db '        ', 0xA
	       db	'        ', 0xA
	       db	'        ', 0xA
	       db	'        ', 0xA
	       db	'-----   ', 0xA
				 
	icons dd icon_0, icon_1, icon_2, icon_3, icon_4, icon_5, icon_6, icon_7, icon_8
	buf times secret_len db 0x00
	
	msg_welcome db 'Benvenuto al gioco dell', 0x27, 'impiccato!!!', 0xA
	     				db 'Inserisci la frase segreta, ma non dirla al tuo avversario:', 0xA
	msg_welcome_len equ $ - msg_welcome

	msg_guess db 'Prova a indovinare una lettera', 0xA
	msg_guess_len equ $ - msg_guess

	msg_win db 'Complimenti!!! Hai vinto: il Gabibbo è fiero di te!!!', 0xA
	msg_win_len equ $ - msg_win

	msg_lose db 'Che peccato, hai perso. Skill issue.', 0xA
	         db 'La frase segreta era', 0xA
	msg_lose_len equ $ - msg_lose

	vowels db 'aeiou', 0x00
	consonants db 'bcdfghjklmnpqrstvwxyz', 0x00

segment .bss
	secret resb secret_len
	hints resb secret_len
	guess resb 2

segment .text
	global _start
_start:
	write_string msg_welcome, msg_welcome_len

	mov eax, SYS_READ
	mov ebx, STDIN
	mov ecx, secret
	mov edx, secret_len
	int 0x80

	mov ecx, 8
main_loop:
	mov eax, ecx
	push ecx
	call print_hangman
	call print_hints
	pop ecx

	push ecx
	call count_missing
	pop ecx

	cmp eax, 0x00
	je win

	cmp ecx, 0x00
	je lose

	push ecx
	write_string msg_guess, msg_guess_len
	pop ecx

	push ecx
	mov eax, SYS_READ
	mov ebx, STDIN
	mov ecx, guess
	mov edx, 2
	int 0x80
	pop ecx

	push ecx
	call process_guess
	cmp ecx, 0x00
	pop ecx
	jne main_loop 
	dec ecx
	jmp main_loop
lose:
	write_string msg_lose, msg_lose_len
	write_string secret, secret_len
	jmp exit
win:
	write_string msg_win, msg_win_len
	jmp exit

print_hangman:
	mov dl, 4
	mul dl
	mov ecx, eax
	add ecx, icons

	write_string [ecx], icon_len
	ret

print_hints:
	mov eax, 0      ; lunghezza stringa
	mov ebx, secret
	mov ecx, buf
	mov edx, hints

print_hints_loop:
	cmp byte [ebx], 0x00
	je print_hints_end

	cmp byte [ecx], 0x00 ; lettera già indovinata
	jne print_hints_copy_buffer

	push_all
	mov al, byte [ebx]
	mov ebx, vowels
	call check_if_in ; vocale
	cmp al, 0x01
	pop_all
	je print_hints_insert_plus

	push_all
	mov al, byte [ebx]
	mov ebx, consonants
	call check_if_in ; consonante
	cmp cl, 0x01
	pop_all
	je print_hints_insert_minus
print_hints_copy_secret:
	push ebx
	mov ebx, [ebx]
	mov [edx], ebx
	pop ebx
	jmp print_hints_continue
print_hints_copy_buffer:
	push ecx
	mov ecx, [ecx]
	mov [edx], ecx
	pop ecx
	jmp print_hints_continue
print_hints_insert_plus:
	mov byte [edx], '+'
	jmp print_hints_continue
print_hints_insert_minus:
	mov byte [edx], '-'
	jmp print_hints_continue

print_hints_continue:
	inc eax
	inc ebx
	inc ecx
	inc edx
	jmp print_hints_loop
print_hints_end:
	push eax
	mov eax, SYS_WRITE
	mov ebx, STDOUT
	mov ecx, hints
	pop edx
	int 0x80
	ret

check_if_in:
	mov cl, 0
check_if_in_loop:
	cmp byte [ebx], 0x00
	je check_if_in_end

	cmp byte [ebx], al
	je check_if_in_good_end
	inc ebx
	jmp check_if_in_loop
check_if_in_good_end:
	mov cl, 1
check_if_in_end:
	mov al, cl
	ret

process_guess:
	mov eax, secret
	mov ebx, buf
	mov ecx, 0
	dec eax
	dec ebx

process_guess_loop:
	inc eax
	inc ebx
	cmp byte [eax], 0x00
	je process_guess_end
	push eax
	mov al, byte [eax]
	cmp byte [guess], al 
	pop eax
	jne process_guess_loop
	push eax
	mov al, byte [eax]
	mov [ebx], al 
	pop eax
	inc ecx
	jmp process_guess_loop
process_guess_end:
	mov eax, ecx
	ret

count_missing:
	mov eax, secret
	mov ebx, buf
	mov ecx, 0
	dec eax
	dec ebx
count_missing_loop:
	inc eax
	inc ebx
	cmp byte [eax], 0x00
	je count_missing_end
	cmp byte [eax], 'a'
	jl count_missing_loop
	cmp byte [eax], 'z'
	jg count_missing_loop
	cmp byte [ebx], 0x00
	jne count_missing_loop
	inc ecx
	jmp count_missing_loop
count_missing_end:
	mov eax, ecx
	ret

exit:
	mov eax, SYS_EXIT
	int 0x80
