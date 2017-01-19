figure
for i = 1:13
  plot( 1, isc_F(i),'og'); hold on
  plot( 2, isc_B(i),'*r'); hold on
  plot([1 2], [isc_F(i) isc_B(i)],'-k'); hold on
end

% plot patient
for i=14:length(isc)
  plot( 3, isc_F(i),'og'); hold on
  plot( 4, isc_B(i),'*r'); hold on
  plot([3 4], [isc_F(i) isc_B(i)],'-k'); hold on
end

% [h, p1] = ttest(isc_F);
% [h, p2] = ttest(isc_F(1:13), isc_B(1:13));
% [h, p3] = ttest(isc_B);
% [h, p4] = ttest(isc_F(14:end), isc_B(14:end));
% [h, p5] = ttest([isc_F' isc_B']);

% sigstar({[1 3] [1 2] [2 4] [3 4] [1 4]}, [p1 p2 p3 p4 p5])

[h,p2]=ttest2(isc_F(1:13), isc_F(14:end));
[h,p3]=ttest2(isc_B(1:14), isc_B(14:end));
[h,p5]=ttest2([isc_F(1:13) isc_B(1:13)], [isc_F(14:end) isc_B(14:end)]);
[h, p6] = ttest(isc_F(1:13) - isc_B(1:13));
[h, p7] = ttest(isc_F(14:end) - isc_B(14:end));

sigstar({[1 3] [2 4] [1 4] [1 2] [3 4]}, [p2 p3 p5 p6 p7])
legend('Forward', 'Backward', 'Location', 'southwest')
xlim([0 5])
xticks([1.5 3.5])
set(gca,'xticklabel',{'Control', 'Patient'});
xlabel('Group'); ylabel('Sum ISC');
