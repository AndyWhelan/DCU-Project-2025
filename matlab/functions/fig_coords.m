function x = x_fig_coords( x_start_data, x_end_data, ax )
    x_norm_start = (x_start_data - ax.XLim(1)) / (ax.XLim(2) - ax.XLim(1));
    x_norm_end = (x_end_data - ax.XLim(1)) / (ax.XLim(2) - ax.XLim(1));
    x_fig_start = ax.Position(1) + x_norm_start * ax.Position(3);
    x_fig_end = ax.Position(1) + x_norm_end * ax.Position(3);
    x = [ x_fig_start, x_fig_end ];
end

function y = y_fig_coords( y_start_data, y_end_data, ax )
    y_norm_start = (y_start_data - ax.YLim(1)) / (ax.YLim(2) - ax.YLim(1));
    y_norm_end = (y_end_data - ax.YLim(1)) / (ax.YLim(2) - ax.YLim(1));
    y_fig_start = ax.Position(2) + y_norm_start * ax.Position(4);
    y_fig_end = ax.Position(2) + y_norm_end * ax.Position(4);
    y = [y_fig_start, y_fig_end];
end
