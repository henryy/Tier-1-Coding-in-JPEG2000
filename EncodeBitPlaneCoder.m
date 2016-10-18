function [ width,length,P, howManyBlocks] = EncodeBitPlaneCoder( Input,Band_Mark )
%ENCODEBITPLANECODER Summary of this function goes here
%   Detailed explanation goes here

    [width,length] = size(Input);
    if mod(width,4) ~= 0 
        width
        error('Attention! Current version only support input matrix width can be divided by 4!');
    end
    
    
    
    
    
    num_width = width/4;
    
    howManyBlocks = num_width;
    P = zeros(1000,1);
    
    for main_loop = 1:num_width  
        
       % V = V_main((main_loop-1)*4+1:(main_loop-1)*4+4,:,:);
        [Sign_Array, S1, S2, S3, V, P] = BitPlaneInit(Input((main_loop-1)*4+1:(main_loop-1)*4+4,:),main_loop,P);
    
        CX = uint8(zeros(100000000,1));
        D = uint8(zeros(100000000,1));
        encode_pointer = 1;

        for bit_plane_lvl = 1:P(main_loop,1)

%             S=sprintf('The %dth bit plane is being processing!', bit_plane_lvl);% m,n,D(index),CX(index));
%             disp(S)

            [D, CX, S1, S2, S3, encode_pointer ] = SigifiancePropagationPass( D, CX, V, bit_plane_lvl, S1, S2, S3 , Sign_Array, encode_pointer, Band_Mark );

            [D, CX, S1, S2, S3, encode_pointer] = MagnitudeRefinementPass( D, CX, V, bit_plane_lvl, S1, S2, S3 , Sign_Array, encode_pointer, Band_Mark );

            [D, CX, encode_pointer, S1, S2, S3 ] = CLeanUpPass( CX, D, V, bit_plane_lvl, S1, S2, S3 , Sign_Array, encode_pointer, Band_Mark);

            S3 = zeros(width,length);
        end

        CX_final = CX(1: encode_pointer-1);
        D_final = D(1: encode_pointer-1);
        %CX(1: encode_pointer)

        D_filename = strcat(Band_Mark,'_D_',num2str(main_loop),'.txt');
        fid = fopen(D_filename, 'wt');
        for iD = 1: encode_pointer-1
            fprintf(fid,'%d',D(iD));
            fprintf(fid,'\n');
        end    
        fclose(fid);

        CX_filename = strcat(Band_Mark,'_CX_',num2str(main_loop),'.txt');
        fid = fopen(CX_filename, 'wt');

        for iCX = 1: encode_pointer-1
            fprintf(fid,'%d',CX(iCX));
            fprintf(fid,'\n');
        end    

        fclose(fid);
    end
end

