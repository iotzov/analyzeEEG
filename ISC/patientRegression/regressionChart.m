for i = 1:13
  plot( 1, mean_iscF(i),'og'); hold on
  plot( 2, mean_iscB(i),'*r'); hold on
  plot([1 2], [mean_iscF(i) averagedbwd(i)],'-k'); hold on
end

% plot bwd
for i=14:length(mean_iscF)
  plot( 3, mean_iscF(i),'og'); hold on
  plot( 4, averagedbwd(i),'*r'); hold on
  plot([3 4], [mean_iscF(i) averagedbwd(i)],'-k'); hold on
end
