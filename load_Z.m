function y = load_Z(data)
    bus = formatted_data(data.bus)+1;
    R = formatted_data(data.R);
    X = formatted_data(data.X)*1i;
    c=data.connection;
    if strcmp(c, 'Yg');
        if isfield(data,'Rn')
            Rn = formatted_data(data.Rn);
        else
            Rn=0;
        end
        
        if isfield(data,'Xn')
            Xn = formatted_data(data.Xn)*1i;
        else
            Xn=0;
        end
    end
    
    Z = R+X;
    Z0 = Z+Rn+Xn;
    
    y=struct;
    y.bus = bus;
    y.Z1 = Z;
    y.Z0 = Z0;
end

function y=formatted_data(x)
    if ischar(x)
        y=str2double(x);
    else
        y=x;
    end
end