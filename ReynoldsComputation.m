function [f1,f2,fluidtype,Re]=ReynoldsComputation(V,rho,mu,D,epislon)
Re=rho*V*D/mu;
if Re<=2300 %Laminar
    f1=64/Re;
    f2=64/Re;
    fluidtype='Laminar';
elseif Re<=4000 %Laminar+Turbulent
    fLaminar=64/Re;
    f_Cole=Colebrook(Re,epislon,D);
    f_Haal=Haaland(Re,epislon,D);
    w=(Re-2300)/(4000-2300);
    f1=(1-w)*fLaminar+w*f_Cole;
    f2=(1-w)*fLaminar+w*f_Haal;
    fluidtype='Transitional';
else %Turbulent
    fLaminar=64/Re;
    f1=Colebrook(Re,epislon,D);
    f2=Haaland(Re,epislon,D);
    fluidtype='Turbulent';
end
end

