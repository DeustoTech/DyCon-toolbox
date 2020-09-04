function RD_Gray_Scott

T=300*60; % 300 sec
dx=4 ;%0.4 0.5 0.3 7.5
%L=80;
L=100;
dy= dx;

xline = (-(L-1)*dx*0.5):dx:((L-1)*dx*0.5);
yline = (-(L-1)*dy*0.5):dy:((L-1)*dy*0.5);

[xms,yms] = meshgrid(xline,yline);

dt=0.25;
steps=ceil(T/dt);

%parameters
f = .018;
k = .041;

DD=1;%*(1/7.5^2);
DE=0.05;%*(1/7.5^2);


lap=zeros(L,L);

cD=zeros(L,L,2);
cE=zeros(L,L,2);

W=zeros(L,L);


%cD(:,:,1) = 0.1*rand(L,L) + ones(L,L);

%cE(60:65 ,60:65,1) = 1;
%cE(:,:,1) = cE(:,:,1) + 0.01*rand(L,L);


rms = sqrt(xms.^2 + yms.^2);
thms = atan2(yms,xms);

cE(:,:,1) = sin(6*thms).^2.*exp(-(rms).^2/10^2);
cD(:,:,1) = 1+0.0001*rms.^2;


t=0;





fig = figure(2);
fig.Units = 'norm';
fig.Position = [0.2 0.2 0.6 0.3];
subplot(1,2,1)
isurf = surf(xms,yms,cD(:,:,2));
caxis([-1 1])
view(0,90)

colormap jet

shading interp
subplot(1,2,2)
jsurf = surf(xms,yms,cE(:,:,2));
caxis([-1 1])
view(0,90)

colormap jet
shading interp
iter = 0;


%%


while t<T-dt
    
    lap(2:end-1,2:end-1)= (1/dx^2)*(cD(1:end-2,2:end-1,1)-2*cD(2:end-1,2:end-1,1)+cD(3:end,2:end-1,1)) + ...
                          (1/dy^2)*(cD(2:end-1,1:end-2,1)-2*cD(2:end-1,2:end-1,1)+cD(2:end-1,3:end,1));
    
    lap(1,:)   = 0;
    lap(:,1)   = 0;
    lap(end,:) = 0;
    lap(:,end) = 0;
    
    cD(:,:,2)=(dt)*( f.*(1-cD(:,:,1)) - cD(:,:,1).*cE(:,:,1).^2   + DD.*lap ) + cD(:,:,1) + 0.001*rand(size(cE(:,:,1)));
    
    lap(2:end-1,2:end-1)= (1/dx^2)*(cE(1:end-2,2:end-1,1)-2*cE(2:end-1,2:end-1,1)+cE(3:end,2:end-1,1)) + ...
                          (1/dy^2)*(cE(2:end-1,1:end-2,1)-2*cE(2:end-1,2:end-1,1)+cE(2:end-1,3:end,1));
    lap(1,:)=0;
    lap(:,1)=0;
    lap(end,:)=0;
    lap(:,end)=0;
    
    cE(:,:,2)=(dt)*( cD(:,:,1).*cE(:,:,1).^2 - (k+f).*cE(:,:,1)  + DE.*lap) + cE(:,:,1);
    
    cD(1,2:end-1,:)     = cD(2,2:end-1,:);% Neumann No flux boundary condition
    cD(end,2:end-1,:)   = cD(end-1,2:end-1,:);
    cD(2:end-1,1,:)     = cD(2:end-1,2,:);
    cD(2:end-1,end,:)   = cD(2:end-1,end-1,:);
    
    cE(1,2:end-1,:)     = cE(2,2:end-1,:);% Neumann No flux boundary condition
    cE(end,2:end-1,:)   = cE(end-1,2:end-1,:);
    cE(2:end-1,1,:)     = cE(2:end-1,2,:);
    cE(2:end-1,end,:)   = cE(2:end-1,end-1,:);

    if (mod(iter,200)==0) 
        
         ht.String = ['Time = ' num2str(t)];
         isurf.ZData = cD(:,:,2);
         jsurf.ZData = cE(:,:,2);
         ksurf.ZData = W;

         pause(0.01)
     end
    
        t=t+dt;
        iter=iter+1;

    cD(:,:,1) = cD(:,:,2);
    cE(:,:,1) = cE(:,:,2);
    
    W = W + cD(:,:,1);

end


