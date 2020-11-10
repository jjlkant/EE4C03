clc; clear all; close all;

% n = 1;
% 
% load(strcat('Slice',int2str(n),'/BadData/slice',int2str(n),'_channel1.mat'));
% load(strcat('Slice',int2str(n),'/BadData/slice',int2str(n),'_channel2.mat'));
% load(strcat('Slice',int2str(n),'/BadData/slice',int2str(n),'_channel3.mat'));

slices = load_slices();

% 1. X - dimension of the K-Space data    - 128
% 2. Y - dimension of the K-Space data    - 512

for slice = 1:8
    figure;
    % IFFT of k-space data
    %channel 1 (replace "slice1_channel1_goodData" with
    %slice1_channel1_badData) for bad images
    Data_img(:,:,1) = ifftshift(ifft2(squeeze(slices(slice, 1, :, :))),1);
    %channel 2
    Data_img(:,:,2) = ifftshift(ifft2(squeeze(slices(slice, 2, :, :))),1);
    %channel 3
    Data_img(:,:,3) = ifftshift(ifft2(squeeze(slices(slice, 3, :, :))),1);

    eye_raw  = sqrt( abs(squeeze(Data_img(:,:,1))).^2 + abs(squeeze(Data_img(:,:,2))).^2 + abs(squeeze(Data_img(:,:,3))).^2);
    imagesc(eye_raw);
    axis image
    colormap gray
    axis off
end

%%
% clear compensation, preparation, based on fourier transformed blinked 
% k-space data (Data_raw)
clear_comp = linspace(10,0.1,size(Data_img,2)).^2; 
clear_matrix = repmat(clear_comp,[size(Data_img,1) 1]);

% combine 3 channels sum of squares and add clear compensation
eye_raw  = sqrt( abs(squeeze(Data_img(:,:,1))).^2 + ...
           abs(squeeze(Data_img(:,:,2))).^2 + ...
           abs(squeeze(Data_img(:,:,3))).^2).* clear_matrix;  
    
% crop images because we are only interested in eye. Make it square 
% 128 x 128
crop_x = [128 + 60 : 348 - 33]; % crop coordinates
eye_raw = eye_raw(crop_x, :);

% Visualize the images. 

%image
eye_visualize = reshape(squeeze(eye_raw(:,:)),[128 128]); 


% For better visualization and contrast of the eye images, histogram based
% compensation will be done 

std_within = 0.995; 
% set maximum intensity to contain 99.5 % of intensity values per image
[aa, val] = hist(eye_visualize(:),linspace(0,max(...
                                    eye_visualize(:)),1000));
    thresh = val(find(cumsum(aa)/sum(aa) > std_within,1,'first'));
    
% set threshold value to 65536
eye_visualize = uint16(eye_visualize * 65536 / thresh); 


%% plotting scripts
close all
figure(1); 
imagesc(eye_visualize(:,:,1));
axis image, 
colormap gray;
axis off

% Spatial frequency observations
figure(2); 
imagesc(100*log(abs(slice1_channel1_goodData)));


xlabel('Horizontal frequency bins')
ylabel('Vertical frequency bins');

