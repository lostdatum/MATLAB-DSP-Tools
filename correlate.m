function [corr, lags] = correlate(signal_1, signal_2, method)
% CORRELATE - Computes cross-correlation product of two 1D signals.
%
% Syntax:          corr = correlate(signal_1, signal_2, method)
%          [corr, lags] = correlate(signal_1, signal_2, method)
%
% Inputs:
%    signal_1 - First signal (in time-domain). Must be a column vector.
%    signal_2 - Second signal (in time-domain). Must be a column vector.
%    method - String indicating computation method. 
%             Supported values are "time" and "frequency".
%
% Outputs:
%    corr - Cross-correlation product (signal_2 <x> signal_1), where <x> repre-
%           sents the cross-correlation operator. Column vector.
%    lags - Relative lag of signal_2 with respect to signal_1 for each sample
%           of ouput 'corr'. Column vector.
%
% Example: 
%    sgn_1 = [1 0 0 1 1 0 0 1 0 1].' ;
%    sgn_2 = [0 1 1 0 0 1].' ;
%    corr = correlate(sgn_1, sgn_2, "time") ;
%
% Other m-files required: none
% Subfunctions: none
% MAT-files required: none
%
%
% See also: convolute
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
	P = 2*L+1 ; % Number of processed samples
	% EXPLANATION: Only N+M-1 samples are relevant (may have non-zero value),
	% but there is no harm in processing more to achieve symmetry.
	% Using L is useful to make sure we can circshift safely both ways.
	
	
	% Compute lags
	lags = (-L:L).' ; % Length is P = 2*L+1
	
	% Compute correlation product
	if strcmp(method, "time")  % Straightforward method
		
		corr = zeros(P, 1) ; % Allocate memory
		
		sgn_1_pad = [signal_1 ; zeros(M+L, 1)] ; % Padding up to N+M+L
		sgn_2_pad = [signal_2 ; zeros(N+L, 1)] ; % Idem
		% EXPLANATION: We need to be able to circshift to max lag L both ways.
		% Adding M or N is a simple way of having both signals the same length.
		
		for d = lags % For each lag
			
			sgn_2_shift = circshift(sgn_2_pad, d) ; % Shift (L or R)
			corr(d + L+1) = sgn_2_shift' * sgn_1_pad ; % Hermitian product
			
		end
		
	elseif strcmp(method, "frequency") % Faster but generates numerical noise
		
		Q = 2^nextpow2(P) ; % For faster FFT computation
		corr = ifft(conj(fft(signal_2, Q)) .* fft(signal_1, Q)) ; % Corr. Th.
		corr = fftshift(corr) ; % Needed, for some reason...
		% Select only relevant samples:
		corr = corr((Q/2+1) - floor(P/2) : (Q/2+1) + ceil(P/2) - 1) ;
		% EXPLANATION: (Q/2+1) is the index of the zero-lag sample and we are
		% saving P samples around (Q/2+1).
		
	else
		
		error("Argument #3 invalid: unsupported computation method.")
		
	end
	
	% Imaginary component processing
	if isreal(signal_1) && isreal(signal_2)
		corr = real(corr) ; % Product should be real
	end

end