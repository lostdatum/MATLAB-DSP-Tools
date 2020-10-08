function sgn_out = interpz(sgn_in, factor)
% INTERPZ - Inperpolates zeros between samples of signal.
%
% Syntax:  sgn_out = interpz(sgn_in, factor)
%
% Inputs:
%    sgn_in - Input signal (in time-domain). Must be a column vector.
%    factor - Interpolation factor. Must be an integer higher or equal to 1.
%
% Outputs:
%    sgn_out - Output signal such that length(sgn_out) = length(sgn_in)*factor,
%              and only zeros are interpolated. Column vector.
%
% Example: 
%    seq = [1 0 0 1 1 0 0 1 0 1].' ;
%    seq_itp = interpz(seq, 10) ;
%
%
% Other m-files required: isintnb.m
% Subfunctions: none
% MAT-files required: none
%
%
% See also: none
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
% All rights reserved
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

	
	% Parse arguments
	if length(size(sgn_in)) != 2 | size(sgn_in, 2) != 1
		error("Argument #1 must be a column vector.") ;
	elseif size(factor) != [1 , 1] | ~isintnb(factor) | factor < 1
		error("Argument #2 must be an integer higher or equal to 1.") ;
	end
	
	% Compute output
	if factor == 1
		sgn_out = sgn_in ;
	else
		blocpond = [1 ; zeros(factor-1, 1)] ;
		sgn_out = reshape(blocpond*sgn_in', length(sgn_in)*factor, 1) ;
	end
	
end