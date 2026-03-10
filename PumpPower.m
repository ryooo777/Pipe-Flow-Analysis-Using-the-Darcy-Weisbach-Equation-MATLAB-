function [Ploss1,Ploss2]=PumpPower(delta1Plist,delta2Plist,V)
D=0.01:0.005:0.1;
A=pi.*(D.^2)./4;
Q=A.*V;
Ploss1=delta1Plist.*Q;
Ploss2=delta2Plist.*Q;
