function [Wout] = affineTracker(img, tmp, mask, Win, context)
%Updates warp matrix for each frame
    niter = 10;

    Hinv = context.HessianInv;
    J = context.Jacobian;
    [height,width] = size(img);
    
    
    W = Win;
    Wdp = eye(3);
    
    for i = 1:niter
        ImgWarp = warpImageMasked(img,W,mask);
        tmpWarp = warpImageMasked(tmp,Wdp,mask);
        dp =  Hinv * J' * (-ImgWarp(:) + tmpWarp(:));
        %Normalize dp
        dp(1) = dp(1)/width;
        dp(2) = dp(2)/width;
        dp(3) = dp(3)/height;
        dp(4) = dp(4)/height;
        Wdp = [1+dp(1) dp(3) dp(5);
               dp(2) 1+dp(4) dp(6);
               0 0 1];
        %Get new Warp matrix
        W = W*inv(Wdp);
    end
    
    Wout = W;


end

