function [ D,CX, N ] = SignCoding(S1, Sign_array, m, n)
%   S1 is the 1st status array. Sign_array is the Sign array and m n is the
%   location of current value.

%   D is the return bit. CX is the corresponding context information. N is
%   how many (D,CX) pairs returned. D and CX are arrays.

%if nargin ~= 4, error('Not correct input arguments for SignCoding!'); end


[width,length] = size(S1);
[widthSA,lengthSA] = size(Sign_array);
N = 1; % Always encode 1 bit and output 1 value pair (D, CX).

% H = min(1,max(-1, S1(m,n-1)*(1-2*Sign_array(m,n-1)) + S1(m,n+1)*(1-2*Sign_array(m,n+1))))
% V = min(1,max(-1, S1(m-1,n)*(1-2*Sign_array(m-1,n)) + S1(m+1,n)*(1-2*Sign_array(m+1,n))))

S1_extendSC = int8(zeros(width+2, length+2));
%[w_ext,l_ext] = size(S1_extend);
for i = 1:width
    for j = 1: length
        S1_extendSC(i+1,j+1)= S1(i,j);
    end
end

S1_extendSA = int8(zeros(widthSA+2, lengthSA+2));
%[w_ext,l_ext] = size(S1_extend);
for i = 1:width
    for j = 1: length
        S1_extendSA(i+1,j+1)= Sign_array(i,j);
    end
end

H = min(1,max(-1, S1_extendSC(m+1,n)*(1-2*S1_extendSA(m+1,n)) + S1_extendSC(m+1,n+2)*(1-2*S1_extendSA(m+1,n+2))));
V = min(1,max(-1, S1_extendSC(m,n+1)*(1-2*S1_extendSA(m,n+1)) + S1_extendSC(m+2,n+1)*(1-2*S1_extendSA(m+2,n+1))));

switch_case2 = strcat(num2str(H), num2str(V));
switch switch_case2
    
    case '11'
        Sign_prime = 0;
        CX = 13;
        D = bitxor(Sign_prime, Sign_array(m,n));
    case '10'
        Sign_prime = 0;
        CX = 12;
        D = bitxor(Sign_prime ,Sign_array(m,n));
    case '1-1'
        Sign_prime = 0;
        CX = 11;
        D = bitxor(Sign_prime,Sign_array(m,n));
    case '01'
        Sign_prime = 0;
        CX = 10;
        D = bitxor(Sign_prime, Sign_array(m,n));
    case '00'
        Sign_prime = 0;
        CX = 9;
        D = bitxor(Sign_prime, Sign_array(m,n));
    case '0-1'
        Sign_prime = 1;
        CX = 10;
        D = bitxor(Sign_prime,Sign_array(m,n));
    case '-11'
        Sign_prime = 1;
        CX = 11;
        D = bitxor(Sign_prime, Sign_array(m,n));
    case '-10'
        Sign_prime = 1;
        CX = 12;
        D = bitxor(Sign_prime, Sign_array(m,n));
    case '-1-1'
        Sign_prime = 1;
        CX = 13;
        D = bitxor(Sign_prime, Sign_array(m,n));
    otherwise
        error('Some shit happens in function SignCoding with wrong H,V values');  
end


%     S=sprintf('SignCoding is called at (%d,%d) and (D,CX) output is (%d,%d)', m,n,D,CX);
%     disp(S)
end

