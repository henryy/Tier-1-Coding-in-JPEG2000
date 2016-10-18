function mq_decoder_main( howManyBlocks,encode_pointer,Band_Mark)
%MQ_DECODER_MAIN Summary of this function goes here
%   Detailed explanation goes here
    for main_loop = 1:howManyBlocks
        %main_loop
        mq_encode_filename = strcat(Band_Mark,'_mq_encode_',num2str(main_loop),'.txt');
        reg_dec = mq_decoder_init(mq_encode_filename);
        D_decode = zeros(encode_pointer(1,main_loop),1);
        %D_decode 
        
        CX_filename = strcat(Band_Mark,'_CX_',num2str(main_loop),'.txt');
        fid = fopen(CX_filename,'r');
        CX = fscanf(fid,'%d');
        fclose(fid);
        CX = uint8(CX+1);
        

        [CX_Table, PET_Table] = mq_inits;%CX_Table has to be the initial one.

        for ii = 1:encode_pointer(1,main_loop)
        % %mq_decoder
            [tempSymbol, reg_dec, CX_Table] = mq_decoder(CX(ii),reg_dec,CX_Table,PET_Table);

            D_decode(ii,1) = tempSymbol;

        end
        
        
        
        mq_decode_filename = strcat(Band_Mark,'_D_afterMQ_',num2str(main_loop),'.txt');
        fid = fopen(mq_decode_filename, 'wt');
        for j = 1: encode_pointer(1,main_loop)
            fprintf(fid,'%d',D_decode(j,1));
            fprintf(fid,'\n');
        end    
    
        fclose(fid);
        
    end    

end

