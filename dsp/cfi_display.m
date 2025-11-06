function cfi_display(s, domain)
% display image in spatial or frequency domain
%
% cfi_display(s, domain)
%
% inputs: s- struct with s.img
%           domain - 's' (spatial) or 'f' (frequency). Default 's' if omitted.
%
% example: cfi_display(s, 's');   normal view
%          cfi_display(s, 'f');   log-magnitude FFT

    if nargin < 2
        domain = 's';
    end

    switch lower(domain)
        case 's'
            % spatial domain
            imshow(s.img);
            title('Spatial Domain Image');

        case 'f'
            % frequency domain
            img = s.img;

            if size(img,3) == 3

                imgGray = rgb2grayManual(double(img));
            else

                imgGray = double(img);
            end

            maxVal = max(imgGray(:));

            if maxVal > 0

                imgGray = imgGray / maxVal;
            end

            F = fft2(imgGray);
            Fshift = fftshift(F);

 
            magSpec = log(1 + abs(Fshift));
            imshow(magSpec, []);

            title('Frequency Domain (Log Magnitude)');

        otherwise
            error('Unknown domain option. Use ''s'' or ''f''.');
    end
end


% helper function
function gray = rgb2grayManual(rgbImg)
    if isa(rgbImg, 'uint8')

        rgbImg = double(rgbImg)/255;

    elseif isa(rgbImg, 'uint16')

        rgbImg = double(rgbImg)/65535;
    end

    R = rgbImg(:,:,1);
    G = rgbImg(:,:,2);
    B = rgbImg(:,:,3);

    gray = 0.2989*R + 0.5870*G + 0.1140*B;
end
