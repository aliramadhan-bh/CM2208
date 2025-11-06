function m = cfi_segment(s)
% creates a binary (black/white) mask from s.img
%
% how this function works is first converts the input image to grayscale
% double [0..1] then determines a threshold with a manual Otsu method binarizes: mask = (gray > threshold)
% example: s = cfi_load('test.jpg');
%          m = cfi_segment(s);
%          figure, imshow(m);

    img = s.img;

    if size(img, 3) == 3
        grayImg = rgb2grayManual(img);
    else
        grayImg = double(img);
    end

    maxVal = max(grayImg(:));
    if maxVal > 0
        grayImg = grayImg / maxVal;
    end

    level = manualOtsu(grayImg);

    m = (grayImg > level);
end

% helper function
function thresh = manualOtsu(imgGray)
    nbins = 256;
    [counts, edges] = histcounts(imgGray, nbins, 'BinLimits', [0,1]);
    p = counts / sum(counts);
    binCenters = (edges(1:end-1) + edges(2:end)) / 2;

    w0 = cumsum(p);
    w1 = 1 - w0;
    mu0 = cumsum(p .* binCenters) ./ w0;
    muT = sum(p .* binCenters);
    mu1 = (muT - w0 .* mu0) ./ w1;
    sigmaB2 = w0 .* w1 .* (mu0 - mu1).^2;

    [~, idx] = max(sigmaB2);
    thresh = binCenters(idx);
end

% helper function
function gray = rgb2grayManual(rgbImg)

    if isa(rgbImg, 'uint8')
        rgbImg = double(rgbImg) / 255;

    elseif isa(rgbImg, 'uint16')

        rgbImg = double(rgbImg) / 65535;

    else

        rgbImg = double(rgbImg); 
    end

    R = rgbImg(:, :, 1);
    G = rgbImg(:, :, 2);
    B = rgbImg(:, :, 3);

    gray = 0.2989 * R + 0.5870 * G + 0.1140 * B;
end
