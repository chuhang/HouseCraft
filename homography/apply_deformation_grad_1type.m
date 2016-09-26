function [ outpoints2d ] = apply_deformation_grad_1type( points3d,pointsfn,xchanges,ychanges,zchanges,zchanges_fn,xgrad,ygrad,zgrad )
sz=size(points3d,1);
searchsz=size(xchanges,1);

xchangesrep=repmat(xchanges',sz,1);
xchangesrep=xchangesrep(:);
ychangesrep=repmat(ychanges',sz,1);
ychangesrep=ychangesrep(:);
zchangesrep=repmat(zchanges',sz,1);
zchangesrep=zchangesrep(:);
zchangesfnrep=repmat(zchanges_fn',sz,1);
zchangesfnrep=zchangesfnrep(:);

nowfn=repmat(pointsfn,searchsz,1);
adddata=[xgrad(1)*xchangesrep+ygrad(1)*ychangesrep+zgrad(1)*(zchangesrep+zchangesfnrep.*nowfn),xgrad(2)*xchangesrep+ygrad(2)*ychangesrep+zgrad(2)*(zchangesrep+zchangesfnrep.*nowfn),xgrad(3)*xchangesrep+ygrad(3)*ychangesrep+zgrad(3)*(zchangesrep+zchangesfnrep.*nowfn)];
outpoints3d=repmat(points3d,searchsz,1)+adddata;
outpoints2d=[outpoints3d(:,1)./outpoints3d(:,3),outpoints3d(:,2)./outpoints3d(:,3)];
end