clc; clf; clear; set(gcf,'color','k');
javaaddpath([pwd '/dep/OpenSimplex.jar'])

nPix = 31;
nT = 120;
disp('getting length...');  len = getSimplexMat(nPix,nT);
disp('getting colour...');  col = getSimplexMat(nPix,nT);
disp('getting ori...');     ori = getSimplexMat(nPix,nT)*pi;

tPos = linspace(0,1,nPix);
colmap = crameri('hawaii',nPix);
% cols = jet(nPix);

vidObj = VideoWriter('drift','MPEG-4');
vidObj.FrameRate = 24;
open(vidObj);
for tt=1:nT
    clf;
    for ii=1:nPix
        for jj=1:nPix
            [~,idx] = min(abs(tPos-col(ii,jj,tt)));
            lineCol = colmap(idx,:)*len(ii,jj,tt);
            
            x = [tPos(ii) tPos(ii) + len(ii,jj,tt)*cos(ori(ii,jj,tt))/7];
            y = [tPos(jj) tPos(jj) + len(ii,jj,tt)*sin(ori(ii,jj,tt))/7];
            
            line(x,y,'color',lineCol,'linewidth',2)
        end
    end
    axis([-0.2 1.2 -0.2 1.2]); axis square; axis off;
    currFrame = getframe;
    writeVideo(vidObj,currFrame);
end
close(vidObj);

function yy = getSimplexMat(nPix,nT)
    tt = linspace(-1,1,nPix);
    [xx,zz] = meshgrid(tt,tt);
    tt = linspace(0,2*pi,nT);
    yy = zeros(size(xx));
    o = OpenSimplex.OpenSimplexNoise(randi(10000));
    for kk=1:nT
        for ii=1:nPix
            for jj=1:nPix
                yy(ii,jj,kk) = o.eval(xx(ii,jj),zz(ii,jj),cos(tt(kk)),sin(tt(kk)));
            end
        end
        yy(:,:,kk) = 0.5+yy(:,:,kk)/2;
    end
    yy = (yy - min(yy(:)))./(max(yy(:)) - min(yy(:)));
end