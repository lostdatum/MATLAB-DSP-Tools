% Testing of home-made function correlate().
% Comparison with built-in function xcorr().
%
%
% Other m-files required: correlate.m, extend.m, interpz.m, isintnb.m
% Subfunctions: none
% MAT-files required: none
%
%
% See also: convolute, correlate
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



% ================================== STARTUP ===================================


% Cleaning
close all ; clear ; clc ;


% Packages
pkg load signal ;


% Path
addpath("BasicTools") ;


% =============================== PARAMETERS ===================================

% ---------------------------- Signals parameters -------------------------------
seq_1 = [0 1 1 0 1 0 1 0]' ; % Binary sequence #1 (to be extended)
seq_2 = [0 0 1 0 0 1 1 0 1 0 0 1 0]' ; % Binary sequence #2 (to be extended)
factor = 10 ; % Sequences extension factor
% ------------------------------------------------------------------------------

% ---------------------------- Computation method ------------------------------
method = "frequency" ; % Accepted methods are "time" and "frequency"
% ------------------------------------------------------------------------------

% ================================ COMPUTATIONS ================================

% Signals
sgn_1 = extend(seq_1, factor) ; % RZ toggle signal
sgn_2 = extend(seq_2, factor) ; % Idem

% Energy (for normalization)
nrg_1 = (sgn_1'*sgn_1) ;
nrg_2 = (sgn_2'*sgn_2) ;

% Correlation
[acr, alags] = correlate(sgn_1, sgn_1, method) ; % Home-made function
[xcr, xlags] = correlate(sgn_1, sgn_2, method) ; % Idem
acr_ref = xcorr(sgn_1, sgn_1) ; % Built-in function
xcr_ref = xcorr(sgn_1, sgn_2) ; % Idem


% ==================================== PLOTS ===================================


figure % Signal #1

plot(sgn_1, "-b+")
title("Sequence")
xlabel("Samples")
ylabel("Magnitude")


figure % Auto-correlation

subplot(1, 3, 1)
plot(alags, acr/nrg_1, "-m+")
axis([alags(1), alags(end), 0, 1])
[~, maxlag] = max(acr) ;
title(["Normalized autocorrelation (home-made)\n",...
	   sprintf("Computation method: %s domain ; ", method), ...
	   sprintf("Lag of maximum: %i", xlags(maxlag))])
xlabel("Lag")
ylabel("Magnitude")

subplot(1, 3, 2)
plot(alags, acr_ref/nrg_1, "-m+")
axis([alags(1), alags(end), 0, 1])
[~, maxlag] = max(acr_ref) ;
title(["Normalized autocorrelation (built-in)\n", ...
		sprintf("Lag of maximum: %i", xlags(maxlag))])
xlabel("Lag")
ylabel("Magnitude")

subplot(1, 3, 3)
plot(alags, (acr - acr_ref)/nrg_1, "-k+")
axis([alags(1), alags(end)])
title("Difference between home-made & built-in")
xlabel("Lag")
ylabel("Magnitude")




figure % Signals #1 & #2

subplot(1, 2, 1)
plot(sgn_1, "-b+")
title("Sequence #1")
xlabel("Samples")
ylabel("Magnitude")

subplot(1, 2, 2)
plot(sgn_2, "-r+")
title("Sequence #2")
xlabel("Samples")
ylabel("Magnitude")


figure % Cross-correlation

subplot(1, 3, 1)
plot(xlags, xcr/sqrt(nrg_1*nrg_2), "-m+")
axis([xlags(1), xlags(end), 0, 1])
title(["Normalized cross-correlation (home-made)\n", ...
	   sprintf("Computation method: %s domain", method)])
xlabel("Lag")
ylabel("Magnitude")

subplot(1, 3, 2)
plot(xlags, xcr_ref/sqrt(nrg_1*nrg_2), "-m+")
axis([xlags(1), xlags(end), 0, 1])
title("Normalized cross-correlation of sequences (built-in)")
xlabel("Lag")
ylabel("Magnitude")

subplot(1, 3, 3)
plot(xlags, (xcr - xcr_ref)/sqrt(nrg_1*nrg_2), "-k+")
axis([xlags(1), xlags(end)])
title("Difference between home-made & built-in")
xlabel("Lag")
ylabel("Magnitude")


