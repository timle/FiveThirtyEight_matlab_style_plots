function ns17_plotter(conf)
% emulates plotting style of popular statistics website
% 
% xdat: [cell] One cell for x data of each line.
% ydat: [cell] One cell for x data of each line. One for each of
%                xdata. Optional, will use 1:numel(xdata) if not specified.
% line_plot_colors: [cell] Hex codes for lines colors. One for each of
%                           xdata.
% line_labels: [cell] Labels for lines. One for each of xdata. Blank {''}
%               if not label for line.
% line_label_xpos_lim: [min max] In units of axis. Limits within to
%                       distribute line labels. 
% 
% 
%  grid_draw_lim_y: [min max] Limits for grid, on y axis. In same units as
%                   y data.
%  grid_draw_lim_x: [min max] Limits for grid, on x axis. In same units as
%                   x data.
% 
% 
% xtick: [vector] x gridline locations.
% ytick: [vector] y gridline locations.
% xticklabel: [vector/cell of strings] x tick/grid labels.
% yticklabel: [vector/cell of strings] y tick/grid labels.
% xticklabel_suffix: [cell] labels to selectivly append to xticklabel
%                      xticklabel_suffix{1} = 'th'
%                         will append 'th' to first value in xticklabel
% yticklabel_suffix: [cell] labels to selectivly append to yticklabel
% 

% plot_margin_prcnt_x: [left right] Margin on either left/right of plot.
%                       Percentages of x axis width. 
% plot_margin_prcnt_y: [top bottom] Margin on top/bottom  of plot.
%                       Percentages of y axis width. 
% 
% axis_color: Background color of plot.
% plot_lineWidth: linewidth for plot
% xrefline: if refline across x axis, location in axis units
% xrefline_parameters: parameters for refline
% 
% xlabel: x axis label
% xlabel_parameters: x axis label parameters
% ylabel: y axis label
% ylabel_parameters: y axis label parameters
% title: main title
% title_parameters: main title parameters
% biline: biline under title
% biline_parameters: biline under title parameters
% 
% footer_Color: background color of footer
% footer_icon: location of icon for footer
% footer_txt_left: footer text left
% footer_txt_right: footer text right
% footer_parameters: parameters of footer_text
% footerHeight: height of footer, relative to figure


%% figure
    fh = figure;
    set(fh,'color','w');


%%
    clf;
    axes('position',[0.04 0.1 0.92 0.86])
    hold on;
    
%%%%config values


%%%%
    x_width = diff(abs(conf.grid_draw_lim_x));
    y_width = diff(abs(conf.grid_draw_lim_y));
    
    conf.plot_margin_x = x_width .* conf.plot_margin_prcnt_x;
    conf.plot_margin_y = y_width .* conf.plot_margin_prcnt_y;
%     x_negatives = conf.grid_draw_lim_x < 0;
%     y_negatives = conf.grid_draw_lim_y < 0;
    conf.plot_margin_x(1) = -conf.plot_margin_x(1);
    conf.plot_margin_y(1) = -conf.plot_margin_y(1);

    LeftAlign = conf.grid_draw_lim_x(1)+conf.plot_margin_x(1);
    BotAlign = conf.grid_draw_lim_y(1)+conf.plot_margin_y(1);
    TopAlign = conf.grid_draw_lim_y(2)+conf.plot_margin_y(2);
    
    d = conf.xdat;
    dy = [];
    if isfield(conf,'ydat') && ~isempty(conf.ydat)
        dy = conf.ydat;
    else
        xNumels = cellfun(@numel,d);
        dy = arrayfun(@(x)(1:x),xNumels,'uni',false);
    end

% axis settings
    set(gca,'YColor','w','xColor','w');
    set(gca,'xlim',conf.grid_draw_lim_x+conf.plot_margin_x);
    set(gca,'ylim',conf.grid_draw_lim_y+conf.plot_margin_y);
    set(gca,'color',conf.axis_color);

%grid
    xticks_y = repmat(conf.grid_draw_lim_y,1,numel(conf.xtick));
    xticks_x = repmat(conf.xtick,2,1);
    handles.xGridLines = plot(xticks_x,xticks_y,'color',[.8 .8 .8]);
    yticks_x = repmat(conf.grid_draw_lim_x,1,numel(conf.ytick));
    yticks_y = repmat(conf.ytick,2,1);
    handles.yGridLines = plot(yticks_x,yticks_y,'color',[.8 .8 .8]);

    
%tick labels
    x_has_suffix = find(~cellfun(@isempty,conf.xticklabel_suffix));
    y_has_suffix = find(~cellfun(@isempty,conf.yticklabel_suffix));
    
    if ~iscell(conf.xticklabel)
        conf.xticklabel = arrayfun(@num2str,conf.xticklabel,'uni',false);
    end
    if ~iscell(conf.yticklabel)
        conf.yticklabel = arrayfun(@num2str,conf.yticklabel,'uni',false);
    end
    
    conf.xticklabel(x_has_suffix) = ...
                cellfun(@(x,y)([x y]),...
                    conf.xticklabel(x_has_suffix),...
                        conf.xticklabel_suffix(x_has_suffix),'uni',false);
                    
    conf.yticklabel(y_has_suffix) = ...
                cellfun(@(x,y)([x y]),...
                    conf.yticklabel(y_has_suffix),...
                        conf.yticklabel_suffix(y_has_suffix),'uni',false);
    
   
    x_txt_locs_x = num2cell(xticks_x(1,:));
    x_txt_locs_y = num2cell(xticks_y(1,:));

    textFun = @(x,y,txt)text(x,y,txt,...
                'HorizontalAlignment','center',...
                'VerticalAlignment','top',...
                'color',[.3 .3 .3],'FontName','tahoma');

    x_lbls_hands =cellfun(textFun, x_txt_locs_x, x_txt_locs_y, conf.xticklabel)

    y_txt_locs_x = num2cell(yticks_x(1,:));
    y_txt_locs_y = num2cell(yticks_y(1,:));
    textFun = @(x,y,txt)text(x,y,txt,...
                'HorizontalAlignment','right',...
                'VerticalAlignment','middle',...
                'color',[.3 .3 .3],'FontName','tahoma');
        
    y_lbls_hands = cellfun(textFun,y_txt_locs_x,y_txt_locs_y,conf.yticklabel)
    
%reflines
    if conf.xrefline
    plot(conf.grid_draw_lim_x,[conf.xrefline conf.xrefline],conf.xrefline_parameters{:})
    end
    plot(conf.grid_draw_lim_x,[0 0],'color',[.4 .4 .4])
    
% plot the data

    p_hndls = cellfun(@plot,dy,d);

    
%apply colors
    hexFun = @(hexCol)hex2dec(reshape(hexCol, 2, numel(hexCol)/2)')'/255;
    colors_ml = cellfun(hexFun,conf.line_plot_colors,'uni',false);
    colors_ml = colors_ml(:)';
    p_hndls_cell = num2cell(p_hndls);

    cellfun(@(handle,colr)(set(handle,'color',colr)),p_hndls_cell,colors_ml)

%line width
    set(p_hndls,'linewidth',conf.plot_lineWidth)
    
%line labels
    if isempty(conf.line_label_xpos_lim)
        conf.line_label_xpos_lim = [conf.xtick(1) conf.xtick(end)];
    end
    if ~isempty([conf.line_labels{:}])
        y_txt_locs_x = linspace(conf.line_label_xpos_lim(1),...
                                             conf.line_label_xpos_lim(2),...
                                                 numel(conf.line_labels));
        y_txt_locs_x = num2cell(y_txt_locs_x);

        y_txt_locs_y = cellfun(@(yLc,yAx,xdat)(xdat(yAx==yLc))',y_txt_locs_x,dy,d,'uni',false);
        textFun = @(x,y,txt,colr)text(x,y,txt,...
                    'HorizontalAlignment','left',...
                    'VerticalAlignment','top',...
                    'color',colr,...
                    'fontsize',14,...
                    'FontName','tahoma');

        cellfun(textFun, y_txt_locs_x, y_txt_locs_y, conf.line_labels, colors_ml)
    end


%labels   
    x_mid = x_width/2 + conf.grid_draw_lim_y(1);
    y_mid = y_width/2 + conf.grid_draw_lim_x(1);

    text(LeftAlign,x_mid, conf.xlabel, 'Rotation',90,...
                'HorizontalAlignment','center',...
                'VerticalAlignment','top',conf.xlabel_parameters{:})

    text(y_mid,BotAlign, conf.ylabel,...
                'HorizontalAlignment','center',...
                'VerticalAlignment','bottom',conf.ylabel_parameters{:})
    
%main title
    winsz = get(gcf,'position');
    onedot = x_width/winsz(3);
    
    titleLeft = LeftAlign + x_width*.01;
    tiltleTop = TopAlign*.95;
    tiltleTopBiLine = TopAlign*.95;
    
    text(titleLeft,tiltleTop, conf.title,...
                    'HorizontalAlignment','left',...
                    'VerticalAlignment','bottom',...
                    conf.title_parameters{:});

    text(titleLeft,tiltleTopBiLine, conf.biline,...
                    'HorizontalAlignment','left',...
                    'VerticalAlignment','top',...
                    conf.biline_parameters{:});
%footer
    axisPos = get(gca,'position');
    footerHeight = conf.footerHeight;
    

    footer_txt_right_pos= [axisPos(1) ...
                           axisPos(2)-(footerHeight+footerHeight*.1)...
                           axisPos(3)...
                           footerHeight];
                       
    footer_icon_pos = [ footer_txt_right_pos(1:2) ...
                        footerHeight*2 ...
                        footer_txt_right_pos(4)];
                    
    footer_icon_internal_pos = [ footer_txt_right_pos(1:2)...
                                 footerHeight...
                                 footer_txt_right_pos(4)];
                             
    footer_icon_internal_pos = [footer_icon_internal_pos(1)...
                                footer_icon_internal_pos(2) * 1.1...
                                footer_icon_internal_pos(3:4) * .8];
                            
    footer_txt_left_pos = [ footer_txt_right_pos(1) + footerHeight/1.5 ...
                            footer_txt_right_pos(2) ...
                            footerHeight*2 ...
                            footer_txt_right_pos(4)];

    subplot('position',footer_txt_right_pos)
    rectangle('Position',[0 0 1 1],'FaceColor',conf.footer_Color,'edgecolor','none');
    set(gca,'YColor','w','xColor','w')

    %footer icon
        axes('Position', footer_icon_pos, 'Layer','top');
        icon = imread(conf.footer_icon);

        alphaDat = ~(sum(icon,3) == 0);
    %     alphamap(A)
        h=imagesc(0,0,icon);
        axis image
        set(gca,'position',footer_icon_internal_pos,'Visible','off')
        set(h, 'AlphaData', alphaDat);

    %footer_txt_left
    annotation('textbox',footer_txt_left_pos,...
                'string',upper(conf.footer_txt_left),...
                'edgecolor','none', 'VerticalAlignment','middle',...
                'HorizontalAlignment','left',...
                conf.footer_parameters{:})

    %footer_txt_right
    annotation('textbox',footer_txt_right_pos,...
                'string',upper(conf.footer_txt_right),...
                'edgecolor','none','VerticalAlignment','middle',...
                'HorizontalAlignment','right',...
                conf.footer_parameters{:});