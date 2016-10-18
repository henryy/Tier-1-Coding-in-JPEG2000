# Tier-1-Coding-in-JPEG2000
The demo of encoder and decoder in Matlab for EBCOT (Bit plane coder programmed by myself) and MQ coder. The MQ coder Matlab code is from Dr. Xavier Alameda-Pineda (http://xavirema.eu/mq-coder-in-matlab/)

The demo_for_all.m is to show how to use it.

The input matrix must have a width that can be divided by 4 (in this demo there are two matrices as examples, 4*4 and 8*8).

The process is : input >> bit plane encode >> mq encode >> mq decode >> bit palne decode

Input and Output is as follows:

%Call bit plane coder

%Input:Input matrix (must be a matrix that width can be divided by 4).

%Output: Di.txt and CXi.txt

[width,length,P, howManyBlocks] = EncodeBitPlaneCoder(Input,Band_Mark);


%Call MQ coder

%Input: Di.txt and CXi.txt

%Output: mq_encode_i.txt

encode_pointer  = mq_encode_main( howManyBlocks );


%Call MQ decoder

%Input: mq_encode_i.txt and CXi.txt

%Output:D_afterMQ_i.txt

mq_decoder_main( howManyBlocks,encode_pointer);


%Call bit plane decoder

%Input:D_afterMQ_i.txt

%Output: Output matrix.

Output = DecodeBitPlaneCoder(width,length, P);
