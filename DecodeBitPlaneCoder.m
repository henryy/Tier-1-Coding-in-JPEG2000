function [ Output ] = DecodeBitPlaneCoder( deWidth,deLength, P ,Band_Mark)
%DECODEBITPLANECODER Summary of this function goes here
%   Detailed explanation goes here
    if mod(deWidth,4) ~= 0 
        error('Attention! Current version only support input matrix width can be divided by 4!');
    end
    num_width = deWidth/4;
     
    Output = zeros(deWidth,deLength);
    
    
    for main_loop = 1:num_width
        
    %Read in D file and CX file.
        %D_filename = strcat('D_',num2str(main_loop),'.txt');
        D_filename = strcat(Band_Mark,'_D_afterMQ_',num2str(main_loop),'.txt');
        fid = fopen(D_filename,'r');
        D = fscanf(fid,'%d');
        D = D';
        fclose(fid);

        %CX_filename = strcat('CX_',num2str(main_loop),'.txt');
        CX_filename = strcat(Band_Mark,'_CX_',num2str(main_loop),'.txt');
        %CX_filename
        fid = fopen(CX_filename,'r');
        CX = fscanf(fid,'%d');
        CX = CX';
       
        fclose(fid);

    %Init all stuffs needed for decoding.
        DeS1 = zeros(4,deLength);
        DeS2 = zeros(4,deLength);
        DeS3 = zeros(4,deLength);
        Sign_array = zeros(4,deLength);
        V = int8(zeros(4,deLength, P(main_loop,1)));
        decode_pointer = 1;
        
    %Strat decoding
        for bit_plane_lvl = 1:P(main_loop,1)
%             S=sprintf('The %dth bit plane is being decoding!', bit_plane_lvl);% m,n,D(index),CX(index));
%             disp(S)
            [V,bit_plane_lvl,DeS1,DeS2, DeS3,decode_pointer,Sign_array] = DecodeSPP( D,CX ,DeS1,DeS2, DeS3, bit_plane_lvl, V, Sign_array, decode_pointer);
            [V,bit_plane_lvl,DeS1,DeS2, DeS3,decode_pointer,Sign_array] = DecodeMRP( D,CX ,DeS1,DeS2, DeS3, bit_plane_lvl, V, Sign_array, decode_pointer );
            [V,bit_plane_lvl,DeS1,DeS2, DeS3,decode_pointer,Sign_array] = DecodeCUP( D,CX ,DeS1,DeS2, DeS3, bit_plane_lvl, V, Sign_array, decode_pointer );
            DeS3 = zeros(deWidth,deLength);
        end
        
    %Form all decode result from binary to decimal    
        for i = 1: 4
            for j = 1: deLength
                if Sign_array(i,j) == 1
                    temp_sign = -1;
                else
                    temp_sign = 1;
                end
                %temp = dec2bin(Magnitude_Array(i,j),P);%
                temp_str = '';
                %P(1:10)
                for l = 1:P(main_loop,1)
                    temp_str = strcat(temp_str,num2str(V(i,j,l)));
                end    
                Output((main_loop-1)*4+i,j) = bin2dec(temp_str) * temp_sign;
            end
        end
    end
end

