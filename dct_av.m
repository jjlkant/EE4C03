function imf = dct_av(ch_1,ch_2,ch_3,bs)
% DCT based image fusion by averaging (eq. 5)
im1 = double(abs(ch_1));
im2 = double(abs(ch_2));
im3 = double(abs(ch_3));
[m,n] = size(im1);
for i=1:bs:m
    for j=1:bs:n
        cb1 = im1(i:i+bs-1,j:j+bs-1);
        cb2 = im2(i:i+bs-1,j:j+bs-1);
        cb3 = im3(i:i+bs-1,j:j+bs-1);
        CB1 = dct2(cb1);
        CB2 = dct2(cb2);
        CB3 = dct2(cb3);
        CBF = (1/3)*(CB1+CB2+CB3);
        % DC components
        CBF(1,1)=(1/3)*(CB1(1,1)+CB2(1,1)+CB3(1,1));
        cbf = idct2(CBF);
        imf(i:i+bs-1,j:j+bs-1)=cbf;
    end
end