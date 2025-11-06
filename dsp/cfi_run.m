
    % load an image
    s = cfi_load('test.jpg'); 

    % figure 1
    figure, imshow(s.img);
    title('Original Image');

    % figure 2
    figure;
    cfi_display(s, 's');
    title('Spatial Domain');

    % figure 3
    m = cfi_segment(s);
    figure, imshow(m);
    title('Binary Segmentation (Foreground=1, Background=0)');

    % figure 4
    figure;
    cfi_display(s, 'f');
    title('Frequency Domain');

    %figure 5
    segImg = cfi_ext(s, 4); 
    figure, imshow(segImg);
    title('Multi-Color Segmentation');

    % save the multi-color segmentation image
    outStruct = s;
    outStruct.img = segImg;
    cfi_save('multiseg.png', outStruct);

    disp('cfi_run completed successfully!');

