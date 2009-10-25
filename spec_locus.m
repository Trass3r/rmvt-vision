lam=[400:2:700]*1e-9'; 
rgb = cmfrgb(lam);     
r=rgb(:,1)./sum(rgb')';
g=rgb(:,2)./sum(rgb')';
plot(r, g);
grid
xlabel('r')
ylabel('g')

hold on
for l=400:20:700,
	rgb = cmfrgb(l*1e-9);
	r=rgb(:,1)./sum(rgb')';
	g=rgb(:,2)./sum(rgb')';
	plot(r, g, 'o');
	text(r, g, sprintf('  %d', l));
end
hold off

