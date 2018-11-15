import io
import random
def acento(word):
    for c in word:
        if(c >= 'á' and c <= 'ú' or c == 'é'):
            return True
    return False

def creaPalabra(word):
    word1 = word.replace('á','a')
    word1 = word1.replace('é','e')
    word1 = word1.replace('í','i')
    word1 = word1.replace('ó','o')
    word1 = word1.replace('ú','u')
    if (word != word1):
        print("<dict>")
        print("<key>right</key>")
        print("<string>" + word + "</string>")
        print("<key>wrong</key>")
        print("<string>" + word1 + "</string>")
        print("</dict>")

def creaPalabra2(word):
    word1 = word.replace("ción", "sión")
    if (word != word1):
        print("<dict>")
        print("<key>right</key>")
        print("<string>" + word + "</string>")
        print("<key>wrong</key>")
        print("<string>" + word1 + "</string>")
        print("</dict>")

def creaPalabra3(word):
    word1 = word.replace("v", "b", 1)
    if (word1 != word):
        print("<dict>")
        print("<key>right</key>")
        print("<string>" + word + "</string>")
        print("<key>wrong</key>")
        print("<string>" + word1 + "</string>")
        print("</dict>")

def creaPalabra4(word):
    word1 = word.replace("ll", "y")
    if (word != word1):
        print("<dict>")
        print("<key>right</key>")
        print("<string>" + word + "</string>")
        print("<key>wrong</key>")
        print("<string>" + word1 + "</string>")
        print("</dict>")

def creaPalabra5(word):
    word1 =word.replace("z", "s",1)
    if (word!= word1):
        print("<dict>")
        print("<key>right</key>")
        print("<string>" + word + "</string>")
        print("<key>wrong</key>")
        print("<string>" + word1 + "</string>")
        print("</dict>")

print("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
print("<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">")
print("<plist version=\"1.0\">")
print("<array>")
f = io.open ('prueba2.txt')
mensaje = f.read()
Palabras = set()
for word in mensaje.split():
    if (len(word) > 5 and len(word) < 13):
        for c in "- .,\"":
            word = word.replace(c, '')
        word = word.lower()
        if (word.isalpha() and word not in Palabras):
            if("ción" in word):
                creaPalabra2(word)
            if (acento(word)):
                creaPalabra(word)
            if ("v" in word):
                creaPalabra3(word)
            if ("ll" in word):
                creaPalabra4(word)
            if ("z" in word):
                creaPalabra5(word)
        Palabras.add(word)
            
print("</array>")
print("</plist>")
f.close()
