%parameters
maxSpaces=100;
i=1;
err=0;
log=readtable("Log.csv", "Delimiter", ",", "ReadVariableNames", false);
pph=2;

while i==1
    x = input("enter command: ", 's'); 
    switch x
        %chatgpt wrote this part
       case "IMPORT"
            filename=input("Enter the name of the file: ","s");
            file=readtable(filename, "Delimiter", ",", "ReadVariableNames", false);
            fopen("Log.csv","a");
            j=1;
            while j<(height(file)+1)
                np=file{j,1};
                h1=file{j,2};
                m1=file{j,3};
                h2=file{j,4};
                m2=file{j,5};
                NewRow={np,h1,m1,h2,m2};
                writetable(cell2table(NewRow),"Log.csv","Delimiter", ",","WriteMode", "append","WriteVariableNames", false)
                j=j+1;
                
            end
        case "ENTER"
            err=0;
            np=input("Enter numberplate: ","s");
            h1=input("Current hour (24h): ");
            if h1<0 || h1>24
                disp("error number needs to be positive and under 24")
                err=1;
            end
            m1=input("Current minute: ");
            if m1<0 || m1>60
                disp("error number needs to be positive and under 60")
                err=1;
            end
            NewRow={np,h1,m1,NaN,NaN};
            j=1;
            
            while j<(height(log)+1)
                if strcmpi(np,log{j,1})
                    if isnan(log{j,5})
                        disp("Error, Car already Parked")
                        err=1;
                    end
                end
                j=j+1;
            end
            if err~=1
                writetable(cell2table(NewRow),"Log.csv","Delimiter", ",","WriteMode", "append","WriteVariableNames", false)
            end
        case "EXIT"
            np=input("input number plate: ","s");
            
            j=1;
            err=1;
            while j<(height(log)+1)
                if strcmpi(np,log{j,1})
                    err=0;
                    h1=log{j,2};
                    m1=log{j,3};
                    h2=input("enter the current hour (24h): ");
                    m2=input("enter the minutes: ");
                    st=h1*60+m1;% start time
                    et=h2*60+m2;% exit time
                    ts=et-st;% time spent
                    if ts<0
                        ts=ts+1440;% if overnight
                    end
                    if ts<16
                        disp("Parking is free 🥳")
                    else
                        pt=ts-15;
                        hs=pt/60;
                        hsr=ceil(hs);
                        fee=hsr*pph;
                        disp("your fee is: "+fee+" euro")
                    end
                    %log(j,:)
                    GG={np,h1,m1,h2,m2};
                    log(j,:)=(GG);
                    writetable(log,"Log.csv","Delimiter", ",","WriteMode", "overwrite","WriteVariableNames", false)
                else
                    
                    
                end
            j=j+1;
            end
            if err==1
                disp("car is not parked here 🐗")
            end
        case "CHECK"
            np=input("enter number plate and current time");
        case "TERMINATE"
            disp("exiting program")
            i=0;
        case "FILETEST"
            disp(filename)
            disp(file)
            disp(file(3,2))

        case "REPORT"
            j=1;
            
            parkingHistory=zeros(1440,1);
            isparked=zeros(1440,1);
            minutes=1:1440;
            while j<(height(log)+1)
                h1=log{j,2};
                m1=log{j,3};
                h2=log{j,4};
                m2=log{j,5};
                st=h1*60+m1;        % start time
                et=h2*60+m2;        % exit time
                ts=et-st;           % time spent
                k=1;
                if isnan(ts)
                    l=1;
                    while l<1441
                        if l>=st
                            isparked(l,1)=1;
                        end
                        l=l+1;
                    end

                else
                    while k<(ts+1)
                        isparked((st+k),1)=1;
                        k=k+1;
                    end
                end
                parkingHistory=parkingHistory+isparked;
                j=j+1;
                
            end    
           plot(minutes,parkingHistory)
        otherwise
            disp("Invalid option");
    end
end