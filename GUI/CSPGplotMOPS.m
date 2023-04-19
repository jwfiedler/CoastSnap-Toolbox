function CSPGplotMOPS(handles)
%Get data from handles
data = get(handles.oblq_image,'UserData');
data_plan = get(handles.plan_image,'UserData');


CSPloadPaths
addpath(fullfile(fileparts(base_path),'MOPS'))

width = 20; %Width of figure in cm


%Now plot shorelines on image
figure
I = data.I;
ax_height = width*size(I,1)/size(I,2);
plot_gap = 0.5;
plot_bot = 0.5;
hor_mar = [0.2 0.2];
ver_mar = [0.2 plot_bot];
mid_mar = [0 0];
geomplot(1,1,1,1,width,ax_height,hor_mar,ver_mar,mid_mar)
image(I)
axis off
hold on


load(fullfile(shoreline_path,'Transect Files','SLtransectsMOP.mat'))
SLtransects = SLtransectsMOP;
SLtransects.alongshore_distances = [100 200 300 400 500 600 700 800 900];

metadata = data_plan.metadata;
colors = lines(9);
for i=1:length(SLtransects.x)

    xyz(:,1) = SLtransects.x(:,i);
    xyz(:,2) = SLtransects.y(:,i);
    xyz(:,3) = [1;1]*data.tide_level;

    UV = findUVnDOF(metadata.geom.betas,xyz,metadata.geom);
    UV = reshape(UV,2,2);
    plot(UV(:,1),UV(:,2),'linewidth',2,'color',colors(i,:))
end