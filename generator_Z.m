function y = generator_Z(data)
    %loading generator parameter
    bus = formatted_data(data.bus)+1;
    R = formatted_data(data.sub_tr_R);
    X = formatted_data(data.sub_tr_X);
    M = formatted_data(data.sub_tr_M);
    
    W = data.winding;
    if (strcmp(W,'Yg'))
        if isfield(data,'Rn')
            Rn = formatted_data(data.Rn);
        else
            Rn=0;
        end
        
        if isfield(data,'Xn')
            Xn = 1i*formatted_data(data.Xn);
        else
            Xn = 0i;
        end
        Zn = Rn+Xn;
    else
        Zn=0;
    end
    
    Z1=R+(X+M)*1i;
    Z0=R+(X-2*M)*1i+3*Zn;
    
    %Returning appropriate data
    y=struct;
    y.Z1=Z1;
    y.Z0=Z0;
    y.bus=bus;
    if (strcmp(W,'Yg'))
        y.New = 0;
    else
        y.New = 1;
    end
end

function y=formatted_data(x)
    if ischar(x)
        y=str2double(x);
    else
        y=x;
    end
end