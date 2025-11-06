function s = cfi_load(filename)
%   s = cfi_load(filename)
%
%   fields: s.img=the raw image data 
%           s.height= number of rows
%           s.width= number of columns
%           s.channels= number of channels (1=grayscale, 3=RGB, etc.)
%           s.filename= original filename
%  
%   example: s = cfi_load('test.jpg');

    imgData = imread(filename); 
    
    [rows, cols, chans] = size(imgData);

    s.img       = imgData;
    s.height    = rows;
    s.width     = cols;
    s.channels  = chans;
    s.filename  = filename;
end
