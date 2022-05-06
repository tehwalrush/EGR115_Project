function nosecone_dim(dim, event, other_dim, engine_length, engine_diameter, engine_diameter1, tank_dia, tank1_dia, tank_height, tank1_height, tank_weight, tank_price_overall, tank_price_overall1, prop_weight, prop_price_overall, prop_price_overall1, fair_thickness, fair_thickness1, fair_density, fair_weight, fair_weight1, fair_price, fair_price1, fair_price_ov2, drag, nose_weight, nose_cost, sim_button, engine_thrust, engine_length1, engine_weight, engine_cost, engine1_cost, stage_mass, stage1_mass, stage1_thrust, stage_tw, rocket_cost, stack_tw, stack_tw_string)

ScreenSize = get(groot, 'ScreenSize');
ScreenLength = ScreenSize(3);
ScreenHeight = ScreenSize(4);

if dim.Position(2) == 0.08*ScreenHeight
% If the dimension selected is the nose cone length
    nose_length = dim.String;
    nose_power = other_dim.String;

elseif dim.Position(2) == 0.03*ScreenHeight
% If the dimension selected is the nose cone geo. power
    nose_power = dim.String;
    nose_length = other_dim.String;
end

if isempty(nose_length) == 0 && isempty(nose_power) == 0 && isnan(str2double(nose_length)) == 0 && isnan(str2double(nose_power)) == 0 && str2double(nose_power) >= 1 && str2double(nose_length) > 0
% Error checks the user inputs - ensures that the variables exist and are
% numbers before proceeding

    tank_diameter = str2double(tank_dia.String);
    tank_radius = tank_diameter / 2;
    tank_height = str2double(tank_height.String);
    fair_thickness_num = str2double(fair_thickness.String([30:end]));

    nose_length_num = str2double(nose_length);
    nose_power_num = str2double(nose_power);

    engine_length = str2double(engine_length.String);
    engine_radius = str2double(engine_diameter.String) / 2;
    engine_x = linspace(-engine_radius, engine_radius, 100);
    % Obtain variables needed for calcs and plotting


    count_var = 1;
    for x_value = engine_x
    % Engine contour
        engine_y(count_var) = engine_length - ((engine_length / (engine_radius ^ 2)) * x_value ^ 2);
        count_var = count_var + 1;
    end

    tank_x = linspace(-tank_radius, tank_radius, 100);
    tank_vertical_range = linspace(0, tank_height - tank_diameter, 100);
    
    tank_count_var = 1;
    for x_value = tank_x
        tank_y1(tank_count_var) = -sqrt((tank_radius^2) - x_value^2) + engine_length + tank_radius;
        tank_count_var = tank_count_var + 1;
    end

    tank_count_var2 = 1;
    for x_value = tank_vertical_range
        tank_y2(tank_count_var2) = x_value + engine_length + tank_radius;
        tank_count_var2 = tank_count_var2 + 1;
    end

    tank_count_var3 = 1;
    for x_value = tank_x
        tank_y3(tank_count_var3) = sqrt((tank_radius^2) - x_value^2) + engine_length - tank_radius + tank_height;
        tank_count_var3 = tank_count_var3 + 1;
    end
    % Tank contour
    
    tank_thick_x = linspace((-tank_radius) - fair_thickness_num, (tank_radius) + fair_thickness_num, 100);
    % This is needed to attach the nose cone to the fairings instead of the
    % tank (which is probably a good idea)

    nose_count_var = 1;
    for x_value = tank_thick_x
    % Nose cone contour
        nose_curve(nose_count_var) = -1 * nose_length_num / (tank_radius + fair_thickness_num)^nose_power_num * abs(x_value)^nose_power_num + nose_length_num + tank_height + engine_length;
        nose_count_var = nose_count_var + 1;
    end
    

    if strcmp(string(stack_tw_string), "0") == 1

        fair_vertical_range = linspace(engine_length, engine_length + tank_height, 100);
        fair_vertical_left = linspace((-tank_radius) - fair_thickness_num, (-tank_radius) - fair_thickness_num, 100);
        fair_vertical_right = linspace((tank_radius) + fair_thickness_num, (tank_radius) + fair_thickness_num, 100);
        fair_horizontal_range = linspace((-tank_radius) - fair_thickness_num, (tank_radius) + fair_thickness_num, 100);
        fair_horizontal_top = linspace(engine_length + tank_height, engine_length + tank_height, 100);
        fair_horizontal_bot = linspace(engine_length, engine_length, 100);
    
        subplot("Position", [0.775 0.2 0.2 0.7]);
        plot(engine_x, engine_y, tank_x, tank_y1, linspace(tank_radius, tank_radius, 100), tank_y2, tank_x, tank_y3, linspace(-tank_radius, -tank_radius, 100), tank_y2, fair_vertical_left, fair_vertical_range, fair_vertical_right, fair_vertical_range, fair_horizontal_range, fair_horizontal_bot, fair_horizontal_range, fair_horizontal_top, tank_thick_x, nose_curve, "Color", "#4a4b52");
        % Plot engine + tank + fairings + nose cone
    
        xlim([(tank_radius + engine_length + tank_height + nose_length_num)/-2 (tank_radius + engine_length + tank_height + nose_length_num)/2])
        ylim([0 (tank_radius + engine_length + tank_height + nose_length_num)])
        
        Cd = 0.5 * (( tank_radius / nose_length_num * abs(nose_power_num - (2 * nose_length_num / pi / tank_radius))) ^ 0.1);
        % Pretty rough estimate since Cd is obtained experimentally, but
        % the numbers involved in this allows the user to try to optimize by
        % iteration
    
        rho = 1.225;
        % Air density at STP in metric units (kg/m3)
    
        front_area = pi * (tank_radius + fair_thickness_num/12)^2;
    
        surf_area_equation = @(x) (( cos( (pi * x) / (2 * (tank_radius + fair_thickness_num/12)) ) .^ (nose_power_num / 2) ));
        surf_area = sqrt(2) * 2 * nose_length_num * integral(surf_area_equation, -tank_radius - fair_thickness_num/12, tank_radius + fair_thickness_num/12);
        % Estimate based on double integation equation for surface area
        % Second integral cannot be simplified (to my knowledge) but area can still 
        % be calculated
    
        front_area_metric = front_area / 10.764;
        % ft2  ->  m2  for calculation of force in Newtons
    
        drag_per_v2 = Cd * rho * front_area_metric / 2;
        % Newtons of drag per unit velocity squared (m2/s2)
        % Translates to "Newton-kilograms per joule"
    
        drag.String = "Estimated drag: " + string(drag_per_v2) + " Newtons/v2";
        drag.Position(4) = 0.03*ScreenHeight;
        
        total_vol_equation = @(x) (-nose_length_num/((tank_radius+fair_thickness_num/12).^nose_power_num)/(nose_power_num+1)).*((tank_radius+fair_thickness_num/12).^2-x.^2).^(nose_power_num/2+1/2)+(nose_length_num).*(sqrt((tank_radius+fair_thickness_num/12).^2-x.^2));
        total_volume = 4 * integral(total_vol_equation, 0, tank_radius + fair_thickness_num/12);
        % Total volume of the nosecone estimated by double integral
        % End result multiplied by 4 since the volume was split into four equal
        % parts to make lower bounds 0
    
        inside_vol_equation = @(x) (-nose_length_num/((tank_radius).^nose_power_num)/(nose_power_num+1)).*((tank_radius).^2-x.^2).^(nose_power_num/2+1/2)+(nose_length_num).*(sqrt((tank_radius).^2-x.^2));
        inside_volume = 4 * integral(inside_vol_equation, 0, tank_radius);
        % Volume of the inside of the nosecone estimated by double integral
    
        shell_nose_vol = total_volume - inside_volume;
    
        nose_density_num = str2double(fair_density.String([10:14]));
    
        nose_weight_num = shell_nose_vol * nose_density_num;
    
        nose_weight.String = "Nose cone weight (kg): " + string(round(nose_weight_num));
        nose_weight.Position(4) = 0.03*ScreenHeight;
    
        price_num = str2double(fair_price.String([22:end]));
    
        nose_price_num = price_num * nose_weight_num;
    
        nose_cost.String = "Nose cone cost: $" + string(round(nose_price_num));
        nose_cost.Position(4) = 0.03*ScreenHeight;
    
        total_weight = str2double(engine_weight.String) + round(str2double(tank_weight.String([19:end]))) + round(str2double(prop_weight.String([25:end]))) + round(str2double(fair_weight.String([22:end]))) + round(nose_weight_num);
        total_cost = str2double(engine_cost.String) + round(str2double(tank_price_overall.String([13:end]))) + round(str2double(prop_price_overall.String([19:end]))) + (round(str2double(fair_price.String([22:end]))) * round(str2double(fair_weight.String([22:end])))) + round(nose_price_num);
    
        tw_ratio = str2double(engine_thrust.String) / (9.81 * total_weight);
            
        stage_mass.String = "Mass: " + string(round(total_weight)) + " kg";
        stage_tw.String = "T/W Ratio: " + string(round(10 * tw_ratio) / 10);
    
        if total_cost < 1000000
            rocket_cost.String = "Net cost: $" + string(round(total_cost));
        else
            rocket_cost.String = "Net cost: $" + string(round(total_cost / 100000) / 10) + " Million";
        end
    
        if tw_ratio <= 1
            stage_tw.ForegroundColor = "red";
        else
            stage_tw.ForegroundColor = "black";
        end

    else

        tank_diameter1 = str2double(tank1_dia.String);
        tank_radius1 = tank_diameter1 / 2;
        tank_height1_num = str2double(tank1_height.String);
        fair_thickness_num1 = str2double(fair_thickness1.String([30:end]));
    
        engine_length1_num = str2double(engine_length1.String);
        engine_radius1 = str2double(engine_diameter1.String) / 2;
        engine_x1 = linspace(-engine_radius1, engine_radius1, 100);
        % Obtain variables needed for calcs and plotting

        Cd = 0.5 * (( tank_radius / nose_length_num * abs(nose_power_num - (2 * nose_length_num / pi / tank_radius))) ^ 0.1);
        % Pretty rough estimate since Cd is obtained experimentally, but
        % the numbers involved in this allows the user to try to optimize by
        % iteration
    
        rho = 1.225;
        % Air density at STP in metric units (kg/m3)
    
        front_area = pi * (tank_radius + fair_thickness_num/12)^2;
    
        surf_area_equation = @(x) (( cos( (pi * x) / (2 * (tank_radius + fair_thickness_num/12)) ) .^ (nose_power_num / 2) ));
        surf_area = sqrt(2) * 2 * nose_length_num * integral(surf_area_equation, -tank_radius - fair_thickness_num/12, tank_radius + fair_thickness_num/12);
        % Estimate based on double integation equation for surface area
        % Second integral cannot be simplified (to my knowledge) but area can still 
        % be calculated
    
        front_area_metric = front_area / 10.764;
        % ft2  ->  m2  for calculation of force in Newtons
    
        drag_per_v2 = Cd * rho * front_area_metric / 2;
        % Newtons of drag per unit velocity squared (m2/s2)
        % Translates to "Newton-kilograms per joule"
    
        drag.String = "Estimated drag: " + string(drag_per_v2) + " Newtons/v2";
        drag.Position(4) = 0.03*ScreenHeight;
        
        total_vol_equation = @(x) (-nose_length_num/((tank_radius+fair_thickness_num/12).^nose_power_num)/(nose_power_num+1)).*((tank_radius+fair_thickness_num/12).^2-x.^2).^(nose_power_num/2+1/2)+(nose_length_num).*(sqrt((tank_radius+fair_thickness_num/12).^2-x.^2));
        total_volume = 4 * integral(total_vol_equation, 0, tank_radius + fair_thickness_num/12);
        % Total volume of the nosecone estimated by double integral
        % End result multiplied by 4 since the volume was split into four equal
        % parts to make lower bounds 0
    
        inside_vol_equation = @(x) (-nose_length_num/((tank_radius).^nose_power_num)/(nose_power_num+1)).*((tank_radius).^2-x.^2).^(nose_power_num/2+1/2)+(nose_length_num).*(sqrt((tank_radius).^2-x.^2));
        inside_volume = 4 * integral(inside_vol_equation, 0, tank_radius);
        % Volume of the inside of the nosecone estimated by double integral
    
        shell_nose_vol = total_volume - inside_volume;
    
        nose_density_num = str2double(fair_density.String([10:14]));
    
        nose_weight_num = shell_nose_vol * nose_density_num;
    
        nose_weight.String = "Nose cone weight (kg): " + string(round(nose_weight_num));
        nose_weight.Position(4) = 0.03*ScreenHeight;

        price_num = str2double(fair_price.String([22:end]));
        
        nose_price_num = price_num * nose_weight_num;
    
        nose_cost.String = "Nose cone cost: $" + string(round(nose_price_num));
        nose_cost.Position(4) = 0.03*ScreenHeight;
        
        tot_rocket_mass = str2double(string(extractBetween(stage1_mass.String, "Mass: ", " kg"))) + str2double(engine_weight.String) + str2double(tank_weight.String([19:end])) + str2double(prop_weight.String([25:end])) + str2double(fair_weight.String([22:end])) + nose_weight_num;
        tot_rocket_cost = str2double(engine1_cost.String) + round(str2double(tank_price_overall1.String([13:end]))) + round(str2double(prop_price_overall1.String([19:end]))) + round(str2double(fair_price1.String([16:end]))) + str2double(engine_cost.String) + str2double(tank_price_overall.String([13:end])) + str2double(prop_price_overall.String([19:end])) + str2double(fair_price_ov2.String([16:end])) + nose_price_num;
        stage2_mass_num = str2double(engine_weight.String) + str2double(tank_weight.String([19:end])) + str2double(prop_weight.String([25:end])) + str2double(fair_weight.String([22:end])) + nose_weight_num;
    
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

        nose_curve = nose_curve + engine_length1_num + tank_height1_num + (0.5 * engine_length);
    
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
        plot(engine_x1, engine_y1, tank_x1, tank1_y1, linspace(tank_radius1, tank_radius1, 100), tank1_y2, tank_x1, tank1_y3, linspace(-tank_radius1, -tank_radius1, 100), tank1_y2, fair_vertical_left, fair_vertical_range, fair_vertical_right, fair_vertical_range, fair_horizontal_range, fair_horizontal_bot, fair_horizontal_range, fair_horizontal_top, engine_x, engine_y, tank_x, tank_y1, linspace(tank_radius, tank_radius, 100), tank_y2, tank_x, tank_y3, linspace(-tank_radius, -tank_radius, 100), tank_y2, fair_vertical_left2, fair_vertical_range2, fair_vertical_right2, fair_vertical_range2, fair_horizontal_range2, fair_horizontal_bot2, fair_horizontal_range2, fair_horizontal_top2, fair_connect_left_r, fair_connect_left, fair_connect_right_r, fair_connect_right, tank_thick_x, nose_curve, "Color", "#4a4b52");
        xlim([(tank_diameter1 / 2 + engine_length1_num + tank_height1_num + engine_length + tank_height + nose_length_num)/-2 (tank_diameter1 / 2 + engine_length1_num + tank_height1_num + engine_length + tank_height + nose_length_num)/2])
        ylim([0 (tank_diameter1 / 2 + engine_length1_num + tank_height1_num + engine_length + tank_height + nose_length_num)])
        % Plot first stage engine + tank + fairings + nose cone + second stage
        % engine + second stage tank

    end


    sim_button.Position(4) = 0.04*ScreenLength;

end