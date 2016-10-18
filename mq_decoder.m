function [symbol reg_dec Dynamic_Table] = mq_decoder(label,reg_dec,Dynamic_Table,Static_Table)


% Inputs
%     label ~ CX for that symbol
%     reg_dec ~ state-registers for the coder (before decode)
%     Dynamic_Table ~ CX_Table
%     Static_Table ~ PET_Table

% Outputs
%     symbol ~ decoded bit
%     reg_dec ~ state-registers for the coder (after decode)
%     Dynamic_Table ~ arithmetic code states table (after decode)



if nargin < 4
    error('4 arguments needed.');
end

% C subsets indexes

C_active  =  9:24;
C_active_mask  =  uint32(sum(2.^(C_active-1)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % MQ Decoder Procedure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Get information related to the label
expected_symbol = Dynamic_Table(label,2);               % s = s_k
probability = Static_Table(Dynamic_Table(label,1),4);   % p = p(sigma_k)

if expected_symbol > 1
    %expected_symbol
    disp('expected_symbol > 1 in nq_decoder.m!');
end

reg_dec.A = reg_dec.A - uint16(probability);

if reg_dec.A < uint16(probability),
    % Conditional exchange of MPS and LPS
    expected_symbol = 1 - expected_symbol;
end

% Compare active reg_decion of C
if bitshift(bitand(reg_dec.C,C_active_mask),-(min(C_active)-1)) < probability
    symbol = 1-expected_symbol;
    reg_dec.A = uint16(probability);
else
    symbol = expected_symbol;
    Temp = bitshift(bitand(reg_dec.C,C_active_mask),-(min(C_active)-1))-uint32(probability);
    reg_dec.C = bitand(reg_dec.C,bitcmp(C_active_mask));
    reg_dec.C = reg_dec.C + bitand(uint32(bitshift(Temp,min(C_active)-1)),C_active_mask);
end

if reg_dec.A < 2^15,
    % The symbol was a real MPS
    if symbol == Dynamic_Table(label,2),
        Dynamic_Table(label,1) = Static_Table(Dynamic_Table(label,1),1);
    % The symbol was a real LPS
    else
        Dynamic_Table(label,2) = bitxor(Dynamic_Table(label,2),...
                                        Static_Table(Dynamic_Table(label,1),3));
        Dynamic_Table(label,1) = Static_Table(Dynamic_Table(label,1),2);
    end
end

% Perform quantization shift
while reg_dec.A < 2^15,
    reg_dec = mq_renormalize_once(reg_dec);
end


return