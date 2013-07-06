%% Riemann Solver ( minimum of sending and receiving)
function[q]=RS(density1,vmax1,dmax1,dc1,density2,vmax2,dmax2,dc2)
qmax1 = vmax1 .* dc1;
qmax2 = vmax2 .* dc2;
% s = (density1>=dc1).*(vmax1*dc1) + (density1<dc1).* (vmax1*density1.*((0<density1).*(density1<=dc1))+...
%         (dc1*vmax1)*(dmax1-density1)./(dmax1-dc1).*((dmax1>density1).*(density1>dc1))+...
%         0.*(density1>=dmax1)+0.*(density1<=0));
    
s = min(qmax1, (vmax1.*density1));
% 
% r = (density2 >= dc2) .* ( vmax2*density2.*((0<density2).*(density2<=dc2))+...
%         (dc2*vmax2)*(dmax2-density2)./(dmax2-dc2).*((dmax2>density2).*(density2>dc2))+...
%         0.*(density2>=dmax2)+0.*(density2<=0)) + (density2 < dc2).*(vmax2*dc2);
    
r = min(qmax2, (qmax2).*(dmax2-density2)./(dmax2-dc2));
q= max(min(s,r),0);