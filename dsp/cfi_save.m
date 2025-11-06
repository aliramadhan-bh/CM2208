function cfi_save(filename, s)

%  example: cfi_save('output.png', s);

    imwrite(s.img, filename); 
end
