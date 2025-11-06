function cfa_play(s, v)

% input: s - struct with .data and .fs
%        v - volume percentage 
%
%  example: cfa_play(s);  will play at full volume
%           cfa_play(s, 50);   will play at 50% volume

    if nargin < 2
        v = 100; 
    end

    scaledData = s.data * (v / 100);

    sound(scaledData, s.fs);
end