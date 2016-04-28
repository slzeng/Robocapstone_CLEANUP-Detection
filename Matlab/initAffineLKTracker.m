function [affineLKContext] = initAffineLKTracker(img, msk)
%Initialize LK Tracker
%   img: greyscale image
%   msk: mask same size of img, true at pixels in bounding box
    template = img .* msk;

    %Jacobian of T(W(x;dp)) = del(T) * (dW/dp)
    %Get del(T)
    [dAx,dAy] = gradient(double(template));
    dT = horzcat(dAx(:),dAy(:));    %Unroll so final size is mx2
    J = zeros(size(dT,1),6);
    for i = 1:size(dT,1)
        [y, x] = ind2sub(size(template),i);
        x = x/size(template,1);
        y = y/size(template,2);
        J(i,:) = dT(i,:) * [x 0 y 0 1 0; 0 x 0 y 0 1];
    end

    %Approximate Hessian
    H = J'*J;
    Hi = inv(H);

    %Pack intro struct
    affineLKContext = struct('Jacobian',J,'HessianInv',Hi);
end

