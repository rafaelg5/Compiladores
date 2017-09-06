Para los ejemplos de esta práctica vamos a utilizar la implementación
de Lex llamada Flex. Debido a que tiene funcionalidades extra que nos van
a ser útiles.

1. Objetivo
Aprender a definir y utilizar el analizador léxico generado por Flex.
Reconocer los símbolos de un lenguaje de programación y poder generar
tokens. También se busca poder manejar la máquina de estados que usa
Flex.

2. Introducción
Vamos a utilizar Flex para crear un analizador léxico para un compilador. 
Esta herramienta genera programas que realizan casa de patrones
sobre texto. A este programa tambíen se le puede llamar Scanner. Funciona
definiendo parejas de expresiones regulares y código en C/C++ llamadas
Reglas.

3. Ejercicios

Para esta práctica tendrán que escribir un analizador léxico que reco-
nozca los símbolos de un lenguaje de programación básico.

Los símbolos básicos que deben de reconocer son: números enteros,
identificadores, cadenas, palabras clave, espacios en blanco, comentarios y
operadores.

3.1. Detalles
Números enteros van a ser cadenas no vacias de dígitos 0-9.
Identificadores son cadenas (distintas de las palabras claves) que
pueden contener letras, digitos y el guión bajo .
Cadenas serán todos los caracteres que esten encerrados entre las
dobles comillas ” ... ” . El caracter nulo \0 o el fin de archivo EOF no
deben de estar dentro de la cadena.

Palabras Clave: class, if, then, else, while, do, od, case, of , new, is-
void, not, true, false.

Los espacios en blanco consisten en cualquier secuencia de los si-
guientes caracteres: blank (ascii 32), \n (newline, ascii 10), \f (form-
feed, ascii 12), \r (carriage return, ascii 13), \t (tab, ascii 9), \v (ver-
tical tab, ascii 11).

Los comentarios habrá de una sola linea, que es todo lo que este
entre ”//” y la siguiente nueva linea. También habrá de sección de
texto, que será cualquier texto entre los simbolos /* y */ .
Operadores: <-, ( , ) , . ,+, -, * , /, ~, <, <=, =, :, ; {, }
La entrada de su parser va a ser un archivo de texto y la salida será
otro archivo de texto donde cada símbolo reconocido es sustituido por
una constante númerica única para cada uno. De preferencia definan cada
constante en un archivo de encabezado de C, o si quieren la sección de
definiciones de su archivo flex.
Deberan mostrar un mensaje cada vez que se reconozca algo que no
sea parte de los símbolos ya especificados.
