function cnvl = convolve(signal_1, signal_2, method)
% CONVOLVE - Computes convolution product of two 1D signals.
%
% Syntax:  cnvl = convolve(signal_1, signal_2, method)
%
% Inputs:
%    signal_1 - First signal (in time-domain). Must be a column vector.
%    signal_2 - Second signal (in time-domain). Must be a column vector.
%    method - String indicating computation method.
%             Supported values are "time" and "frequency".
%
% Outputs:
%    cnvl - Convolution product (signal_2 <*> signal_1), where <*> represents 
%           the convolution operator. Column vector.
%
% Example: 
%    seq = [1 0 0 1 1 0 0 1 0 1].' ;
%    rect = [1 1 1].' ;
%    cnvl = convolve(seq, rect, "time") ;
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
%
% See also: correlate
%
%
% Author: lostdatum
% Email: lostdatum@outlook.com
% License: BSD 3-Clause License (see below)
% Software: OCTAVE 5.2.0
% Revision: 1.0
% Date: 2020/10/07
%
% 
% COPYRIGHT 2020 lostdatum
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without modifica-
% tion, are permitted provided that the following conditions are met:
% 1. Redistributions of source code must retain the above copyright notice,
% this list of conditions and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright notice,
% this list of conditions and the following disclaimer in the documentation
% and/or other materials provided with the distribution.
% 3. Neither the name of the copyright holder nor the names of its contributors
% may be used to endorse or promote products derived from this software without
% specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSE-
% QUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
% GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
% HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
% LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
% OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH
% DAMAGE.


	% Check arguments
	if length(size(signal_1)) != 2 | size(signal_1, 2) != 1
		error("Argument #1 must be a column vector.") ;
	elseif length(size(signal_2)) != 2 | size(signal_2, 2) != 1
		error("Argument #2 must be a column vector.") ;
	end
	
	% Lengths
	N = length(signal_1) ;
	M = length(signal_2) ;
	L = max(N,M)-1 ; % Absolute value of maximum lag
	P = N+M-1 ; % Number of processed samples
	% EXPLANATION: Only N+M-1 samples are relevant (may have non-zero value).
	% Knowing L is useful to make sure we can circshift safely both ways.
	
	% Compute lags
	lags = (-M+1:N-1).' ; % Length is P = N+M-1
	
	% Compute convolution product
	if strcmp(method, "time") % Straightforward method
		
		signal_2 = flip(signal_2) ; % Flip signal (time-reversal)
		
		cnvl = zeros(P, 1) ; % Allocate memory
		
		signal_1_pad = [signal_1 ; zeros(M+L, 1)] ; % Padding up to N+M+L
		signal_2_pad = [signal_2 ; zeros(N+L, 1)] ; % Idem
		% EXPLANATION: We need to be able to circshift to max lag L both ways.
		% Adding M or N is a simple way of having both signals the same length.
		 
		for d = lags % For each lag
			
			signal_2_shift = circshift(signal_2_pad, d) ; % Shift (L or R)
			cnvl(d + M) = signal_2_shift.' * signal_1_pad ; % Inner product
			
		end
		
	elseif strcmp(method, "frequency") % Faster but generates numerical noise
		
		Q = 2^nextpow2(P) ; % For faster FFT computation
		cnvl = ifft(fft(signal_2, Q) .* fft(signal_1, Q)) ; % Conv. Theorem
		cnvl = cnvl(lags + M) ; % Select only relevant samples
		
	else
		
		error("Argument #3 invalid: unsupported computation method.")
		
	end
	
	% Imaginary component processing
	if isreal(signal_1) && isreal(signal_2)
		cnvl = real(cnvl) ; % Product should be real
	end

end