% This script creates a scatter plot of all the configurations tested in
% this experiment.
load configurations_04_12_trimmed_v_and_a;

configs=configurations_04_12_trimmed_v_and_a;

drop_height=[23.3,26.6,29.9,33.5,37.7,41.3,45.2,48.7,52.8,55.9]; % cm
passes=[];
mass=[];
r=[];
h_ID=[];

for m=1:length(configs)
    passes=[passes configs(m).passes];
    for n=1:configs(m).total_runs
        mass=[mass configs(m).m];
        r=[r configs(m).r];
        h_ID=[h_ID configs(m).h];
    end
end

h_actual=zeros(size(h_ID));
for m=1:length(h_actual)
    h_actual(m)=drop_height(h_ID(m));
end

scatter3(mass,r,h_actual,'filled','MarkerFaceColor','k');


boundingBox1=...
    [
        716.5,45.3632,23.3;
        716.5,45.3632,55.9;
        1044.4,37.8963,55.9;
        1044.4,37.8963,23.3;
        716.5,45.3632,23.3;
        1044.4,37.8963,23.3;
        2460.7,44.1993,23.3;
        2460.7,44.1993,55.9;
        1044.4,37.8963,55.9;
        2460.7,44.1993,55.9;
        1610.6,45.0921,55.9;
        1610.6,45.0921,23.3;
        2460.7,44.1993,23.3;
        1610.6,45.0921,23.3;
        716.5,45.3632,23.3;
        716.5,45.3632,55.9;
        1610.6,45.0921,55.9;
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