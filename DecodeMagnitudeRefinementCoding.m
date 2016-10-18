function [ V, P ] = DecodeMagnitudeRefinementCoding( V, P, m, n ,D,CX )
%DECODEMAGNITUDEREFINEMENTCODING Summary of this function goes here
%   Detailed explanation goes here
%     S=sprintf('DecodeMagnitudeRefinementCoding is called for (D,CX) is (%d,%d)', D, CX);
%     disp(S)
    if CX >16 || CX <14
        error('Wrong use of Magnitude Refinement Coding, wrong CX!');
    end
        V(m,n,P) = D;

end

