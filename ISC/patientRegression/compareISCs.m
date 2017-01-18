figure
subplot(1,2,1)
imagesc(isc(1:43,:))
caxis([.0059 .0254])
xticks([1 2 3]); xlabel('Components'); ylabel('Subject'); title('Healthy ISC Values')

subplot(1,2,2)
imagesc(isc(44:85,:))
caxis([.0059 .0254])
xticks([1 2 3]); xlabel('Components'); ylabel('Subject'); title('Patient ISC Values')
colorbar