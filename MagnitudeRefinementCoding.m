function [D, CX, N  ] = MagnitudeRefinementCoding(V, P ,S2, S1, m, n )
%
%   Detailed explanation goes here
if nargin ~= 6, error('Not correct input arguments in MagnitudeRefinementCoding func.'); end

[width,length] = size(S2);
D = V(m,n,P);
N = 1;

S1_extend = int8(zeros(width+4, length+2));
    %[w_ext,l_ext] = size(S1_extend);
    for i = 1:width
        for j = 1: length
            S1_extend(i+1,j+1)= S1(i,j);
        end
    end

temp = S1_extend(m,n+1)+S1_extend(m+2,n+1)+S1_extend(m+1,n+2)+S1_extend(m+1,n); 

if S2(m,n) == 1
    CX = 16;
elseif S2(m,n) == 0 && temp == 0
    CX = 14;
else
    CX = 15;
end




% S=sprintf('MRCoding is called at (%d,%d) and (D,CX) output is (%d,%d)', m,n,D,CX);
% disp(S)

end
