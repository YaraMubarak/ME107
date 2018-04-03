load combinedConfigurations_03_22;

drop_height=[23.3,26.6,29.9,33.5,37.7,41.3,45.2,48.7,52.8,55.9]; % cm
passes=[];
mass=[];
r=[];
h_ID=[];

for m=1:length(combinedConfigurations_03_22)
    passes=[passes combinedConfigurations_03_22(m).passes];
    for n=1:combinedConfigurations_03_22(m).total_runs
        mass=[mass combinedConfigurations_03_22(m).m];
        r=[r combinedConfigurations_03_22(m).r];
        h_ID=[h_ID combinedConfigurations_03_22(m).h];
    end
end

h_actual=zeros(size(h_ID));
for m=1:length(h_actual)
    h_actual(m)=drop_height(h_ID(m));
end

scatter3(mass,r,h_actual,'filled','MarkerFaceColor','k');

boundingBox1=...
    [
        508.2,43.8070,23.3;
        508.2,43.8070,55.9;
        932.3,42.7592,55.9;
        932.3,42.7592,23.3;
        1759.1,44.7,23.3;
        1759.1,44.7,55.9;
        710.6,45.59,55.5;
        710.6,45.59,23.3;
        508.2,43.8070,23.3;
        932.3,42.7592,23.3;
        932.3,42.7592,55.9;
        1759.1,44.7,55.9;
        710.6,45.59,55.5;
        508.2,43.8070,55.9;
        710.6,45.59,55.5;
        710.6,45.59,23.3;
        1759.1,44.7,23.3;
    ];

line(boundingBox1(1:size(boundingBox1,1),1),boundingBox1(1:size(boundingBox1,1),2),...
    boundingBox1(1:size(boundingBox1,1),3),'LineWidth',1.5);

l=legend('Configurations Tested','Bounding Box');
set(l,'Location','Northwest');

title('Bounding Box of Experimental Configurations');
xlabel('m (Mass (g))');
ylabel('r_g (Radius of gyration (mm))');
zlabel('h (drop height (cm))');
set(gca,'FontSize',14);