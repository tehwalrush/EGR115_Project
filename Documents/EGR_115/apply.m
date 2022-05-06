function apply(button, event, engine, engineinfo, engine_data, engine_name, engine_cost, engine_base_thrust, engine_base_isp, engine_prop, engine_thrust, engine_isp, engine_weight, engine_diameter, engine_length, tankbutton, deselectbutton, tank_dia, tank_height, stage1_thrust, stage1_mass, stage1_tw, stage2_thrust, stage2_mass, stage2_tw, stack_tw, rocket_cost, engine_length1, engine_diameter1, fair_thickness, engine_cost1, tank_price_overall, prop_price_overall, fair_price)

ScreenSize = get(groot, 'ScreenSize');
ScreenLength = ScreenSize(3);
ScreenHeight = ScreenSize(4);

for pos = 1:length(engineinfo)
    if engineinfo(pos).Value == 1 
        name = engine(pos).String;
    end
end

location = find(string(engine_data{:, "Engine Name"}) == name);
%<SM:SEARCH>

engine_name.String = string(engine_data{location, "Engine Name"});
engine_thrust.String = string(engine_data{location, "Thrust (N)"});
engine_base_thrust.String = string(engine_data{location, "Thrust (N)"});
engine_isp.String = string(engine_data{location, "Isp"});
engine_base_isp.String = string(engine_data{location, "Isp"});
engine_prop.String = string(engine_data{location, "Base Prop"});
engine_cost.String = string(engine_data{location, "Cost ($)"});
engine_weight.String = string(engine_data{location, "Weight (kg)"});
engine_diameter.String = string(engine_data{location, "Diameter (ft)"});
engine_length.String = string(engine_data{location, "Length (ft)"});
% Set variables related to the engine information - will be used in later
% functions

stage = string(engine_data{location, "Stage"});

tankbutton.Position(4) = 0.04*ScreenLength;
% Make tankbutton appear

for pos = 1:length(engineinfo)
    if engineinfo(pos).Position(4) ~= 0
        engineinfo(pos).Position(4) = 0;
    end
end

button.Position(4) = 0;
deselectbutton.Position(4) = 0;
% Make apply and deselect buttons disappear

engine_x = linspace((-engine_data{location, "Diameter (ft)"} / 2), (engine_data{location, "Diameter (ft)"} / 2), 100);
engine_length = engine_data{location, "Length (ft)"};
engine_radius = engine_data{location, "Diameter (ft)"} / 2;

count_var = 1;
for x_value = engine_x
    engine_y(count_var) = engine_length - ((engine_length / (engine_radius ^ 2)) * x_value ^ 2);
    count_var = count_var + 1;
    % Create a y-value set for the engine contour
end

if stage == "L"

    stage1_thrust.Position(4) = 0.03*ScreenHeight;
    if str2double(engine_thrust.String) < 1000000
        stage1_thrust.String = "Thrust: " + string(round(str2double(engine_thrust.String) / 100) / 10) + " kN";
    else
        stage1_thrust.String = "Thrust: " + string(round(str2double(engine_thrust.String) / 100000) / 10) + " MN";
    end

    stage1_mass.Position(4) = 0.03*ScreenHeight;
    stage1_mass.String = "Mass: " + engine_weight.String + " kg";

    tw_ratio = round(10 * str2double(engine_thrust.String) / (9.81 * str2double(engine_weight.String))) / 10;
    stage1_tw.Position(4) = 0.03*ScreenHeight;
    stage1_tw.String = "T/W Ratio: " + string(tw_ratio);

    rocket_cost.Position(4) = 0.03*ScreenHeight;

    if tw_ratio <= 1
        stage1_tw.ForegroundColor = "red";
    else
        stage1_tw.ForegroundColor = "black";
    end

    if str2double(engine_cost.String) < 1000000
        rocket_cost.String = "Net Cost: $" + engine_cost.String;
    else
        rocket_cost.String = "Net Cost: $" + string(str2double(engine_cost.String) / 1000000) + " Million";
    end

    subplot("Position", [0.775 0.2 0.2 0.7]);
    plot(engine_x, engine_y, "Color", "#4a4b52");
    %<SM:PLOT>
    % Plot engine contour

    xlim([-10 10])
    ylim([0 20])


elseif stage == "U"

    tank_diameter = str2double(tank_dia.String);
    tank_radius = tank_diameter / 2;
    tank_height_num = str2double(tank_height.String);
    fair_thickness_num = str2double(fair_thickness.String([30:end]));

    engine_length1_num = str2double(engine_length1.String);
    engine_radius1 = str2double(engine_diameter1.String) / 2;
    engine_x1 = linspace(-engine_radius1, engine_radius1, 100);
    % Obtain variables needed for calcs and plotting

    engine_y = engine_y + engine_length1_num + tank_height_num + (0.5 * engine_length);
    total_cost = str2double(engine_cost1.String) + round(str2double(tank_price_overall.String([13:end]))) + round(str2double(prop_price_overall.String([19:end]))) + round(str2double(fair_price.String([16:end]))) + str2double(engine_cost.String);

    if isempty(extractBetween(stage1_thrust.String, "Thrust: ", " kN")) == 0
        stage1_thrust.String = "Stage 1 Thrust: " + string(extractBetween(stage1_thrust.String, "Thrust: ", " kN")) + " kN";
    else
        stage1_thrust.String = "Stage 1 Thrust: " + string(extractBetween(stage1_thrust.String, "Thrust: ", " MN")) + " MN";
    end

    stage1_mass.String = "Stage 1 Mass: " + string(extractBetween(stage1_mass.String, "Mass: ", " kg")) + " kg";
    stage1_tw.String = "Stage 1 T/W Ratio: " + string(extractAfter(stage1_tw.String, "T/W Ratio: "));

    stage2_thrust.Position(4) = 0.03*ScreenHeight;
    if str2double(engine_thrust.String) < 1000000
        stage2_thrust.String = "Stage 2 Thrust: " + string(round(str2double(engine_thrust.String) / 100) / 10) + " kN";
    else
        stage2_thrust.String = "Stage 2 Thrust: " + string(round(str2double(engine_thrust.String) / 100000) / 10) + " MN";
    end

    stage2_mass.Position(4) = 0.03*ScreenHeight;
    stage2_mass.String = "Stage 2 Mass: " + engine_weight.String + " kg";

    tw_ratio = round(10 * str2double(engine_thrust.String) / (9.81 * str2double(engine_weight.String))) / 10;
    stage2_tw.Position(4) = 0.03*ScreenHeight;
    stage2_tw.String = "Stage 2 T/W Ratio: " + string(tw_ratio);

    if tw_ratio <= 1
        stage2_tw.ForegroundColor = "red";
    else
        stage2_tw.ForegroundColor = "black";
    end

    rocket_cost.Position(4) = 0.03*ScreenHeight;
    if total_cost < 1000000
        rocket_cost.String = "Net Cost: $" + string(round(10* total_cost) / 10);
    else
        rocket_cost.String = "Net Cost: $" + string(round(total_cost / 100000) / 10) + " Million";
    end

    tot_rocket_mass = str2double(string(extractBetween(stage1_mass.String, "Mass: ", " kg"))) + str2double(engine_weight.String);
    if isempty(extractBetween(stage1_thrust.String, "Thrust: ", " kN")) == 0
        stack_tw.String = "Full Rocket T/W Ratio: " + string(round(10000 * str2double(string(extractBetween(stage1_thrust.String, "Thrust: ", " kN"))) / 9.8 / tot_rocket_mass) / 10);
    else
        stack_tw.String = "Full Rocket T/W Ratio: " + string(round(10000000 * str2double(string(extractBetween(stage1_thrust.String, "Thrust: ", " MN"))) / 9.8 / tot_rocket_mass) / 10);
    end

    count_var1 = 1;
    for x_value = engine_x1
    % Engine contour
        engine_y1(count_var1) = engine_length1_num - ((engine_length1_num / (engine_radius1 ^ 2)) * x_value ^ 2);
        count_var1 = count_var1 + 1;
    end

    tank_x = linspace(-tank_radius, tank_radius, 100);
    tank_vertical_range = linspace(0, tank_height_num - tank_diameter, 100);
    
    tank_count_var = 1;
    for x_value = tank_x
        tank_y1(tank_count_var) = -sqrt((tank_radius^2) - x_value^2) + engine_length1_num + tank_radius;
        tank_count_var = tank_count_var + 1;
    end

    tank_count_var2 = 1;
    for x_value = tank_vertical_range
        tank_y2(tank_count_var2) = x_value + engine_length1_num + tank_radius;
        tank_count_var2 = tank_count_var2 + 1;
    end

    tank_count_var3 = 1;
    for x_value = tank_x
        tank_y3(tank_count_var3) = sqrt((tank_radius^2) - x_value^2) + engine_length1_num - tank_radius + tank_height_num;
        tank_count_var3 = tank_count_var3 + 1;
    end
    % Tank contour

    fair_vertical_range = linspace(engine_length1_num, engine_length1_num + tank_height_num, 100);
    fair_vertical_left = linspace((-tank_radius) - fair_thickness_num, (-tank_radius) - fair_thickness_num, 100);
    fair_vertical_right = linspace((tank_radius) + fair_thickness_num, (tank_radius) + fair_thickness_num, 100);
    fair_horizontal_range = linspace((-tank_radius) - fair_thickness_num, (tank_radius) + fair_thickness_num, 100);
    fair_horizontal_top = linspace(engine_length1_num + tank_height_num, engine_length1_num + tank_height_num, 100);
    fair_horizontal_bot = linspace(engine_length1_num, engine_length1_num, 100);

    subplot("Position", [0.775 0.2 0.2 0.7]);
    plot(engine_x1, engine_y1, tank_x, tank_y1, linspace(tank_radius, tank_radius, 100), tank_y2, tank_x, tank_y3, linspace(-tank_radius, -tank_radius, 100), tank_y2, fair_vertical_left, fair_vertical_range, fair_vertical_right, fair_vertical_range, fair_horizontal_range, fair_horizontal_bot, fair_horizontal_range, fair_horizontal_top, engine_x, engine_y, "Color", "#4a4b52");
    % Plot first stage engine + tank + fairings + nose cone + second stage
    % engine

    xlim([(tank_radius + engine_length + tank_height_num + engine_length1_num)/-2 (tank_radius + engine_length + tank_height_num + engine_length1_num)/2])
    ylim([0 (tank_radius + engine_length + tank_height_num + engine_length1_num)])
end
