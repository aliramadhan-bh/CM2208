function ss = cfa_equalise(s, b)
% applies an 11-band equalizer in the frequency domain
% inputs: s - The input audio struct with fields: data -> NxM audio samples N = sample and M = channels .fs   -> sampling rate
%         b - A 1x11 vector of band gains in dB gains correspond to center frequencies
% output: ss - Output audio struct with the same fields as s, but with the data filtered by the specified eq gains.
  
% this fucntion uses FFT-based binning and scaling.

    if length(b) ~= 11
        
        error('cfa_equalise: b must be a 1x11 vector of dB gains.');
    end

    % defined center frequencies
    centerFreqs = [16, 31.5, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000];

    fs = s.fs;

    edges = zeros(1, 12);
    edges(1)  = 0;

    for i = 1:10

        edges(i+1) = sqrt(centerFreqs(i) * centerFreqs(i+1));
    end

    edges(12) = fs/2;

    % converts the dB gains to linear scale multipliers
    multiplier = 10.^(b / 20);
    ss = s;

    audioData = s.data;
    [N, M] = size(audioData);
    outData = zeros(N, M);

    for ch = 1:M
        % take fft of channel ch
        Y = fft(audioData(:, ch));

        % scale each frequency bin based on its band

        for k = 1:N
            % freq in hz for bin k

            freqIndex = k - 1; 

            if freqIndex <= N/2
                
                freq = freqIndex * (fs / N);
            else
                
                freq = (freqIndex - N) * (fs / N);
            end

            freqAbs = abs(freq); 
            bandIdx = findBand(freqAbs, edges);

            if bandIdx > 0 && bandIdx <= 11

                Y(k) = Y(k) * multiplier(bandIdx);
            end
        end

        % inverse FFT to get time-domain
        outData(:, ch) = ifft(Y, 'symmetric');
    end

    ss.data = outData;
end

%helper function
function idx = findBand(freqHz, edges)

    if freqHz < edges(1) || freqHz >= edges(end)

        
        idx = 0; 

        return;
    end

    for i = 1:11

        if freqHz >= edges(i) && freqHz < edges(i+1)
            idx = i;

            return;
        end
    end

    idx = 11;  
end
