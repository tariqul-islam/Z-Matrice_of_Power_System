clear;
clc;

[~,len] = json_read('busdata.json'); %loading bus data from database

nG= zeros(len+1); %network graph for +ve and -ve sequence network
nG0= zeros(len+1); %network graph for zero sequence
l_0 = length(nG0); %size of zero sequence network

%%%%%%%%%%%%%loading transformer data from database%%%%%%%%%%%%

[trandata,ll] = json_read('transformerdata.json'); 
if ll
    trfname=fieldnames(trandata); %getting each transformer's name
end

%for each transformer doing the operations:
for i=1:ll
    %geting Z1(/Z2) and Z0 data
    Z = transformer_Z(getfield(trandata,trfname{i}));
    
    %adding Z1(/Z2) to the network graph
    Z1 = Z.Z1;
    nG(Z1.b1,Z1.b2) = parallel_load(Z1.val,nG(Z1.b1,Z1.b2));
    nG(Z1.b2,Z1.b1) = nG(Z1.b1,Z1.b2);
    
    %processing for Z0
    Z0 = Z.Z0;
    if(Z0.b2=='N') %then new bus has to be created
        l_0 = l_0+1;
        nG0(l_0,:) = 0;
        nG0(:,l_0) = 0;
        Z0.b2=l_0; %adding this bus to the Z0 bus data for this transformer
    end
    %adding Z0 to the network graph
    nG0(Z0.b1,Z0.b2) = parallel_load(Z0.val,nG0(Z0.b1,Z0.b2));
    nG0(Z0.b2,Z0.b1) = nG0(Z0.b1,Z0.b2);
end

clear('trandata','trfname'); %deleting extra memory

%%%%%%%%%%%%%Generator Data%%%%%%%%%%%%%%%

[genData,ll] = json_read('generatordata.json'); %loading generator data
if ll
    gfname = fieldnames(genData); %oading generator names
end

%for each generator doing the operations
for i=1:length(gfname)
    %getting generato's Z1(/Z2) and Z0
    Z=generator_Z(getfield(genData,gfname{i}));
    
    %adding Z1 to the network graph
    nG(Z.bus,1)= parallel_load(Z.Z1,nG(Z.bus,1));
    nG(1,Z.bus)= nG(Z.bus,1);
    
    %adding Z0 to Zero sequence network graph
    if ~Z.New
        nG0(Z.bus,1) = parallel_load(Z.Z0,nG0(Z.bus,1));
        nG0(1,Z.bus) = nG0(Z.bus,1);
    else
        l_0 = l_0+1;
        nG0(l_0,:) = 0;
        nG0(:,l_0) = 0;
        Z.bus2=l_0; %adding this bus to the Z0 bus data for this transformer
        
        nG0(Z.bus, Z.bus2) = parallel_load(Z.Z0,nG0(Z.bus, Z.bus2));
        nG0(Z.bus2, Z.bus) = nG0(Z.bus, Z.bus2);
    end
end

clear('genData','gfname');

%%%%%%%%%%%%LINE DATA%%%%%%%%%%%%%%%%%%%

[lineData,ll] = json_read('linedata.json'); %loading line data from database
if ll
    lfname = fieldnames(lineData); %getting names of the lines
end

%for each line doing the operations
for i=1:ll
    %getting Z1(/Z2) and Z0 data of the line
    Z = line_Z(getfield(lineData,lfname{i}));
    
    %adding the data to the network graph
    nG(Z.b1, Z.b2) = parallel_load(Z.Z1, nG(Z.b1, Z.b2));
    nG(Z.b2, Z.b1) = nG(Z.b1, Z.b2);
    
    %adding Z0
    nG0(Z.b1, Z.b2) = parallel_load(Z.Z0, nG0(Z.b1, Z.b2));
    nG0(Z.b2, Z.b1) = nG0(Z.b1, Z.b2);
end

clear('lineData','lfname');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%LOAD DATAH!!!%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[loadData, ll] =json_read('loadData.json');
if ll
    lfname=fieldnames(loadData);
end 

for i=1:ll
    Z=load_Z(getfield(loadData,lfname{i}));
    
    %adding Z1 to the network graph
    nG(Z.bus,1)= parallel_load(Z.Z1,nG(Z.bus,1));
    nG(1,Z.bus)= nG(Z.bus,1);
    
    %adding Z0 to Zero sequence network graph
    nG0(Z.bus,1) = parallel_load(Z.Z0,nG0(Z.bus,1));
    nG0(1,Z.bus) = nG0(Z.bus,1);
    
end

Z1 = zbus(nG)

Z2 = Z1

Z0 = zbus(nG0);
Z0 = Z0(1:len, 1:len)