function LOGSUM = logsum( Y, dim )
    if nargin < 2
        dim = 1;
    end
    
    if dim == 1
        LOGSUM = Y(1,:);
        for i = 2:size(Y,1)
            LOGSUM = logsumexp( LOGSUM, Y(i,:) );
        end
    elseif dim == 2
        LOGSUM = Y(:,1);
        for i = 2:size(Y,2)
            LOGSUM = logsumexp( LOGSUM, Y(:,i) );
        end
    end
end