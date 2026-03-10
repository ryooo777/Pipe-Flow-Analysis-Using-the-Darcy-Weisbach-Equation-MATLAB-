function [deltaP1,deltaP2,hf1,hf2] = DarcyWeisbach(L,V,rho,mu,D,f1,f2)
g=9.81;
deltaP1=f1*(L/D)*rho*(V^2)/2;
deltaP2=f2*(L/D)*rho*(V^2)/2;

hf1=deltaP1/(rho*g);
hf2=deltaP2/(rho*g);
end