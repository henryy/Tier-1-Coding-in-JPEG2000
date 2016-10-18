function [EncodeLength, V, P ] = DecodeRunLengthCoding( V, P, m, n ,D,CX, N )
%DECODERUNLENGTHCODING Summary of this function goes here
%   Detailed explanation goes here

    
    for i = 1:N
%         S=sprintf('DecodeRunLengthCoding is called for (D,CX) is (%d,%d)', D(i), CX(i));
%         disp(S)
        if CX(i) < 17 || CX(i) > 18
            
            error('Wrong CX value input for RLC decoding!');
        end

    end 
       
    if D(1) == 0
        EncodeLength = 4;
        V(m,n,P) = 0; 
        V(m+1,n,P) = 0;
        V(m+2,n,P) = 0;
        V(m+3,n,P) = 0;
%         S=sprintf('0');
%         disp(S)
    elseif D == [1,0,1]
        V(m,n,P) = 0; 
        V(m+1,n,P) = 1;
        EncodeLength = 2;
%         S=sprintf('1');
%         disp(S)
    elseif D == [1,1,0]
        V(m,n,P) = 0; 
        V(m+1,n,P) = 0;
        V(m+2,n,P) = 1;
        EncodeLength = 3;
%         S=sprintf('2');
%         disp(S)
    elseif D == [1,1,1]
        V(m,n,P) = 0; 
        V(m+1,n,P) = 0;
        V(m+2,n,P) = 0;
        V(m+3,n,P) = 1;
        EncodeLength = 4;
%         S=sprintf('3');
%         disp(S)
    elseif D == [1,0,0];
        V(m,n,P) = 1;
        EncodeLength = 1;
%         S=sprintf('4');
%         disp(S)
    else error('Wrong D value in RLC Decoding!');
    end

end

