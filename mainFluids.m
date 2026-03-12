L=input('What is the Pipe Length (m)? ');
fprintf('\n')
V=input('What is the Velocity (m/s)? ');
fprintf('\n')
disp('Choose the fluids...')
disp('1=Water, 2=Air, 3=Oil, 4=Manual')
fprintf('\n')
rhoinput=input('Enter the number: ');
fprintf('\n')
if rhoinput==4
    K="Custom";
    rho=input('What is the Fluid density (kg/m^3)? ');
    mu=input('What is the Fluid viscocity (Pa*s)? ');
else
    K=0;
    rho_table=[1000,1.2,850];
    rho=rho_table(rhoinput);
    %[Water, air, oil]
    mu_table=[0.001,1.8*10^(-5),0.05];
    mu=mu_table(rhoinput);
end
disp('Choose the pipe material...')
disp('1=Concrete, 2=Steel, 3=PVC, 4=Manual')
fprintf('\n')
epislon_table=[(3*10^(-4)),(4.5*10^(-5)),1.5*10^(-6),];
material_choice=input('Enter the number: ');
if material_choice==4
    epislon=input('What is the roughness of the material? ');
else
    epislon=epislon_table(material_choice);
end
fluids=["Water","Air","Oil",K];
Materials=["Concrete","Steel","PVC",'Custom'];
Dlist=0.01:0.005:0.1;
Relist=zeros(1,length(Dlist));
regimelist=strings(1,length(Dlist));
delta1Plist=zeros(1,length(Dlist));
delta2Plist=zeros(1,length(Dlist));
FCole=zeros(1,length(Dlist));
FHaal=zeros(1,length(Dlist));
hf1list=zeros(1,length(Dlist));
hf2list=zeros(1,length(Dlist));
for i=1:length(Dlist)
    D=Dlist(i);
    [f1,f2,fluidtype,Re]=ReynoldsComputation(V,rho,mu,D,epislon);
    [deltaP1,deltaP2,hf1,hf2]=DarcyWeisbach(L,V,rho,mu,D,f1,f2);
    Relist(i)=Re;
    delta1Plist(i)=deltaP1;
    delta2Plist(i)=deltaP2;
    FCole(i)=f1;
    FHaal(i)=f2;
    regimelist(i)=string(fluidtype);
    hf1list(i)=hf1;
    hf2list(i)=hf2;
end
[Ploss1,Ploss2]=PumpPower(delta1Plist,delta2Plist,V);
[minPower,index]=min(Ploss1);
Optimaldiam=Dlist(index);

disp('')
disp('              Pipe Flow Analysis')
disp('-------------------------------------------------')
fprintf('Fluid: %s\n',fluids(rhoinput));
fprintf('Material: %s\n',Materials(material_choice));
fprintf('\n')

fprintf('Reynolds Range: %.0f - %.0f\n',min(Relist),max(Relist));
fprintf('Optimal Diameter: %4.4fm\n',Optimaldiam);
fprintf('\n')
fprintf('Minimum Pump Power: %4.4fW\n',minPower);
fprintf('\n%20s %20s %15s\n', ...
'Pressure Drop ΔP1 (Pa)', ...
'Pressure Drop ΔP2 (Pa)', ...
'Diameter (m)');

for i = 1:length(Dlist)
    fprintf('%20.4f %20.4f %15.4f\n', ...
        delta1Plist(i), delta2Plist(i), Dlist(i));
end
figure;
hold on;
plot(Dlist,delta1Plist,'k-','LineWidth',2); 
plot(Dlist,delta2Plist,'b--','LineWidth',2); 
Thelaminar=regimelist=="Laminar";
Theturbulent=regimelist=="Turbulent";
Thetransitional=regimelist=="Transitional";
if any(Thelaminar)
    plot(Dlist(Thelaminar),delta1Plist(Thelaminar),'ko','MarkerFaceColor', 'c');
end
if any(Theturbulent)
    plot(Dlist(Theturbulent),delta1Plist(Theturbulent),'ko','MarkerFaceColor','m');
end
if any(Thetransitional)
    plot(Dlist(Thetransitional),delta1Plist(Thetransitional),'ko','MarkerFaceColor','y');
end

xlabel('Pipe Diameter (m)');
ylabel('Pressure Drop (Pa)');
title('Pressure Drop vs Pipe Diameter');


h=[];
labels={};

h(end+1)=plot(Dlist,delta1Plist,'k-','LineWidth',2);
labels{end+1}='Colebrook';

h(end+1)=plot(Dlist,delta2Plist,'b--','LineWidth',2);
labels{end+1}='Haaland';

if any(Thelaminar)
    h(end+1)=plot(Dlist(Thelaminar),delta1Plist(Thelaminar), ...
        'ko','MarkerFaceColor','c');
    labels{end+1}='Laminar Region';
end

if any(Theturbulent)
    h(end+1)=plot(Dlist(Theturbulent),delta1Plist(Theturbulent), ...
        'ko','MarkerFaceColor','m');
    labels{end+1}='Turbulent Region';
end

if any(Thetransitional)
    h(end+1)=plot(Dlist(Thetransitional),delta1Plist(Thetransitional), ...
        'ko','MarkerFaceColor','y');
    labels{end+1}='Transitional Region';
end

legend(h,labels,'Location','northeast');
grid on;

percentError=abs((delta1Plist-delta2Plist)./delta1Plist)*100;

figure
hold on
plot(Dlist,percentError,'ro-','LineWidth',2,'MarkerEdgeColor','black','MarkerFaceColor','black')
xlabel('Pipe Diameter (m)')
ylabel('Percent Difference (%)')
title('Colebrook vs Haaland Difference')
legend('Percent Difference', 'Location','northeast')
grid on
hold off

figure
hold on
plot(Dlist,hf1list,'k-','LineWidth',2)
plot(Dlist,hf2list,'b--','LineWidth',2)
xlabel('Pipe Diameter (m)')
ylabel('Head loss (m)')
title('Energy loss vs. Pipe Diameter')
legend('Colebrook','Haaland','Location','northeast')
grid on
hold off

figure
hold on
plot(Dlist,Ploss1,'red','LineWidth',2)
plot(Dlist,Ploss2,'blue','LineWidth',2)
xlabel('Pipe Diameter (m)')
ylabel('Power')
title('Power vs. Pipe Diameter')
legend('Colebrook','Haaland')
grid on
hold off;

figure 
hold on
plot(Relist,FCole,'k','LineWidth',2)
plot(Relist,FHaal,'b--','LineWidth',2)
set(gca,'XScale','log')
set(gca,'YScale','log')
xlabel('Reynolds Number')
ylabel('Friction Factor')
title('Friction Factor vs. Reynolds Number')

legend('Colebrook','Haaland','Location','best')

grid on
hold off
