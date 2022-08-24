A demo for feature extraction of "A Sparse representation strategy to eliminate pseudo-HFO events from intracranial EEG for seizure onset zone localization"
DOI: Behrang Fazli Besheli et al 2022 J. Neural Eng. 19 046046 https://doi.org/10.1088/1741-2552/ac8766

This demo visualizes the following features:
1- Approximation error: the quality of global reconstrcution of detected events with Gabor atoms
2- V-Factor: the quality of local reconstrcution of detected events with Gabor atoms
3- Line noise: number of atoms with 50/60 Hz components (shown as blue atoms in the figure)

This demo automatically makes a video from the whole process of feature extraction and saves it as ".avi: format

to change the event use the following instrcution:
 line 16 >>>> no=1:5 (Change events)
 line 17 >>>> Example.HFO/Example.Noise (change from real to pseudo-HFO)
 
for more information/code please email: bfazlibesheli@uh.edu