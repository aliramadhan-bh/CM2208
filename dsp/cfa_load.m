function s = cfa_load(filename)

%  input: filename - path to the audio file (sample.ogg
%
%  Output: s - a struct containing the audio and relevant metadata
%          s.data = audio samples
%          s.fs = sampling rate
%          s.filename = original filename (optional)
%          s.nbits = bits per sample (optional)
%
%  example: s = cfa_load('sample.ogg');

  
    [audioData, fs] = audioread(filename);

    info = audioinfo(filename);

    s.data = audioData;
    s.fs   = fs;
    s.filename = filename;

    if isfield(info, 'BitsPerSample')

        s.nbits = info.BitsPerSample;
    else

        s.nbits = 16; 
    end
end


