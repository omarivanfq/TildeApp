#include <iostream>
#include <fstream>
#include <time.h>
#include <locale>
#include <wchar.h>
using namespace std;


ofstream salida("Swiping.plist");

void crearPalabra(string palabra, bool correcta) {
    printf("<dict>\n");
    printf("<key>word</key>\n");
    printf("<string>");
    if (correcta) {
        printf("%s\n",palabra.c_str());
    } else {
        for(int i = 0; i < palabra.length(); i++) {
            if(palabra[i] >= 'á' && palabra[i] <= 'ú') {
                if(palabra[i] == 'á')
                    palabra[i] = 'a';
                else if (palabra[i] == 'é')
                    palabra[i] = 'e';
                else if (palabra[i] == 'í')
                    palabra[i] = 'i';
                else if (palabra[i] == 'ó')
                    palabra[i] = 'o';
                else if (palabra[i] == 'ú')
                    palabra[i] = 'u';

            }
        }
        printf("%s\n",palabra.c_str());        
    }
    printf("</string>\n");
    printf("<key>correct</key>\n");
    if (correcta) {
		printf("<true/>\n");
    } else {
        printf("<false/>\n");
    }
	printf("</dict>\n");
}
int main()
{
    setlocale(LC_ALL, "");
    srand(time(NULL));
    printf("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
    printf("<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">\n");
    printf("<plist version=\"1.0\">\n");
    printf("<array>\n");
    ifstream en("prueba.txt");
    string palabra;
    while (en >> palabra) {
        if (palabra.length() >= 5) {
            for (int i =0; i < palabra.length(); i++) {
                if(palabra[i] >= 'á' && palabra[i] <= 'ú') {
                    crearPalabra(palabra, rand()%2);
                }
            }
        }
    }
    printf("</array>\n");
    printf("</plist>\n");
    return 0;
}
