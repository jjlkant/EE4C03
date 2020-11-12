function[imf] = dct_ma(ch_1,ch_2,ch_3,bs)
% DCT based image fusion by max coeficients (eq.6)
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
        mask_ch1 = abs(CB1) >= max(abs(CB2),abs(CB3));
        mask_ch2 = abs(CB2) >= max(abs(CB1),abs(CB3));
        mask_ch3 = abs(CB3) >= max(abs(CB1),abs(CB2));
        CBF = mask_ch1.*CB1 + mask_ch2.*CB2 + mask_ch3.*CB3;
        CBF(1,1)=(1/3)*(CB1(1,1)+CB2(1,1)+CB3(1,1));
        cbf = idct2(CBF);
        imf(i:i+bs-1,j:j+bs-1)=cbf;
    end
end