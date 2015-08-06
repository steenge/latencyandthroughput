function res = pingplot1(IPaddress, cnt, deltaT, tech)


% cnt       : Antal ping pakker der skal sendes 
% deltatT   : Tid mellem pakker i ms (mindst 25 ms, ellers som root)
% 
%


[s, r] = system(['/usr/local/bin/fping -C ' num2str(cnt) ' -p ' num2str(deltaT) ' -q ' IPaddress]);

idx=1;


disp(r);

tmp = explode(r, ' ');

packetloss=0;

for i=3:length(tmp)
    
    if ~strcmp(char(tmp(i)), '-')
    	latency(idx) = str2num(char(tmp(i)));
       idx=idx+1;
    else
        packetloss=packetloss+1;
    end
end


figure
%stairs(latency, 'LineWidth', 2)
plot(1/1000:deltaT/1000:(length(latency)*deltaT)/1000, latency, 'LineWidth', 0.5)
grid
ylabel('latency [ms]')
xlabel('time [s]')
title(['Roundtrip delay for ' IPaddress ', tech=' tech ', packets lost: ' num2str(packetloss)], 'FontSize', 14)

res = latency;

disp(['packets lost: ' num2str(packetloss)]);

%% Lav normalfordelingskurve for latenstider, og sammenlign mellem 2,4 og 5 GHz

figure
mu=mean(latency);
sg=std(latency);
x=linspace(mu-4*sg,mu+4*sg,200);
pdfx=1/sqrt(2*pi)/sg*exp(-(x-mu).^2/(2*sg^2));
plot(x,pdfx);
