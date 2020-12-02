close all; clc; clear all;

[fname, pname] = uigetfile({'*.edf';'*.bdf';               ...
   'Archivo de excel';},'Selecciona base de datos');
    
ruta=[pname fname];

%Funcion de lectura de archivos EDF
%arch_edf=pop_readbdf(ruta);
[h,r]=edfread(ruta);
%%
%Lectura de los datos EDF.
%datos=arch_edf.data;
datos=r;
fm=max(h.frequency)*2;

fc=2/(fm/2);  %Frecuencia de corte del filtro
N=1;   %Orden del filtro
[a,b]=butter(N,fc,'low');  %Filtro pasa bajas para eliminar ruidos

%Eliminación de offset
AF3_o=(datos(3,:))-4100;
F7_o=(datos(4,:))-4100;
F8_o=(datos(15,:))-4100;
AF4_o=(datos(16,:))-4100;

%Filtrado para eliminacion de offset
but_AF3=filter(a,b,AF3_o);
but_F7=filter(a,b,F7_o);
but_F8=filter(a,b,F8_o);
but_AF4=filter(a,b,AF4_o);

AF3_G=but_AF3-(mean(but_AF3));
F7_G=but_F7-(mean(but_F7));
F8_G=but_F8-(mean(but_F8));
AF4_G=but_AF4-(mean(but_AF4));

figure,
subplot 221; plot(but_AF3,'linewidth',1); title('Canal AF3'); xlabel('Número de muestras'); ylabel('uV'); set(gca, 'fontsize', 13) 
subplot 222; plot(but_F7,'linewidth',1);title('Canal F7'); xlabel('Número de muestras'); ylabel('uV'); set(gca, 'fontsize', 13) 
subplot 223; plot(but_F8,'linewidth',1);title('Canal F8'); xlabel('Número de muestras'); ylabel('uV'); set(gca, 'fontsize', 13) 
subplot 224; plot(but_AF4,'linewidth',1);title('Canal AF4'); xlabel('Número de muestras'); ylabel('uV'); set(gca, 'fontsize', 13) 

figure,
subplot 221; plot(AF3_G,'linewidth',1); title('Canal AF3'); xlabel('Número de muestras'); ylabel('uV'); set(gca, 'fontsize', 13) 
subplot 222; plot(F7_G,'linewidth',1);title('Canal F7'); xlabel('Número de muestras'); ylabel('uV'); set(gca, 'fontsize', 13) 
subplot 223; plot(F8_G,'linewidth',1);title('Canal F8'); xlabel('Número de muestras'); ylabel('uV'); set(gca, 'fontsize', 13) 
subplot 224; plot(AF4_G,'linewidth',1);title('Canal AF4'); xlabel('Número de muestras'); ylabel('uV'); set(gca, 'fontsize', 13) 