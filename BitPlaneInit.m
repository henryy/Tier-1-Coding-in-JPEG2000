function [ Sign_Array, S1, S2, S3, V, P ] = BitPlaneInit( Input,main_loop,P)
%BITPLANEINIT Summary of this function goes here
%   Detailed explanation goes here

[width,length] = size(Input);



% if width < 4 || length <4
%     error('The size of the input block should always be bigger than 4x4!');
% end
if width ~= 4
    error('ERROR in BitPlaneInit!');
end

%Init the three status matrix, S1 is 
S1 = zeros(width,length);
S2 = zeros(width,length);
S3 = zeros(width,length);


Magnitude_Array = abs(Input);
%sign matrix, negative is 1 and non-negative is 0.
Sign_Array = zeros(width,length);
for i = 1: width
    for j = 1: length
        if Input(i,j) < 0
            Sign_Array(i,j) = 1;
        end
    end
end

[useless, P(main_loop,1)] = size(dec2bin(max(Magnitude_Array)));%P = 1 means most sigificant plane.

V = zeros(width, length, P(main_loop,1));
V = int8(V);
% P(1:5)
%V(1,:,:) is the most significant bit matrix.
for i = 1: width
    for j = 1: length
        temp = dec2bin(Magnitude_Array(i,j),P(main_loop,1));%
        for l = 1:P(main_loop,1)
            %uint8(temp(l))
            if temp(l) == '1'
                V(i,j,l) = 1;
            end
            
        end    
    end
end

end

