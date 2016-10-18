function reg_dec = mq_fill_lsbs(reg_dec)

% state-registers for the decoder (before fill)


reg_dec.t = 8;
if (reg_dec.L == numel(reg_dec.byte_stream)) || ...
        (reg_dec.T == uint8(hex2dec('ff')) && reg_dec.byte_stream(reg_dec.L+1) > hex2dec('8f'))
    % Codeword exhausted; fill C with 1's from now on
    reg_dec.C = reg_dec.C + uint32(hex2dec('ff'));
else
    if reg_dec.T == uint8(hex2dec('ff'))
        reg_dec.t = 7;
    end
    reg_dec.T = reg_dec.byte_stream(reg_dec.L+1);
    reg_dec.L = reg_dec.L+1;
    reg_dec.C = reg_dec.C + bitshift(uint32(reg_dec.T),8-reg_dec.t);
end