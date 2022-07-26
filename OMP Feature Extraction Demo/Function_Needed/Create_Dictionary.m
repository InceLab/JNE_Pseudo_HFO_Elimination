function [Dict,DL,DR,DF] = Create_Dictionary(sz,fs)
   


    % Dictionary Elements
    Dict.DCT = [];
    Dict.DL1 = [];
    Dict.DL2 = [];
    Dict.DM =  [];
    Dict.DR1 = [];
    Dict.DR2 = [];
    Dict.DF1 = [];
    Dict.DF2 = [];

    % Dictionary Elements
    Dict.DCT = []; Dict.DCTloc = []; Dict.DCTfrq = []; Dict.DCTwnd = [];
    Dict.DL1 = []; Dict.DL1loc = []; Dict.DL1frq = []; Dict.DL1wnd = [];
    Dict.DL2 = []; Dict.DL2loc = []; Dict.DL2frq = []; Dict.DL2wnd = [];
    Dict.DM =  [];  Dict.DMloc = [];  Dict.DMfrq = [];  Dict.DMwnd = [];
    Dict.DR1 = []; Dict.DR1loc = []; Dict.DR1frq = []; Dict.DR1wnd = [];
    Dict.DR2 = []; Dict.DR2loc = []; Dict.DR2frq = []; Dict.DR2wnd = [];
    Dict.DF1 = []; Dict.DF1loc = []; Dict.DF1frq = []; Dict.DF1wnd = [];
    Dict.DF2 = []; Dict.DF2loc = []; Dict.DF2frq = []; Dict.DF2wnd = [];

    for ph = [0, pi/2]
        [TempDCT,TemplocDCT,TempfrqDCT,TempwdDCT] = Create_Gabor_Dictionary(sz,0,[0 35],0,ph,fs);
        Dict.DCT = [TempDCT,Dict.DCT];
        Dict.DCTloc = [TemplocDCT,Dict.DCTloc];
        Dict.DCTwnd = [TempwdDCT,Dict.DCTwnd];
        Dict.DCTfrq = [TempfrqDCT,Dict.DCTfrq];

        [TempDL1,TemplocDL1,TempfrqDL1,TempwdDL1] = Create_Gabor_Dictionary(sz,1,[0 35],256,ph,fs,0.99);%64
        Dict.DL1=[TempDL1,Dict.DL1];
        Dict.DL1loc = [TemplocDL1,Dict.DL1loc];
        Dict.DL1wnd = [TempwdDL1,Dict.DL1wnd];
        Dict.DL1frq = [TempfrqDL1,Dict.DL1frq];

        [TempDL2,TemplocDL2,TempfrqDL2,TempwdDL2] = Create_Gabor_Dictionary(sz,1/2,[0 35],256,ph,fs,0.99);%64
        Dict.DL2=[TempDL2,Dict.DL2];
        Dict.DL2loc = [TemplocDL2,Dict.DL2loc];
        Dict.DL2wnd = [TempwdDL2,Dict.DL2wnd];
        Dict.DL2frq = [TempfrqDL2,Dict.DL2frq];

        [TempDM,TemplocDM,TempfrqDM,TempwdDM] = Create_Gabor_Dictionary(sz,1/4,[40 70],256,ph,fs,0.7);%32
        Dict.DM=[TempDM,Dict.DM];
        Dict.DMloc = [TemplocDM,Dict.DMloc];
        Dict.DMwnd = [TempwdDM,Dict.DMwnd];
        Dict.DMfrq = [TempfrqDM,Dict.DMfrq];

        [TempDR1,TemplocDR1,TempfrqDR1,TempwdDR1] = Create_Gabor_Dictionary(sz,1/4,[85 200],256,ph,fs,0.8);%64
        Dict.DR1=[TempDR1,Dict.DR1];
        Dict.DR1loc = [TemplocDR1,Dict.DR1loc];
        Dict.DR1wnd = [TempwdDR1,Dict.DR1wnd];
        Dict.DR1frq = [TempfrqDR1,Dict.DR1frq];

        [TempDR2,TemplocDR2,TempfrqDR2,TempwdDR2] = Create_Gabor_Dictionary(sz,1/8,[150 200],256,ph,fs,0.8);%64
        Dict.DR2=[TempDR2,Dict.DR2];
        Dict.DR2loc = [TemplocDR2,Dict.DR2loc];
        Dict.DR2wnd = [TempwdDR2,Dict.DR2wnd];
        Dict.DR2frq = [TempfrqDR2,Dict.DR2frq];

        [TempDF1,TemplocDF1,TempfrqDF1,TempwdDF1] = Create_Gabor_Dictionary(sz,1/8,[200 600],256,ph,fs,0.8);%64
        Dict.DF1=[TempDF1,Dict.DF1];
        Dict.DF1loc = [TemplocDF1,Dict.DF1loc];
        Dict.DF1wnd = [TempwdDF1,Dict.DF1wnd];
        Dict.DF1frq = [TempfrqDF1,Dict.DF1frq];

        [TempDF2,TemplocDF2,TempfrqDF2,TempwdDF2] = Create_Gabor_Dictionary(sz,1/12,[300 600],256,ph,fs,0.8);%64
        Dict.DF2=[TempDF2,Dict.DF2];
        Dict.DF2loc = [TemplocDF2,Dict.DF2loc];
        Dict.DF2wnd = [TempwdDF2,Dict.DF2wnd];
        Dict.DF2frq = [TempfrqDF2,Dict.DF2frq];
    end
    DL.Atom = [Dict.DCT,Dict.DL1,Dict.DL2,Dict.DM];
    DLsize = size(DL,2);
    DL.Atom = data_norm(DL.Atom,2);
    DL.frq = [Dict.DCTfrq,Dict.DL1frq,Dict.DL2frq,Dict.DMfrq];
    
    DR.Atom  = [Dict.DR1,Dict.DR2];
    DRsize = size(DR,2);
    DR.Atom = data_norm(DR.Atom,2);
    DR.frq = [Dict.DR1frq,Dict.DR2frq]; 
    
    DF.Atom = [Dict.DF1,Dict.DF2];
    DFsize = size(DF,2);
    DF.Atom = data_norm(DF.Atom,2);
    DF.frq = [Dict.DF1frq,Dict.DF2frq];

end

