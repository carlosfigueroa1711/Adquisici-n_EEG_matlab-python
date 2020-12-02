%close all; 
clc; clear all;

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
%%
%Filtro pasa bajas
%fm=arch_edf.srate*2;  %Frecuencia de muestreo 128 Hz
fm=max(h.frequency)*2;
[AF3_id,F7_id,F8_id,AF4_id,tam_cadena]=eliminar_offset(datos,fm);

%Determinación del tamaño de la ventana y entrenamiento para determinar
%valor maximo en normalización.
paso=64;
[var_af3_base, var_f7_base, var_f8_base, var_af4_base]= ...
    entranamiento_varianzas(AF3_id,AF4_id,F7_id,F8_id, paso, tam_cadena,fm);


%Creación del sistema difuso para deteccion de evento
Fiev=deteccion_evento_2;

ev=0;
F8_evento=[]; 
F7_evento=[]; 
AF3_evento=[]; 
AF4_evento=[]; 

c=0;
d=0;
im=0;
i=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  En esta parte se seleccionara de donde será tomada la varianza maxima
%  Puede ser tomada del mismo archivo que será analizado o bien trabajar
%  con promedio de varianzas calculadas anteriormente

AF3_max=max(var_af3_base);
AF4_max=max(var_af4_base);
F7_max=max(var_f7_base);
F8_max=max(var_f8_base);

%
%Valores referenciales Carlos
% AF3         AF4            F7       F8
%2.51E+03	2.80E+03	1.26E+04	3.83E+03
% AF3_max=2.51E+03;
% AF4_max=2.80E+03;
% F7_max=1.26E+04;
% F8_max=3.83E+03;

% Valores referenciales Jorge
% Prom AF3	prom AF4	Prom F7	Prom F8
% 6.94E+03	5.99E+03	3.12E+04	7.15E+04
% AF3_max=6.94E+03;
% AF4_max=5.99E+03;
% F7_max=3.12E+04;
% F8_max=7.15E+04;

%Brenda Olivas
% AF3_max=1.6630e+03;
% AF4_max=2.5309e+03;
% F7_max=1.3432e+03;
% F8_max=1.9465e+03;

%Abimael Guzman
% AF3_max=3.9931e+03;
% AF4_max=7.1651e+03;
% F7_max=2.8736e+04;
% F8_max=5.9252e+03;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Carga de redes neuronales expertas
load('red_masomenos.mat');
load('red_no.mat');
load('red_si.mat');
load('red_ruido.mat');
load('red_nose.mat');
v=0;
ref=0;

% Inicio de algoritmo 
for i=0:paso:(tam_cadena)
    v=v+1;
    
    %Analisis por ventaneo. (ventaneo de la señal original "258 muestras
    %por ventana")
     if i<=fm && i>2
        AF3_t((i-paso)+1:i)=AF3_id((i-paso)+1:i);
        F7_t((i-paso)+1:i)=F7_id((i-paso)+1:i);
        F8_t((i-paso)+1:i)=F8_id((i-paso)+1:i);
        AF4_t((i-paso)+1:i)=AF4_id((i-paso)+1:i);
    elseif i==fm
        subplot 411; plot(AF3_t); title('AF3'); xlabel('Muestras'); ylabel('Uv');
        subplot 412; plot(F7_t); title('F7'); xlabel('Muestras'); ylabel('Uv');
        subplot 413; plot(F8_t); title('F8'); xlabel('Muestras'); ylabel('Uv');
        subplot 414; plot(AF4_t); title('AF4'); xlabel('Muestras'); ylabel('Uv');
    elseif i>fm && i<tam_cadena
        AF3(1:fm-(paso-1))=AF3_t(paso:fm);
        F7(1:fm-(paso-1))=F7_t(paso:fm);
        F8(1:fm-(paso-1))=F8_t(paso:fm);
        AF4(1:fm-(paso-1))=AF4_t(paso:fm);
        
        AF3(fm-paso:fm)=AF3_id(i-paso:i);
        F7(fm-paso:fm)=F7_id(i-paso:i);
        F8(fm-paso:fm)=F8_id(i-paso:i);
        AF4(fm-paso:fm)=AF4_id(i-paso:i);
        
%         desviacion_af3_muestra(i)=std(AF3);
        var_af3_muestra(i)=var(AF3)/AF3_max;
% 
% %         desviacion_f7_muestra(i)=std(F7);
        var_f7_muestra(i)=var(F7)/F7_max;
%         
% %         desviacion_f8_muestra(i)=std(F8);
        var_f8_muestra(i)=var(F8)/F8_max;
% 
% %         desviacion_af4_muestra(i)=std(AF4);
        var_af4_muestra(i)=var(AF4)/AF4_max;
        
        %Revisión de las varianzas por medio del sistema difuso
        r=evalfis([double(var_af3_muestra(i)) double(var_af4_muestra(i))...
            double(var_f7_muestra(i)) double(var_f8_muestra(i))],Fiev);
        if r >= 0.5
              c=c+1;
            d=d+paso+1;
            im=1;
            %Acumulación de señales correspondientes a eventos
            F8_evento(d-paso:d)=F8_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2));
            F7_evento(d-paso:d)=F7_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2));
            AF3_evento(d-paso:d)=AF3_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2));
            AF4_evento(d-paso:d)=AF4_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2));
            detec=1;
            figure(600+ev),
            hold on;
            subplot 411; plot(AF3_evento); title ('Eventos en AF3'); xlabel ('Muestras'); ylabel('uV');
            subplot 412; plot(AF4_evento); title ('Eventos en AF4'); xlabel ('Muestras'); ylabel('uV');
            subplot 413; plot(F7_evento); title ('Eventos en F7'); xlabel ('Muestras'); ylabel('uV');
            subplot 414; plot(F8_evento); title ('Eventos en F8'); xlabel ('Muestras'); ylabel('uV');
            
                        
            if c>=fm
                c=0;
            end
            evento(i-paso:i)=1;
        else 
            evento(i-paso+1:i)=0;
            if length(F8_evento)>1
                ev=ev+1;   
                
                %Promedio de las señales detectadas como evento.

                if ev==1;
                    signal_F8_ev(ev,(1:d))=F8_evento;
                    signal_F7_ev(ev,(1:d))=F7_evento;  
                    signal_AF3_ev(ev,(1:d))=AF3_evento;
                    signal_AF4_ev(ev,(1:d))=AF4_evento;
                    analisis1(ev,(1:d))=(signal_F8_ev(ev,(1:d))+signal_F7_ev(ev,(1:d))...
                        +signal_AF3_ev(ev,(1:d))+signal_AF4_ev(ev,(1:d)));
                    reg=d;
                else
                    if reg<=d
                        signal_F8_ev(ev,(1:d))=F8_evento;
                        signal_F7_ev(ev,(1:d))=F7_evento;  
                        signal_AF3_ev(ev,(1:d))=AF3_evento;
                        signal_AF4_ev(ev,(1:d))=AF4_evento;
                        analisis1(ev,(1:d))=(signal_F8_ev(ev,(1:d))+signal_F7_ev(ev,(1:d))...
                            +signal_AF3_ev(ev,(1:d))+signal_AF4_ev(ev,(1:d)));
                        reg=d;
                        
                    else                        
                        signal_F8_ev(ev,(1:reg))=zeros(1,reg);
                        signal_F7_ev(ev,(1:reg))=zeros(1,reg);  
                        signal_AF3_ev(ev,(1:reg))=zeros(1,reg);
                        signal_AF4_ev(ev,(1:reg))=zeros(1,reg);
                        analisis1(ev,(1:reg))=zeros(1,reg);
                        
                        signal_F8_ev(ev,(1:d))=F8_evento(1:d);
                        signal_F7_ev(ev,(1:d))=F7_evento(1:d);  
                        signal_AF3_ev(ev,(1:d))=AF3_evento(1:d);
                        signal_AF4_ev(ev,(1:d))=AF4_evento(1:d);
                        analisis1(ev,(1:d))=(signal_F8_ev(ev,(1:d))+signal_F7_ev(ev,(1:d))...
                            +signal_AF3_ev(ev,(1:d))+signal_AF4_ev(ev,(1:d)));
                        
                    end
                end
                
                
                % Caracteristicas de las señales correspondientes a eventos
                analisis(ev,(1:d))=analisis1(ev,(1:d))/max(analisis1(ev,(1:d)));
                figure(),
                plot(analisis(ev,(1:d))); title('Evento normalizado'); xlabel('Muestras'); ylabel ('uV');
                desviacion_analisis(ev)= std(analisis(ev,(1:d)));
                Energia(ev)=sum(analisis(ev,(1:d)).^2);
                Entropia_analisis(ev)=entropy(double(analisis(ev,(1:d))));
                
                [peak_value, peak_location] = findpeaks(analisis(ev,(1:d)),'minpeakheight',0.3);
                [amplitudes,delta,theta,alpha,F]=fourier(analisis(ev,(1:d)));
                Vector(ev,1:6)=[desviacion_analisis(ev),delta, theta,alpha,length(peak_value),Energia(ev)];

                
                %Evaluación de las caracterisitcas en las redes neuronales
                r_si(ev,1:2)=net_si(Vector(ev,1:6)');
                r_no(ev,1:2)=net_no(Vector(ev,1:6)');
                r_maso(ev,1:2)=net_maso(Vector(ev,1:6)');
                r_nose(ev,1:2)=net_nose(Vector(ev,1:6)');
                r_ruido(ev,1:2)=net_noclase(Vector(ev,1:6)');
                
                if r_si(ev,1)>0.5
                    if r_si(ev,1)>0.2+r_si(ev,2);
                        p_si=r_si(ev,1);
                    else
                        p_si=0;
                    end
                else
                    p_si=0;
                end
                
                if r_no(ev,1)>0.5
                    if r_no(ev,1)>0.2+r_no(ev,2);
                        p_no=r_no(ev,1);
                    else
                        p_no=0;
                    end
                else
                    p_no=0;
                end
                
                if r_maso(ev,1)>0.5
                    if r_maso(ev,1)>0.2+r_maso(ev,2);
                        p_maso=r_maso(ev,1);
                    else
                        p_maso=0;
                    end
                else
                    p_maso=0;
                end
                
                
                if r_nose(ev,1)>0.5
                    if r_nose(ev,1)>0.2+r_nose(ev,2);
                        p_nose = r_nose(ev,1);
                    else
                        p_nose=0;
                    end
                else
                    p_nose=0;
                end
                
                if r_ruido(ev,1)>0.5
                    if r_ruido(ev,1)>0.2+r_ruido(ev,2);
                        p_ruido=r_ruido(ev,1);
                    else
                        p_ruido=0;
                    end
                else
                    p_ruido=0;
                end

                si='si';
                no='no';
                maso='masomenos';
                nose='no se';
                ruido='ruido';
                
                % Gráficas de resultados para cada red neuronal
                if p_si>p_no && p_si>p_nose &&...
                        p_si>p_maso && p_si>p_ruido
                    respuesta(1,ev)={si};
                    figure(501),
           
                    subplot 321; 
                    plot(r_si(ev,1),r_si(ev,2),'bo'); title('respuesta de la red si');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 322; 
                    plot(r_no(ev,1),r_no(ev,2),'r+'); title('respuesta de la red no');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 323; 
                    plot(r_maso(ev,1),r_maso(ev,2),'gx'); title('respuesta de la red más o menos');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 324; 
                    plot(r_nose(ev,1),r_nose(ev,2),'k*'); title('respuesta de la red no sé');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 325; plot(r_ruido(ev,1),r_ruido(ev,2),'mh'); title('respuesta de la red ruido');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    
                    subplot 326;
                    plot(r_si(ev,1),r_si(ev,2),'bo'); title('resultados de la expresion si');
                    hold on;
                    plot(r_no(ev,1),r_no(ev,2),'r+');
                    hold on;
                    plot(r_maso(ev,1),r_maso(ev,2),'gx');
                    hold on;
                    plot(r_nose(ev,1),r_nose(ev,2),'k*');
                    hold on;
                    plot(r_ruido(ev,1),r_ruido(ev,2),'mh');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    legend('si','no','más o menos','no sé','ruido');
                    hold on;
                    
                elseif p_no>p_si && p_no>p_nose &&...
                        p_no>p_maso && p_no>p_ruido
                    respuesta(1,ev)={no};
                    figure(502),
                    
                    subplot 321; 
                    plot(r_si(ev,1),r_si(ev,2),'bo'); title('respuesta de la red si');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 322; 
                    plot(r_no(ev,1),r_no(ev,2),'r+'); title('respuesta de la red no');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 323; 
                    plot(r_maso(ev,1),r_maso(ev,2),'gx'); title('respuesta de la red más o menos');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 324; 
                    plot(r_nose(ev,1),r_nose(ev,2),'k*'); title('respuesta de la red no sé');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 325; 
                    plot(r_ruido(ev,1),r_ruido(ev,2),'mh'); title('respuesta de la red ruido');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    
                    subplot 326;
                    plot(r_si(ev,1),r_si(ev,2),'bo'); title('resultados de la expresion no');
                    hold on;
                    plot(r_no(ev,1),r_no(ev,2),'r+');
                    hold on;
                    plot(r_maso(ev,1),r_maso(ev,2),'gx');
                    hold on;
                    plot(r_nose(ev,1),r_nose(ev,2),'k*');
                    hold on;
                    plot(r_ruido(ev,1),r_ruido(ev,2),'mh');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    legend('si','no','más o menos','no sé','ruido');
                    hold on;
                    
                elseif p_maso>p_no && p_maso>p_nose  &&...
                        p_maso>p_si && p_maso>p_ruido
                    respuesta(1,ev)={maso};
                    figure(503),
                    
                    subplot 321; 
                    plot(r_si(ev,1),r_si(ev,2),'bo'); title('respuesta de la red si');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 322; 
                    plot(r_no(ev,1),r_no(ev,2),'r+'); title('respuesta de la red no');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 323; 
                    plot(r_maso(ev,1),r_maso(ev,2),'gx'); title('respuesta de la red más o menos');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 324; 
                    plot(r_nose(ev,1),r_nose(ev,2),'k*'); title('respuesta de la red no sé');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 325; 
                    plot(r_ruido(ev,1),r_ruido(ev,2),'mh'); title('respuesta de la red ruido');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    
                    subplot 326;
                    plot(r_si(ev,1),r_si(ev,2),'bo'); title('resultados de la expresion más o menos');
                    hold on;
                    plot(r_no(ev,1),r_no(ev,2),'r+');
                    hold on;
                    plot(r_maso(ev,1),r_maso(ev,2),'gx');
                    hold on;
                    plot(r_nose(ev,1),r_nose(ev,2),'k*');
                    hold on;
                    plot(r_ruido(ev,1),r_ruido(ev,2),'mh');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    legend('si','no','más o menos','no sé','ruido');
                    hold on;
                    
                    
                elseif p_nose>p_no && p_nose>p_si  &&...
                        p_nose>p_maso && p_nose>p_ruido
                    respuesta(1,ev)={nose};
                    ref=ref+1;
                    var_f8(ref)=var(F8_evento(:,:));            
                    var_f7(ref)=var(F7_evento(:,:));            
                    var_af3(ref)=var(AF3_evento(:,:));            
                    var_af4(ref)=var(AF4_evento(:,:));
                    
                    figure(504),
                    
                    subplot 321; 
                    plot(r_si(ev,1),r_si(ev,2),'bo'); title('respuesta de la red si');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 322; plot(r_no(ev,1),r_no(ev,2),'r+'); title('respuesta de la red no');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 323; plot(r_maso(ev,1),r_maso(ev,2),'gx'); title('respuesta de la red más o menos');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 324; plot(r_nose(ev,1),r_nose(ev,2),'k*'); title('respuesta de la red no sé');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 325; plot(r_ruido(ev,1),r_ruido(ev,2),'mh'); title('respuesta de la red ruido');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    
                    subplot 326;plot(r_si(ev,1),r_si(ev,2),'bo'); title('resultados de la expresion no sé');
                    hold on;
                    plot(r_no(ev,1),r_no(ev,2),'r+');
                    hold on;
                    plot(r_maso(ev,1),r_maso(ev,2),'gx');
                    hold on;
                    plot(r_nose(ev,1),r_nose(ev,2),'k*');
                    hold on;
                    plot(r_ruido(ev,1),r_ruido(ev,2),'mh');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    legend('si','no','más o menos','no sé','ruido');
                    hold on;
                    

                elseif p_ruido>p_no && p_ruido>p_nose  &&...
                        p_ruido>p_maso && p_ruido>p_si
                    respuesta(1,ev)={ruido};
                    figure(505),
                    
                    subplot 321; plot(r_si(ev,1),r_si(ev,2),'bo'); title('respuesta de la red si');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 322; plot(r_no(ev,1),r_no(ev,2),'r+'); title('respuesta de la red no');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 323; plot(r_maso(ev,1),r_maso(ev,2),'gx'); title('respuesta de la red más o menos');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 324; plot(r_nose(ev,1),r_nose(ev,2),'k*'); title('respuesta de la red no sé');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 325; plot(r_ruido(ev,1),r_ruido(ev,2),'mh'); title('respuesta de la red ruido');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    
                    subplot 326;plot(r_si(ev,1),r_si(ev,2),'bo'); title('resultados de ruido');
                    hold on;
                    plot(r_no(ev,1),r_no(ev,2),'r+');
                    hold on;
                    plot(r_maso(ev,1),r_maso(ev,2),'gx');
                    hold on;
                    plot(r_nose(ev,1),r_nose(ev,2),'k*');
                    hold on;
                    plot(r_ruido(ev,1),r_ruido(ev,2),'mh');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    legend('si','no','más o menos','no sé','ruido');
                    hold on;
                    
                else
                    respuesta(1,ev)={ruido};
                    figure(505),
                    
                    subplot 321; plot(r_si(ev,1),r_si(ev,2),'bo'); title('respuesta de la red si');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 322; plot(r_no(ev,1),r_no(ev,2),'r+'); title('respuesta de la red no');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 323; plot(r_maso(ev,1),r_maso(ev,2),'gx'); title('respuesta de la red más o menos');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 324; plot(r_nose(ev,1),r_nose(ev,2),'k*'); title('respuesta de la red no sé');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    subplot 325; plot(r_ruido(ev,1),r_ruido(ev,2),'mh'); title('respuesta de la red ruido');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    hold on;
                    
                    subplot 326;plot(r_si(ev,1),r_si(ev,2),'bo'); title('resultados de ruido');
                    hold on;
                    plot(r_no(ev,1),r_no(ev,2),'r+');
                    hold on;
                    plot(r_maso(ev,1),r_maso(ev,2),'gx');
                    hold on;
                    plot(r_nose(ev,1),r_nose(ev,2),'k*');
                    hold on;
                    plot(r_ruido(ev,1),r_ruido(ev,2),'mh');
                    xlim([-0.2 1.2]);
                    ylim([0 1.2]);
                    xlabel('Grado de pertenencia');
                    ylabel('Grado de no pertenencia');
                    grid on;
                    legend('si','no','más o menos','no sé','ruido');
                    hold on;
                    
                    
                    
                end
                
                %Gráfica de cada evento detectado 
                figure, 
                plot(analisis(ev,(1:d))); title(['evento detectados con varianza de ',num2str(desviacion_analisis(ev)),respuesta(1,ev)]); 
                
                
            end
            %Reinicio de variables para cada ventana
            F8_evento=[];            
            F7_evento=[];            
            AF3_evento=[];            
            AF4_evento=[];
            
            im=0;
            d=0;
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Ventana de señal ventaneada
        figure(200),
        subplot 411; plot(AF3); title('Canal AF3'); xlabel('Muestras'); ylabel('Uv');
        ylim([-50 50])
        subplot 412; plot(AF4); title('Canal AF4'); xlabel('Muestras'); ylabel('Uv');
        ylim([-50 50])
        subplot 413; plot(F7); title ('Canal F7'); xlabel('Muestras'); ylabel('Uv');
        ylim([-100 100])
        subplot 414; plot(F8); title ('Canal F8'); xlabel('Muestras'); ylabel('Uv');         
        ylim([-50 50])
        
        AF3_t=AF3;
        F7_t=F7;
        F8_t=F8;
        AF4_t=AF4;
        %analisis de la señal a la velocidad de 128 Hz
        pause(1/128);
     end
end
Veinte=0.2;
diez=0.1;
nueve=0.09;
V_V(1,1:length(F7_id))=double(Veinte);
V_D(1,1:length(F7_id))=double(diez);
V_n(1,1:length(F7_id))=double(nueve);
%
close(200);
figure,
%Gráfica de las señales analizadas.
subplot 411; plot(AF3_id); title('Canal AF3'); xlabel('Número de muestra'); ylabel('uV');
subplot 412;plot(AF4_id); title('Canal AF4');xlabel('Número de muestra'); ylabel('uV');
subplot 413;plot(F7_id); title('Canal F7');xlabel('Número de muestra'); ylabel('uV');
subplot 414;plot(F8_id); title('Canal F8');xlabel('Número de muestra'); ylabel('uV');
figure

%Analisis de las varianzas detectadas.
subplot 411;plot(var_af3_muestra); title('Varianza del canal AF3');xlabel('K-esima ventana'); ylabel('? norm_A_F_3^2');
hold on;
plot(V_V,'g');
hold on;
plot(V_D,'k');
hold on;
plot(V_n,'r');
hold off;
subplot 412;plot(var_af4_muestra); title('Varianza del canal AF4');xlabel('K-esima ventana'); ylabel('? norm_A_F_4^2');
hold on;
plot(V_V,'g');
hold on;
plot(V_D,'k');
hold on;
plot(V_n,'r');
hold off;
subplot 413;plot(var_f7_muestra); title('Varianza del canal F7');xlabel('K-esima ventana'); ylabel('? norm_F_7^2');
hold on;
plot(V_V,'g');
hold on;
plot(V_D,'k');
hold on;
plot(V_n,'r');
hold off;
subplot 414;plot(var_f8_muestra); title('Varianza del canal F8');xlabel('K-esima ventana'); ylabel('? norm_F_8^2');
hold on;
plot(V_V,'g');
hold on;
plot(V_D,'k');
hold on;
plot(V_n,'r');
hold off;

%Detección de eventos correspondiente a cada canal
figure,
subplot 511; plot(AF3_id); title('Canal AF3');xlabel('Número de muestras');ylabel('Amplitud EEG'); grid on;
xlim([0 length(AF3_id)]);
subplot 512;plot(AF4_id); title('Canal AF4');xlabel('Número de muestras');ylabel('Amplitud EEG'); grid on;
xlim([0 length(AF4_id)]);
subplot 513;plot(F7_id); title('Canal F7');xlabel('Número de muestras');ylabel('Amplitud EEG'); grid on;
xlim([0 length(F7_id)]);
subplot 514;plot(F8_id); title('Canal F8');xlabel('Número de muestras');ylabel('Amplitud EEG'); grid on;
xlim([0 length(F8_id)]);
subplot 515;plot(evento);title('Evento detectado'); xlabel('Número de muestras');ylabel('Evento');
ylim([0 1.2]);
xlim([0 length(evento)]);
grid on;

