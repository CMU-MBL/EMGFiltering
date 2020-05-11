cryoung 11052020

The following files were used during a research project at Carnegie Mellon University 2020 in Pittsburgh,
   Pennsylvania. 

Here is a list of the MATLAB provided: EMG_Processing, emgSegment, emgFilter, ZeroLagButtFiltfilt

-----------------------------------------------HOW TO USE:------------------------------------------------

EMG_Processing:

	Section 1: 
	   -Change line 28 to the folder containing data
	   -Change line 31 to have names of files for filtering
	   -When prompted, select the start time of the segment desired,
	    followed by the stop time. (NOTE: every input is recorded,
	    click using the left mouse button ONLY)

	Section 2: (emgSegment.m,emgFilter.m)
	   -Change line 45 to the folder containing code (should be start folder)

	Section 3:
	   -Change line 55 to the folder for the destination for the filtered data
	   -Change line 67 to adjust the file save name

emgSegment:
		
	*Nothing to change*

emgFilter: 
	
	Depending on the sensor brand, the properties below might need to be changed.

	Fs      = Sampling Frequency [line 29]
	dt*     = Change in time between data points (a function of Fs)
	fcut    = Frequency cutoff value [lines 31, 37, 49]
	order   = The order of the filter [lines 32, 50]
	type**  = The type of filter being applied: lowpass, bandpass, bandstop, 
	          or highpass ('lp','bp','bs','hp' respectively). [lines 33, 38, 51]
      
*dt should not be changed unless there is no Fs, but the dt is derived from the data set.  
**If 'bs' or 'bp' are used, fcut must be two numbers [low# high#].



-------------------------------------------------------------------------------------------------------------

Path to process data (Step-by-Step):

1. Upload data to a data folder
2. Change EMG_Processing.m to match the 'data', 'code', and 'filtered data' folder locations
3. Depending on the EMG Sensors, update the variables defined in emgFilter.m
4. Run EMG_Processing.m
5. Select the start time and stop time for the all the data sets you input.

