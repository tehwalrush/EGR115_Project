function fair_mat_select(selected, event, material_info, engine_thrust, fair_density, fair_strength, fair_price, tank_dia, tank1_dia, tank_height, tank1_height, tank_weight, tank_price_overall, tank_price_overall1, prop_weight, prop_price_overall, prop_price_overall1, fair_thickness, fair_thickness1, fair_weight, fair_price_overall, fair_price1, engine_diameter, engine_diameter1, engine_length, engine_length1, stage_choice, engine_weight, engine_cost, engine1_cost, stage_thrust, stage1_thrust, stage_mass, stage1_mass, stage_tw, rocket_cost, stack_tw, stack_tw_string, nosecone, nose_length, nose_power, drag, nose_weight, nose_cost)

ScreenSize = get(groot, 'ScreenSize');
ScreenLength = ScreenSize(3);
ScreenHeight = ScreenSize(4);

for pos = 1:height(material_info)
    if selected.String == string(material_info{pos, "Name"})
    % Iterate over material_info data and match the selected material
    % to a particular set on the matrix (basically same process as tank
    % material selection)
        
        fair_density_num = material_info{pos, "Density (kg/ft3)"};
        fair_strength_num = material_info{pos, "Yield Strength (kN/ft2)"};
        fair_price_num = material_info{pos, "Price per kg"};

        fair_density.String = "Density: " + string(fair_density_num) + " kg/ft3";
        fair_density.Position(4) = 0.03*ScreenHeight;
        
        fair_strength.String = "Strength: " + string(fair_strength_num) + " kN/ft2";
        fair_strength.Position(4) = 0.03*ScreenHeight;

        fair_price.String = "Price per kilogram: $" + string(fair_price_num);
        fair_price.Position(4) = 0.03*ScreenHeight;

        

    end
end

tank_diameter = str2double(tank_dia.String);
tank_radius = tank_diameter / 2;
tank_height = str2double(tank_height.String);
max_thrust = str2double(engine_thrust.String);
% Obtain needed variables for calcs

fair_thickness_num = ((tank_diameter * 12) - sqrt((tank_diameter * 12) ^ 2 - (4 * max_thrust / (pi * fair_strength_num)))) / 2;
fair_thickness.String = "Fairing Wall Thickness (in): " + string(fair_thickness_num);
    
total_volume = (4/3) * pi * (tank_diameter / 2 + (fair_thickness_num / 12))^3 + pi * (tank_diameter / 2 + (fair_thickness_num / 12))^2 * (tank_height + (fair_thickness_num / 6));
inside_volume = (4/3) * pi * (tank_diameter / 2)^3 + pi * (tank_diameter / 2)^2 * tank_height;
shell_volume = total_volume - inside_volume;

fair_weight_num = fair_density_num * shell_volume;
fair_weight.String = "Fairing Weight (kg): " + string(round(fair_weight_num));

fair_price_num = fair_weight_num * fair_price_num;
fair_price_overall.String = "Fairing Cost: $" + string(round(fair_price_num));
% Calculate fairing weight and price based on density and volume

engine_length = str2double(engine_length.String);
engine_radius = str2double(engine_diameter.String) / 2;
engine_x = linspace(-engine_radius, engine_radius, 100);
% Prep variables for engine contour

count_var = 1;
for x_value = engine_x
% Engine contour
    engine_y(count_var) = engine_length - ((engine_length / (engine_radius ^ 2)) * x_value ^ 2);
    count_var = count_var + 1;
end

tank_x = linspace(tank_diameter/-2, tank_diameter/2, 100);
tank_vertical_range = linspace(0, tank_height - tank_diameter, 100);
    
tank_count_var = 1;
for x_value = tank_x
    tank_y1(tank_count_var) = -sqrt((tank_diameter^2/4) - x_value^2) + engine_length + tank_diameter/2;
    tank_count_var = tank_count_var + 1;
end

tank_count_var2 = 1;
for x_value = tank_vertical_range
    tank_y2(tank_count_var2) = x_value + engine_length + tank_diameter/2;
    tank_count_var2 = tank_count_var2 + 1;
end

tank_count_var3 = 1;
for x_value = tank_x
    tank_y3(tank_count_var3) = sqrt((tank_diameter^2/4) - x_value^2) + engine_length - tank_diameter/2 + tank_height;
    tank_count_var3 = tank_count_var3 + 1;
end
% Tank contour

if strcmp(string(stack_tw_string), "0") == 1

    stage_choice.Position(4) = 0.2;
    % Make buttongroup appear so that the user may select a second stage

    total_weight = str2double(engine_weight.String) + round(str2double(tank_weight.String([19:end]))) + round(str2double(prop_weight.String([25:end]))) + round(fair_weight_num);
    total_cost = str2double(engine_cost.String) + round(str2double(tank_price_overall.String([13:end]))) + round(str2double(prop_price_overall.String([19:end]))) + round(fair_price_num);

    tw_ratio = str2double(engine_thrust.String) / (9.81 * total_weight);
        
    stage_mass.String = "Mass: " + string(round(total_weight)) + " kg";
    stage_tw.String = "T/W Ratio: " + string(round(10 * tw_ratio) / 10);

    if str2double(engine_thrust.String) < 1000000
        stage_thrust.String = "Thrust: " + string(str2double(engine_thrust.String) / 1000) + " kN";
    else
        stage_thrust.String = "Thrust: " + string(str2double(engine_thrust.String) / 1000000) + " MN";
    end

    if total_cost < 1000000
        rocket_cost.String = "Net Cost: $" + string(round(total_cost));
    else
        rocket_cost.String = "Net Cost: $" + string(round(total_cost / 100000) / 10) + " Million";
    end

    if tw_ratio <= 1
        stage_tw.ForegroundColor = "red";
    else
        stage_tw.ForegroundColor = "black";
    end
    
    fair_vertical_range = linspace(engine_length, engine_length + tank_height, 100);
    fair_vertical_left = linspace((-tank_diameter / 2) - fair_thickness_num, (-tank_diameter / 2) - fair_thickness_num, 100);
    fair_vertical_right = linspace((tank_diameter / 2) + fair_thickness_num, (tank_diameter / 2) + fair_thickness_num, 100);
    fair_horizontal_range = linspace((-tank_diameter / 2) - fair_thickness_num, (tank_diameter / 2) + fair_thickness_num, 100);
    fair_horizontal_top = linspace(engine_length + tank_height, engine_length + tank_height, 100);
    fair_horizontal_bot = linspace(engine_length, engine_length, 100);
    % Create variables for x and y sets for organizational purposes
    
    subplot("Position", [0.775 0.2 0.2 0.7]);
    plot(engine_x, engine_y, tank_x, tank_y1, linspace(tank_diameter/2, tank_diameter/2, 100), tank_y2, tank_x, tank_y3, linspace(tank_diameter/-2, tank_diameter/-2, 100), tank_y2, fair_vertical_left, fair_vertical_range, fair_vertical_right, fair_vertical_range, fair_horizontal_range, fair_horizontal_bot, fair_horizontal_range, fair_horizontal_top, "Color", "#4a4b52");
    % Plot engine + tank + fairings for first stage

    xlim([(tank_diameter / 2 + engine_length + tank_height)/-2 (tank_diameter / 2 + engine_length + tank_height)/2])
    ylim([0 (tank_diameter / 2 + engine_length + tank_height)])

else
    tot_rocket_mass = str2double(string(extractBetween(stage1_mass.String, "Mass: ", " kg"))) + str2double(engine_weight.String) + str2double(tank_weight.String([19:end])) + str2double(prop_weight.String([25:end])) + fair_weight_num;
    tot_rocket_cost = str2double(engine1_cost.String) + round(str2double(tank_price_overall1.String([13:end]))) + round(str2double(prop_price_overall1.String([19:end]))) + round(str2double(fair_price1.String([16:end]))) + str2double(engine_cost.String) + str2double(tank_price_overall.String([13:end])) + str2double(prop_price_overall.String([19:end])) + fair_price_num;
    stage2_mass_num = str2double(engine_weight.String) + str2double(tank_weight.String([19:end])) + str2double(prop_weight.String([25:end])) + fair_weight_num;

    tw_ratio = round(10 * str2double(engine_thrust.String) / (9.81 * stage2_mass_num)) / 10;
    stage_tw.Position(4) = 0.03*ScreenHeight;
    stage_tw.String = "Stage 2 T/W Ratio: " + string(tw_ratio);
        
    stage_mass.String = "Stage 2 Mass: " + string(round(stage2_mass_num)) + " kg";

    if isempty(extractBetween(stage1_thrust.String, "Thrust: ", " kN")) == 0
        stack_tw.String = "Full Rocket T/W Ratio: " + string(round(10000 * str2double(string(extractBetween(stage1_thrust.String, "Thrust: ", " kN"))) / 9.8 / tot_rocket_mass) / 10);
    else
        stack_tw.String = "Full Rocket T/W Ratio: " + string(round(10000000 * str2double(string(extractBetween(stage1_thrust.String, "Thrust: ", " MN"))) / 9.8 / tot_rocket_mass) / 10);
    end

    if tot_rocket_cost < 1000000
        rocket_cost.String = "Net Cost: $" + string(round(10* tot_rocket_cost) / 10);
    else
        rocket_cost.String = "Net Cost: $" + string(round(tot_rocket_cost / 100000) / 10) + " Million";
    end

    if tw_ratio <= 1
        stage_tw.ForegroundColor = "red";
    else
        stage_tw.ForegroundColor = "black";
    end
    
    tank_diameter1 = str2double(tank1_dia.String);
    tank_radius1 = tank_diameter1 / 2;
    tank_height1_num = str2double(tank1_height.String);
    fair_thickness_num1 = str2double(fair_thickness1.String([30:end]));

    engine_length1_num = str2double(engine_length1.String);
    engine_radius1 = str2double(engine_diameter1.String) / 2;
    engine_x1 = linspace(-engine_radius1, engine_radius1, 100);
    % Obtain variables needed for calcs and plotting

    count_var1 = 1;
    for x_value = engine_x1
    % Engine contour
        engine_y1(count_var1) = engine_length1_num - ((engine_length1_num / (engine_radius1 ^ 2)) * x_value ^ 2);
        count_var1 = count_var1 + 1;
    end

    tank_x1 = linspace(-tank_radius1, tank_radius1, 100);
    tank_vertical_range = linspace(0, tank_height1_num - tank_diameter1, 100);

    tank_count_var4 = 1;
    for x_value = tank_x1
        tank1_y1(tank_count_var4) = -sqrt((tank_radius1^2) - x_value^2) + engine_length1_num + tank_radius1;
        tank_count_var4 = tank_count_var4 + 1;
    end

    tank_count_var5 = 1;
    for x_value = tank_vertical_range
        tank1_y2(tank_count_var5) = x_value + engine_length1_num + tank_radius1;
        tank_count_var5 = tank_count_var5 + 1;
    end

    tank_count_var6 = 1;
    for x_value = tank_x1
        tank1_y3(tank_count_var6) = sqrt((tank_radius1^2) - x_value^2) + engine_length1_num - tank_radius1 + tank_height1_num;
        tank_count_var6 = tank_count_var6 + 1;
    end

    fair_connect_left_r = linspace(-tank_radius1 - fair_thickness_num1, -tank_radius - fair_thickness_num, 100);
    fair_connect_right_r = linspace(tank_radius + fair_thickness_num, tank_radius1 + fair_thickness_num1,  100);
    stage1_height = engine_length1_num + tank_height1_num;
    fair_connect_slope = (-1.5 * engine_length) / (tank_radius1 + fair_thickness_num1/12 - tank_radius - fair_thickness_num/12);
    fair_connect_slope_pos = (1.5 * engine_length) / (1 - ((tank_radius1 + fair_thickness_num1 / 12) / (tank_radius + fair_thickness_num/12)));

    connect_count_1 = 1;
    for x_value = fair_connect_left_r
        fair_connect_left(connect_count_1) = fair_connect_slope * abs(x_value) - fair_connect_slope_pos + stage1_height + (1.5 * engine_length) + fair_thickness_num1;
        connect_count_1 = connect_count_1 + 1;
    end

    connect_count_2 = 1;
    for x_value = fair_connect_right_r
        fair_connect_right(connect_count_2) = fair_connect_slope * abs(x_value) - fair_connect_slope_pos + stage1_height + (1.5 * engine_length) + fair_thickness_num1;
        connect_count_2 = connect_count_2 + 1;
    end

    engine_y = engine_y + engine_length1_num + tank_height1_num + (0.5 * engine_length);
    tank_y1 = tank_y1 + engine_length1_num + tank_height1_num + (0.5 * engine_length);
    tank_y2 = tank_y2 + engine_length1_num + tank_height1_num + (0.5 * engine_length);
    tank_y3 = tank_y3 + engine_length1_num + tank_height1_num + (0.5 * engine_length);

    fair_vertical_range = linspace(engine_length1_num, engine_length1_num + tank_height1_num, 100);
    fair_vertical_left = linspace((-tank_radius1) - fair_thickness_num1, (-tank_radius1) - fair_thickness_num1, 100);
    fair_vertical_right = linspace((tank_radius1) + fair_thickness_num1, (tank_radius1) + fair_thickness_num1, 100);
    fair_horizontal_range = linspace((-tank_radius1) - fair_thickness_num1, (tank_radius1) + fair_thickness_num1, 100);
    fair_horizontal_top = linspace(engine_length1_num + tank_height1_num, engine_length1_num + tank_height1_num, 100);
    fair_horizontal_bot = linspace(engine_length1_num, engine_length1_num, 100);

    fair_vertical_range2 = linspace((engine_length * 1.5) + tank_height1_num + engine_length1_num, engine_length + tank_height + engine_length1_num + tank_height1_num + (0.5 * engine_length), 100);
    fair_vertical_left2 = linspace((-tank_radius) - fair_thickness_num, (-tank_radius) - fair_thickness_num, 100);
    fair_vertical_right2 = linspace((tank_radius) + fair_thickness_num, (tank_radius) + fair_thickness_num, 100);
    fair_horizontal_range2 = linspace((-tank_radius) - fair_thickness_num, (tank_radius) + fair_thickness_num, 100);
    fair_horizontal_top2 = linspace(engine_length1_num + tank_height1_num + (1.5 * engine_length) + tank_height, engine_length1_num + tank_height1_num + (1.5 * engine_length) + tank_height, 100);
    fair_horizontal_bot2 = linspace(engine_length1_num + tank_height1_num + (1.5 * engine_length), engine_length1_num + tank_height1_num + (1.5 * engine_length), 100);

    subplot("Position", [0.775 0.2 0.2 0.7]);
    plot(engine_x1, engine_y1, tank_x1, tank1_y1, linspace(tank_radius1, tank_radius1, 100), tank1_y2, tank_x1, tank1_y3, linspace(-tank_radius1, -tank_radius1, 100), tank1_y2, fair_vertical_left, fair_vertical_range, fair_vertical_right, fair_vertical_range, fair_horizontal_range, fair_horizontal_bot, fair_horizontal_range, fair_horizontal_top, engine_x, engine_y, tank_x, tank_y1, linspace(tank_radius, tank_radius, 100), tank_y2, tank_x, tank_y3, linspace(-tank_radius, -tank_radius, 100), tank_y2, fair_vertical_left2, fair_vertical_range2, fair_vertical_right2, fair_vertical_range2, fair_horizontal_range2, fair_horizontal_bot2, fair_horizontal_range2, fair_horizontal_top2, fair_connect_left_r, fair_connect_left, fair_connect_right_r, fair_connect_right, "Color", "#4a4b52");
    xlim([(tank_diameter1 / 2 + engine_length1_num + tank_height1_num + engine_length + tank_height)/-2 (tank_diameter1 / 2 + engine_length1_num + tank_height1_num + engine_length + tank_height)/2])
    ylim([0 (tank_diameter1 / 2 + engine_length1_num + tank_height1_num + engine_length + tank_height)])
    % Plot first stage engine + tank + fairings + nose cone + second stage
    % engine + second stage tank

    nosecone.Position(4) = 0.2;
    drag.Position(4) = 0.03*ScreenHeight;
    nose_weight.Position(4) = 0.03*ScreenHeight;
    nose_cost.Position(4) = 0.03*ScreenHeight;
    
end