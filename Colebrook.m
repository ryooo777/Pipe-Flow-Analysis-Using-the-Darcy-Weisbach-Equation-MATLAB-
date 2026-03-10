function [f]=Colebrook(Re,epislon,D)
f=0.02;
for k=1:20
    f=(1/(((-2.0)*log10(((epislon/D)/3.7)+(2.51)/(Re*sqrt(f))))^2));
end
