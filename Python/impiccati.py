# GIOCO DELL'IMPICCATO - Bombonati Leonardo

# Leggere i tuoi commenti è un toccasana per l'anima, leo -J

# ho rubato questa lista di ascii art ad una repo su github godo
HANGMANPICS = ['''
  +---+
  |   |
      |
      |
      |
      |
=========''', '''
  +---+
  |   |
  O   |
      |
      |
      |
=========''', '''
  +---+
  |   |
  O   |
  |   |
      |
      |
=========''', '''
  +---+
  |   |
  O   |
 /|   |
      |
      |
=========''', '''
  +---+
  |   |
  O   |
 /|\  |
      |
      |
=========''', '''
  +---+
  |   |
  O   |
 /|\  |
 /    |
      |
=========''', '''
  +---+
  |   |
  O   |
 /|\  |
 / \  |
      |
=========''']

def check_lettera(lettera_guessata, parola_listata):
    if lettera_guessata in parola_listata:
        print("\nGrande, lettera trovata!") #vibe check -J
        return 0
    else:
        print("\nGuessa più forte")
        return 1

# ripulire il terminale in modo basato
def based_clear_schermo():
    i = 0
    while(i<300):
        print("\n")
        i = i + 1
        
def main():
    print("\tGIOCO DELL'''''IMPICCATO'''''")
    print("Regole:\n - si gioca in due, il primo scrive la parola e l'altro indovina\n - no frasi, solo una singola parola.\n - solo lettere minuscole.\n\nCominciamo")
    parola = input("Inserisci la parola da impiccare e passa poi il pc al compare: ")
    parola_listata = list(parola)

    # cambio le vocali in + e le restanti consonanti in - 
    parola_impiccata = ""
    for lettera in parola_listata:
        if lettera == 'a' or lettera == 'e' or lettera == 'i' or lettera == 'o' or lettera == 'u':
            parola_impiccata = parola_impiccata + '+'
        else:
            parola_impiccata = parola_impiccata + '-'
    print(parola_impiccata)

    based_clear_schermo()

    # iniziamo a guessare hard
    errore = 0
    lettere_trovate = 0
    already_guessate = []
    print("E' tempo di giocare")
    while(errore < 6):
        lettera_guessata = input("Inserisci una lettera da guessare: ")
        if lettera_guessata in already_guessate:
            # cringe bro, sei demente?
            print("\nHai già provato a guessare questa lettera, cringe")
            print("\nHai trovato per ora ---> " + parola_impiccata)
        else: 
            already_guessate.append(lettera_guessata)
            if check_lettera(lettera_guessata, parola_listata):
                # lettera non presente nella parola, unlucky
                errore = errore + 1
                print(str(errore) + " tentativi su 6")
                print("\nHai trovato per ora ---> " + parola_impiccata)
            else:
                # lettera presente nella parola, che culo ziopera
                contatore = 0
                parola_impiccata = list(parola_impiccata)
                for lettera in parola_listata:
                    if lettera == lettera_guessata:         
                        lettere_trovate = lettere_trovate + 1
                        parola_impiccata[contatore] = lettera_guessata
                    contatore = contatore + 1
                parola_impiccata = ''.join(parola_impiccata)
                if(lettere_trovate == len(parola_impiccata)):
                    break
                print("\nHai trovato per ora ---> " + parola_impiccata)
        print(HANGMANPICS[errore])    
        
    based_clear_schermo()
    print("\tFINE\nLa parola era: " + parola)
    if(errore == 6):
        print("Hai perso lmao Lol\n") # bad ending
    else:
        print("Hai vinto GG EZ\nErrori commessi --> " + str(errore) + "\n\n") # good ending

if __name__ == "__main__":
    main() 
# Com'è possibile che in python ci hai messo più righe di me in C? -J