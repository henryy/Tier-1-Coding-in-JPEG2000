function [ V,P,DeS1,DeS2, DeS3,decode_pointer,Sign_array] = DecodeCUP(D,CX ,DeS1,DeS2, DeS3, P, V, Sign_array, decode_pointer )
%DECODECUP Summary of this function goes here
%   Detailed explanation goes here

    [deWidth,deLength] = size(DeS1);
    deWidth = 4;
    DeS1_ext = int8(zeros(deWidth+4, deLength+2));
    for i = 1:deWidth
        for j = 1: deLength
            DeS1_ext(i+1,j+1)= DeS1(i,j);
        end
    end
    
    flag_RLC = 1;
   % decode_pointer = 1;
    
    for n = 1:deLength
        m = 1;
        while m ~= deWidth+1
%             decode_pointer = (n-1)*4 + m;

            if DeS1(m,n) ~= 0 || DeS3(m,n) ~= 0
                m = m + 1;
                continue
            end
            
            tempSum = 0;
            for i = m+1:m+4
                for j = n:n+2
               %[i,j]
                tempSum = tempSum + DeS1_ext(i,j);
                end
            end
            tempSum = tempSum + DeS1_ext(m,n+1) + DeS1_ext(m+4,n+1); 
            %Calculate consecutive sigma's and their neighbors = 0?
            
            if tempSum == 0 && mod(m,4) == 1%RLC decoding if this is true.                 
                if CX(decode_pointer) < 17
                    %CX(decode_pointer)
                    error('ERROR at Decode CUP!');
                end
                RLC_pointer = 0;
                
                if D(decode_pointer) == 0
                    temp_D = 0;
                    temp_CX = 17;
                    RLC_pointer = RLC_pointer + 1;
                    
                else
                    RLC_pointer = RLC_pointer + 3;
                    temp_D = D(decode_pointer: decode_pointer+RLC_pointer-1);
                    temp_CX = CX(decode_pointer: decode_pointer+RLC_pointer-1);
                end
                
                
                
%                 if CX(decode_pointer) == 17 && D(decode_pointer) == 0
%                     temp_D = 0;
%                     temp_CX = 17;
%                     RLC_pointer = RLC_pointer + 1;
%                 else
%                     for temp_pointer = 1:4
%                         if CX(decode_pointer + temp_pointer - 1) < 17
%                             break;
%                         end
%                         RLC_pointer = RLC_pointer + 1;
%                     end
%                     temp_D = D(decode_pointer: decode_pointer+RLC_pointer-1);
%                     temp_CX = CX(decode_pointer: decode_pointer+RLC_pointer-1);
% 
%                     if RLC_pointer ~=1 && RLC_pointer ~=3
%                          %RLC_pointer
%                          %D(decode_pointer-1:decode_pointer+5)
%                          %CX(decode_pointer-1:decode_pointer+5)
% %                         temp_D
% %                         temp_CX
%                         error('ERROR in CUP decoding!');
%                     end
%                 end
                [flag_RLC, V, P ] = DecodeRunLengthCoding( V, P, m, n ,temp_D,temp_CX, RLC_pointer );
                decode_pointer = decode_pointer + RLC_pointer;
                %decode_pointer
            else
                [ V, P ] = DecodeZeroCoding( V, P, m, n ,D(decode_pointer),CX(decode_pointer));
                 decode_pointer = decode_pointer + 1; 
                
            end 
            
            tempm = m + flag_RLC - 1;
            if V(tempm,n,P) == 1
%                 flag_RLC
%                 D(decode_pointer-1:decode_pointer+10)
%                 CX(decode_pointer-1:decode_pointer+10)
%                 [D(decode_pointer-1),CX(decode_pointer-1)]
%                 [D(decode_pointer),CX(decode_pointer)] 
%                 [D(decode_pointer+1),CX(decode_pointer+1)]
%                 V(m:tempm,n,P)
%                 tempm
%                 flag_RLC
%                 m
%                 n
                [Sign_array ] = DecodeSignCoding(tempm, n, D(decode_pointer),CX(decode_pointer),Sign_array, DeS1);
                decode_pointer = decode_pointer + 1;
                DeS1(tempm,n) = 1;
                
                    
                for i = 1:deWidth
                    for j = 1: deLength
                        DeS1_ext(i+1,j+1)= DeS1(i,j);
                    end
                end
            end
        m = m + flag_RLC;
        flag_RLC = 1; 
        end
        

    end
    

end

