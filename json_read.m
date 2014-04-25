function [y, len] = json_read(fname)
%
%Reads a json file using p_json() library
%USAGE: json_read(filename)
%
    fid = fopen(fname, 'rt');
    str = fscanf(fid,'%c');
    fclose(fid);
    y = p_json(str);
    if (isempty(y))
        len=0;
    else
        len=length(fieldnames(y));
    end
    
end