function [ D CX, encode_pointer, S1, S2, S3 ] = CLeanUpPass( CX, D, V, P, S1, S2, S3 , Sign_Array, encode_pointer, Band_Mark)
%CLEANPASS Summary of this function goes here
%   Detailed explanation goes here

% S=sprintf('CleanUpPass is called!');
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

if width ~= 4
    error('The number of the row should always be 4.');
end

flag_RLC = 1;
%Follow the scan pattern, so scan every column.
flag_pointer = 0;

n = 1;
m = 1;

for n = 1:length
%     if flag_pointer == 1
%         
%     else
         m = 1;
%     end
    while m ~= width+1
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
        %%lack of Band_mark for ZCoding
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
        
%        if flag_RLC ~=0
%            flag_RLC = flag_RLC - 1;
%            m = m + 1;
%            continue
%        end

       %Check the status table to see if the bit is already encoded by SSP pr MRP. 
       if S1(m,n) ~= 0 || S3(m,n) ~= 0
           %flag_pointer = 1;
           m = m + 1;
           continue
       end
       %Start the Clean Pass process.
       
       tempSum = 0;
       for i = m+1:m+4
           for j = n:n+2
               %[i,j]
               tempSum = tempSum + S1_extend(i,j);
           end
       end
       tempSum = tempSum + S1_extend(m,n+1) + S1_extend(m+4,n+1);     
           %m <= i <= m+5
           %n <= j <= n+2

       %mind the index of m starts from 1 instead of 0. 
       if tempSum == 0 && mod(m,4) == 1
            tempD_RLC = int8(zeros(3));
            tempCX_RLC = int8(zeros(3));
            [tempD_RLC, tempCX_RLC, tempN_RLC]=RunLengthCoding(m,n,V,P);
            %[ D,CX, N] = ZeroCoding( V, P, S1, m, n )
            flag_RLC = tempN_RLC;
            flag_pointer = 0;
            if size(tempD_RLC) == 1
                D(encode_pointer) = tempD_RLC;
                CX(encode_pointer) = tempCX_RLC;
                encode_pointer = encode_pointer + 1;
            else
                D(encode_pointer) = tempD_RLC(1);
                CX(encode_pointer) = tempCX_RLC(1);
                D(encode_pointer + 1) = tempD_RLC(2);
                CX(encode_pointer + 1) = tempCX_RLC(2);
                D(encode_pointer + 2) = tempD_RLC(3);
                CX(encode_pointer + 2) = tempCX_RLC(3);
                encode_pointer = encode_pointer + 3;
            end
            
       else
           [tempD, tempCX, tempN] = ZeroCoding(V, P, S1, m, n, Band_Mark);
           %[ D,CX, N] = ZeroCoding( V, P, S1, m, n )
           flag_pointer = 0;
           D(encode_pointer) = tempD;
           CX(encode_pointer) = tempCX;
           encode_pointer = encode_pointer + 1;
       end    
       
       %Sign coding
       if flag_RLC ~= 0
           tempm = m + flag_RLC - 1;
       end
       if V(tempm,n,P) == 1

           [tempD, tempCX, tempN] = SignCoding(S1, Sign_Array, tempm, n);
           %function [ D,CX, N ] = SignCoding(S1, Sign_array, m, n)
           D(encode_pointer) = tempD;
           CX(encode_pointer) = tempCX;
           encode_pointer = encode_pointer + 1;
           %%%%%%%%%%%%%%%%%%%5
           %Once modify S1, aways sync S1 with S1_extend
           S1(tempm,n) = 1;
           for i = 1:width
                for j = 1: length
                    S1_extend(i+1,j+1)= S1(i,j);
                end
            end
       end
    m = m + flag_RLC;     
    flag_RLC = 1;
    end
  
end


end

