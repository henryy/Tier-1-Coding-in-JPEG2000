function reg_enc = mq_encoder_init


%    Init the state-registers for the coder (initializes)
%


reg_enc = struct;

% register values

reg_enc.C =     uint32(0);  % Lower-bound interval
reg_enc.A = uint16(32768);  % Upper-bound interval 0x8000
reg_enc.t =     uint8(12);  % Cound-down variablexs
reg_enc.T =      uint8(0);  % Temporary byte reg_encister
reg_enc.L =     int32(-1);  % Byte-transfered counter

reg_enc.byte_stream = uint8([]);