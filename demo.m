%method = 'rigid';% affine nonrigid

clear all;
close all;

initialization;  %run at the first time

flag = 0;

for k = 1:5
    tmp = num2str(k);
    fn_match_1_5 = ['./4type/set20r1.5/' tmp '.mat'];
    fn_match_1 = ['./4type/set20r1/' tmp '.mat'];
    correct_index = ['./4type/CorrectIndex2/' tmp  '.mat'];
    fn_l = ['./4type/image/' num2str(k) '_l.jpg']; fn_r = ['./4type/image/' num2str(k) '_r.jpg'];
    fprintf('%s  %s\n', fn_l, fn_r);
    Ia = imread(fn_l); Ib = imread(fn_r);
    if size(Ia,3)==1,    Ia = repmat(Ia,[1,1,3]);end
    if size(Ib,3)==1,    Ib = repmat(Ib,[1,1,3]);end
    
    
    load(fn_match_1_5);
    
    x1 = X; y1 = Y;
    [numx1,~] = size(x1);
    p1 = ones(1,numx1);
    Xt = X';Yt = Y';
    tic
    
    lambda1 = 6;lambda2 = 4;
    numNeigh1 = 4; numNeigh2 = 4;
    kdtreeX = vl_kdtreebuild(Xt);
    kdtreeY = vl_kdtreebuild(Yt);
    
    [neighborX, ~] =vl_kdtreequery(kdtreeX, Xt, Xt, 'NumNeighbors', numNeigh1+1) ;
    [neighborY, ~] =vl_kdtreequery(kdtreeY, Yt, Yt, 'NumNeighbors', numNeigh1+1) ;
    p2 = ffm2(X, Y, lambda1, numNeigh1, neighborX(1:end,:),neighborY(1:end,:),p1);
    idx = find(p2 == 1);
    kdtreeX = vl_kdtreebuild(Xt(:,idx));
    kdtreeY = vl_kdtreebuild(Yt(:,idx));
    [neighborX, ~] =vl_kdtreequery(kdtreeX, Xt(:,idx), Xt, 'NumNeighbors', numNeigh2+1) ;
    [neighborY, ~] =vl_kdtreequery(kdtreeY, Yt(:,idx), Yt, 'NumNeighbors', numNeigh2+1) ;
    p2 = ffm2(X, Y, lambda2, numNeigh2, neighborX(1:end,:),neighborY(1:end,:),p2);
    time1 = toc;
    
    
    load(fn_match_1);
    
    
    Xt = X';Yt = Y';
    tic
    [numx2,~] = size(X);
    p3 = zeros(1,numx2);
    for l = 1:numx1
        if p2(l) == 1
            indx = find(X(:,1) == x1(l,1));
            indy = find(X(:,2) == x1(l,2));
            if ~isempty(intersect(indx,indy))
                p3(intersect(indx,indy)) = 1;
            end
        end
    end
    idx = find(p3 == 1);
    fprintf('New method:\n')
    lambda1 = 6; numNeigh1 = 6;
    
    kdtreeX = vl_kdtreebuild(Xt(:,idx));
    kdtreeY = vl_kdtreebuild(Yt(:,idx));
    [neighborX, ~] =vl_kdtreequery(kdtreeX, Xt(:,idx), Xt, 'NumNeighbors', numNeigh1+1) ;
    [neighborY, ~] =vl_kdtreequery(kdtreeY, Yt(:,idx), Yt, 'NumNeighbors', numNeigh1+1) ;
    Prob = ffm2(X, Y, lambda1, numNeigh1, neighborX(1:end,:),neighborY(1:end,:),p3);
    ind = find(Prob == 1);
    
    
    lambda1 = 4;  numNeigh1 = 5;
    kdtreeX = vl_kdtreebuild(Xt(:,ind));
    kdtreeY = vl_kdtreebuild(Yt(:,ind));
    [neighborX, ~] =vl_kdtreequery(kdtreeX, Xt(:,ind), Xt, 'NumNeighbors', numNeigh1+1) ;
    [neighborY, ~] =vl_kdtreequery(kdtreeY, Yt(:,ind), Yt, 'NumNeighbors', numNeigh1+1) ;
    p = ffm2(X, Y, lambda1, numNeigh1, neighborX(1:end,:),neighborY(1:end,:),Prob);
    
    ind = find(p == 1);
    
    load(correct_index);
    Correct = find(CorrectIndex);
    
    
    fprintf('\nFile_name:%d---correct correspondence rate in the original data: %d/%d = %f\r\n',k,  sum(CorrectIndex), size(X,1),  sum(CorrectIndex)/size(X,1));
    [p,r,~] = evaluatex(p,Correct);
    titile_str = [num2str(k) 'th    ' num2str(sum(CorrectIndex)) '/' num2str(size(X,1)) '=' num2str(sum(CorrectIndex)/size(X,1)) '  PR: ' num2str(p) '-' num2str(r)]
    figure; [FP,FN] =  plot_matches(Ia, Ib, X, Y, ind, Correct);
    title(titile_str);
    plot_4c(Ia,Ib,X,Y,ind,Correct);
    title(titile_str);
end









