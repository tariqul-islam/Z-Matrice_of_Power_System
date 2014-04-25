function y=line_Z(data)
    %loading line parameters from data
    b1 = formatted_data(data.bus1)+1;
    b2 = formatted_data(data.bus2)+1;
    
    Raa = formatted_data(data.Raa);
    Xaa = formatted_data(data.Xaa)*1i;
    Zaa = Raa+Xaa;
    
    if isfield(data,'Xab')
        Xab = formatted_data(data.Xab)*1i;
    else
        Xab=0;
    end
    
    if isfield(data,'Xan')
        Xan = formatted_data(data.Xan)*1i;
    else
        Xan=0;
    end
    
    if isfield(data, 'Rnn')
        Rnn = formatted_data(data.Rnn);
    else
        Rnn = 0;
    end
    
    if isfield(data, 'Xnn')
        Xnn = formatted_data(data.Xnn)*1i;
    else
        Xnn=0;
    end
    
    Znn = Rnn+Xnn;
    
    %calculating
    Z0 = Zaa+2*Xab+3*Znn-6*Xan;
    Z1 = Zaa-Xab;
    
    %returning data
    y=struct;
    y.b1 = b1; %Connected Buses
    y.b2 = b2; 
    y.Z1 = Z1; %Z values
    y.Z0 = Z0;
    
end

function y=formatted_data(x)
    if ischar(x)
        y=str2double(x);
    else
        y=x;
    end
end