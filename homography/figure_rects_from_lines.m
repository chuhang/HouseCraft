function [ rects ] = figure_rects_from_lines( lines )
rects=[];
notused=ones(size(lines,1),1);
while sum(notused)>0
    notusedidx=find(notused==1);
    nowidx=notusedidx(1);
    notused(nowidx)=0;
    linecandidates=nowidx;
    for ii=2:length(notusedidx)
        thisidx=notusedidx(ii);
        if (lines(nowidx,1)==lines(thisidx,1)) && (lines(nowidx,3)==lines(thisidx,3))
            linecandidates=[linecandidates;thisidx;];
        end
    end
    if size(linecandidates,1)==1
        continue;
    else
        [~,sortidx]=sort(lines(linecandidates,2),'ascend');
        tmp=find(sortidx==1);
        if mod(tmp,2)==1
            spouse=find(sortidx==(tmp+1));
        else
            spouse=find(sortidx==(tmp-1));
        end
        nowtwolines=[lines(nowidx,:);lines(linecandidates(spouse),:);];
        notused(linecandidates(spouse))=1;
        rects=[rects;nowtwolines(1,1),min([nowtwolines(1,2),nowtwolines(2,2)]),nowtwolines(1,3),max([nowtwolines(1,2),nowtwolines(2,2)])];
    end
end
end