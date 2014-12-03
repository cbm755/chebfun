function handles = setupPanelDiscretization(handles)
%SETUPPANELDISCRETIZATION   Setup panel for the discretization option.

% Background colour for text fields:
textBackgroundColour = get(handles.panel_buttons, 'BackgroundColor');
textFontsize = 12;
leftMargin = 0.025;
textHeight = 0.45;
vertLoc = linspace(.55, .05, 2);

%% Create a panel for the discretization option:
handles.panel_discretization = uibuttongroup('parent', handles.panel_buttons, ...
    'Title', 'Discretization', 'BackgroundColor', textBackgroundColour, ...
    'Position', [0.045 .465 .92 .14], 'FontSize', textFontsize, ...
    'BorderType', 'etchedin', ...
    'SelectionChangeFcn',@(hObject, eventdata) ...
    discretizationSelection(hObject, eventdata, guidata(hObject)));

%% Populate the discretization option panel with two buttons.
handles.button_collocation = uicontrol('Parent', handles.panel_discretization, ...
    'Style', 'radiobutton', 'BackgroundColor', textBackgroundColour, ...
    'String','Collocation', 'FontSize', textFontsize, ...
    'Units', 'normalized', ...
    'Position', [leftMargin vertLoc(1) 1-leftMargin textHeight]);

handles.button_ultraspherical = uicontrol('Parent', handles.panel_discretization, ...
    'Style', 'radiobutton', 'BackgroundColor', textBackgroundColour, ...
    'String','Ultraspherical', 'FontSize', textFontsize, ...
    'Units', 'normalized', ...
    'Position', [leftMargin vertLoc(2) 1-leftMargin textHeight]);

end

function discretizationSelection(hObject, eventdata, handles)
% hObject    handle to the selected object in panel_IVPsolver
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was 
%             selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

% What's the new IVP solver selected?
newIVPsolver = get(eventdata.NewValue, 'String');

% Change the ivpSolver option stored in handles.guifile.options based on the new
% selection.
if ( strcmp(newIVPsolver, get(handles.button_collocation, 'String')) )
    % User selected time-stepping. Default time stepping method is ODE113:
    handles.guifile.options.discretization = 'collocation';
else
    % User selected global solver. Default global method is collocation:
    handles.guifile.options.discretization = 'ultraspherical';
end

% Update HOBJECT.
guidata(hObject, handles);

end