function [ encode_pointer ] = mq_encode_main( howManyBlocks,Band_Mark )
%MQ_ENCODE_MAIN Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%Inits the CX table, PET table(CX is dynamic and PET is static)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    encode_pointer = zeros(1,howManyBlocks);
    
    for main_loop = 1:howManyBlocks
        
        [CX_Table, PET_Table] = mq_inits;
        reg_enc = mq_encoder_init;
        D_filename = strcat(Band_Mark,'_D_',num2str(main_loop),'.txt');
        fid = fopen(D_filename,'r');
        D = fscanf(fid,'%d');
        fclose(fid);
        
        CX_filename = strcat(Band_Mark,'_CX_',num2str(main_loop),'.txt');
        fid = fopen(CX_filename,'r');
        CX = fscanf(fid,'%d');
        fclose(fid);
        
        D = uint8(D);
        CX = uint8(CX+1);%Adjust the index to avoid CX(0) happens in matlab.
        
        temp =size(D);
        
        encode_pointer(1,main_loop) = temp(1,1);
        
        for ii = 1:encode_pointer(1,main_loop)

            [reg_enc CX_Table] = mq_encoder(D(ii),CX(ii),reg_enc,CX_Table,PET_Table);

        end
        mq_encode_filename = strcat(Band_Mark,'_mq_encode_',num2str(main_loop),'.txt');
        [buffer,reg_enc] = mq_encoder_end(reg_enc,mq_encode_filename); 
        
    end    

end

