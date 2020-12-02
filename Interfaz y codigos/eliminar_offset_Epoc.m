function [AF3_id,F7_id,F8_id,AF4_id,tam_cadena]=eliminar_offset(datos,fm)

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

%Colocación de la señal sobre cero
AF3_G=but_AF3-(mean(but_AF3));
F7_G=but_F7-(mean(but_F7));
F8_G=but_F8-(mean(but_F8));
AF4_G=but_AF4-(mean(but_AF4));

%Toma de longitudes de las señales
tam_AF3=length(AF3_G);
tam_F7=length(F7_G);
tam_F8=length(F8_G);
tam_AF4=length(AF4_G);

Tam_3_7=min(tam_AF3,tam_F7);
Tam_8_4=min(tam_F8,tam_AF4);
Tam_t=min(Tam_3_7,Tam_8_4);

%Eliminación del 2% inicial de los datos
%para eliminar el error de los filtros ideales
Tam_in= round((2*Tam_t)/100);

%Carga de los datos origen filtrados y sin offset
AF3_id=AF3_G(Tam_in:Tam_t);
F7_id=F7_G(Tam_in:Tam_t);
F8_id=F8_G(Tam_in:Tam_t);
AF4_id=AF4_G(Tam_in:Tam_t);


tam_cadena=Tam_t-Tam_in;
