function [ thepoints ] = lines2points( thelines,ptinterval )
thepoints=[];
for ii=1:size(thelines,1)
    len=norm(thelines(ii,1:2)-thelines(ii,3:4));
    if len>ptinterval
        ptlens=0:ptinterval:len;
        ptx=thelines(ii,1)+ptlens'*((thelines(ii,3)-thelines(ii,1))/len);
        pty=thelines(ii,2)+ptlens'*((thelines(ii,4)-thelines(ii,2))/len);
        thepoints=[thepoints;ptx,pty;];
    end
end
end