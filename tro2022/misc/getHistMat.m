function [hist_mat] = getHistMat( data, loop_distribution_viz )

%
unit_cell_meter = 0.5;
unit_cell_deg = 10;
upperbound_cell_meter = 8;
upperbound_cell_deg = 180;
num_cells_meter = round(upperbound_cell_meter/unit_cell_meter);
num_cells_deg = round(upperbound_cell_deg/unit_cell_deg);

if( isempty(data) )
    hist_mat = zeros(num_cells_meter, num_cells_deg);
else
    %
    hist_mat = hist3(data,'CDataMode','auto','FaceColor','interp',  'EdgeColor', 'none' ...
            ,'Edges', {0:unit_cell_meter:upperbound_cell_meter, 0:unit_cell_deg:upperbound_cell_deg} ); % [1m, 15deg]

    % return: remove the zero paddings
    hist_mat = hist_mat(1:end-1, 1:end-1);

    % viz
    if( loop_distribution_viz )
        figure(round(rand(1)*1000)); clf;
%         figure(viz_fig_idx); clf;
        hist3(data,'CDataMode','auto','FaceColor','interp',  'EdgeColor', 'none' ...
                ,'Edges', {0:unit_cell_meter:upperbound_cell_meter, 0:unit_cell_deg:upperbound_cell_deg}); % [1m, 15deg]    
        caxis([0, 10]);
        % colormap((jet));
        colormap(flipud(bone));
%         colorbar;
    end

end

end

