clear all;

%This is a small 8x8 matrix as fast demo. Becareful, use 8x8 matrix when
%BAND_MODE == 0.
% Input = [3,  0, 0, 5, -6, 1, 2, 5;
%          -3, 7, 2, 1, -2, 3, 4, 7;
%          -4,-1,-2, 3,  0, 4, 2, 1;
%           0, 6, 0, 2,  3, 7, -3, 0;
%          23, 0, 1110, 5, -6, 1, 2, 5;
%          -3,7, 2, 1, -2, 3, 4,7 ;
%          -4,-1,-2,3, 0, 4, 2, 1;
%          0,6,0,2, 3, 7, -3, 0];
     
 Input = imread('bar.bmp');  
 Input = double(Input(1:64,1:64));
%Put only the 64*64 block of the image into the coder in order to save execution time.
    
BAND_Mode = 1;
%This value determines which mode be used:
%!!!!Be careful, if BAND_MODE == 1, then every sub matrices must have a
%size with width and length divided by 4.
%BAND_Mode = 1 will see the input matrix as 7 different frequency bands.
%BAND_Mode = 0 will see the whole input matrix as the LL frequency.
    
[width_global,length_global] = size(Input);

%Randomlize the sign of input to test the Sign Coding in Bit Plane Coding.
for i = 1:width_global
   for j = 1:length_global
        r = randi([-1 1],1);
        if r>0
        else
            Input(i,j) = -1*Input(i,j);
        end
    end
end
    
%Current version only supports when the input matrix width and length can be divided by 4.  
if mod(width_global,4) ~=0 || mod(length_global,4)~=0
    
    error('The input matrix size has to be divided by 4!');
end
     
if BAND_Mode == 1

    Band_Mark_val = ['LH1', 'HL1', 'HH1', 'LL2', 'LH2', 'HL2', 'HH2' ];
    band_pointer = 1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %           %           %                       %
    %    LL2    %    HL2    %                       %
    %           %           %                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%          HL1          %
    %           %           %                       %
    %    LH2    %    HH2    %                       %
    %           %           %                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                       %                       %
    %                       %                       %
    %                       %                       %
    %          LH1          %          HH1          %
    %                       %                       %
    %                       %                       %
    %                       %                       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    InputLL1 = Input(1:width_global/2,1:length_global/2);
    InputLH1 = Input(width_global/2+1:width_global,1:length_global/2);
    InputHL1 = Input(1:width_global/2,length_global/2+1:length_global);
    InputHH1 = Input(width_global/2+1:width_global,length_global/2+1:length_global);
    InputLL2 = Input(1:width_global/4,1:length_global/4);
    InputLH2 = Input(width_global/4+1:width_global/2,1:length_global/4);
    InputHL2 = Input(1:width_global/4,length_global/4+1:length_global/2);
    InputHH2 = Input(width_global/4+1:width_global/2,length_global/4+1:length_global/2);

    Input_total = {InputLH1,InputHL1,InputHH1,InputLL2,InputLH2,InputHL2,InputHH2};
    %Different band should be called seperately.
    %In fact, only the ZeroCoding will encode the freq band differently.
    Band_Mark_interval=2;
    %Band_Mark_val
    for Index = 1:7
           
            Band_Mark = Band_Mark_val(band_pointer:band_pointer+2);
            %Band_Mark
            band_pointer = band_pointer+3;
            Input_InLoop = cell2mat(Input_total(Index));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Source side%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Call bit plane coder
            %Input:Input matrix (must be a matrix that width can be divided by 4).
            %Output: Di.txt and CXi.txt
            [width,length,P, howManyBlocks] = EncodeBitPlaneCoder(Input_InLoop,Band_Mark);

            %Call MQ coder
            %Input: Di.txt and CXi.txt
            %Output: mq_encode_i.txt
            %encode_pointer means length of each coded block
            encode_pointer  = mq_encode_main( howManyBlocks,Band_Mark );


            %%%%%%%%%%%%%%%%%%%%%%%%%%% Receiver side%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %Call MQ decoder
            %Input: mq_encode_i.txt and CXi.txt
            %Output:D_afterMQ_i.txt
            mq_decoder_main( howManyBlocks,encode_pointer,Band_Mark);

            %Call bit plane decoder
            %Input:D_afterMQ_i.txt
            %Output: Output matrix.
            Output = DecodeBitPlaneCoder(width,length, P,Band_Mark);

            %Input
            %Output
            if Input_InLoop == Output
                 S=sprintf(['SUCCESS! Input and Output is identical for ' Band_Mark]);
                 disp(S)
            else 
                S=sprintf(['ERROR! Input and Output is not identical for ' Band_Mark]);
                 disp(S)
            end            
    end
end





if BAND_Mode == 0

    Band_Mark = 'LL';%Different band should be called seperately.

    %Call bit plane coder
    %Input:Input matrix (must be a matrix that width can be divided by 4).
    %Output: Di.txt and CXi.txt
    [width,length,P, howManyBlocks] = EncodeBitPlaneCoder(Input,Band_Mark);

    %Call MQ coder
    %Input: Di.txt and CXi.txt
    %Output: mq_encode_i.txt
    encode_pointer  = mq_encode_main( howManyBlocks,Band_Mark );

    %Call MQ decoder
    %Input: mq_encode_i.txt and CXi.txt
    %Output:D_afterMQ_i.txt
    mq_decoder_main( howManyBlocks,encode_pointer,Band_Mark);

    %Call bit plane decoder
    %Input:D_afterMQ_i.txt
    %Output: Output matrix.
    Output = DecodeBitPlaneCoder(width,length, P,Band_Mark);

    %Input
    %Output
    if Input == Output
         S=sprintf('SUCCESS! Input and Output is identical!');
         disp(S)
    else 
        S=sprintf('ERROR! Input and Output is not identical!');
         disp(S)
    end
end










