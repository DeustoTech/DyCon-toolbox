clear;
clc;


T=300*60; % 300 sec
dx=2;%0.4 0.5 0.3 7.5
L=128;
dy= dx;
dt=0.25;
steps=ceil(T/dt);

%parameters
f = .018;
k = .051;

DD=1;%*(1/7.5^2);
DE=0.5;%*(1/7.5^2);


lap=zeros(L,L);
cD=zeros(L,L,2);
cE=zeros(L,L,2);

cD(:,:,1)=ones(L,L);
%cD(:,:,1)=rand(L,L);


  cE(51:60 ,51:70,1) = 1;
  cE(61:80,71:80,1) = 1;

% cE(:,:,1) = repelem( 0+(2-0)*rand(L/4,L/4),4,4);

 %cE(:,:,1) = rand(L,L)
t=0;

targetframerate = 24;
frametime = 1/(24*60*60*targetframerate);
nextframe = now + frametime;
tic
nframes = 1;


hFig = figure('Visible','off','Position', [100, 100, 1500, 800]);
set(hFig, 'PaperPositionMode','auto');

str='rd_example';
str=strcat(str,'_f_',num2str(f),'_k_',num2str(k));

writerObj = VideoWriter(str);
open(writerObj);
iter=0;
figure(2)
while t<T-dt
    
    lap(2:end-1,2:end-1)= (1/dx^2)*(cD(1:end-2,2:end-1,1)-2*cD(2:end-1,2:end-1,1)+cD(3:end,2:end-1,1)) + (1/dy^2)*(cD(2:end-1,1:end-2,1)-2*cD(2:end-1,2:end-1,1)+cD(2:end-1,3:end,1));
    lap(1,:)=0;
    lap(:,1)=0;
    lap(end,:)=0;
    lap(:,end)=0;
    cD(:,:,2)=(dt)*( f.*(1-cD(:,:,1)) - cD(:,:,1).*cE(:,:,1).^2   + DD.*lap ) + cD(:,:,1);
    
    lap(2:end-1,2:end-1)= (1/dx^2)*(cE(1:end-2,2:end-1,1)-2*cE(2:end-1,2:end-1,1)+cE(3:end,2:end-1,1)) + (1/dy^2)*(cE(2:end-1,1:end-2,1)-2*cE(2:end-1,2:end-1,1)+cE(2:end-1,3:end,1));
    lap(1,:)=0;
    lap(:,1)=0;
    lap(end,:)=0;
    lap(:,end)=0;
    cE(:,:,2)=(dt)*( cD(:,:,1).*cE(:,:,1).^2 - (k+f).*cE(:,:,1)  + DE.*lap) + cE(:,:,1);
    
    cD(1,2:end-1,:)=cD(2,2:end-1,:);% Neumann No flux boundary condition
    cD(end,2:end-1,:)=cD(end-1,2:end-1,:);
    cD(2:end-1,1,:)=cD(2:end-1,2,:);
    cD(2:end-1,end,:)=cD(2:end-1,end-1,:);
    
    cE(1,2:end-1,:)=cE(2,2:end-1,:);% Neumann No flux boundary condition
    cE(end,2:end-1,:)=cE(end-1,2:end-1,:);
    cE(2:end-1,1,:)=cE(2:end-1,2,:);
    cE(2:end-1,end,:)=cE(2:end-1,end-1,:);

    
    
    if (mod(iter,100)==0) 
        
         ht.String = ['Time = ' num2str(t)];

         subplot(1,2,1)
         imagesc(cD(:,:,2)),colorbar
          caxis([0 0.4])

         subplot(1,2,2)
         imagesc(cE(:,:,2)),colorbar 

         caxis([0 0.4])
        %saveas(hFig, str , 'png');

%       img = hardcopy(hFig, '-dzbuffer', '-r0');
       %writeVideo(writerObj, im2frame(img));
     pause(0.01)   
        if now > nextframe
            drawnow
            nextframe = now + frametime;
        end
        nframes = nframes+1;
     end
    
        t=t+dt;
        iter=iter+1;

    cD(:,:,1) = cD(:,:,2);
    cE(:,:,1) = cE(:,:,2);

end

close(writerObj);
delta = toc;
disp([num2str(nframes) ' frames in ' num2str(delta) ' seconds']);
