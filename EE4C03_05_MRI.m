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

for slice = 1:8
    figure
    imagesc(100*log(abs(  squeeze(slices(slice, 1, :, :))   )));
    imagesc(100*log(abs(  squeeze(slices(slice, 2, :, :))   )));
    imagesc(100*log(abs(  squeeze(slices(slice, 3, :, :))   )));
end

close all
%% utilize autocorrelation method %%

p = 100; %filter order
slice11 = squeeze(slices(1,1,:,:));
Good_Columns = 53; % number of good column before outlier
N = Good_Columns - 1;
r = zeros(512, p+2); % row corresponds to row number of data, column corresponds to lag

% compute autocorrelation %
for k = 0:p+1
    for n = k:N
        r(1,k+1) = slice11(1,n+1) .* conj( slice11(1,n-k+1) ) + r(1,k+1);
    end
end

plot(abs(r(1,:)))
Rx = toeplitz(r(1, 1:end-1)');

%a = linsolve(Rx,-r(1, 2:end)'); % remember first element a is 1 which is not in this vector

% implement Levinson algorithm %
r_p_vec = flip( r(1,2:p+2) );
a_p = zeros(p+1,p+1); % column i contains solution for filter order i-1
a_p(1,1) = 1;
error = zeros(1,p+1); % minimum error for each filter order
error(1) = r(1,1);
for i = 0:p-1
    
    gamma = r_p_vec(end-i:end) * a_p(1:i+1, i+1);
    
    rho = gamma/conj(error(i+1)); 
    
    if abs(rho) > 1
        disp('Watch out Magnitude Reflection greater than one')
        pause(inf)
    end
    
    a_p(1:i+2, i+2) = [a_p(1:i+1, i+1);0] - rho*conj(flip([a_p(1:i+1, i+1);0]));
    error(i+2) = error(i+1)*( 1- (abs(rho)^2) );
    
end

b = sqrt(error(p+1));
plot(error)

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
imagesc(100*log(abs(squeeze(slices(1,1,:,:)))));


xlabel('Horizontal frequency bins')
ylabel('Vertical frequency bins');

