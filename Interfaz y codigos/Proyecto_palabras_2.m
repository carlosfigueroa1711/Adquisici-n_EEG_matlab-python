function varargout = Proyecto_palabras_2(varargin)
% PROYECTO_PALABRAS_2 MATLAB code for Proyecto_palabras_2.fig
%      PROYECTO_PALABRAS_2, by itself, creates a new PROYECTO_PALABRAS_2 or raises the existing
%      singleton*.
%
%      H = PROYECTO_PALABRAS_2 returns the handle to a new PROYECTO_PALABRAS_2 or the handle to
%      the existing singleton*.
%
%      PROYECTO_PALABRAS_2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROYECTO_PALABRAS_2.M with the given input arguments.
%
%      PROYECTO_PALABRAS_2('Property','Value',...) creates a new PROYECTO_PALABRAS_2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Proyecto_palabras_2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Proyecto_palabras_2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Proyecto_palabras_2

% Last Modified by GUIDE v2.5 24-Nov-2016 15:43:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Proyecto_palabras_2_OpeningFcn, ...
                   'gui_OutputFcn',  @Proyecto_palabras_2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before Proyecto_palabras_2 is made visible.
function Proyecto_palabras_2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Proyecto_palabras_2 (see VARARGIN)

% Choose default command line output for Proyecto_palabras_2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Proyecto_palabras_2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Proyecto_palabras_2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global dispositivo;
dispositivo = get(hObject,'Value');


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');

end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sujeto;
Sujeto = get(hObject,'Value');
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    


end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global dispositivo;
%global arch_edf;
global h;
%global r;

if dispositivo == 1
    [fname, pname] = uigetfile({'*.edf';'*.bdf';               ...
        'Archivo EDF';},'Selecciona base de datos');
    
    ruta=[pname fname];
    %Funcion de lectura de archivos EDF
    [h,r]=edfread(ruta);
    %Lectura de los datos EDF.
    global Datos;
    Datos=r;
end

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
global fm;
fm = get(hObject,'Value');

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Sujeto;
global referencia;
global Datos;
%global arch_edf;
global h;
global AF3_id;
global AF4_id;
global F7_id;
global F8_id;
global evento;


%Filtro pasa bajas
%fm=arch_edf.srate*2;  %Frecuencia de muestreo 128 Hz

fm=max(h.frequency)*2;
[AF3_id,F7_id,F8_id,AF4_id,tam_cadena]=eliminar_offset_Epoc(Datos,fm);
paso=64;
s=0;
rui=0;
ms=0;
ns=0;
n=0;

if Sujeto == 1
    %Carlos Eduardo Cañedo Figueroa
    %Prom AF3	prom AF4	Prom F7	     Prom F8
    %2.51E+03	2.80E+03	1.26E+04	3.83E+03
    if referencia==0
        AF3_max=2.51E+03;
        AF4_max=2.80E+03;
        F7_max=1.26E+04;
        F8_max=3.83E+03;
    else
        [var_af3_base, var_f7_base, var_f8_base, var_af4_base]= ...
            entranamiento_varianzas_Epoc(AF3_id,AF4_id,F7_id,F8_id, paso, tam_cadena,fm);
        AF3_max=max(var_af3_base);
        AF4_max=max(var_af4_base);
        F7_max=max(var_f7_base);
        F8_max=max(var_f8_base);
    end
end

if Sujeto == 2
   % Abimael Guzman Pando
   % Prom AF3	prom AF4	Prom F7	Prom F8
   % 3.30E+03	4.09E+03	1.90E+03	7.34E+03


    if referencia==0
        AF3_max=3.30E+03;
        AF4_max=4.09E+03;
        F7_max=1.90E+03;
        F8_max=7.34E+03;
    else
        [var_af3_base, var_f7_base, var_f8_base, var_af4_base]= ...
            entranamiento_varianzas_Epoc(AF3_id,AF4_id,F7_id,F8_id, paso, tam_cadena,fm);
        AF3_max=max(var_af3_base);
        AF4_max=max(var_af4_base);
        F7_max=max(var_f7_base);
        F8_max=max(var_f8_base);
    end
end

if Sujeto == 3
    % Jorge Alberto Peñaloza
    %Prom AF3	prom AF4	Prom F7	     Prom F8
    %6.94E+03	5.99E+03	3.12E+04	7.15E+04

    if referencia==0
        AF3_max=6.94E+03;
        AF4_max=5.99E+03;
        F7_max=3.12E+04;
        F8_max=7.15E+04;
    else
        [var_af3_base, var_f7_base, var_f8_base, var_af4_base]= ...
            entranamiento_varianzas_Epoc(AF3_id,AF4_id,F7_id,F8_id, paso, tam_cadena,fm);
        AF3_max=max(var_af3_base);
        AF4_max=max(var_af4_base);
        F7_max=max(var_f7_base);
        F8_max=max(var_f8_base);
    end
end

if Sujeto == 4
    %Brenda Elizabeth Olivas
    %Prom AF3	prom AF4	Prom F7	Prom F8
    %4.88E+03	7.83E+03	4.57E+03	7.71E+03

    if referencia==0
        AF3_max=4.88E+03;
        AF4_max=7.83E+03;
        F7_max=4.57E+03;
        F8_max=7.71E+03;
    else
        [var_af3_base, var_f7_base, var_f8_base, var_af4_base]= ...
            entranamiento_varianzas_Epoc(AF3_id,AF4_id,F7_id,F8_id, paso, tam_cadena,fm);
        AF3_max=max(var_af3_base);
        AF4_max=max(var_af4_base);
        F7_max=max(var_f7_base);
        F8_max=max(var_f8_base);
    end
end

if Sujeto == 5
    % Tania Lizbeth Navarro Márquez
    %Prom AF3	prom AF4	Prom F7	Prom F8
    %1.04E+04	1.44E+04	1.99E+04	1.81E+04

    if referencia==0
        AF3_max=1.04E+04;
        AF4_max=1.44E+04;
        F7_max=1.99E+04;
        F8_max=1.81E+04;
    else
        [var_af3_base, var_f7_base, var_f8_base, var_af4_base]= ...
            entranamiento_varianzas_Epoc(AF3_id,AF4_id,F7_id,F8_id, paso, tam_cadena,fm);
        AF3_max=max(var_af3_base);
        AF4_max=max(var_af4_base);
        F7_max=max(var_f7_base);
        F8_max=max(var_f8_base);
    end
end

%load('Red_carlos_jorge_epoc.mat');

load('red_masomenos.mat');
load('red_no.mat');
load('red_si.mat');
load('red_ruido.mat');
load('red_nose.mat');


Fiev=deteccion_evento_2;
AF3_t=[];
AF4_t=[];
F7_t=[];
F8_t=[];
F8_evento=[];
c=0;
d=0;
im=0;
i=0;
ev=0;

var_af3_muestra=[];
var_af4_muestra=[];
var_f7_muestra=[];
var_f8_muestra=[];
rojo=0;
dr=0;
axes(handles.Grafica_AF3)
hold off;            
axes(handles.Grafica_AF4)
hold off;            
axes(handles.Grafica_F7)
hold off;           
axes(handles.Grafica_F8)
hold off;
ventana=0;

for i=0:paso:(tam_cadena)
     ventana=ventana+1;
     if i<=fm && i>2
        AF3_t((i-paso)+1:i)=AF3_id((i-paso)+1:i);
        F7_t((i-paso)+1:i)=F7_id((i-paso)+1:i);
        F8_t((i-paso)+1:i)=F8_id((i-paso)+1:i);
        AF4_t((i-paso)+1:i)=AF4_id((i-paso)+1:i);
    elseif i==fm
        subplot 411; plot(AF3_t); title('AF3');
        subplot 412; plot(F7_t); title('F7');
        subplot 413; plot(F8_t); title('F8');
        subplot 414; plot(AF4_t); title('AF4');
    elseif i>fm && i<tam_cadena
        AF3(1:fm-(paso-1))=AF3_t(paso:fm);
        F7(1:fm-(paso-1))=F7_t(paso:fm);
        F8(1:fm-(paso-1))=F8_t(paso:fm);
        AF4(1:fm-(paso-1))=AF4_t(paso:fm);

        AF3(fm-paso:fm)=AF3_id(i-paso:i);
        F7(fm-paso:fm)=F7_id(i-paso:i);
        F8(fm-paso:fm)=F8_id(i-paso:i);
        AF4(fm-paso:fm)=AF4_id(i-paso:i);

        var_af3_muestra(i)=var(AF3)/AF3_max;
        var_f7_muestra(i)=var(F7)/F7_max;
        var_f8_muestra(i)=var(F8)/F8_max;
        var_af4_muestra(i)=var(AF4)/AF4_max;


        r=evalfis([double(var_af3_muestra(i)) double(var_af4_muestra(i))...
            double(var_f7_muestra(i)) double(var_f8_muestra(i))],Fiev);
        if r >= 0.5
            rojo=1;
              c=c+1;
            d=d+paso+1;
            dr=dr+paso+1;
            im=1;

            F8_evento(d-paso:d)=F8_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2));
            F7_evento(d-paso:d)=F7_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2));
            AF3_evento(d-paso:d)=AF3_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2));
            AF4_evento(d-paso:d)=AF4_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2));

            if c>=fm
                c=0;
            end
            evento(i-paso:i)=1;

        else     
            evento(i-paso+1:i)=0;
            if length(F8_evento)>1
                ev=ev+1;              

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


                analisis(ev,(1:d))=analisis1(ev,(1:d))/max(analisis1(ev,(1:d)));
                desviacion_analisis(ev)= std(analisis(ev,(1:d)));
                %Energia(ev)=max(xcorr(analisis(ev,(1:d))))
                Energia(ev)=sum(analisis(ev,(1:d)).^2)
                Entropia_analisis(ev)=entropy(double(analisis(ev,(1:d))));

                [peak_value, peak_location] = findpeaks(double(analisis(ev,(1:d))),'minpeakheight',0.3);
                [amplitudes,delta,theta,alpha,F]=fourier_Epoc(analisis(ev,(1:d)));
               
                Vector(ev,1:6)=[desviacion_analisis(ev),delta, theta,alpha,length(peak_value),Energia(ev)];

                r_si(ev,1:2)=net_si(Vector(ev,1:6)');
                r_no(ev,1:2)=net_no(Vector(ev,1:6)');
                r_maso(ev,1:2)=net_maso(Vector(ev,1:6)');
                r_nose(ev,1:2)=net_nose(Vector(ev,1:6)');
                r_ruido(ev,1:2)=net_noclase(Vector(ev,1:6)');
                
              %  if r_si(ev,1)>0.5
                    if r_si(ev,1)>0.2+r_si(ev,2);
                        p_si=r_si(ev,1);
                    else
                        p_si=0;
                    end
              %  else
              %      p_si=0;
              %  end
                
              %  if r_no(ev,1)>0.5
                    if r_no(ev,1)>0.2+r_no(ev,2);
                        p_no=r_no(ev,1);
                    else
                        p_no=0;
                    end
%                 else
%                     p_no=0;
%                 end
%                 
%                 if r_maso(ev,1)>0.5
                    if r_maso(ev,1)>0.2+r_maso(ev,2);
                        p_maso=r_maso(ev,1);
                    else
                        p_maso=0;
                    end
%                 else
%                     p_maso=0;
%                 end
%                 
%                 
%                 if r_nose(ev,1)>0.5
                    if r_nose(ev,1)>0.2+r_nose(ev,2);
                        p_nose = r_nose(ev,1);
                    else
                        p_nose=0;
                    end
%                 else
%                     p_nose=0;
%                 end
%                 
%                 if r_ruido(ev,1)>0.5
                    if r_ruido(ev,1)>0.2+r_ruido(ev,2);
                        p_ruido=r_ruido(ev,1);
                    else
                        p_ruido=0;
                    end
%                 else
%                     p_ruido=0;
%                 end

                si='si';
                no='no';
                maso='masomenos';
                nose='no se';
                ruido='--ruido--';
                
                if p_si>p_no && p_si>p_nose &&...
                        p_si>p_maso && p_si>p_ruido
                    respuesta(1,ev)={si};
                    
                elseif p_no>p_si && p_no>p_nose &&...
                        p_no>p_maso && p_no>p_ruido
                    respuesta(1,ev)={no};
                    
                elseif p_maso>p_no && p_maso>p_nose  &&...
                        p_maso>p_si && p_maso>p_ruido
                    respuesta(1,ev)={maso};
                    
                elseif p_nose>p_no && p_nose>p_si  &&...
                        p_nose>p_maso && p_nose>p_ruido
                    respuesta(1,ev)={nose};

                elseif p_ruido>p_no && p_ruido>p_nose  &&...
                        p_ruido>p_maso && p_ruido>p_si
                    respuesta(1,ev)={ruido};
                else
                    respuesta(1,ev)={ruido};
                end
                axes(handles.Grafica_evento)
                try
                    plot(analisis(ev,(1:d))); title(['La palabra detectada es ' ,respuesta(1,ev)]);
                catch
                    plot(analisis(ev,(1:d))); title('Ruido');
                end
                %pause();

            end

            F8_evento=[];            
            F7_evento=[];            
            AF3_evento=[];            
            AF4_evento=[];

            im=0;
            d=0;
        end
        if r < 0.09
            rojo=0;
            dr=dr+paso+1;
        end
        
        axes(handles.Grafica1)
        plot(AF3); title(['Analisis de canal AF3, ventana ',num2str(ventana)]);
        axes(handles.Grafica2)
        plot(AF4); title(['Analisis de canal AF4, ventana ',num2str(ventana)]);
        axes(handles.Grafica3)
        plot(F7); title(['Analisis de canal F7, ventana ',num2str(ventana)]);
        axes(handles.Grafica4)
        plot(F8); title(['Analisis de canal F8, ventana ',num2str(ventana)]);
        axes(handles.Grafica4)
        plot(F8); title(['Analisis de canal F8, ventana ',num2str(ventana)]);
        
        %%%%%%%%%%%%%%%%
        if rojo==0;
            axes(handles.Grafica_AF3)
            plot(dr-paso:dr,AF3_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2)),'b'); title('canal AF3');
            hold on;
            xlabel('Numero de muestra')
            ylabel('Amplitud EEG')
            
            axes(handles.Grafica_AF4)
            plot(dr-paso:dr,AF4_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2)),'b'); title('canal AF4');
            hold on;
            xlabel('Numero de muestra')
            ylabel('Amplitud EEG')
            
            axes(handles.Grafica_F7)
            plot(dr-paso:dr,F7_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2)),'b'); title('canal F7');
            hold on;
            xlabel('Numero de muestra')
            ylabel('Amplitud EEG')
            
            axes(handles.Grafica_F8)
            plot(dr-paso:dr,F8_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2)),'b'); title('canal F8');
            hold on;
            xlabel('Numero de muestra')
            ylabel('Amplitud EEG')
        else
            axes(handles.Grafica_AF3)
            plot(dr-paso:dr,AF3_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2)),'r'); title('canal AF3');
            hold on;
            xlabel('Numero de muestra')
            ylabel('Amplitud EEG')
            
            axes(handles.Grafica_AF4)
            plot(dr-paso:dr,AF4_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2)),'r'); title('canal AF4');
            hold on;
            xlabel('Numero de muestra')
            ylabel('Amplitud EEG')
            
            axes(handles.Grafica_F7)
            plot(dr-paso:dr,F7_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2)),'r'); title('canal F7');
            hold on;
            xlabel('Numero de muestra')
            ylabel('Amplitud EEG')
            
            axes(handles.Grafica_F8)
            plot(dr-paso:dr,F8_id(((i-paso)+1)-(fm/2):((i)+1)-(fm/2)),'r'); title('canal F8');
            hold on;
            xlabel('Numero de muestra')
            ylabel('Amplitud EEG')
        end

        AF3_t=AF3;
        F7_t=F7;
        F8_t=F8;
        AF4_t=AF4;
        %pause();
        pause(1/128);
     end
end
    
global s;
global n;
global ms;
global ns;
global rui;


%tab{'Si' s;'No' n; 'Masomenos' ms, 'No se' ns};
% set(handles.Tabla_expresiones,'data',);

% --- Executes on selection change in popupmenu13.
function popupmenu13_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global paso;
paso = get(hObject,'Value');
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu13


% --- Executes during object creation, after setting all properties.
function popupmenu13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global referencia;
referencia = get(hObject,'Value');
% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global AF3_id;
global AF4_id;
global F7_id;
global F8_id;
global evento;
figure,
subplot 511; plot(AF3_id);title('Canal AF3');
subplot 512; plot(AF4_id);title('Canal AF4');
subplot 513; plot(F7_id);title('Canal F7');
subplot 514; plot(F8_id);title('Canal F8');
subplot 515; plot(evento);title('Posición de eventos');
ylim([-0.1 1.2]);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
