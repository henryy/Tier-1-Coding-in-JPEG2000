function [ D, CX, S1, S2, S3, encode_pointer ] = SigifiancePropagationPass( D, CX, V, P, S1, S2, S3 , Sign_Array, encode_pointer, Band_Mark )
%SIGIFIANCEPROPAGATIONPASS Summary of this function goes here
%   Detailed explanation goes here

% S=sprintf('SigifiancePropagationPass is called!');% m,n,D(index),CX(index));
%     disp(S)

    [width, length] = size(S1);
    width = 4;
    
S1_extend = int8(zeros(width+4, length+2));
%[w_ext,l_ext] = size(S1_extend);
for i = 1:width
    for j = 1: length
        S1_extend(i+1,j+1)= S1(i,j);
    end
end
%Extend the S1 matrix.

% if width ~= 4
%     error('The number of the row should always be 4.');
% end

for n = 1:length
    for m = 1: width
        if S1(m,n) ~= 0
            continue
        end
        
        temp = S1_extend(m,n) + S1_extend(m+1,n) + S1_extend(m+2,n) + S1_extend(m,n+1) + S1_extend(m+2,n+1) + S1_extend(m,n+2) + S1_extend(m+1,n+2) + S1_extend(m+2,n+2);
        
        if temp == 0
            continue
        end
        
        [tempD, tempCX, tempN]=ZeroCoding(V, P, S1, m,n, Band_Mark);
        %[ D,CX, N] = ZeroCoding( V, P, S1, m, n )
        D(encode_pointer) = tempD;
        CX(encode_pointer) = tempCX;
        encode_pointer = encode_pointer + 1;
        
        S3(m,n) = 1;
        
        if V(m,n,P) == 1
            [tempD, tempCX, tempN] = SignCoding(S1, Sign_Array, m, n);
            D(encode_pointer) = tempD;
            CX(encode_pointer) = tempCX;
            encode_pointer = encode_pointer + 1;
            S1(m,n) = 1;
            for i = 1:width
                for j = 1: length
                    S1_extend(i+1,j+1)= S1(i,j);
                end
            end
        end
        %function [ D,CX, N ] = SignCoding(S1, Sign_array, m, n)
        
    end
end


%S1(m-1,n-1) + S1(m,n-1) + S1(m+1,n-1) + S1(m-1,n) + S1(m+1,n) + S1(m-1,n+1) + S1(m,n+1) + S1(m+1,n+1) 


end

