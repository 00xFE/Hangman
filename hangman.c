#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void clear() {
    for (int i = 0; i < 300; i++) {
        printf("\n");
    }
}

int checkword(char *buffer, char *parola, char lettera) {
    int found = 0;
    for (int i = 0; buffer[i] != '\0'; i++){        
        
        if (buffer[i] == lettera) {
            parola[i] = lettera;
            found++;
        }

    }
    if (found == 0) {
        printf("\nLettera sbagliata!\n");
        return 1;
    } else {
        printf("Ci hai preso!\n");
        return 0;
    }
}

void omino(int err) {
    if (err == 0) {
        printf("T------|\n");
        printf("|      \n");
        printf("|     \n");
        printf("|      \n");
        printf("------------\n");
        
    } else if (err == 1) {
        printf("T------|\n");
        printf("|      0\n");
        printf("|     \n");
        printf("|      \n");
        printf("------------\n");

    } else if (err == 2) {
        printf("T------|\n");
        printf("|      0\n");
        printf("|      |\n");
        printf("|      \n");
        printf("------------\n");
        
    }else if (err == 3) {
        printf("T------|\n");
        printf("|      0\n");
        printf("|      |-\n");
        printf("|      \n");
        printf("------------\n");
        
    }else if (err == 4) {
        printf("T------|\n");
        printf("|      0\n");
        printf("|     -|-\n");
        printf("|       \n");
        printf("------------\n");
        
    }else if (err == 5) {
        printf("T------|\n");
        printf("|      0\n");
        printf("|     -|-\n");
        printf("|      \\ \n");
        printf("------------\n");

    }else if (err == 6) {
        printf("T------|\n");
        printf("|      0\n");
        printf("|     -|-\n");
        printf("|     /\\ \n");
        printf("------------\n");

        printf("Hai perso :(\n");
        exit(0);
    }
}

int main () {
    char lettera;
    char buffer[100], parola[100];
    int i, k;
    int err = 0;
    printf("BENVENUTO ALL'IMPICCATO\n\nInserisci una parola ma non farla vedere al tuo avversario:\n");
    printf("(Solo minuscole, niente spazi o caratteri speciali)\n");
    scanf("%s", buffer);
    
    //clear();

    for (i = 0; buffer[i] != '\0'; i++){
        if (buffer[i] == 'u' ||buffer[i] == 'o' ||buffer[i] == 'i' ||buffer[i] == 'e' ||buffer[i] == 'a') {
            parola[i] = '+';
        } else parola[i] = '-';
    }
    //scanf("%s");
    //while(1){
        printf("Prova ad inserire una lettera:\n");
        //putchar(stdin);
        char lett[1];
        fgets(lett, 1, stdin);
        printf("inserito: %c", lett);
        
        //err += checkword(buffer, parola, lettera);
        /*
        omino(err);
        printf("\n\n%s\n", parola);
        if (strcmp(buffer, parola) == 0) {
            printf("\nHai vinto! :)\n");
            exit(0);
        }
        */
    //}
    return 0;
}