function dataout = mkInvExpData_helper(mean,minV,maxV)
    %minV/maxV are for scaling
    %gen exp data with jitter
    x = 1:1:100;
    baseVals = exppdf(x,mean); 
    %flip
    baseVals = (max(baseVals)-baseVals)/max(baseVals);
    %jitter
    jitter = (rand([1,100]) - .5) *(max(baseVals)/50);
    baseVals = baseVals + jitter;
    %scale
    dataout = baseVals - min(baseVals(:));
    dataout = (dataout/range(dataout(:)))*(maxV-minV);
    dataout = dataout + minV;
    