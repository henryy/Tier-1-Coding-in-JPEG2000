function reg_enc = mq_put_byte(reg_enc)

if reg_enc.L >= 0
    reg_enc.byte_stream = [reg_enc.byte_stream reg_enc.T];
%    fprintf('MQ_ENC: byte_written = %s\n',dec2bin(reg_enc.T));
end
reg_enc.L = reg_enc.L+1;