function ZBUS = zbus(imp)
%this function finds the zbus of a pwer system from a impedence graph of
%the system
%imp is a matrix that describes the graph between impedences.
%tariqul islam
%19/03/2014

    n=length(imp);
    imp2 = imp(1,2:n); %extracting node to reference impedences for each bus
    imp = imp(2:n,2:n); %bus to bus impedences
    n=n-1;
    ZBUS = zeros(n+1); %ZBUS shell
    F=zeros(1,n); %index for knowing which bus is in which column of ZBUS
    fi = 0; %index of F
    FUT = [0 0]'; % memory for isolating the branch which's node is not inside the current ZBUS
    bi = 0; %index of ZBUS
    
    
    %modifies the bus matrix using Kron Reduction
    %random thoughts: why I didn't name it kronred?
    function busmod(z)
        for p=1:z-1
            for q=1:z-1
                ZBUS(p,q)=ZBUS(p,q)-ZBUS(p,z)*ZBUS(z,q)/ZBUS(z,z);
            end
        end
        bi=bi-1;
    end
    
    %finds whether the z node is inside ZBUS
    function y = getindexof(z)
        found=0;
        for i=1:length(F)
            if F(i)==z
                found=1;
                break;
            end
        end

        if found==1
            y=i;
        else
            y=0;
        end
    end

    %adds a new node with an existing node
    %adapted from CASE 2
    %Power System Analysis,
    %Stevenson & Grainger, McGraw Hill India, Page: 299
    function case1(j, val)
        bi=bi+1;
        ZBUS(bi,:) = ZBUS(j,:);
        ZBUS(:,bi) = ZBUS(:,j);
        ZBUS(bi,bi) = ZBUS(j,j)+val;
    end

    %adds impedence between two existing node
    %adapted from CASE 4
    %Power System Analysis,
    %Stevenson & Grainger, McGraw Hill India, Page: 299
    function case2(j,k,val)
        bi=bi+1;
        ZBUS(bi,:) = ZBUS(j,:) - ZBUS(k,:);
        ZBUS(:,bi) = ZBUS(:,j) - ZBUS(:,k);
        ZBUS(bi,bi) = ZBUS(j,j)+ZBUS(k,k)-2*ZBUS(j,k)+val;
    end
    

    %the general loop for the algorithm
    function general_loop(a,b)
        if abs(imp(a,b))
            j=getindexof(a);
            k=getindexof(b);

            %if j=0 swaping it with k
            swapped=0;
            if j==0
                j=k;
                k=0;
                swapped=1;
            end

            %isolating non-existing nodes for future
            %if j=0 for successive checking (1st one above, 2nd one
            %below),
            %it means both j=0; k=0;
            if j==0
                fi=fi+1;
                FUT(:,fi) = [a b]';
                return;
            end

            %otherwise j=value, k=0 (CASE 2)
            if k==0
                case1(j,imp(a,b));
                if swapped
                    F(bi)=a;
                else
                    F(bi)=b;
                end

            %otherwise j=value, k=valuse (CASE 4)
            else
                case2(j,k,imp(a,b));
                busmod(bi);
            end
        end
    end
    
    %adding all buses connected to reference
    %adapted from CASE 1
    %Power System Analysis,
    %Stevenson & Grainger, McGraw Hill India, Page: 299
    for b=1:n
        if abs(imp2(b))
            bi=bi+1;
            ZBUS(bi,bi) = imp2(b);
            F(bi)=b;
        end
    end
    
    %adding the bues that are connected to other buses
    for a=1:n
        for b=a+1:n
            general_loop(a,b);
        end
    end
    
    %now checking the nodes that were kept for future
    fii=fi;
    fi2=0;
    while fi~=0
        a=FUT(1,1);
        b=FUT(2,1);
        FUT(:,1)=[];
        fi=fi-1;
        general_loop(a,b);
        
        fi2=fi2+1;
        if fi2==fii
            if fii==fi;
                break;
            else
                fi2=0;
                fii=fi;
            end
        end
    end
    
    for a=1:n
        z=getindexof(a);
        if a==z
            continue;
        else
            ZBUS(n+1,:)=ZBUS(z,:);
            ZBUS(z,:)=ZBUS(a,:);
            ZBUS(a,:)=ZBUS(n+1,:);
            
            ZBUS(:,n+1)=ZBUS(:,z);
            ZBUS(:,z) = ZBUS(:,a);
            ZBUS(:,a) = ZBUS(:,n+1);
            
            F(z) = F(a);
            F(a) = a;
            
        end
    end
    
    ZBUS = ZBUS(1:n,1:n);
end

