height = 1e3;
hardness   = 100;
pos = 0.5;

xline = -1:0.01:1;

f = - (height/2) + (height/2)*tanh(hardness.*( - xline - pos));
figure
plot(xline,f)