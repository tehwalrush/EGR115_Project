function tank_dimensions(dim, event, other_dim, engine, engineinfo, engine_data, tank_strength, tank_density, tank_price, tank_thickness, tank_weight, tank_price_overall, tank_error_message, prop_select, prop_weight, prop_price_overall1, prop_price_overall2, engine_thrust, engine_weight, engine1_cost, engine2_cost, fair_price1, stage1_mass, stage1_thrust, stage2_mass, stage_tw, rocket_cost, stack_tw, stack_tw_string, tank1_dia, tank1_height, fair_thickness1, engine_length1, engine_diameter1)

ScreenSize = get(groot, 'ScreenSize');
ScreenLength = ScreenSize(3);
ScreenHeight = ScreenSize(4);

if dim.Position(2) == 0.7*ScreenHeight
% If dimension element selected is tank diameter
    tank_diameter_string = dim.String;
    tank_height_string = other_dim.String;
elseif dim.Position(2) == 0.64*ScreenHeight
% If dimension element selected is tank height
    tank_diameter_string = other_dim.String;
    tank_height_string = dim.String;
end

if isempty(tank_diameter_string) == 0 && isempty(tank_height_string) == 0 && isnan(str2double(tank_diameter_string)) == 0 && isnan(str2double(tank_height_string)) == 0 && str2double(tank_height_string) >= str2double(tank_diameter_string)
% Error checking of tank_diameter and tank_height - ensure that they both
% exist, are numbers, and that height >= diameter before moving on

    for pos = 1:length(engineinfo)
        if engineinfo(pos).Value == 1 
            name = engine(pos).String;
        end
    end

    location = find(string(engine_data{:, "Engine Name"}) == name);
    % Locate where the selected engine is in engine_data matrix

    engine_x = linspace((-engine_data{location, "Diameter (ft)"} / 2), (engine_data{location, "Diameter (ft)"} / 2), 100);
    engine_length = engine_data{location, "Length (ft)"};
    engine_radius = engine_data{location, "Diameter (ft)"} / 2;
    % Set prep variables for creation of engine contour

    count_var = 1;
    for x_value = engine_x
    % Create engine contour
        engine_y(count_var) = engine_length - ((engine_length / (engine_radius ^ 2)) * x_value ^ 2);
        count_var = count_var + 1;
    end
    
    tank_diameter = str2double(tank_diameter_string);
    tank_height = str2double(tank_height_string);

    tank_x = linspace(tank_diameter/-2, tank_diameter/2, 100);
    tank_vertical_range = linspace(0, tank_height - tank_diameter, 100);
    % Set prep variables for tank contour
    
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

    % The 3 for loops above create lines for the tank contour - a vertical
    % line and two semicircular patterns (for pill shape)

    tank_diameter = str2double(tank_diameter_string);
    tank_radius = tank_diameter / 2;
    tank_height = str2double(tank_height_string);

    if isempty(tank_density.String) == 0
        tank_strength_num = str2double(tank_strength.String(11:15));
        tank_density_num = str2double(tank_density.String(10:14));
        tank_price_num = str2double(tank_price.String(22:24));
        % Obtain needed variables for calculations from uicontrol strings

        P_max = 7200 + (2 * tank_height * 30);
        % Calculate max tank pressure

        tank_thickness_num = ((2/144) * P_max * (tank_diameter * 6) * 0.641) / tank_strength_num;
        tank_thickness.String = "Tank Wall Thickness (in): " + string(tank_thickness_num);

        % Assumes T/W at burnout to be 3
        % Assumes 30 lb/ft3 for prop.

        total_volume = ((4/3) * pi * (tank_diameter / 2)^3) + (pi * (tank_diameter / 2)^2 * tank_height);
        inside_volume = ((4/3) * pi * (tank_diameter / 2 - (tank_thickness_num / 12))^3) + (pi * (tank_diameter / 2 - (tank_thickness_num / 12))^2 * (tank_height - (tank_thickness_num / 6)));
        shell_volume = total_volume - inside_volume;
        % Volume of hollow tank
    
        tank_weight_num = shell_volume * tank_density_num;

        tank_weight.String = "Tank Weight (kg): " + string(round(tank_weight_num));

        tank_price_overall.String = "Tank Cost: $" + string(round(tank_weight_num * tank_price_num));

        tank_error_message.String = " ";
        % No user error - woohoo!

        prop_select.Position(4) = 0.36;
        prop_weight.Position(4) = 0.05*ScreenHeight;
        % Set up propellant selection for user

        if strcmp(string(stack_tw_string), "0") == 1
            prop_price_overall1.Position(4) = 0.05*ScreenHeight;
            total_weight = str2double(engine_weight.String) + round(tank_weight_num);
            total_cost = str2double(engine1_cost.String) + round(tank_weight_num * tank_price_num);

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

            subplot("Position", [0.775 0.2 0.2 0.7]);
            plot(engine_x, engine_y, tank_x, tank_y1, linspace(tank_diameter/2, tank_diameter/2, 100), tank_y2, tank_x, tank_y3, linspace(tank_diameter/-2, tank_diameter/-2, 100), tank_y2, "Color", "#4a4b52");
            % Plot engine and tank contours

            xlim([(tank_diameter / 2 + engine_length + tank_height)/-2 (tank_diameter / 2 + engine_length + tank_height)/2])
            ylim([0 (tank_diameter / 2 + engine_length + tank_height)])
        
        else

            prop_price_overall2.Position(4) = 0.05*ScreenHeight;
            tot_rocket_mass = str2double(string(extractBetween(stage1_mass.String, "Mass: ", " kg"))) + str2double(engine_weight.String) + tank_weight_num;
            tot_rocket_cost = str2double(engine1_cost.String) + round(str2double(tank_price_overall.String([13:end]))) + round(str2double(prop_price_overall1.String([19:end]))) + round(str2double(fair_price1.String([16:end]))) + str2double(engine2_cost.String) + round(tank_weight_num * tank_price_num);
            stage2_mass_num = str2double(engine_weight.String) + tank_weight_num;

            tw_ratio = round(10 * str2double(engine_thrust.String) / (9.81 * stage2_mass_num)) / 10;
            stage_tw.Position(4) = 0.03*ScreenHeight;
            stage_tw.String = "Stage 2 T/W Ratio: " + string(tw_ratio);
        
            stage2_mass.String = "Stage 2 Mass: " + string(round(stage2_mass_num)) + " kg";

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
            fair_thickness_num = str2double(fair_thickness1.String([30:end]));

            engine_length1_num = str2double(engine_length1.String);
            engine_radius1 = str2double(engine_diameter1.String) / 2;
            engine_x1 = linspace(-engine_radius1, engine_radius1, 100);
            % Obtain variables needed for calcs and plotting

            engine_y = engine_y + engine_length1_num + tank_height1_num + (0.5 * engine_length);
            tank_y1 = tank_y1 + engine_length1_num + tank_height1_num + (0.5 * engine_length);
            tank_y2 = tank_y2 + engine_length1_num + tank_height1_num + (0.5 * engine_length);
            tank_y3 = tank_y3 + engine_length1_num + tank_height1_num + (0.5 * engine_length);

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
            % Tank contour

            fair_vertical_range = linspace(engine_length1_num, engine_length1_num + tank_height1_num, 100);
            fair_vertical_left = linspace((-tank_radius1) - fair_thickness_num, (-tank_radius1) - fair_thickness_num, 100);
            fair_vertical_right = linspace((tank_radius1) + fair_thickness_num, (tank_radius1) + fair_thickness_num, 100);
            fair_horizontal_range = linspace((-tank_radius1) - fair_thickness_num, (tank_radius1) + fair_thickness_num, 100);
            fair_horizontal_top = linspace(engine_length1_num + tank_height1_num, engine_length1_num + tank_height1_num, 100);
            fair_horizontal_bot = linspace(engine_length1_num, engine_length1_num, 100);

            subplot("Position", [0.775 0.2 0.2 0.7]);
            plot(engine_x1, engine_y1, tank_x1, tank1_y1, linspace(tank_radius1, tank_radius1, 100), tank1_y2, tank_x1, tank1_y3, linspace(-tank_radius1, -tank_radius1, 100), tank1_y2, fair_vertical_left, fair_vertical_range, fair_vertical_right, fair_vertical_range, fair_horizontal_range, fair_horizontal_bot, fair_horizontal_range, fair_horizontal_top, engine_x, engine_y, tank_x, tank_y1, linspace(tank_radius, tank_radius, 100), tank_y2, tank_x, tank_y3, linspace(-tank_radius, -tank_radius, 100), tank_y2, "Color", "#4a4b52");
            xlim([(tank_diameter1 / 2 + engine_length1_num + tank_height1_num + engine_length + tank_height)/-2 (tank_diameter1 / 2 + engine_length1_num + tank_height1_num + engine_length + tank_height)/2])
            ylim([0 (tank_diameter1 / 2 + engine_length1_num + tank_height1_num + engine_length + tank_height)])
            % Plot first stage engine + tank + fairings + nose cone + second stage
            % engine + second stage tank

        end

    end
elseif isempty(tank_height_string) == 1 || isempty(tank_diameter_string) == 1
    tank_error_message.String = " ";

elseif isnan(str2double(tank_diameter_string)) == 1 && isempty(tank_height_string) == 0
    tank_error_message.String = "ERROR: Tank diameter must be a real number";

elseif isnan(str2double(tank_height_string)) == 1 && isempty(tank_diameter_string) == 0
    tank_error_message.String = "ERROR: Tank height must be a real number";

elseif str2double(tank_height_string) < str2double(tank_diameter_string)
    tank_error_message.String = "ERROR: Tank height must be larger than diameter";
end
% Display error message relating to what the user did wrong