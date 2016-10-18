function [ V,P,DeS1,DeS2, DeS3,decode_pointer,Sign_array ] = DecodeMRP( D,CX ,DeS1,DeS2, DeS3, P, V, Sign_array, decode_pointer )
%DECODEMRP Summary of this function goes here
%   Detailed explanation goes here

    [deWidth, deLength] = size(DeS1);
     deWidth = 4;
    DeS1_ext = int8(zeros(deWidth+4, deLength+2));
    %[w_ext,l_ext] = size(S1_extend);
    for i = 1:deWidth
        for j = 1: deLength
            DeS1_ext(i+1,j+1)= DeS1(i,j);
        end
    end
    
    for n = 1:deLength
        for m = 1: deWidth
            if DeS1(m,n) ~=1 || DeS3(m,n) ~=0
               continue 
            end
            
            [ V, P ] = DecodeMagnitudeRefinementCoding( V, P, m, n ,D(decode_pointer),CX(decode_pointer));
            decode_pointer = decode_pointer + 1;
            DeS2(m,n) = 1;
        end
    end
    

end

