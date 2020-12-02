

[fname, pname] = uigetfile({'*.edf';'*.bdf';               ...
   'Archivo de excel';},'Selecciona base de datos');
    
ruta=[pname fname];
[h,r]=edfread(ruta);