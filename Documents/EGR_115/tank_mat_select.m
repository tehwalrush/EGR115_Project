function tank_mat_select(selected, event, material_info, tank_density, tank_strength, tank_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, tank_price_overall2, prop_select, prop_weight, prop_price_overall, prop_price_overall2, fair_price1, engine_thrust, engine_weight, engine_cost, engine_cost2, stage1_thrust, stage1_mass, stage2_mass, stage_tw, rocket_cost, stack_tw, stack_tw_string)

ScreenSize = get(groot, 'ScreenSize');
ScreenLength = ScreenSize(3);
ScreenHeight = ScreenSize(4);

for pos = 1:height(material_info)
    if selected.String == string(material_info{pos, "Name"})
        % Iterate over material_info data and match the selected material
        % to a particular set on the matrix

        tank_density_num = material_info{pos, "Density (kg/ft3)"};
        tank_strength_num = material_info{pos, "Yield Strength (kN/ft2)"};
        tank_price_num = material_info{pos, "Price per kg"};

        tank_density.String = "Density: " + string(tank_density_num) + " kg/ft3";
        tank_density.Position(4) = 0.03*ScreenHeight;
        
        tank_strength.String = "Strength: " + string(tank_strength_num) + " kN/ft2";
        tank_strength.Position(4) = 0.03*ScreenHeight;

        tank_price.String = "Price per kilogram: $" + string(tank_price_num);
        tank_price.Position(4) = 0.03*ScreenHeight;

        

    end
end

if isempty(tank_dia.String) == 0 && isempty(tank_height.String) == 0
%<SM:ROP>

    P_max = 7200 + (2 * str2double(tank_height.String) * 30);
    % Estimate for max chamber pressure

    tank_thickness_num = ((2/144) * P_max * (str2double(tank_dia.String) * 6) * 0.641) / tank_strength_num;
    tank_thickness.String = "Tank Wall Thickness (in): " + string(tank_thickness_num);

    % Assumes T/W at burnout to be 3
    % Assumes 30 lb/ft3 for prop.

    total_volume = (4/3) * pi * (str2double(tank_dia.String) / 2)^3 + pi * (str2double(tank_dia.String) / 2)^2 * str2double(tank_height.String);
    inside_volume = (4/3) * pi * ((str2double(tank_dia.String) / 2) - (tank_thickness_num / 12))^3 + pi * ((str2double(tank_dia.String) / 2) - (tank_thickness_num / 12))^2 * (str2double(tank_height.String) - (tank_thickness_num / 6));
    shell_volume = total_volume - inside_volume;
    % Calculate volume of the hollow tank
    
    tank_weight_num = shell_volume * tank_density_num;

    tank_weight.String = "Tank Weight (kg): " + string(round(tank_weight_num));

    prop_select.Position(4) = 0.36;

    prop_weight.Position(4) = 0.05*ScreenHeight;

    if strcmp(string(stack_tw_string), "0") == 1

        prop_price_overall.Position(4) = 0.05*ScreenHeight;

        tank_price_overall.String = "Tank Cost: $" + string(round(tank_weight_num * tank_price_num));

        total_weight = str2double(engine_weight.String) + round(tank_weight_num);
        total_cost = str2double(engine_cost.String) + round(tank_weight_num * tank_price_num);
        tw_ratio = str2double(engine_thrust.String) / (9.81 * total_weight);

        stage1_mass.String = "Mass: " + string(round(total_weight)) + " kg";
        stage_tw.String = "T/W Ratio: " + string(round(10 * tw_ratio) / 10);

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

    else

        prop_price_overall2.Position(4) = 0.05*ScreenHeight;

        tank_price_overall2.String = "Tank Cost: $" + string(round(tank_weight_num * tank_price_num));
        
        tot_rocket_mass = str2double(string(extractBetween(stage1_mass.String, "Mass: ", " kg"))) + str2double(engine_weight.String) + tank_weight_num;
        tot_rocket_cost = str2double(engine_cost.String) + round(str2double(tank_price_overall.String([13:end]))) + round(str2double(prop_price_overall.String([19:end]))) + round(str2double(fair_price1.String([16:end]))) + str2double(engine_cost2.String) + round(tank_weight_num * tank_price_num);
        stage2_mass_num = str2double(engine_weight.String) + tank_weight_num;

        tw_ratio = round(10 * str2double(engine_thrust.String) / 9.81 / stage2_mass_num) / 10;
        stage_tw.Position(4) = 0.03*ScreenHeight;
        stage_tw.String = "Stage 2 T/W Ratio: " + string(tw_ratio);
        
        stage2_mass.String = "Stage 2 Mass: " + string(round(stage2_mass_num)) + " kg";

        stage1_thrust_num = stage1_thrust.String;

        if isempty(extractBetween(stage1_thrust_num, "Thrust: ", " kN")) == 0
            stack_tw.String = "Full Rocket T/W Ratio: " + string(round(10000 * str2double(string(extractBetween(stage1_thrust_num, "Thrust: ", " kN"))) / 9.8 / tot_rocket_mass) / 10);
        else
            stack_tw.String = "Full Rocket T/W Ratio: " + string(round(10000000 * str2double(string(extractBetween(stage1_thrust_num, "Thrust: ", " MN"))) / 9.8 / tot_rocket_mass) / 10);
        end

        if tot_rocket_cost < 1000000
            rocket_cost.String = "Net Cost: $" + string(round(10* tot_rocket_cost) / 10);
        else
            rocket_cost.String = "Net Cost: $" + string(round(tot_rocket_cost / 100000) / 10) + " Million";
        end
    end
end