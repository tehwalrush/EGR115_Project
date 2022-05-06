function prop_select(selected, event, prop_info, prop_density, prop_isp, prop_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall1, tank_price_overall2, prop_weight, prop_price_overall, prop_price_overall1, engine_name, engine_prop, engine_base_thrust, engine_base_isp, engine_thrust, engine_isp, correction_message, isp_correction, thrust_correction, fairbutton, engine_weight, engine_weight2, engine_cost, engine_cost1, stage_thrust, stage1_thrust, stage_mass, stage1_mass, stage_tw, rocket_cost, stack_tw, stack_tw_string, fair_price1, engine_thrust2)

ScreenSize = get(groot, 'ScreenSize');
ScreenLength = ScreenSize(3);
ScreenHeight = ScreenSize(4);

for pos = 1:height(prop_info)
    if selected.String == string(prop_info{pos, "Name"})
        
        ratio = prop_info{pos, "Mix Ratio"};
        fuel_density = prop_info{pos, "Fuel Density (kg/ft3)"};
        ox_density = prop_info{pos, "Oxidizer Density (kg/ft3)"};
        fuel_cost = prop_info{pos, "Fuel Cost per kg"};
        ox_cost = prop_info{pos, "Oxidizer Cost per kg"};
        base_isp = prop_info{pos, "Base ISP"};
        % Gathere needed data from prop_info matrix for calculations

        overall_density = 1 / (((ratio / (ratio + 1)) / ox_density) + ((1 / (ratio + 1)) / fuel_density));
        overall_cost = 1 / (((ratio / (ratio + 1)) / ox_cost) + ((1 / (ratio + 1)) / fuel_cost));
        % Calculate density and cost of the bipropellant mixture

        prop_density.String = "Density: " + string(round(overall_density * 100) / 100) + " kg/ft3";
        prop_density.Position(4) = 0.05*ScreenHeight;

        prop_isp.String = "Base Specific Impulse: " + string(base_isp);
        prop_isp.Position(4) = 0.05*ScreenHeight;

        prop_price.String = "Price per kilogram: $" + string(round(overall_cost * 100) / 100);
        prop_price.Position(4) = 0.05*ScreenHeight;
        % Display data for propellant selected based on data table


        tank_thickness_num = str2double(tank_thickness.String(27:end));
        tank_volume = (4/3) * pi * ((str2double(tank_dia.String) / 2) - (tank_thickness_num / 12))^3 + pi * ((str2double(tank_dia.String) / 2) - (tank_thickness_num / 12))^2 * (str2double(tank_height.String) - 2 * tank_thickness_num);

        prop_weight_num = overall_density * tank_volume;
        % Calculate propellant weight from the volume of the hollow tank
        % and density

        prop_weight.String = "Propellant Weight (kg): " + string(round(prop_weight_num));
        prop_weight.Position(4) = 0.03*ScreenHeight;

        prop_price_num = overall_cost * prop_weight_num;

        prop_price_overall.String = "Propellant Cost: $" + string(round(prop_price_num));

        position = find(string(prop_info{:, "Name"}) == engine_prop.String);
        initial_base_isp = prop_info{position, "Base ISP"};

        isp_ratio = base_isp / initial_base_isp;

        final_isp = isp_ratio * str2double(engine_base_isp.String);
        final_thrust = isp_ratio * str2double(engine_base_thrust.String);
        % Corrections to engine thrust and specific impulse related to a
        % change in propellant - idealized estimations

        engine_isp.String = string(round(final_isp));
        engine_thrust.String = string(round(final_thrust));

        if strcmp(selected.String, engine_prop.String) == 0
        %<SM:STRING>
        % If a propellant was selected that the chosen engine does not
        % ususally use, display to the user that aspects were changed

            correction_message.String = "Your " + engine_name.String + " engine does not naturally use " + selected.String + ". Therefore, its parameters have changed.";
            correction_message.Position(4) = 0.06*ScreenHeight;

            isp_correction.String = "New Specific Impulse: " + string(round(final_isp));
            isp_correction.Position(4) = 0.03*ScreenHeight;

            thrust_correction.String = "New Thrust: " + string(round(final_thrust));
            thrust_correction.Position(4) = 0.03*ScreenHeight;
        
        elseif strcmp(selected.String, engine_prop.String) == 1
            correction_message.Position(4) = 0;
            isp_correction.Position(4) = 0;
            thrust_correction.Position(4) = 0;
        end

        if strcmp(string(stack_tw_string), "0") == 1

            fairbutton.Position(4) = 0.04*ScreenLength;
            % Make fairing button visible to user

            total_weight = str2double(engine_weight.String) + round(str2double(tank_weight.String([19:end]))) + round(prop_weight_num);
            total_cost = str2double(engine_cost.String) + round(str2double(tank_price_overall1.String([13:end]))) + round(prop_price_num);

            tw_ratio = str2double(engine_thrust.String) / (9.81 * total_weight);
        
            stage_mass.String = "Mass: " + string(round(total_weight)) + " kg";
            stage_tw.String = "T/W Ratio: " + string(round(10 * tw_ratio) / 10);

            if str2double(engine_thrust.String) < 1000000
                stage_thrust.String = "Thrust: " + string(round(str2double(engine_thrust.String) / 100) / 10) + " kN";
            else
                stage_thrust.String = "Thrust: " + string(round(str2double(engine_thrust.String) / 100000) / 10) + " MN";
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

        else

            fairbutton.Position(4) = 0.04*ScreenLength;

            tot_rocket_mass = str2double(string(extractBetween(stage1_mass.String, "Mass: ", " kg"))) + str2double(engine_weight2.String) + str2double(tank_weight.String([19:end])) + prop_weight_num;
            tot_rocket_cost = str2double(engine_cost1.String) + round(str2double(tank_price_overall1.String([13:end]))) + round(str2double(prop_price_overall1.String([19:end]))) + round(str2double(fair_price1.String([16:end]))) + str2double(engine_cost.String) + str2double(tank_price_overall2.String([13:end])) + prop_price_num;
            stage2_mass_num = str2double(engine_weight2.String) + str2double(tank_weight.String([19:end])) + prop_weight_num;

            tw_ratio = round(10 * str2double(engine_thrust2.String) / (9.81 * stage2_mass_num)) / 10;
            stage_tw.Position(4) = 0.03*ScreenHeight;
            stage_tw.String = "Stage 2 T/W Ratio: " + string(tw_ratio);
        
            stage_mass.String = "Stage 2 Mass: " + string(round(stage2_mass_num)) + " kg";

            if str2double(engine_thrust.String) < 1000000
                stage_thrust.String = "Stage 2 Thrust: " + string(round(str2double(engine_thrust.String) / 100) / 10) + " kN";
            else
                stage_thrust.String = "Stage 2 Thrust: " + string(round(str2double(engine_thrust.String) / 100000) / 10) + " MN";
            end

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

        end
    end
end
