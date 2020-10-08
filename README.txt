Digital signal processing tools for MATLAB

I originally made this to get a better understanding of convolution and cross-
correlation operations. Then I figured this could be useful to students, or 
engineers who want to go over their basics again.

Actually this was developped with OCTAVE 5.2.0 but it should be compatible,
with MATLAB, at worst with some minor adjustements.

This package contains:
>> Functions
	- convolve (discrete 1D convolution)
	- correlate (discrete 1D cross-correlation)
	These functions are standalone and do not require any other files.
>> Test routines:
	- convolve_test
	- correlate_test
	Those routines do require some functions, which are located in BasicTools.

As this is kind of a textbook case, I favored readability over performance, 
chose variable names compliant with usual mathematical conventions, and I added
some comments and explanations when I thought it was needed. I believe it to
be much clearer than similar content I found on Mathworks File Exchange.