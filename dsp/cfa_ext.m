function so = cfa_ext(s, freqRange, harmonicGains)
%   call: so = cfa_ext(s, freqRange, harmonicGains)
%   this function implements a exciter effect
%
%   inputs: s- input audio struct with fields: .data (NxM) samples and .fs   sampling rate
%           freqRange- A 1x2 array [fLow, fHigh] specifying which part of the spectrum to excite
%           harmonicGains- A vector specifying how much to scale each harmonic.

%   outputs: so - output audio struct (same fields as s) with the generated harmonics
%
%   example:
%       s = cfa_load('test.wav');

%       so = cfa_ext(s, [3000, 7000], [0.5, 0.25]);

%       cfa_play(so);

    if length(freqRange) ~= 2

        error('freqRange must be [fLow, fHigh].');
    end

    fLow  = min(freqRange);
    fHigh = max(freqRange);

    if fLow < 0 || fHigh > s.fs/2
        
        warning('Specified frequency range is out of the typical (0..fs/2) range.');
    end

    numHarms = length(harmonicGains);


    so = s;
    fs = s.fs;

    audioData = s.data;
    [N, M] = size(audioData); 

    outData = zeros(N, M);

    for ch = 1:M

        Y = fft(audioData(:, ch));

        % iterate over bins, find which belong to fLow and fHigh
        for k = 1:N
           
            freqIndex = k - 1;

            if freqIndex <= N/2

                freq = freqIndex * (fs / N);
            else

                freq = (freqIndex - N) * (fs / N);
            end
            
            freqAbs = abs(freq);


            if freqAbs >= fLow && freqAbs <= fHigh

                for h = 1:numHarms

                    harmFreq = freq * (h+1);  
                    harmFreqAbs = abs(harmFreq);

                    if harmFreqAbs >= fs/2

                        continue;
                    end

                    % determine the bin index for harmFreq

                    if harmFreq >= 0

                        harmIndex = round(harmFreqAbs / (fs/N)) + 1;
                    else

                        harmIndex = N + round(harmFreq / (fs/N)) + 1;
                    end

                    if harmIndex < 1 || harmIndex > N

                        continue;
                    end

                    Y(harmIndex) = Y(harmIndex) + harmonicGains(h) * Y(k);
                end
            end
        end

        % inverse FFT to get time domain
        outData(:, ch) = ifft(Y, 'symmetric');
    end

    so.data = outData;
   
end
