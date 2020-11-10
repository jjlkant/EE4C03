function slices = load_slices()
    for n = 1:8
        load(strcat('Slice',int2str(n),'/BadData/slice',int2str(n),'_channel1.mat'));
        load(strcat('Slice',int2str(n),'/BadData/slice',int2str(n),'_channel2.mat'));
        load(strcat('Slice',int2str(n),'/BadData/slice',int2str(n),'_channel3.mat'));
    end

    slices(1, 1, :, :) = slice1_channel1_badData;
    slices(1, 2, :, :) = slice1_channel2_badData;
    slices(1, 3, :, :) = slice1_channel3_badData;
    slices(2, 1, :, :) = slice2_channel1_badData;
    slices(2, 2, :, :) = slice2_channel2_badData;
    slices(2, 3, :, :) = slice2_channel3_badData;
    slices(3, 1, :, :) = slice3_channel1_badData;
    slices(3, 2, :, :) = slice3_channel2_badData;
    slices(3, 3, :, :) = slice3_channel3_badData;
    slices(4, 1, :, :) = slice4_channel1_badData;
    slices(4, 2, :, :) = slice4_channel2_badData;
    slices(4, 3, :, :) = slice4_channel3_badData;
    slices(5, 1, :, :) = slice5_channel1_badData;
    slices(5, 2, :, :) = slice5_channel2_badData;
    slices(5, 3, :, :) = slice5_channel3_badData;
    slices(6, 1, :, :) = slice6_channel1_badData;
    slices(6, 2, :, :) = slice6_channel2_badData;
    slices(6, 3, :, :) = slice6_channel3_badData;
    slices(7, 1, :, :) = slice7_channel1_badData;
    slices(7, 2, :, :) = slice7_channel2_badData;
    slices(7, 3, :, :) = slice7_channel3_badData;
    slices(8, 1, :, :) = slice8_channel1_badData;
    slices(8, 2, :, :) = slice8_channel2_badData;
    slices(8, 3, :, :) = slice8_channel3_badData;
end