function [var_af3_base, var_f7_base, var_f8_base,...
    var_af4_base]= entranamiento_varianzas(AF3_id,AF4_id,F7_id,F8_id, paso, tam_cadena,fm)


for i=0:paso:(tam_cadena)
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %       desviacion_af3_base(i)=std(AF3);
        var_af3_base(i)=var(AF3);
        
 %       desviacion_f7_base(i)=std(F7);
        var_f7_base(i)=var(F7);
        
 %       desviacion_f8_base(i)=std(F8);
        var_f8_base(i)=var(F8);
        
 %       desviacion_af4_base(i)=std(AF4);
        var_af4_base(i)=var(AF4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        

        AF3_t=AF3;
        F7_t=F7;
        F8_t=F8;
        AF4_t=AF4;
       % pause(1/fm);
     end
end