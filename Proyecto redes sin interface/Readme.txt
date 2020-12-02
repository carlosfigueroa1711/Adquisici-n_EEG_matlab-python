Este es el prototipo base del proyecto de redes neuronales.
En este trabajo se realizan las graficas de comparación de la salida de cada una de las redes.

el archivo Proyecto.m viene comentado en su codigo para conocer cada una de sus partes.

para correr este programa es necesario tener archivos EDF ubicados dentro del equipo, no es necesario que se encuentren dentro de la misma carpeta.

Es necesario tener instalado el toolbox de matlab edfread, el cual se encuentra dentro de la carpeta edfread matlab de este trabajo.

Una vez instalado el toolbox se corre el archivo proyecto.m en matlab

al correr el programa se deberá seleccionar un archivo .edf para analizarlo.

al ejecutar este codigo, el programa realizara lo siguiente.
 
1.- Analizara toda la señal completa por ventana de datos.

2.- Cuando se detecte un evento, se desplegará en una ventana. (una ventana nueva (figure) por cada evento)

3.- Se graficarán las respuestas de cada una de las redes neuronales.
    En la ventana figure 501 se mostraran los resultados de la red experta en la expresión si
    En la ventana figure 502 se mostraran los resultados de la red experta en la expresión no
    En la ventana figure 503 se mostraran los resultados de la red experta en la expresión mas o menos
    En la ventana figure 504 se mostraran los resultados de la red experta en la expresión no sé
    En la ventana figure 505 se mostraran los resultados de la red experta en ruido

   NOTA ** estas ventanas no deberan ser cerradas si se desea conocer la salida de las redes expertas en cada expresión

4.- Se gráficaran los 4 canales que se estan analizando.

5.- se graficaran las varianzas de los 4 canales a lo largo del tiempo

6.- Se graficaran los eventos detectados a lo largo del tiempo y su posición.

