function [buffer ,reg_enc] = mq_encoder_end(reg_enc,filename)


% Inputs
%     reg_enc ~ state-registers for the coder (before termination)
%     filename ~ filename to write results into.
%     
% Outputs
%     reg_enc ~ state-registers for the coder (after termination) 
%     buffer ~ debug to use.


% The number of bits we need to flush out of C
nbits = 27-15-reg_enc.t;
% Move the next 8 available bits into the partial byte
reg_enc.C = reg_enc.C * uint32(2^reg_enc.t);
while nbits > 0
    reg_enc = mq_transfer_byte(reg_enc);
    % New value of reg.t is the number of bits just transferred
    nbits = nbits - reg_enc.t;
    % Move bits into available position for next transfer
    reg_enc.C = reg_enc.C * uint32(2^reg_enc.t);
end
reg_enc = mq_transfer_byte(reg_enc);

byte_stream = reg_enc.byte_stream;
buffer = reg_enc.byte_stream;


save(filename,'byte_stream');