function segImg = cfi_ext(s, nSegments)
% creates a multi-color segmented image from s.img by splitting grayscale intensities into nSegments bins
%
% help note: segImg = cfi_ext(s, nSegments);
%
%   inputs: s= struct with s.img (RGB or grayscale)
%           nSegments= number of color segments (default=4)
%
%   outputs: segImg - an RGB image (uint8), with each intensity bin assigned a random color
%
%   example: s = cfi_load('test.jpg');
%            out = cfi_ext(s, 5);
%            figure, imshow(out);
%
% This function first converts s.img to grayscale [0..1] if RGB then splits intensities into nSegments bins then 
% assigns a random color to each bin and finally creates a segmented RGB image

    if nargin < 2

        nSegments = 4;
    end

    img = double(s.img);

    [rows, cols, chans] = size(img);

    % convert to grayscale if RGB
    if chans == 3
       
        maxValLocal = max(img(:));

        if maxValLocal > 1
            img = img / maxValLocal; 
        end

        R = img(:,:,1);
        G = img(:,:,2);
        B = img(:,:,3);

        grayImg = 0.2989*R + 0.5870*G + 0.1140*B;
    else

        maxValLocal = max(img(:));

        if maxValLocal > 1

            img = img / maxValLocal;
        end

        grayImg = img;
    end

    maxVal = max(grayImg(:));
    if maxVal > 0
        grayImg = grayImg / maxVal;
    end

    binEdges = linspace(0, 1, nSegments+1);

    segRGB = zeros(rows, cols, 3);

    rng(0);
    palette = rand(nSegments, 3);  

    % assign each pixel to a segment
    for i = 1:nSegments

        inBin = (grayImg >= binEdges(i)) & (grayImg < binEdges(i+1));

        for c = 1:3
            
            segRGB(:,:,c) = segRGB(:,:,c) + inBin * palette(i,c);
        end
    end

    segImg = uint8(segRGB * 255);
end
