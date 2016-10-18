function [ V, P ] = DecodeZeroCoding( V, P, m, n ,D,CX )
%DECODEZEROCODING Summary of this function goes here
%   Detailed explanation goes here
%     S=sprintf('DecodeZeroCoding is called for (D,CX) is (%d,%d)', D, CX);
%     disp(S)
    if CX > 8
        
        error('Wrong decoding for ZeroCoding');
    end
    V(m,n,P) = D;
%     S=sprintf('DecodeZeroCoding V(%d,%d,%d) is %d', m, n,P, D );
%     disp(S)
%     [width, length] = size(S1);
%     S1_extendZC = int8(zeros(width+4, length+2));
%     
%     for i = 1:width
%         for j = 1: length
%             S1_extendZC(i+1,j+1)= S1(i,j);
%         end
%     end

%     sumH = S1_extendZC(m+1,n) + S1_extendZC(m+1,n+2);
%     sumV = S1_extendZC(m,n+1) + S1_extendZC(m+2,n+1); 
%     sumD = S1_extendZC(m,n) + S1_extendZC(m,n+2) + S1_extendZC(m+2,n) + S1_extendZC(m+2,n+2);
%     
%     if strcmp(Band_Mark,'LL') == 1 || strcmp(Band_Mark,'LH') ==1
        
        
    
    
end

