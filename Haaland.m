function [f]=Haaland(Re,epislon,D);
f=(1/(-1.8*log10((((epislon/D))/3.7)^1.11+6.9/Re)))^2;
