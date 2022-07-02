#include <stdio.h> 
#include <stdlib.h>
#include <string.h>
// compile with -no-pie -fno-stack-protector
char ez[100];

void clear() {
    /*
    for (int i = 0; i < 300; i++) {
        printf("\n");
    }
    */
    // Deviante leccata da stackoverflow
    printf("\033[2J\033[1;1H");
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

void sussiervuln() {
    printf("easy mode: %s", ez);
}

void vuln(char* parola) { //buffer overflow con argomenti, è possibile?
    //printf("%s =? %s => %d", buffer, parola, strncmp(buffer, parola, 100));
    printf("mentre dormi, Leo sta già flaggando: %s", parola);
}

void omino(int err) { //Al contrario di quel poser di leo la grafica è tutta fatta in casa
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
    
    clear();

    for (i = 0; buffer[i] != '\0'; i++){
        if (buffer[i] == 'u' ||buffer[i] == 'o' ||buffer[i] == 'i' ||buffer[i] == 'e' ||buffer[i] == 'a') {
            parola[i] = '+';
        } else parola[i] = '-';
    }
    parola[i] = '\0';
    //printf("%d", parola[i]);
    strcpy(ez, buffer);

    int m = 0;
    if (m == 1) vuln(ez); //🤔
    //sussiervuln();

    while(1){
        printf("\n\n%s\n", parola);
        printf("Prova ad inserire una lettera:\n");
        
        while ((getchar()) != '\n');
        lettera = getchar();
        printf("inserito: %c\n", lettera);
        
        err += checkword(buffer, parola, lettera);
        
        omino(err);
        

        if (strncmp(buffer, parola, 100) == 0) {
            printf("\nHai vinto! :)\n");
            exit(0);
        }
        
    }
    return 0;
}