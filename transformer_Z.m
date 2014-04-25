function y = transformer_Z(data)
    %loading transformer parameter
    pw = data.primary_winding;
    sw = data.secondary_winding;
    pn= formatted_data(data.primary_bus)+1;
    
    sn = formatted_data(data.secondary_bus)+1;
    R = formatted_data(data.R1);
    X = formatted_data(data.X1);    
    Z1 = R+X*1i;
    
    y = struct;
    y.Z0 = struct;
    y.Z1 = struct;
    
    y.Z1.val = Z1;
    y.Z1.b1 = pn;
    y.Z1.b2 = sn;
    
    %Z0 is calculated for different types of connection
    if (strcmp(pw,'Yg') && strcmp(sw,'Yg'))
        znp = formatted_data(data.primary_zn);
        zns = formatted_data(data.secondary_zn);
        
        y.Z0.val = Z1 + 3*znp + 3*zns;
        y.Z0.b1 = pn;
        y.Z0.b2 = sn;
    elseif (strcmp(pw,'Yg') && strcmp(sw,'D'))
        znp = formatted_data(data.primary_zn);

        y.Z0.val = Z1 + 3*znp;
        y.Z0.b1 = pn;
        y.Z0.b2 = 1;
    elseif (strcmp(pw,'D') && strcmp(sw,'Yg'))
        zns = formatted_data(data.secondary_zn);
        
        y.Z0.val = Z1 + 3*zns;
        y.Z0.b1 = sn;
        y.Z0.b2 = 1;
    elseif (strcmp(pw,'Yg') && strcmp(sw,'Y'))
        y.Z0.val = Z1;
        y.Z0.b1 = pn;
        y.Z0.b2 = 'N';
    elseif (strcmp(pw,'Y') && strcmp(sw,'Yg'))
        y.Z0.val = Z1;
        y.Z0.b1 = sn;
        y.Z0.b2 = 'N';
    elseif (strcmp(pw,'Y') && strcmp(sw,'D'))
        y.Z0.val = Z1;
        y.Z0.b1 = pn;
        y.Z0.b2 = 'N';
    elseif (strcmp(pw,'D') && strcmp(sw,'Y'))
        y.Z0.val = Z1;
        y.Z0.b1 = sn;
        y.Z0.b2 = 'N';
    else
        y.Z0.val = 0;
        y.Z0.b1 = 0;
        y.Z0.b2 = 0;
    end
    
end

function y=formatted_data(x)
    if ischar(x)
        y=str2double(x);
    else
        y=x;
    end
end