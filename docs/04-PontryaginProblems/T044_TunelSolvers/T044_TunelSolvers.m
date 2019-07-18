
%%

type model.AMPL
%%

ijob = NeosJob('model.AMPL');

%%
outputfile = ijob.send();
%%
data = NeosLoadData(outputfile);