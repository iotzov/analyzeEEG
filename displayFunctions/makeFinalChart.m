displayFinalFourWay(results) 
[h,p1]=ttest(results.averagedfwd);
[h,p2]=ttest(results.averagedfwd(1:13), results.averagedbwd(1:13));
[h,p3]=ttest(results.averagedbwd);
[h,p4]=ttest(results.averagedfwd(14:end), results.averagedbwd(14:end));
[h,p5]=ttest([results.averagedfwd results.averagedbwd]);
subplot(1,2,1)                                            
sigstar({[1 3] [1 2] [2 4] [3 4] [1 4]}, [p1 p2 p3 p4 p5])
legend('Forward', 'Backward', 'Location', 'southwest')   
