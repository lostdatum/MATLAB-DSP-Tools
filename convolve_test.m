% Testing of home-made function convolve().
% Comparison with built-in function conv().
%
%
% Other m-files required: convolve.m, extend.m, interpz.m, isintnb.m
% Subfunctions: none
% MAT-files required: none
%
%
% See also: convolve, correlate
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

% -------------------------- Signal #1 parameters ------------------------------
seq = [0 1 1 0 1 0 1 0]' ; % Binary sequence to be zero-interpolated
factor = 50 ; % Sequence interpolation factor
% ------------------------------------------------------------------------------

% -------------------------- Signal #2 parameters ------------------------------
M = 32 ; % Number of samples (must be a multiple of 4 to use current pattern)
% ------------------------------------------------------------------------------

% ---------------------------- Computation method ------------------------------
method = "frequency" ; % Accepted methods are "time" and "frequency"
% ------------------------------------------------------------------------------

% ================================ COMPUTATIONS ================================

% Signals
sgn_1 = interpz(seq, factor) ; % RZ signal
sgn_2 = [4/M*(0:(M/4))' ; 4/3 - 4/(3*M)*((M/4+1):(M-1))'] ; % Asymmetric pattern

% Convolution
cvl = convolve(sgn_1, sgn_2, method) ; % Home-made function
cvl_ref = conv(sgn_1, sgn_2) ; % Built-in function

% ==================================== PLOTS ===================================


% Input signals
figure

subplot(1, 2, 1)
plot(sgn_1, "-b+")
title("Signal #1")
xlabel("Samples")
ylabel("Magnitude")

subplot(1, 2, 2)
plot(sgn_2, "-r+")
title("Signal #2")
xlabel("Samples")
ylabel("Magnitude")


% Convolution product
figure

subplot(1, 3, 1)
plot(cvl, "-m+")
axis([1, length(cvl), 0, 1])
title(["Convolution product (home-made)\n",...
	   sprintf("Computation method: %s domain", method)])
xlabel("Samples")
ylabel("Magnitude")

subplot(1, 3, 2)
plot(cvl_ref, "-m+")
axis([1, length(cvl_ref), 0, 1])
title("Convolution product (built-in)")
xlabel("Samples")
ylabel("Magnitude")

subplot(1, 3, 3)
plot(cvl-cvl_ref, "-k+")
axis([1, length(cvl_ref)])
title("Difference between home-made & built-in")
xlabel("Samples")
ylabel("Magnitude")