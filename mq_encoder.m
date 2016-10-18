function [reg_enc Dynamic_Table] = mq_encoder(symbol,label,reg_enc,Dynamic_Table,Static_Table)

%     
% Inputs
%     symbol ~ D
%     label ~ CX
%     reg_enc ~ state-registers for the coder (before code)
%     Dynamic_Table ~ CX_Table (before code)
%     Static_Table ~ PET_Table  
%     
% Outputs
%     reg_enc ~ state-registers for the coder (after code)
%     Dynamic_Table ~ CX_Table (after code)
%     



if nargin < 5
    error('5 arguments needed.');
end

% Get information related to the label

expected_symbol = Dynamic_Table(label,2);               % s = s_k
probability = Static_Table(Dynamic_Table(label,1),4);   % p = p(sigma_k)

reg_enc.A = reg_enc.A - probability;

if reg_enc.A < probability,
    % Conditional exchange of MPS and LPS
    expected_symbol = 1 - expected_symbol;
end

if symbol == expected_symbol,
    % Assign MPS the upper sub-interval
    reg_enc.C = reg_enc.C + uint32(probability);
else
    % Assign LPS the lower sub-interval
    reg_enc.A = probability;
end

if reg_enc.A < 2^15,
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
while reg_enc.A < 2^15,
    reg_enc.A = 2*reg_enc.A;
    reg_enc.C = 2*reg_enc.C;
    reg_enc.t = reg_enc.t-1;
    if reg_enc.t == 0,
        reg_enc = mq_transfer_byte(reg_enc);
    end
end

