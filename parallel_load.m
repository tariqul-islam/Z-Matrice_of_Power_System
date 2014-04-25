function y=parallel_load(val1,val2)
%parallel impedance calculator. 0 means impedence is infinite
    if val1==0
        y=val2;
    elseif val2==0
        y=val1;
    else
        y=val1*val2/(val1+val2);
    end
end