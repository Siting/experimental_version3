%% Cell Transmition Model
function[dLinkUpdate]=CTM(dlink,leftFlux,rightFlux,deltaT,deltaX,vmax,dmax,dc)

c = deltaT/deltaX;

% one cell?
if length(dlink) == 1
    dLinkUpdate = dlink - c*(rightFlux-leftFlux);
    % >= one cell?
else dLinkUpdate = zeros(length(dlink),1);
    i=1; % first cell
    dLinkUpdate(i)=dlink(i)-c*(...
        RS(dlink(i),vmax,dmax,dc,dlink(i+1),vmax,dmax,dc)-leftFlux);
    
    for i=2:(length(dlink)-1)
%         if i == 36 && dlink(i+1) > 190
%             keyboard
%         end
        dLinkUpdate(i)=dlink(i)-c*(...
            RS(dlink(i),vmax,dmax,dc,dlink(i+1),vmax,dmax,dc)...
            -RS(dlink(i-1),vmax,dmax,dc,dlink(i),vmax,dmax,dc));
    end
    
    i=length(dlink); % last cell
    dLinkUpdate(i)=dlink(i)-c*(...
        rightFlux-RS(dlink(i-1),vmax,dmax,dc,dlink(i),vmax,dmax,dc));
end

if any(dLinkUpdate < 0)
    keyboard
end





