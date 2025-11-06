
% test to process audio with both equalization and exciter

% load audio file
s = cfa_load('sample.ogg');

% play original audio
disp('Playing the original audio at 100% volume...');
cfa_play(s);
pause(length(s.data)/s.fs + 0.5);  

% display the original in time and frequency domains
figure;

cfa_display(s, 't'); 
title('Original Audio - Time Domain');
figure;

cfa_display(s, 'f'); 
title('Original Audio - Frequency Domain');

% equalize the audio
eqSettings = [ 0 0 0 0 0 3 0 0 0 6 0 ];  
se = cfa_equalise(s, eqSettings);  

% play equalised audio
disp('Playing the equalised audio...');
cfa_play(se);
pause(length(se.data)/se.fs + 0.5);  % Wait for playback to finish

% exciter function
freqRange = [3000, 7000];
harmonicGains = [0.5, 0.25];

so = cfa_ext(se, freqRange, harmonicGains);

% play the extended (processed) audio
disp('Playing the extended (processed) audio...');
cfa_play(so);
pause(length(so.data)/so.fs + 0.5); 

% display the extended audio in frequency domain
figure;
cfa_display(so, 'f'); 
title('Extended Audio - Frequency Domain');

% save the final processed audio to a file
cfa_save('processed_output.wav', so);

disp('cfa_run completed successfully!');
