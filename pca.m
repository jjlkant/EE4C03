function imf = pca(ch_1,ch_2,ch_3)
%     Modified from: https://nl.mathworks.com/matlabcentral/fileexchange/31338-pca-based-image-fusion
    im1 = double(abs(ch_1));
    im2 = double(abs(ch_2));
    im3 = double(abs(ch_3));
    C = cov([im1(:) im2(:) im3(:)]);
    [V, D] = eig(C);
    [~,col] = find(D == max(D(:)));
    pca = V(:,col)./sum(V(:,col));
    imf = pca(1)*squeeze(abs(ch_1)) + pca(2)*squeeze(abs(ch_2)) + pca(3)*squeeze(abs(ch_3));