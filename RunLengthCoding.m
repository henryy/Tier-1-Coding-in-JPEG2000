function [ D,CX, N] = RunLengthCoding( m, n, V, P )
%RUNLENGTHCODING Summary of this function goes here
%   N means how many elements are encoded
if nargin ~= 4, error('ERROR! Incorrect input arguments for RunLengthCoding!'); end
if mod(m,4) ~= 1, error('ERROR! misuse the RunLengthCoding!'); end

        
%S=sprintf('RLCoding is called at %d, %d', m,n);
%disp(S)

if V(m,n,P) == 0 && V(m+1,n,P)==0 && V(m+2,n,P)==0 && V(m+3,n,P)==0
    N = 4;
    D = 0;
    CX = 17;
end

if V(m,n,P) == 1 
    N = 1;
    D = [1,0,0];
    CX = [17,18,18];
end

if V(m,n,P) == 0 && V(m+1,n,P)==1 
    N = 2;
    D = [1,0,1];
    CX = [17,18,18];
end

if V(m,n,P) == 0 && V(m+1,n,P)==0 && V(m+2,n,P)==1 
    N = 3;
    D = [1,1,0];
    CX = [17,18,18];
end

if V(m,n,P) == 0 && V(m+1,n,P)==0 && V(m+2,n,P)==0 && V(m+3,n,P)==1
    N = 4;
    D = [1,1,1];
    CX = [17,18,18];
end

% indexD = size(D);
% for index = 1:indexD(2)
%    
%     S=sprintf('RLCoding is called at (%d,%d) and (D,CX) output is (%d,%d)', m,n,D(index),CX(index));
%     disp(S)
% end
    
end

