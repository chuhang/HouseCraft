imshow(I)
hold on;
for ii=1:100
    if ((bbs(ii,3)+bbs(ii,4))/2)<120
        plot([bbs(ii,1),bbs(ii,1)+bbs(ii,3),bbs(ii,1)+bbs(ii,3),bbs(ii,1),bbs(ii,1)],[bbs(ii,2),bbs(ii,2),bbs(ii,2)+bbs(ii,4),bbs(ii,2)+bbs(ii,4),bbs(ii,2)]);
    end
end
hold off;