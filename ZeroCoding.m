function [ D,CX, N] = ZeroCoding( V, P, S1, m, n, Band_Mark )
%ZEROCODING Summary of this function goes here
%   Detailed explanation goes here
if nargin ~= 6, error('Not correct input arguments for ZeroCoding Func!'); end



D = V(m,n,P);
N = 1;
[width, length] = size(S1);

S1_extendZC = int8(zeros(width+4, length+2));
%[w_ext,l_ext] = size(S1_extend);
for i = 1:width
    for j = 1: length
        S1_extendZC(i+1,j+1)= S1(i,j);
    end
end


    sumH = S1_extendZC(m+1,n) + S1_extendZC(m+1,n+2);
    sumV = S1_extendZC(m,n+1) + S1_extendZC(m+2,n+1); 
    sumD = S1_extendZC(m,n) + S1_extendZC(m,n+2) + S1_extendZC(m+2,n) + S1_extendZC(m+2,n+2);
% LL band and LH band
if strcmp(Band_Mark(1:2),'LL') == 1 || strcmp(Band_Mark(1:2),'LH') ==1
    
    if sumH == 2
        CX = 8;
    elseif sumH == 1 && sumV >= 1
        CX = 7;
    elseif sumH == 1 && sumV == 0 && sumD >= 1 
        CX =6;
    elseif sumH == 1 && sumV == 0 && sumD == 0
        CX = 5;
    elseif sumH == 0 && sumV == 2
        CX = 4;
    elseif sumH == 0 && sumV == 1 
        CX = 3;
    elseif sumH == 0 && sumV == 0 && sumD >= 2
        CX = 2;
    elseif sumH == 0 && sumV == 0 && sumD == 1
        CX = 1;
    elseif sumH == 0 && sumV == 0 && sumD == 0
        CX = 0;
    else error('Some shit happens in ZeroCoding process with wrong sumH, sumV or sumD values in LL/LH!')
    end
end

%HL band
if strcmp(Band_Mark(1:2),'HL') == 1
    
    if sumV == 2
        CX = 8;
    elseif sumH >= 1 && sumV == 1
        CX = 7;
    elseif sumH == 0 && sumV == 1 && sumD >= 1 
        CX =6;
    elseif sumH == 0 && sumV == 1 && sumD == 0
        CX = 5;
    elseif sumH == 2 && sumV == 0
        CX = 4;
    elseif sumH == 1 && sumV == 0 
        CX = 3;
    elseif sumH == 0 && sumV == 0 && sumD >= 2
        CX = 2;
    elseif sumH == 0 && sumV == 0 && sumD == 1
        CX = 1;
    elseif sumH == 0 && sumV == 0 && sumD == 0
        CX = 0;
    else error('Some shit happens in ZeroCoding process with wrong sumH, sumV or sumD values in HL!')
    end
end

%HH band
if strcmp(Band_Mark(1:2),'HH') == 1
    
    if sumD >= 3
        CX = 8;
    elseif sumH + sumV >= 1 && sumD == 2
        CX = 7;
    elseif sumH + sumV == 0 && sumD == 2 
        CX =6;
    elseif sumH + sumV >= 2 && sumD == 1
        CX = 5;
    elseif sumH + sumV == 1 && sumD == 1
        CX = 4;
    elseif sumH + sumV == 0 && sumD == 1 
        CX = 3;
    elseif sumH + sumV >= 2 && sumD == 0
        CX = 2;
    elseif sumH + sumV == 1 && sumD == 0
        CX = 1;
    elseif sumH + sumV == 0 && sumD == 0
        CX = 0;
    else       
        
        error('Some shit happens in ZeroCoding process with wrong sumH, sumV or sumD values in HH!')
    end
end

% S=sprintf('ZeroCoding is called at (%d,%d) and (D,CX) output is (%d,%d)', m,n,D,CX);
% disp(S)

end

