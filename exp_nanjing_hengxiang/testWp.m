fileid = fopen( fullfile('.\', 'Wp.dat'   ));
res = textscan(fileid,'%f64');
res2 = res{1,1}; res2 = res2';
line = 144;
res3 = reshape(res2, [ 144,line]); % (1:144^2)
res4 = res3';
fclose(fileid)


