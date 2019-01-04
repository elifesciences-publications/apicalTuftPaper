% from: https://mhlablog.net/2018/08/02/further-checks-in-l1-project-bifurcation-angles-where-do-deep-apicals-originate-in-lpta/
fh=figure;ax=gca;
outputFolder='/mnt/mpibr/data/Data/karimia/presentationsWriting/Talks/progressReport06082018/';
hold on
bar(1,2/50,'FaceColor',dlcolor);
bar(2,8/50,'FaceColor',dlcolor);
bar(3,6/50,'FaceColor',l2color);
bar(4,34/50,'FaceColor',l2color);
ylim([0,1])
xticks(1:4)
xticklabels({'Layer 5 non-main','Layer 5 main','Layer2/3 non-main','Layer2/3 main'})
xtickangle(-45)

x_width=12;
y_width=10;
ylabel('Fraction of bifurcations')
util.plot.cosmeticsSave(fh,ax,x_width,y_width,outputFolder,'fractionofBifurcationType');


