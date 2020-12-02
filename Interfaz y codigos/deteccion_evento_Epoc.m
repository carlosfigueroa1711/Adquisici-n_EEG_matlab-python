function Fiev=deteccion_evento

Fiev= newfis('Eventos');

Fiev=addvar(Fiev, 'input','AF3',[0 1]);
Fiev=addmf(Fiev,'input',1,'Poca','zmf',[0.06 0.09]);
Fiev=addmf(Fiev,'input',1,'Media','trapmf', [0.05 0.08 0.3 0.4]);
Fiev=addmf(Fiev,'input',1,'Mucha','smf', [0.3 0.5]);

Fiev=addvar(Fiev, 'input','AF4',[0 1]);
Fiev=addmf(Fiev,'input',2,'Poca','zmf',[0.06 0.09]);
Fiev=addmf(Fiev,'input',2,'Media','trapmf', [0.05 0.08 0.3 0.4]);
Fiev=addmf(Fiev,'input',2,'Mucha','smf', [0.3 0.5]);

Fiev=addvar(Fiev, 'input','F7',[0 1]);
Fiev=addmf(Fiev,'input',3,'Poca','zmf',[0.06 0.09]);
Fiev=addmf(Fiev,'input',3,'Media','trapmf', [0.05 0.08 0.3 0.4]);
Fiev=addmf(Fiev,'input',3,'Mucha','smf', [0.3 0.5]);

Fiev=addvar(Fiev, 'input','F8',[0 1]);
Fiev=addmf(Fiev,'input',4,'Poca','zmf',[0.06 0.09]);
Fiev=addmf(Fiev,'input',4,'Media','trapmf', [0.05 0.08 0.3 0.4]);
Fiev=addmf(Fiev,'input',4,'Mucha','smf', [0.3 0.5]);

Fiev=addvar(Fiev, 'output','Evento',[0 1]);
Fiev=addmf(Fiev,'output',1,'Nada','zmf',[0.01 0.2]);
Fiev=addmf(Fiev,'output',1,'parece_evento','gaussmf',[0.1 0.4]);
Fiev=addmf(Fiev,'output',1,'evento_seguro','smf',[0.5 0.7]);

Reglas=[...
    1 1 1 1 1 1 1
    2 2 2 2 2 1 1
    3 3 3 3 3 1 1
    2 1 1 1 1 1 1
    1 2 1 1 1 1 1
    1 1 2 1 1 1 1
    1 1 1 2 1 1 1
    2 2 1 1 2 1 1
    1 1 2 2 1 1 1
    2 2 3 3 3 1 1
    3 3 2 2 3 1 1
    3 1 1 1 1 1 1
    1 3 1 1 1 1 1
    1 1 3 1 1 1 1
    1 1 1 3 1 1 1
    3 2 2 2 2 1 1
    2 3 2 2 2 1 1
    2 2 3 2 2 1 1
    2 2 2 3 2 1 1
    1 3 3 3 3 1 1
    3 1 3 3 3 1 1
    3 3 1 3 3 1 1
    3 3 3 1 3 1 1
    2 3 3 3 3 1 1
    3 2 3 3 3 1 1
    3 3 2 3 3 1 1
    3 3 3 2 3 1 1
    ];

Fiev=addrule(Fiev,Reglas);
    
