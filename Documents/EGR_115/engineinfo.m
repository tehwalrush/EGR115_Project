function engineinfo(engine, event, engine_data, engineinfo, applybutton, deselectbutton)
%<SM:PDF_PARAM>

ScreenSize = get(groot, 'ScreenSize');
ScreenLength = ScreenSize(3);
ScreenHeight = ScreenSize(4);

applybutton.Position(4) = 0.04*ScreenHeight;
deselectbutton.Position(4) = 0.04*ScreenHeight;
% Display options so that user may either select or deselect a chosen
% engine

for pos = 1:length(engineinfo)
    engineinfo(pos).Value = 0;
    % Set all values to zero to prevent multiple engines from being selected

    name = engine.String;
    location = find(string(engine_data{:, "Engine Name"}) == name);
    
    if strip(string(engineinfo(pos).String(3, :))) == "Cost: $" + string(engine_data{location, "Cost ($)"})
    % If the engine information is invisible and its button is pressed, make it
    % visible and its value 1
        engineinfo(pos).Value = 1;
        engineinfo(pos).Position(4) = 0.22 * ScreenHeight;
    end
end
