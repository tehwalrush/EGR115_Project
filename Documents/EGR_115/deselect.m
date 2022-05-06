function deselect(button, event, engineinfo, applybutton)

for pos = 1:length(engineinfo)
    engineinfo(pos).Position(4) = 0;
    engineinfo(pos).Value = 0;
end

% If there are button(s) activated, deactivate them

button.Position(4) = 0;
applybutton.Position(4) = 0;
% Make the deselect and apply buttons invisible once more