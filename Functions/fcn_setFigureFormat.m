function fcn_setFigureFormat
% Setting figure properties
fwidth=640;%
fheight=350;%
fright=100;%
fbottom=400;%
set(gcf,'position',[fright,fbottom,fwidth,fheight],'color','w');

% Settings properties for axes
axes_handle = gca;
set(axes_handle, 'FontName', 'Times New Roman', 'FontSize', 12,'LineWidth',1.5);
grid on;
axes_handle.GridLineStyle = '-';
axes_handle.GridColor = 'k';
axes_handle.GridAlpha = 0.2;
box on;
end