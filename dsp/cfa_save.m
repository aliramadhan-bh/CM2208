function cfa_save(filename, s)
%    cfa_save(filename, s)

% input: filename- path to the output audio file (e.g. .wav, .flac, .ogg)
%        s- struct containing the audio data (s.data) and sampling rate (s.fs)

%  example: cfa_save('output.wav', s);

    if isfield(s, 'nbits')
        
        audiowrite(filename, s.data, s.fs, 'BitsPerSample', s.nbits);
    else
        audiowrite(filename, s.data, s.fs);
    end
end