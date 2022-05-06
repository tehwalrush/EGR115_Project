function engineL_slider(engine_slide, event, engine)

engine_data = readtable("engine_data.xlsx", "VariableNamingRule", "preserve");

slidevalue = get(engine_slide, "Value");

ScreenSize = get(groot, 'ScreenSize');
ScreenLength = ScreenSize(3);
ScreenHeight = ScreenSize(4);

displacement = -(200 * slidevalue) + 200;
% When slider is moved, displace each button by how much it is being moved

enginecount = 0;

for i = 1:height(engine_data)
    if string(engine_data{i,"Stage"}) == "L"
        enginecount = enginecount + 1;
        set(engine(enginecount), "Position", [(0.025*ScreenLength) (0.7*ScreenHeight - 0.07*(enginecount-1)*ScreenHeight + displacement) (0.08*ScreenLength) (0.05*ScreenHeight)]);
    end
end

% Move each engine that is being displayed