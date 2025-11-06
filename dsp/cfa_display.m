function cfa_display(s, domain)
% plots the signal s in either time ('t') or frequency ('f') domain. cfa_display(s, domain)

%  input: s = struct with fields .data (audio sample) and .fs (sampling rate)
%  domain - 't' is time-domain plot which is the default and 'f' for frequency-domain plot
%  for example: cfa_display(s, 't'); and cfa_display(s, 'f');

    if nargin < 2

        domain = 't'; 

    end

    switch lower(domain)

        case 't'
            % time-domain plot

            numSamples = size(s.data, 1);
            t = (0:numSamples-1) / s.fs;  

            plot(t, s.data);

            xlabel('Time (s)');
            ylabel('Amplitude');

            title('Time Domain Signal');

        case 'f'
            % frequency-domain plot 
         
            N = size(s.data, 1);         
            Y = fft(s.data);             
            f = (0:N-1) * (s.fs / N);    

            plot(f, abs(Y));

            xlabel('Frequency (Hz)');
            ylabel('|Amplitude|');

            title('Frequency Domain Signal');

        otherwise
            error('Unknown domain option. Use ''t'' or ''f''.');
    end
end
