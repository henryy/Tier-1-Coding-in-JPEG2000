function reg_enc = mq_transfer_byte(reg_enc)

% C subsets indexes

C_partial = 20:27;
C_msbs    = 21:28;
C_carry   =    28;

% C Subsets Masks

C_partial_mask = uint32(sum(2.^(C_partial-1)));
C_msbs_mask    =    uint32(sum(2.^(C_msbs-1)));



if reg_enc.T == hex2dec('ff'),
%    fprintf('MQ_ENC: Bit stuffing. (1)\n');
    reg_enc = mq_put_byte(reg_enc);
    reg_enc.T = uint8(bitshift(bitand(reg_enc.C,C_msbs_mask),-min(C_msbs)+1));   
    reg_enc.C = bitand(reg_enc.C,bitcmp(C_msbs_mask));
    reg_enc.t = 7; % transfer 7 bits plus carry
else
    % propagate any carry bit from C into T
    reg_enc.T = reg_enc.T + uint8(bitget(reg_enc.C,C_carry));
    reg_enc.C = bitset(reg_enc.C,C_carry,0);
    reg_enc = mq_put_byte(reg_enc);
    if reg_enc.T == hex2dec('ff'),
%        fprintf('MQ_ENC: Bit stuffing policy. (2)\n');        
        reg_enc.T = uint8(bitshift(bitand(reg_enc.C,C_msbs_mask),-min(C_msbs)+1));
        reg_enc.C = bitand(reg_enc.C,bitcmp(C_msbs_mask));
        reg_enc.t = 7; % transfer 7 bits plus carry
    else
        reg_enc.T = uint8(bitshift(bitand(reg_enc.C,C_partial_mask),-min(C_partial)+1));
        reg_enc.C = bitand(reg_enc.C,bitcmp(C_partial_mask));
        reg_enc.t = 8; % transfer full byte
    end
end
