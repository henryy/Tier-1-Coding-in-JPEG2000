function [Sign_array ] = DecodeSignCoding( m, n ,D,CX ,Sign_array, DeS1 )
%DECODESIGNCODING Summary of this function goes here
%   Detailed explanation goes here
%     S=sprintf('DecodeSignCoding is called for (D,CX) is (%d,%d)', D, CX);
%     disp(S)
    
    [width,length] = size(DeS1);
    [widthSA,lengthSA] = size(Sign_array);
    S1_extendSC = int8(zeros(width+2, length+2));
    for i = 1:width
        for j = 1: length
            S1_extendSC(i+1,j+1)= DeS1(i,j);
        end
    end
    
    S1_extendSA = int8(zeros(widthSA+2, lengthSA+2));
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
            if CX ~= 13              
                error('Some shit happens in decode SignCoding with wrong CX values');
            end
            Sign_array(m,n) = bitxor(D, Sign_prime);
        case '10'
            Sign_prime = 0;
            if CX ~= 12
                error('Some shit happens in decode SignCoding with wrong CX values');
            end
            Sign_array(m,n) = bitxor(D, Sign_prime);
        case '1-1'
            Sign_prime = 0;
            if CX ~= 11
                error('Some shit happens in decode SignCoding with wrong CX values');
            end
            Sign_array(m,n) = bitxor(D, Sign_prime);
        case '01'
            Sign_prime = 0;
            if CX ~= 10
                error('Some shit happens in decode SignCoding with wrong CX values');
            end
            Sign_array(m,n) = bitxor(D, Sign_prime);
        case '00'
            Sign_prime = 0;
            if CX ~= 9
                error('Some shit happens in decode SignCoding with wrong CX values');
            end
            Sign_array(m,n) = bitxor(D, Sign_prime);
        case '0-1'
            Sign_prime = 1;
            if CX ~= 10
                error('Some shit happens in decode SignCoding with wrong CX values');
            end
            Sign_array(m,n) = bitxor(D, Sign_prime);

        case '-11'
            Sign_prime = 1;
            if CX ~= 11
                error('Some shit happens in decode SignCoding with wrong CX values');
            end
            Sign_array(m,n) = bitxor(D, Sign_prime);
        case '-10'
            Sign_prime = 1;
            if CX ~= 12
                error('Some shit happens in decode SignCoding with wrong CX values');
            end
            Sign_array(m,n) = bitxor(D, Sign_prime);
        case '-1-1'
            Sign_prime = 1;
            if CX ~= 13
                error('Some shit happens in decode SignCoding with wrong CX values');
            end
            Sign_array(m,n) = bitxor(D, Sign_prime);
        otherwise
            error('Some shit happens in decode SignCoding with wrong CX values');  
    end

    
end

