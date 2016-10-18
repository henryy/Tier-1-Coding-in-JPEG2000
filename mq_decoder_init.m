function reg_dec = mq_decoder_init(filename)


% Syntax
%     reg_dec = mq_decoder_init(filename)
%     
% Inputs
%     filename ~ encode result byte-stream's filename
%     buffer ~ for debug purpose.
%     
% Outputs
%     reg_dec ~ state-registers for the coder (initialized)
%     


% reg_dec values

reg_dec.A = uint16(0);
reg_dec.t =  uint8(0);
reg_dec.C = uint32(0);      % Lower-bound interval
reg_dec.T =  uint8(0);      % Temporary byte reg_decister
reg_dec.L =  int32(0);      % Byte
reg_dec.byte_stream = uint8([]);

% Byte-stream init

Temp = importdata(filename);

%if ~isfield(Temp,'byte_stream');
%    error('Bad filename.');

reg_dec.byte_stream = Temp;
clear Temp

%reg_dec.byte_stream = buffer;
% Decoder init procedure

reg_dec = mq_fill_lsbs(reg_dec);
reg_dec.C = bitshift(reg_dec.C,reg_dec.t);
reg_dec = mq_fill_lsbs(reg_dec);
reg_dec.C = bitshift(reg_dec.C,7);
reg_dec.t = reg_dec.t-7;
reg_dec.A = uint16(hex2dec('8000'));