clear, clc


ScreenSize = get(groot, 'ScreenSize');
ScreenLength = ScreenSize(3);
ScreenHeight = ScreenSize(4);

fig_window = figure();

fig_window.WindowState = 'maximized';
% Gather data about screen size and display GUI window on max

engine_data = readtable("engine_data.xlsx", "VariableNamingRule", "preserve");
material_info = readtable("material_info.xlsx", "VariableNamingRule", "preserve");
prop_info = readtable("prop_data.xlsx", "VariableNamingRule", "preserve");
%<SM:READ>
% Read info in data tables and set to variables

engine_slide = uicontrol("Style", "slider", "Position", [0.01*ScreenLength 0.15*ScreenHeight 0.01*ScreenLength 0.6*ScreenHeight], "BackgroundColor", "#cccccc");
engine_slide.Value = 1;
% Make a slider that scrolls through engines for selection

applybutton = uicontrol("Style", "pushbutton", "String", "Apply", "Position", [(0.13*ScreenLength) (0.48*ScreenHeight) (0.06*ScreenLength) 0], "FontSize", 12, "BackgroundColor", "#6ffc9c");
deselectbutton = uicontrol("Style", "pushbutton", "String", "Deselect", "Position", [(0.22*ScreenLength) (0.48*ScreenHeight) (0.06*ScreenLength) 0], "FontSize", 12, "BackgroundColor", "#ff9494");
% Make pushbuttons for applying an engine to configuration and
% deselection of engine

enginecount = 0;
% Initialize enginecount variable

for i = 1:height(engine_data)
% <SM:FOR>
    if string(engine_data{i,"Stage"}) == "L"
    % In the excel file, if the engine is a lower stage engine, ...
    % <SM:IF>
    % <SM:NEST>

        enginecount = enginecount + 1;
        
        engineinfo_text = sprintf("Manufacturer: " + string(engine_data{i, "Make"}) + "\n\n" + "Cost: " + "$" + string(engine_data{i, "Cost ($)"}) + "\n\n" + "Thrust: " + string(engine_data{i, "Thrust (N)"}) + " Newtons" + "\n\n" + "Specific Impulse: " + string(engine_data{i, "Isp"}) + ... 
        "\n\n" + "Weight: " + string(engine_data{i, "Weight (kg)"}) + " kg");
        % For each engine, at data from excel file corresponding to it

        engine(enginecount) = uicontrol("Style", "pushbutton", "String", string(engine_data{i,"Engine Name"}), "Position", [(0.025*ScreenLength) (0.7*ScreenHeight - 0.07*(enginecount-1)*ScreenHeight) (0.08*ScreenLength) (0.05*ScreenHeight)], "FontSize", 13);
        % Toggle button for display of information for each engine

        engineinfo(enginecount) = uicontrol("Style", "text", "String", engineinfo_text, "Position", [(0.11*ScreenLength) (0.53*ScreenHeight) (0.2*ScreenLength) 0], "FontSize", 13);
        % Create text box for engine information

        engine(enginecount).Callback = {@engineinfo, engine_data, engineinfo, applybutton, deselectbutton};
        % When button is pressed for a specific engine, go to engineinfo
        % function
    end
end

engine_name = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_cost = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_base_thrust = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_base_isp = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_weight = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_diameter = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_length = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_prop = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_isp = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_thrust = uicontrol("Style", "text", "Position", [0 0 0 0]);
% Create variables for every aspect of the engine chosen. These are useful
% for future functions so that iterations through engine_data matrix do not
% need to occur

stage1_thrust = uicontrol("Style", "text", "String", "Thrust: ", "Position", [(0.72*ScreenLength) (0.08*ScreenHeight) (0.12*ScreenLength) 0], "FontSize", 12);
stage1_mass = uicontrol("Style", "text", "String", "Mass: ", "Position", [(0.85*ScreenLength) (0.08*ScreenHeight) (0.12*ScreenLength) 0], "FontSize", 12);
stage1_tw = uicontrol("Style", "text", "String", "T/W Ratio: ", "Position", [(0.72*ScreenLength) (0.04*ScreenHeight) (0.12*ScreenLength) 0], "FontSize", 12);
rocket_cost = uicontrol("Style", "text", "String", "Net Cost: ", "Position", [(0.85*ScreenLength) (0.04*ScreenHeight) (0.12*ScreenLength) 0], "FontSize", 12);

engine_slide.Callback = {@engineL_slider, engine};
% Toggle slider with engineL_slider function and pass engine variable

deselectbutton.Callback = {@deselect, engineinfo, applybutton};
% Toggle deselection button, allowing user to choose engines multiple times

enginebutton = uicontrol("Style", "pushbutton", "String", "Engine", "Position", [(0.11*ScreenLength) (0.78*ScreenHeight) (0.1*ScreenLength) (0.04*ScreenLength)], "FontSize", 18);
% Button for toggling the engine section of first stage construction




tankbutton = uicontrol("Style", "pushbutton", "String", "Tanks", "Position", [(0.22*ScreenLength) (0.78*ScreenHeight) (0.1*ScreenLength) 0], "FontSize", 18);
% Button for toggling the tank section of first stage construction

tank_mat_select = uibuttongroup("Position", [0.02 0.52 0.3 0], "Title", "Propellant Tank Material:   ", "FontSize", 15);
prop_select = uibuttongroup("Position", [0.02 0.1 0.3 0], "Title", "Propellant Type: ", "FontSize", 15);
% Create button groups early on so that they may be referenced in later
% callback functions

prop_weight = uicontrol("Style", "text", "Position", [0.34*ScreenLength 0.33*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
prop_price_overall = uicontrol("Style", "text", "Position", [0.33*ScreenLength 0.26*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
% Display to user overall weight and cost of propellant

tank_dia_text = uicontrol("Style", "text", "String", "Tank Diameter (ft): ", "Position", [0.345*ScreenLength 0.7*ScreenHeight (0.1*ScreenLength) 0], "FontSize", 12);
tank_dia = uicontrol("Style", "edit", "Position", [0.445*ScreenLength 0.7*ScreenHeight (0.04*ScreenLength) 0], "FontSize", 12);
% Create edit for user to input a tank diameter to be of use for program

tank_height_text = uicontrol("Style", "text", "String", "Tank Height (ft): ", "Position", [0.34*ScreenLength 0.64*ScreenHeight (0.1*ScreenLength) 0], "FontSize", 12);
tank_height = uicontrol("Style", "edit", "Position", [0.445*ScreenLength 0.64*ScreenHeight (0.04*ScreenLength) 0], "FontSize", 12);
% Create edit for user to input a tank height to be of use for program

tank_error_message = uicontrol("Style", "text", "String", " ", "Position", [0.5*ScreenLength 0.65*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12, "ForegroundColor", "red");
% If the user makes a mistake on input, this message will display red text
% with what the error is

tank_thickness = uicontrol("Style", "text", "String", "Tank Wall Thickness (in): ", "Position", [0.325*ScreenLength 0.53*ScreenHeight (0.17*ScreenLength) 0], "FontSize", 12);
tank_weight = uicontrol("Style", "text", "String", "Tank Weight (kg): ", "Position", [0.328*ScreenLength 0.485*ScreenHeight (0.13*ScreenLength) 0], "FontSize", 12);
tank_price_overall = uicontrol("Style", "text", "String", "Tank Cost: ", "Position", [0.325*ScreenLength 0.44*ScreenHeight (0.11*ScreenLength) 0], "FontSize", 12);

tank_density = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.58*ScreenHeight (0.12*ScreenLength) 0], "FontSize", 12);
tank_strength = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.53*ScreenHeight (0.12*ScreenLength) 0], "FontSize", 12);
tank_price = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.48*ScreenHeight (0.12*ScreenLength) 0], "FontSize", 12);
% Variables above relate to their respective attributes for prop tank

uicontrol("Style", "radiobutton", "String", "Grade H Steel", "Parent", tank_mat_select, "Position", [0.01*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@tank_mat_select, material_info, tank_density, tank_strength, tank_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, 0, prop_select, prop_weight, prop_price_overall, 0, 0, engine_thrust, engine_weight, engine_cost, 0, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0});
uicontrol("Style", "radiobutton", "String", "Grade A Steel", "Parent", tank_mat_select, "Position", [0.1*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@tank_mat_select, material_info, tank_density, tank_strength, tank_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, 0, prop_select, prop_weight, prop_price_overall, 0, 0, engine_thrust, engine_weight, engine_cost, 0, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0});
uicontrol("Style", "radiobutton", "String", "Stainless Steel", "Parent", tank_mat_select, "Position", [0.2*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@tank_mat_select, material_info, tank_density, tank_strength, tank_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, 0, prop_select, prop_weight, prop_price_overall, 0, 0, engine_thrust, engine_weight, engine_cost, 0, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0});
uicontrol("Style", "radiobutton", "String", "Aluminum 6063", "Parent", tank_mat_select, "Position", [0.01*ScreenLength 0.18*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@tank_mat_select, material_info, tank_density, tank_strength, tank_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, 0, prop_select, prop_weight, prop_price_overall, 0, 0, engine_thrust, engine_weight, engine_cost, 0, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0});
uicontrol("Style", "radiobutton", "String", "Aluminum 6061", "Parent", tank_mat_select, "Position", [0.1*ScreenLength 0.18*ScreenHeight (0.09*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@tank_mat_select, material_info, tank_density, tank_strength, tank_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, 0, prop_select, prop_weight, prop_price_overall, 0, 0, engine_thrust, engine_weight, engine_cost, 0, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0});
uicontrol("Style", "radiobutton", "String", "Aluminum 7075", "Parent", tank_mat_select, "Position", [0.2*ScreenLength 0.18*ScreenHeight (0.09*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@tank_mat_select, material_info, tank_density, tank_strength, tank_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, 0, prop_select, prop_weight, prop_price_overall, 0, 0, engine_thrust, engine_weight, engine_cost, 0, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0});
% Buttons for tank material selection

prop_density = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.21*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
prop_isp = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.16*ScreenHeight (0.16*ScreenLength) 0], "FontSize", 12);
prop_price = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.11*ScreenHeight (0.16*ScreenLength) 0], "FontSize", 12);
% Variables related to propellant attributes

correction_message = uicontrol("Style", "text", "Position", [0.32*ScreenLength 0.16*ScreenHeight (0.28*ScreenLength) 0], "FontSize", 12);
isp_correction = uicontrol("Style", "text", "Position", [0.33*ScreenLength 0.14*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
thrust_correction = uicontrol("Style", "text", "Position", [0.325*ScreenLength 0.09*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
% If the propellant is not native to the engine that was selected,
% calculate and display the corrections related to Isp and thrust

fairbutton = uicontrol("Style", "pushbutton", "String", "Fairings", "Position", [(0.33*ScreenLength) (0.78*ScreenHeight) (0.1*ScreenLength) 0], "FontSize", 18);
% Button for toggling the fairing section of first stage construction

uicontrol("Style", "radiobutton", "String", "Hydrolox", "Parent", prop_select, "Position", [0.01*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@prop_select, prop_info, prop_density, prop_isp, prop_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, engine_name, engine_prop, engine_base_thrust, engine_base_isp, engine_thrust, engine_isp, correction_message, isp_correction, thrust_correction, fairbutton, engine_weight, 0, engine_cost, 0, stage1_thrust, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0, 0, 0});
uicontrol("Style", "radiobutton", "String", "Hydrolox:Be", "Parent", prop_select, "Position", [0.1*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@prop_select, prop_info, prop_density, prop_isp, prop_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, engine_name, engine_prop, engine_base_thrust, engine_base_isp, engine_thrust, engine_isp, correction_message, isp_correction, thrust_correction, fairbutton, engine_weight, 0, engine_cost, 0, stage1_thrust, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0, 0, 0});
uicontrol("Style", "radiobutton", "String", "Kerolox", "Parent", prop_select, "Position", [0.2*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@prop_select, prop_info, prop_density, prop_isp, prop_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, engine_name, engine_prop, engine_base_thrust, engine_base_isp, engine_thrust, engine_isp, correction_message, isp_correction, thrust_correction, fairbutton, engine_weight, 0, engine_cost, 0, stage1_thrust, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0, 0, 0});
uicontrol("Style", "radiobutton", "String", "Methalox", "Parent", prop_select, "Position", [0.01*ScreenLength 0.18*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@prop_select, prop_info, prop_density, prop_isp, prop_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, engine_name, engine_prop, engine_base_thrust, engine_base_isp, engine_thrust, engine_isp, correction_message, isp_correction, thrust_correction, fairbutton, engine_weight, 0, engine_cost, 0, stage1_thrust, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0, 0, 0});
uicontrol("Style", "radiobutton", "String", "Hydroflourine", "Parent", prop_select, "Position", [0.1*ScreenLength 0.18*ScreenHeight (0.09*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@prop_select, prop_info, prop_density, prop_isp, prop_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, engine_name, engine_prop, engine_base_thrust, engine_base_isp, engine_thrust, engine_isp, correction_message, isp_correction, thrust_correction, fairbutton, engine_weight, 0, engine_cost, 0, stage1_thrust, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0, 0, 0});
uicontrol("Style", "radiobutton", "String", "Hydroflourine:Li", "Parent", prop_select, "Position", [0.2*ScreenLength 0.18*ScreenHeight (0.09*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@prop_select, prop_info, prop_density, prop_isp, prop_price, tank_dia, tank_height, tank_thickness, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, engine_name, engine_prop, engine_base_thrust, engine_base_isp, engine_thrust, engine_isp, correction_message, isp_correction, thrust_correction, fairbutton, engine_weight, 0, engine_cost, 0, stage1_thrust, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0, 0, 0});
% Buttons for propellant type

tank_dia.Callback = {@tank_dimensions, tank_height, engine, engineinfo, engine_data, tank_strength, tank_density, tank_price, tank_thickness, tank_weight, tank_price_overall, tank_error_message, prop_select, prop_weight, prop_price_overall, 0, engine_thrust, engine_weight, engine_cost, 0, 0, stage1_mass, stage1_thrust, 0, stage1_tw, rocket_cost, 0, 0, 0, 0, 0, 0, 0};
tank_height.Callback = {@tank_dimensions, tank_dia, engine, engineinfo, engine_data, tank_strength, tank_density, tank_price, tank_thickness, tank_weight, tank_price_overall, tank_error_message, prop_select, prop_weight, prop_price_overall, 0, engine_thrust, engine_weight, engine_cost, 0, 0, stage1_mass, stage1_thrust, 0, stage1_tw, rocket_cost, 0, 0, 0, 0, 0, 0, 0};
% Callback funcs for tank_height and tank_dia. They are separate from the
% original uicontrol so that they may reference each other




fair_mat_select = uibuttongroup("Position", [0.02 0.52 0.3 0], "Title", "Fairing Material:   ", "FontSize", 15);
% Button group for fairing material selection

stage_choice = uibuttongroup("Position", [0.02 0.275 0.3 0], "Title", "Would you like to add a second stage?   ", "FontSize", 15);
% Button group for selecting whether or not to have a second stage

fair_thickness = uicontrol("Style", "text", "String", "Fairing Wall Thickness (in): ", "Position", [0.325*ScreenLength 0.58*ScreenHeight (0.17*ScreenLength) 0], "FontSize", 12);
fair_weight = uicontrol("Style", "text", "String", "Fairing Weight (kg): ", "Position", [0.328*ScreenLength 0.52*ScreenHeight (0.13*ScreenLength) 0], "FontSize", 12);
fair_price_overall = uicontrol("Style", "text", "String", "Fairing Cost: ", "Position", [0.325*ScreenLength 0.46*ScreenHeight (0.11*ScreenLength) 0], "FontSize", 12);

fair_density = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.58*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
fair_strength = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.53*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
fair_price = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.48*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
% Variables related to their respective atributes of stage 1 fairing

uicontrol("Style", "radiobutton", "String", "Grade H Steel", "Parent", fair_mat_select, "Position", [0.01*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@fair_mat_select, material_info, engine_thrust, fair_density, fair_strength, fair_price, tank_dia, 0, tank_height, 0, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, fair_thickness, 0, fair_weight, fair_price_overall, 0, engine_diameter, 0, engine_length, 0, stage_choice, engine_weight, engine_cost, 0, stage1_thrust, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0, 0, 0, 0, 0, 0, 0});
uicontrol("Style", "radiobutton", "String", "Grade A Steel", "Parent", fair_mat_select, "Position", [0.1*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@fair_mat_select, material_info, engine_thrust, fair_density, fair_strength, fair_price, tank_dia, 0, tank_height, 0, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, fair_thickness, 0, fair_weight, fair_price_overall, 0, engine_diameter, 0, engine_length, 0, stage_choice, engine_weight, engine_cost, 0, stage1_thrust, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0, 0, 0, 0, 0, 0, 0});
uicontrol("Style", "radiobutton", "String", "Stainless Steel", "Parent", fair_mat_select, "Position", [0.2*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@fair_mat_select, material_info, engine_thrust, fair_density, fair_strength, fair_price, tank_dia, 0, tank_height, 0, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, fair_thickness, 0, fair_weight, fair_price_overall, 0, engine_diameter, 0, engine_length, 0, stage_choice, engine_weight, engine_cost, 0, stage1_thrust, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0, 0, 0, 0, 0, 0, 0});
uicontrol("Style", "radiobutton", "String", "Aluminum 6063", "Parent", fair_mat_select, "Position", [0.01*ScreenLength 0.18*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@fair_mat_select, material_info, engine_thrust, fair_density, fair_strength, fair_price, tank_dia, 0, tank_height, 0, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, fair_thickness, 0, fair_weight, fair_price_overall, 0, engine_diameter, 0, engine_length, 0, stage_choice, engine_weight, engine_cost, 0, stage1_thrust, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0, 0, 0, 0, 0, 0, 0});
uicontrol("Style", "radiobutton", "String", "Aluminum 6061", "Parent", fair_mat_select, "Position", [0.1*ScreenLength 0.18*ScreenHeight (0.09*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@fair_mat_select, material_info, engine_thrust, fair_density, fair_strength, fair_price, tank_dia, 0, tank_height, 0, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, fair_thickness, 0, fair_weight, fair_price_overall, 0, engine_diameter, 0, engine_length, 0, stage_choice, engine_weight, engine_cost, 0, stage1_thrust, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0, 0, 0, 0, 0, 0, 0});
uicontrol("Style", "radiobutton", "String", "Aluminum 7075", "Parent", fair_mat_select, "Position", [0.2*ScreenLength 0.18*ScreenHeight (0.09*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@fair_mat_select, material_info, engine_thrust, fair_density, fair_strength, fair_price, tank_dia, 0, tank_height, 0, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, fair_thickness, 0, fair_weight, fair_price_overall, 0, engine_diameter, 0, engine_length, 0, stage_choice, engine_weight, engine_cost, 0, stage1_thrust, 0, stage1_mass, 0, stage1_tw, rocket_cost, 0, 0, 0, 0, 0, 0, 0, 0});
% Buttons for fairing material selection

nosecone = uibuttongroup("Position", [0.02 0.05 0.3 0], "Title", "Nose Cone:   ", "FontSize", 15);
uicontrol("Style", "text", "String", "Length: ", "Parent", nosecone, "Position", [0.01*ScreenLength 0.08*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12)
nose_length = uicontrol("Style", "edit", "Parent", nosecone, "Position", [0.12*ScreenLength 0.08*ScreenHeight (0.03*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12);
uicontrol("Style", "text", "String", "Geometric Power: ", "Parent", nosecone, "Position", [0.01*ScreenLength 0.03*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12)
nose_power = uicontrol("Style", "edit", "Parent", nosecone, "Position", [0.12*ScreenLength 0.03*ScreenHeight (0.03*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12);

drag = uicontrol("Style", "text", "String", "Estimated drag: ", "Position", [0.32*ScreenLength 0.15*ScreenHeight (0.2*ScreenLength) 0], "FontSize", 12);
nose_weight = uicontrol("Style", "text", "String", "Nose cone weight (kg): ", "Position", [0.32*ScreenLength 0.1*ScreenHeight (0.16*ScreenLength) 0], "FontSize", 12);
nose_cost = uicontrol("Style", "text", "String", "Nose cone cost: ", "Position", [0.32*ScreenLength 0.05*ScreenHeight (0.16*ScreenLength) 0], "FontSize", 12);

sim_button = uicontrol("Style", "pushbutton", "String", "Simulate!", "Position", [(0.875*ScreenLength) (0.78*ScreenHeight) (0.1*ScreenLength) 0], "FontSize", 18, "BackgroundColor", "#6ffc9c");

nose_length.Callback = {@nosecone_dim, nose_power, engine_length, engine_diameter, 0, tank_dia, 0, tank_height, 0, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, fair_thickness, 0, fair_density, fair_weight, 0, fair_price, 0, 0, drag, nose_weight, nose_cost, sim_button, engine_thrust, 0, engine_weight, engine_cost, 0, stage1_mass, 0, 0, stage1_tw, rocket_cost, 0, 0};
nose_power.Callback = {@nosecone_dim, nose_length, engine_length, engine_diameter, 0, tank_dia, 0, tank_height, 0, tank_weight, tank_price_overall, 0, prop_weight, prop_price_overall, 0, fair_thickness, 0, fair_density, fair_weight, 0, fair_price, 0, 0, drag, nose_weight, nose_cost, sim_button, engine_thrust, 0, engine_weight, engine_cost, 0, stage1_mass, 0, 0, stage1_tw, rocket_cost, 0, 0};
% Buttons for nose cone design, as well as their callback functinos.
% Callbacks are separate so that they may reference each other

yes_stage = uicontrol("Style", "radiobutton", "String", "Yes", "Parent", stage_choice, "Position", [0.01*ScreenLength 0.1*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Value", 0);
no_stage = uicontrol("Style", "radiobutton", "String", "No", "Parent", stage_choice, "Position", [0.01*ScreenLength 0.05*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Value", 0);
% Buttons for selection of whether or not to have second stage
% Value of 1 = button is pressed, value of 0 = button is not pressed

applybutton.Callback = {@apply, engine, engineinfo, engine_data, engine_name, engine_cost, engine_base_thrust, engine_base_isp, engine_prop, engine_thrust, engine_isp, engine_weight, engine_diameter, engine_length, tankbutton, deselectbutton, tank_dia, tank_height, stage1_thrust, stage1_mass, stage1_tw, 0, 0, 0, 0, rocket_cost, engine_length, engine_diameter, fair_thickness, 0, 0, 0, 0};
% Button callback function for applying first stage engine




stage1_text = uicontrol("Style", "text", "String", "Stage 1:", "Position", [(0.01*ScreenLength) (0.76*ScreenHeight) (0.1*ScreenLength) 0], "FontSize", 18);
stage2_text = uicontrol("Style", "text", "String", "Stage 2:", "Position", [(0.45*ScreenLength) (0.76*ScreenHeight) (0.1*ScreenLength) 0], "FontSize", 18);

enginebutton2 = uicontrol("Style", "pushbutton", "String", "Engine", "Position", [(0.55*ScreenLength) (0.78*ScreenHeight) (0.1*ScreenLength) 0], "FontSize", 18);
tankbutton2 = uicontrol("Style", "pushbutton", "String", "Tanks", "Position", [(0.66*ScreenLength) (0.78*ScreenHeight) (0.1*ScreenLength) 0], "FontSize", 18);
fairbutton2 = uicontrol("Style", "pushbutton", "String", "Fairings", "Position", [(0.77*ScreenLength) (0.78*ScreenHeight) (0.1*ScreenLength) 0], "FontSize", 18);

yes_stage.Callback = {@stage_choice, no_stage, nosecone, drag, nose_weight, nose_cost, sim_button, stage1_text, stage2_text, enginebutton2};
no_stage.Callback = {@stage_choice, yes_stage, nosecone, drag, nose_weight, nose_cost, sim_button, stage1_text, stage2_text, enginebutton2};

engine_slide2 = uicontrol("Style", "slider", "Position", [0.01*ScreenLength 0.15*ScreenHeight 0.01*ScreenLength 0], "BackgroundColor", "#cccccc");
engine_slide2.Value = 1;
% Make a slider that scrolls through engines for selection

applybutton2 = uicontrol("Style", "pushbutton", "String", "Apply", "Position", [(0.13*ScreenLength) (0.48*ScreenHeight) (0.06*ScreenLength) 0], "FontSize", 12, "BackgroundColor", "#6ffc9c");
deselectbutton2 = uicontrol("Style", "pushbutton", "String", "Deselect", "Position", [(0.22*ScreenLength) (0.48*ScreenHeight) (0.06*ScreenLength) 0], "FontSize", 12, "BackgroundColor", "#ff9494");
% Make pushbuttons for applying an engine to configuration and
% deselection of engine

enginecount2 = 0;
% Initialize enginecount variable

for i = 1:height(engine_data)

    if string(engine_data{i,"Stage"}) == "U"
    % In the excel file, if the engine is a upper stage engine, ...

        enginecount2 = enginecount2 + 1;
        
        engineinfo_text2 = sprintf("Manufacturer: " + string(engine_data{i, "Make"}) + "\n\n" + "Cost: " + "$" + string(engine_data{i, "Cost ($)"}) + "\n\n" + "Thrust: " + string(engine_data{i, "Thrust (N)"}) + " Newtons" + "\n\n" + "Specific Impulse: " + string(engine_data{i, "Isp"}) + ... 
        "\n\n" + "Weight: " + string(engine_data{i, "Weight (kg)"}) + " kg");
        % For each engine, at data from excel file corresponding to it

        engine2(enginecount2) = uicontrol("Style", "pushbutton", "String", string(engine_data{i,"Engine Name"}), "Position", [(0.025*ScreenLength) (0.7*ScreenHeight - 0.07*(enginecount2-1)*ScreenHeight) (0.08*ScreenLength) 0], "FontSize", 13);
        % Toggle button for display of information for each engine

        engineinfo2(enginecount2) = uicontrol("Style", "text", "String", engineinfo_text2, "Position", [(0.11*ScreenLength) (0.53*ScreenHeight) (0.2*ScreenLength) 0], "FontSize", 13);
        % Create text box for engine information

        engine2(enginecount2).Callback = {@engineinfo, engine_data, engineinfo2, applybutton2, deselectbutton2};
        % When button is pressed for a specific engine, go to engineinfo
        % function
    end
end

engine_name2 = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_cost2 = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_base_thrust2 = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_base_isp2 = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_weight2 = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_diameter2 = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_length2 = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_prop2 = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_isp2 = uicontrol("Style", "text", "Position", [0 0 0 0]);
engine_thrust2 = uicontrol("Style", "text", "Position", [0 0 0 0]);
% Create variables for every aspect of the engine chosen. These are useful
% for future functions so that iterations through engine_data matrix do not
% need to occur

stage2_thrust = uicontrol("Style", "text", "String", "Stage 2 Thrust: ", "Position", [(0.72*ScreenLength) (0.08*ScreenHeight) (0.12*ScreenLength) 0], "FontSize", 12);
stage2_mass = uicontrol("Style", "text", "String", "Stage 2 Mass: ", "Position", [(0.85*ScreenLength) (0.08*ScreenHeight) (0.12*ScreenLength) 0], "FontSize", 12);
stage2_tw = uicontrol("Style", "text", "String", "Stage 2 T/W Ratio: ", "Position", [(0.72*ScreenLength) (0.04*ScreenHeight) (0.12*ScreenLength) 0], "FontSize", 12);
stack_tw = uicontrol("Style", "text", "String", "Full Rocket T/W Ratio: ", "Position", [(0.69*ScreenLength) (0.01*ScreenHeight) (0.18*ScreenLength) 0], "FontSize", 12);

engine_slide2.Callback = {@engineL_slider, engine2};
% Toggle slider with engineL_slider function and pass engine variable

deselectbutton2.Callback = {@deselect, engineinfo2, applybutton2};
% Toggle deselection button, allowing user to choose engines multiple times

applybutton2.Callback = {@apply, engine2, engineinfo2, engine_data, engine_name2, engine_cost2, engine_base_thrust2, engine_base_isp2, engine_prop2, engine_thrust2, engine_isp2, engine_weight2, engine_diameter2, engine_length2, tankbutton2, deselectbutton2, tank_dia, tank_height, stage1_thrust, stage1_mass, stage1_tw, stage2_thrust, stage2_mass, stage2_tw, stack_tw, rocket_cost, engine_length, engine_diameter, fair_thickness, engine_cost, tank_price_overall, prop_price_overall, fair_price_overall};




tank_mat_select2 = uibuttongroup("Position", [0.02 0.52 0.3 0], "Title", "Propellant Tank Material:   ", "FontSize", 15);
prop_select2 = uibuttongroup("Position", [0.02 0.1 0.3 0], "Title", "Propellant Type: ", "FontSize", 15);
% Create button groups early on so that they may be referenced in later
% callback functions

prop_weight2 = uicontrol("Style", "text", "Position", [0.34*ScreenLength 0.33*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
prop_price_overall2 = uicontrol("Style", "text", "Position", [0.33*ScreenLength 0.26*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
% Display to user overall weight and cost of propellant

tank_dia_text2 = uicontrol("Style", "text", "String", "Tank Diameter (ft): ", "Position", [0.345*ScreenLength 0.7*ScreenHeight (0.1*ScreenLength) 0], "FontSize", 12);
tank_dia2 = uicontrol("Style", "edit", "Position", [0.445*ScreenLength 0.7*ScreenHeight (0.04*ScreenLength) 0], "FontSize", 12);
% Create edit for user to input a tank diameter to be of use for program

tank_height_text2 = uicontrol("Style", "text", "String", "Tank Height (ft): ", "Position", [0.34*ScreenLength 0.64*ScreenHeight (0.1*ScreenLength) 0], "FontSize", 12);
tank_height2 = uicontrol("Style", "edit", "Position", [0.445*ScreenLength 0.64*ScreenHeight (0.04*ScreenLength) 0], "FontSize", 12);
% Create edit for user to input a tank height to be of use for program

tank_error_message2 = uicontrol("Style", "text", "String", " ", "Position", [0.5*ScreenLength 0.65*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12, "ForegroundColor", "red");
% If the user makes a mistake on input, this message will display red text
% with what the error is

tank_thickness2 = uicontrol("Style", "text", "String", "Tank Wall Thickness (in): ", "Position", [0.325*ScreenLength 0.53*ScreenHeight (0.17*ScreenLength) 0], "FontSize", 12);
tank_weight2 = uicontrol("Style", "text", "String", "Tank Weight (kg): ", "Position", [0.328*ScreenLength 0.485*ScreenHeight (0.13*ScreenLength) 0], "FontSize", 12);
tank_price_overall2 = uicontrol("Style", "text", "String", "Tank Cost: ", "Position", [0.325*ScreenLength 0.44*ScreenHeight (0.11*ScreenLength) 0], "FontSize", 12);

tank_density2 = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.58*ScreenHeight (0.12*ScreenLength) 0], "FontSize", 12);
tank_strength2 = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.53*ScreenHeight (0.12*ScreenLength) 0], "FontSize", 12);
tank_price2 = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.48*ScreenHeight (0.12*ScreenLength) 0], "FontSize", 12);
% Variables above relate to their respective attributes for prop tank

uicontrol("Style", "radiobutton", "String", "Grade H Steel", "Parent", tank_mat_select2, "Position", [0.01*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@tank_mat_select, material_info, tank_density2, tank_strength2, tank_price2, tank_dia2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall, tank_price_overall2, prop_select2, prop_weight2, prop_price_overall, prop_price_overall2, fair_price_overall, engine_thrust2, engine_weight2, engine_cost, engine_cost2, stage1_thrust, stage1_mass, stage2_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String});
uicontrol("Style", "radiobutton", "String", "Grade A Steel", "Parent", tank_mat_select2, "Position", [0.1*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@tank_mat_select, material_info, tank_density2, tank_strength2, tank_price2, tank_dia2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall, tank_price_overall2, prop_select2, prop_weight2, prop_price_overall, prop_price_overall2, fair_price_overall, engine_thrust2, engine_weight2, engine_cost, engine_cost2, stage1_thrust, stage1_mass, stage2_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String});
uicontrol("Style", "radiobutton", "String", "Stainless Steel", "Parent", tank_mat_select2, "Position", [0.2*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@tank_mat_select, material_info, tank_density2, tank_strength2, tank_price2, tank_dia2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall, tank_price_overall2, prop_select2, prop_weight2, prop_price_overall, prop_price_overall2, fair_price_overall, engine_thrust2, engine_weight2, engine_cost, engine_cost2, stage1_thrust, stage1_mass, stage2_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String});
uicontrol("Style", "radiobutton", "String", "Aluminum 6063", "Parent", tank_mat_select2, "Position", [0.01*ScreenLength 0.18*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@tank_mat_select, material_info, tank_density2, tank_strength2, tank_price2, tank_dia2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall, tank_price_overall2, prop_select2, prop_weight2, prop_price_overall, prop_price_overall2, fair_price_overall, engine_thrust2, engine_weight2, engine_cost, engine_cost2, stage1_thrust, stage1_mass, stage2_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String});
uicontrol("Style", "radiobutton", "String", "Aluminum 6061", "Parent", tank_mat_select2, "Position", [0.1*ScreenLength 0.18*ScreenHeight (0.09*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@tank_mat_select, material_info, tank_density2, tank_strength2, tank_price2, tank_dia2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall, tank_price_overall2, prop_select2, prop_weight2, prop_price_overall, prop_price_overall2, fair_price_overall, engine_thrust2, engine_weight2, engine_cost, engine_cost2, stage1_thrust, stage1_mass, stage2_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String});
uicontrol("Style", "radiobutton", "String", "Aluminum 7075", "Parent", tank_mat_select2, "Position", [0.2*ScreenLength 0.18*ScreenHeight (0.09*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@tank_mat_select, material_info, tank_density2, tank_strength2, tank_price2, tank_dia2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall, tank_price_overall2, prop_select2, prop_weight2, prop_price_overall, prop_price_overall2, fair_price_overall, engine_thrust2, engine_weight2, engine_cost, engine_cost2, stage1_thrust, stage1_mass, stage2_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String});
% Buttons for tank material selection

prop_density2 = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.21*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
prop_isp2 = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.16*ScreenHeight (0.16*ScreenLength) 0], "FontSize", 12);
prop_price2 = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.11*ScreenHeight (0.16*ScreenLength) 0], "FontSize", 12);
% Variables related to propellant attributes

correction_message2 = uicontrol("Style", "text", "Position", [0.32*ScreenLength 0.16*ScreenHeight (0.28*ScreenLength) 0], "FontSize", 12);
isp_correction2 = uicontrol("Style", "text", "Position", [0.33*ScreenLength 0.14*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
thrust_correction2 = uicontrol("Style", "text", "Position", [0.325*ScreenLength 0.09*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
% If the propellant is not native to the engine that was selected,
% calculate and display the corrections related to Isp and thrust

uicontrol("Style", "radiobutton", "String", "Hydrolox", "Parent", prop_select2, "Position", [0.01*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@prop_select, prop_info, prop_density2, prop_isp2, prop_price2, tank_dia2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall, tank_price_overall2, prop_weight2, prop_price_overall2, prop_price_overall, engine_name2, engine_prop2, engine_base_thrust2, engine_base_isp2, engine_thrust2, engine_isp2, correction_message2, isp_correction2, thrust_correction2, fairbutton2, engine_weight, engine_weight2, engine_cost2, engine_cost, stage2_thrust, stage1_thrust, stage2_mass, stage1_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, fair_price_overall, engine_thrust2});
uicontrol("Style", "radiobutton", "String", "Hydrolox:Be", "Parent", prop_select2, "Position", [0.1*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@prop_select, prop_info, prop_density2, prop_isp2, prop_price2, tank_dia2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall, tank_price_overall2, prop_weight2, prop_price_overall2, prop_price_overall, engine_name2, engine_prop2, engine_base_thrust2, engine_base_isp2, engine_thrust2, engine_isp2, correction_message2, isp_correction2, thrust_correction2, fairbutton2, engine_weight, engine_weight2, engine_cost2, engine_cost, stage2_thrust, stage1_thrust, stage2_mass, stage1_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, fair_price_overall, engine_thrust2});
uicontrol("Style", "radiobutton", "String", "Kerolox", "Parent", prop_select2, "Position", [0.2*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@prop_select, prop_info, prop_density2, prop_isp2, prop_price2, tank_dia2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall, tank_price_overall2, prop_weight2, prop_price_overall2, prop_price_overall, engine_name2, engine_prop2, engine_base_thrust2, engine_base_isp2, engine_thrust2, engine_isp2, correction_message2, isp_correction2, thrust_correction2, fairbutton2, engine_weight, engine_weight2, engine_cost2, engine_cost, stage2_thrust, stage1_thrust, stage2_mass, stage1_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, fair_price_overall, engine_thrust2});
uicontrol("Style", "radiobutton", "String", "Methalox", "Parent", prop_select2, "Position", [0.01*ScreenLength 0.18*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@prop_select, prop_info, prop_density2, prop_isp2, prop_price2, tank_dia2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall, tank_price_overall2, prop_weight2, prop_price_overall2, prop_price_overall, engine_name2, engine_prop2, engine_base_thrust2, engine_base_isp2, engine_thrust2, engine_isp2, correction_message2, isp_correction2, thrust_correction2, fairbutton2, engine_weight, engine_weight2, engine_cost2, engine_cost, stage2_thrust, stage1_thrust, stage2_mass, stage1_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, fair_price_overall, engine_thrust2});
uicontrol("Style", "radiobutton", "String", "Hydroflourine", "Parent", prop_select2, "Position", [0.1*ScreenLength 0.18*ScreenHeight (0.09*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@prop_select, prop_info, prop_density2, prop_isp2, prop_price2, tank_dia2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall, tank_price_overall2, prop_weight2, prop_price_overall2, prop_price_overall, engine_name2, engine_prop2, engine_base_thrust2, engine_base_isp2, engine_thrust2, engine_isp2, correction_message2, isp_correction2, thrust_correction2, fairbutton2, engine_weight, engine_weight2, engine_cost2, engine_cost, stage2_thrust, stage1_thrust, stage2_mass, stage1_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, fair_price_overall, engine_thrust2});
uicontrol("Style", "radiobutton", "String", "Hydroflourine:Li", "Parent", prop_select2, "Position", [0.2*ScreenLength 0.18*ScreenHeight (0.09*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@prop_select, prop_info, prop_density2, prop_isp2, prop_price2, tank_dia2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall, tank_price_overall2, prop_weight2, prop_price_overall2, prop_price_overall, engine_name2, engine_prop2, engine_base_thrust2, engine_base_isp2, engine_thrust2, engine_isp2, correction_message2, isp_correction2, thrust_correction2, fairbutton2, engine_weight, engine_weight2, engine_cost2, engine_cost, stage2_thrust, stage1_thrust, stage2_mass, stage1_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, fair_price_overall, engine_thrust2});
% Buttons for propellant type

tank_dia2.Callback = {@tank_dimensions, tank_height2, engine2, engineinfo2, engine_data, tank_strength2, tank_density2, tank_price2, tank_thickness2, tank_weight2, tank_price_overall2, tank_error_message2, prop_select2, prop_weight2, prop_price_overall, prop_price_overall2, engine_thrust2, engine_weight2, engine_cost, engine_cost2, fair_price_overall, stage1_mass, stage1_thrust, stage2_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, tank_dia, tank_height, fair_thickness, engine_length, engine_diameter};
tank_height2.Callback = {@tank_dimensions, tank_dia2, engine2, engineinfo2, engine_data, tank_strength2, tank_density2, tank_price2, tank_thickness2, tank_weight2, tank_price_overall2, tank_error_message2, prop_select2, prop_weight2, prop_price_overall, prop_price_overall2, engine_thrust2, engine_weight2, engine_cost, engine_cost2, fair_price_overall, stage1_mass, stage1_thrust, stage2_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, tank_dia, tank_height, fair_thickness, engine_length, engine_diameter};
% Callback funcs for tank_height and tank_dia. They are separate from the
% original uicontrol so that they may reference each other



fair_mat_select2 = uibuttongroup("Position", [0.02 0.52 0.3 0], "Title", "Fairing Material:   ", "FontSize", 15);
% Button group for fairing material selection

fair_thickness2 = uicontrol("Style", "text", "String", "Fairing Wall Thickness (in): ", "Position", [0.325*ScreenLength 0.58*ScreenHeight (0.17*ScreenLength) 0], "FontSize", 12);
fair_weight2 = uicontrol("Style", "text", "String", "Fairing Weight (kg): ", "Position", [0.328*ScreenLength 0.52*ScreenHeight (0.13*ScreenLength) 0], "FontSize", 12);
fair_price_overall2 = uicontrol("Style", "text", "String", "Fairing Cost: ", "Position", [0.325*ScreenLength 0.46*ScreenHeight (0.11*ScreenLength) 0], "FontSize", 12);

fair_density2 = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.58*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
fair_strength2 = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.53*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
fair_price2 = uicontrol("Style", "text", "Position", [0.025*ScreenLength 0.48*ScreenHeight (0.15*ScreenLength) 0], "FontSize", 12);
% Variables related to their respective atributes of stage 1 fairing

nosecone2 = uibuttongroup("Position", [0.02 0.05 0.3 0], "Title", "Nose Cone:   ", "FontSize", 15);
uicontrol("Style", "text", "String", "Length: ", "Parent", nosecone2, "Position", [0.01*ScreenLength 0.08*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12)
nose_length2 = uicontrol("Style", "edit", "Parent", nosecone2, "Position", [0.12*ScreenLength 0.08*ScreenHeight (0.03*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12);
uicontrol("Style", "text", "String", "Geometric Power: ", "Parent", nosecone2, "Position", [0.01*ScreenLength 0.03*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12)
nose_power2 = uicontrol("Style", "edit", "Parent", nosecone2, "Position", [0.12*ScreenLength 0.03*ScreenHeight (0.03*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12);

drag2 = uicontrol("Style", "text", "String", "Estimated drag: ", "Position", [0.32*ScreenLength 0.15*ScreenHeight (0.2*ScreenLength) 0], "FontSize", 12);
nose_weight2 = uicontrol("Style", "text", "String", "Nose cone weight (kg): ", "Position", [0.32*ScreenLength 0.1*ScreenHeight (0.16*ScreenLength) 0], "FontSize", 12);
nose_cost2 = uicontrol("Style", "text", "String", "Nose cone cost: ", "Position", [0.32*ScreenLength 0.05*ScreenHeight (0.16*ScreenLength) 0], "FontSize", 12);

uicontrol("Style", "radiobutton", "String", "Grade H Steel", "Parent", fair_mat_select2, "Position", [0.01*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@fair_mat_select, material_info, engine_thrust2, fair_density2, fair_strength2, fair_price2, tank_dia2, tank_dia, tank_height2, tank_height, tank_weight2, tank_price_overall2, tank_price_overall, prop_weight2, prop_price_overall2, prop_price_overall, fair_thickness2, fair_thickness, fair_weight2, fair_price_overall2, fair_price_overall, engine_diameter2, engine_diameter, engine_length2, engine_length, 0, engine_weight2, engine_cost2, engine_cost, stage2_thrust, stage1_thrust, stage2_mass, stage1_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, nosecone2, nose_length2, nose_power2, drag2, nose_weight2, nose_cost2});
uicontrol("Style", "radiobutton", "String", "Grade A Steel", "Parent", fair_mat_select2, "Position", [0.1*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@fair_mat_select, material_info, engine_thrust2, fair_density2, fair_strength2, fair_price2, tank_dia2, tank_dia, tank_height2, tank_height, tank_weight2, tank_price_overall2, tank_price_overall, prop_weight2, prop_price_overall2, prop_price_overall, fair_thickness2, fair_thickness, fair_weight2, fair_price_overall2, fair_price_overall, engine_diameter2, engine_diameter, engine_length2, engine_length, 0, engine_weight2, engine_cost2, engine_cost, stage2_thrust, stage1_thrust, stage2_mass, stage1_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, nosecone2, nose_length2, nose_power2, drag2, nose_weight2, nose_cost2});
uicontrol("Style", "radiobutton", "String", "Stainless Steel", "Parent", fair_mat_select2, "Position", [0.2*ScreenLength 0.23*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@fair_mat_select, material_info, engine_thrust2, fair_density2, fair_strength2, fair_price2, tank_dia2, tank_dia, tank_height2, tank_height, tank_weight2, tank_price_overall2, tank_price_overall, prop_weight2, prop_price_overall2, prop_price_overall, fair_thickness2, fair_thickness, fair_weight2, fair_price_overall2, fair_price_overall, engine_diameter2, engine_diameter, engine_length2, engine_length, 0, engine_weight2, engine_cost2, engine_cost, stage2_thrust, stage1_thrust, stage2_mass, stage1_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, nosecone2, nose_length2, nose_power2, drag2, nose_weight2, nose_cost2});
uicontrol("Style", "radiobutton", "String", "Aluminum 6063", "Parent", fair_mat_select2, "Position", [0.01*ScreenLength 0.18*ScreenHeight (0.1*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@fair_mat_select, material_info, engine_thrust2, fair_density2, fair_strength2, fair_price2, tank_dia2, tank_dia, tank_height2, tank_height, tank_weight2, tank_price_overall2, tank_price_overall, prop_weight2, prop_price_overall2, prop_price_overall, fair_thickness2, fair_thickness, fair_weight2, fair_price_overall2, fair_price_overall, engine_diameter2, engine_diameter, engine_length2, engine_length, 0, engine_weight2, engine_cost2, engine_cost, stage2_thrust, stage1_thrust, stage2_mass, stage1_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, nosecone2, nose_length2, nose_power2, drag2, nose_weight2, nose_cost2});
uicontrol("Style", "radiobutton", "String", "Aluminum 6061", "Parent", fair_mat_select2, "Position", [0.1*ScreenLength 0.18*ScreenHeight (0.09*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@fair_mat_select, material_info, engine_thrust2, fair_density2, fair_strength2, fair_price2, tank_dia2, tank_dia, tank_height2, tank_height, tank_weight2, tank_price_overall2, tank_price_overall, prop_weight2, prop_price_overall2, prop_price_overall, fair_thickness2, fair_thickness, fair_weight2, fair_price_overall2, fair_price_overall, engine_diameter2, engine_diameter, engine_length2, engine_length, 0, engine_weight2, engine_cost2, engine_cost, stage2_thrust, stage1_thrust, stage2_mass, stage1_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, nosecone2, nose_length2, nose_power2, drag2, nose_weight2, nose_cost2});
uicontrol("Style", "radiobutton", "String", "Aluminum 7075", "Parent", fair_mat_select2, "Position", [0.2*ScreenLength 0.18*ScreenHeight (0.09*ScreenLength) (0.03*ScreenHeight)], "FontSize", 12, "Callback", {@fair_mat_select, material_info, engine_thrust2, fair_density2, fair_strength2, fair_price2, tank_dia2, tank_dia, tank_height2, tank_height, tank_weight2, tank_price_overall2, tank_price_overall, prop_weight2, prop_price_overall2, prop_price_overall, fair_thickness2, fair_thickness, fair_weight2, fair_price_overall2, fair_price_overall, engine_diameter2, engine_diameter, engine_length2, engine_length, 0, engine_weight2, engine_cost2, engine_cost, stage2_thrust, stage1_thrust, stage2_mass, stage1_mass, stage2_tw, rocket_cost, stack_tw, stack_tw.String, nosecone2, nose_length2, nose_power2, drag2, nose_weight2, nose_cost2});
% Buttons for fairing material selection

nose_length2.Callback = {@nosecone_dim, nose_power2, engine_length2, engine_diameter2, engine_diameter, tank_dia2, tank_dia, tank_height2, tank_height, tank_weight2, tank_price_overall2, tank_price_overall, prop_weight2, prop_price_overall2, prop_price_overall, fair_thickness2, fair_thickness, fair_density2, fair_weight2, fair_weight, fair_price2, fair_price_overall, fair_price_overall2, drag2, nose_weight2, nose_cost2, sim_button, engine_thrust2, engine_length, engine_weight2, engine_cost2, engine_cost, stage2_mass, stage1_mass, stage1_thrust, stage2_tw, rocket_cost, stack_tw, stack_tw.String};
nose_power2.Callback = {@nosecone_dim, nose_length2, engine_length2, engine_diameter2, engine_diameter, tank_dia2, tank_dia, tank_height2, tank_height, tank_weight2, tank_price_overall2, tank_price_overall, prop_weight2, prop_price_overall2, prop_price_overall, fair_thickness2, fair_thickness, fair_density2, fair_weight2, fair_weight, fair_price2, fair_price_overall, fair_price_overall2, drag2, nose_weight2, nose_cost2, sim_button, engine_thrust2, engine_length, engine_weight2, engine_cost2, engine_cost, stage2_mass, stage1_mass, stage1_thrust, stage2_tw, rocket_cost, stack_tw, stack_tw.String};
% Buttons for nose cone design, as well as their callback functinos.
% Callbacks are separate so that they may reference each other

countdown = uicontrol("Style", "text", "String", "T- ", "Position", [(0.4*ScreenLength) (0.75*ScreenHeight) (0.15*ScreenLength) 0], "FontSize", 16);
rocket_altitude = uicontrol("Style", "text", "String", "Altitude: 0 m", "Position", [(0.825*ScreenLength) (0.6*ScreenHeight) (0.15*ScreenLength) 0], "FontSize", 14);
rocket_velocity = uicontrol("Style", "text", "String", "Velocity: 0 m/s", "Position", [(0.825*ScreenLength) (0.5*ScreenHeight) (0.15*ScreenLength) 0], "FontSize", 14);
rocket_acceleration = uicontrol("Style", "text", "String", "Acceleration: 0 m/s2", "Position", [(0.825*ScreenLength) (0.4*ScreenHeight) (0.15*ScreenLength) 0], "FontSize", 14);
alt_bar = uibuttongroup("Position", [0.05 0.2 0.02 0]);
alt_bar_perc = uibuttongroup("Position", [0.05 0.2 0.02 0], "BackgroundColor", "#a3c7ff");
escape_message = uicontrol("Style", "text", "String", "You escaped Earth's gravity!", "Position", [(0.375*ScreenLength) (0.7*ScreenHeight) (0.2*ScreenLength) 0], "FontSize", 14);
% Prepare variables for simulation function below

enginebutton.Callback = {@enginebutton, engine, engine_slide, tank_mat_select, tank_density, tank_strength, tank_price, tank_dia_text, tank_dia, tank_height_text, tank_height, tank_thickness, tank_weight, tank_price_overall, tank_error_message, prop_select, prop_density, prop_isp, prop_price, prop_weight, prop_price_overall, correction_message, isp_correction, thrust_correction, fair_mat_select, fair_thickness, fair_weight, fair_price_overall, fair_density, fair_strength, fair_price, stage_choice, nosecone, drag, nose_weight, nose_cost, sim_button, engine2, engine_slide2, stage1_thrust, stage1_mass, stage1_tw, stage2_thrust, stage2_mass, stage2_tw, stack_tw, tank_mat_select2, tank_density2, tank_strength2, tank_price2, tank_dia_text2, tank_dia2, tank_height_text2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall2, tank_error_message2, prop_select2, prop_density2, prop_isp2, prop_price2, prop_weight2, prop_price_overall2, correction_message2, isp_correction2, thrust_correction2, fair_mat_select2, fair_thickness2, fair_weight2, fair_price_overall2, fair_density2, fair_strength2, fair_price2, nosecone2, drag2, nose_weight2, nose_cost2};
tankbutton.Callback = {@tankbutton, engine, engine_slide, tank_mat_select, tank_density, tank_strength, tank_price, tank_dia_text, tank_dia, tank_height_text, tank_height, tank_thickness, tank_weight, tank_price_overall, tank_error_message, prop_select, prop_density, prop_isp, prop_price, prop_weight, prop_price_overall, correction_message, isp_correction, thrust_correction, fair_mat_select, fair_thickness, fair_weight, fair_price_overall, fair_density, fair_strength, fair_price, stage_choice, nosecone, drag, nose_weight, nose_cost, sim_button, engine2, engine_slide2, stage1_thrust, stage1_mass, stage1_tw, stage2_thrust, stage2_mass, stage2_tw, stack_tw, tank_mat_select2, tank_density2, tank_strength2, tank_price2, tank_dia_text2, tank_dia2, tank_height_text2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall2, tank_error_message2, prop_select2, prop_density2, prop_isp2, prop_price2, prop_weight2, prop_price_overall2, correction_message2, isp_correction2, thrust_correction2, fair_mat_select2, fair_thickness2, fair_weight2, fair_price_overall2, fair_density2, fair_strength2, fair_price2, nosecone2, drag2, nose_weight2, nose_cost2};
fairbutton.Callback = {@fairbutton, engine, engine_slide, tank_mat_select, tank_density, tank_strength, tank_price, tank_dia_text, tank_dia, tank_height_text, tank_height, tank_thickness, tank_weight, tank_price_overall, tank_error_message, prop_select, prop_density, prop_isp, prop_price, prop_weight, prop_price_overall, correction_message, isp_correction, thrust_correction, fair_mat_select, fair_thickness, fair_weight, fair_price_overall, fair_density, fair_strength, fair_price, stage_choice, nosecone, drag, nose_weight, nose_cost, sim_button, yes_stage, no_stage, engine2, engine_slide2, stage1_thrust, stage1_mass, stage1_tw, stage2_thrust, stage2_mass, stage2_tw, stack_tw, tank_mat_select2, tank_density2, tank_strength2, tank_price2, tank_dia_text2, tank_dia2, tank_height_text2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall2, tank_error_message2, prop_select2, prop_density2, prop_isp2, prop_price2, prop_weight2, prop_price_overall2, correction_message2, isp_correction2, thrust_correction2, fair_mat_select2, fair_thickness2, fair_weight2, fair_price_overall2, fair_density2, fair_strength2, fair_price2, nosecone2, drag2, nose_weight2, nose_cost2};
enginebutton2.Callback = {@enginebutton2, engine, engine_slide, tank_mat_select, tank_density, tank_strength, tank_price, tank_dia_text, tank_dia, tank_height_text, tank_height, tank_thickness, tank_weight, tank_price_overall, tank_error_message, prop_select, prop_density, prop_isp, prop_price, prop_weight, prop_price_overall, correction_message, isp_correction, thrust_correction, fair_mat_select, fair_thickness, fair_weight, fair_price_overall, fair_density, fair_strength, fair_price, stage_choice, nosecone, drag, nose_weight, nose_cost, sim_button, engine2, engine_slide2, stage1_thrust, stage1_mass, stage1_tw, stage2_thrust, stage2_mass, stage2_tw, stack_tw, tank_mat_select2, tank_density2, tank_strength2, tank_price2, tank_dia_text2, tank_dia2, tank_height_text2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall2, tank_error_message2, prop_select2, prop_density2, prop_isp2, prop_price2, prop_weight2, prop_price_overall2, correction_message2, isp_correction2, thrust_correction2, fair_mat_select2, fair_thickness2, fair_weight2, fair_price_overall2, fair_density2, fair_strength2, fair_price2, nosecone2, drag2, nose_weight2, nose_cost2};
tankbutton2.Callback = {@tankbutton2, engine, engine_slide, tank_mat_select, tank_density, tank_strength, tank_price, tank_dia_text, tank_dia, tank_height_text, tank_height, tank_thickness, tank_weight, tank_price_overall, tank_error_message, prop_select, prop_density, prop_isp, prop_price, prop_weight, prop_price_overall, correction_message, isp_correction, thrust_correction, fair_mat_select, fair_thickness, fair_weight, fair_price_overall, fair_density, fair_strength, fair_price, stage_choice, nosecone, drag, nose_weight, nose_cost, sim_button, engine2, engine_slide2, stage1_thrust, stage1_mass, stage1_tw, stage2_thrust, stage2_mass, stage2_tw, stack_tw, tank_mat_select2, tank_density2, tank_strength2, tank_price2, tank_dia_text2, tank_dia2, tank_height_text2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall2, tank_error_message2, prop_select2, prop_density2, prop_isp2, prop_price2, prop_weight2, prop_price_overall2, correction_message2, isp_correction2, thrust_correction2, fair_mat_select2, fair_thickness2, fair_weight2, fair_price_overall2, fair_density2, fair_strength2, fair_price2, nosecone2, drag2, nose_weight2, nose_cost2};
fairbutton2.Callback = {@fairbutton2, engine, engine_slide, tank_mat_select, tank_density, tank_strength, tank_price, tank_dia_text, tank_dia, tank_height_text, tank_height, tank_thickness, tank_weight, tank_price_overall, tank_error_message, prop_select, prop_density, prop_isp, prop_price, prop_weight, prop_price_overall, correction_message, isp_correction, thrust_correction, fair_mat_select, fair_thickness, fair_weight, fair_price_overall, fair_density, fair_strength, fair_price, stage_choice, nosecone, drag, nose_weight, nose_cost, sim_button, engine2, engine_slide2, stage1_thrust, stage1_mass, stage1_tw, stage2_thrust, stage2_mass, stage2_tw, stack_tw, tank_mat_select2, tank_density2, tank_strength2, tank_price2, tank_dia_text2, tank_dia2, tank_height_text2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall2, tank_error_message2, prop_select2, prop_density2, prop_isp2, prop_price2, prop_weight2, prop_price_overall2, correction_message2, isp_correction2, thrust_correction2, fair_mat_select2, fair_thickness2, fair_weight2, fair_price_overall2, fair_density2, fair_strength2, fair_price2, nosecone2, drag2, nose_weight2, nose_cost2};
sim_button.Callback = {@simbutton, engine, engine_slide, enginebutton, tank_mat_select, tank_density, tank_strength, tank_price, tank_dia_text, tank_dia, tank_height_text, tank_height, tank_thickness, tank_weight, tank_price_overall, tank_error_message, prop_select, prop_density, prop_isp, prop_price, prop_weight, prop_price_overall, correction_message, isp_correction, thrust_correction, tankbutton, fair_mat_select, fair_thickness, fair_weight, fair_price_overall, fair_density, fair_strength, fair_price, stage_choice, nosecone, drag, nose_weight, nose_cost, sim_button, fairbutton, engine2, engine_slide2, stage1_thrust, stage1_mass, stage1_tw, stage2_thrust, stage2_mass, stage2_tw, stack_tw, rocket_cost, tank_mat_select2, tank_density2, tank_strength2, tank_price2, tank_dia_text2, tank_dia2, tank_height_text2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall2, tank_error_message2, prop_select2, prop_density2, prop_isp2, prop_price2, prop_weight2, prop_price_overall2, correction_message2, isp_correction2, thrust_correction2, fair_mat_select2, fair_thickness2, fair_weight2, fair_price_overall2, fair_density2, fair_strength2, fair_price2, nosecone2, drag2, nose_weight2, nose_cost2, engine_thrust, engine_thrust2, engine_isp, engine_isp2, rocket_altitude, rocket_velocity, rocket_acceleration, alt_bar, alt_bar_perc, countdown, escape_message, stage1_text, stage2_text, enginebutton2, tankbutton2, fairbutton2};
% Section toggle callback functions. They must be at the bottom so that all
% uicontrols may be referenced

function simbutton(button, event, engine, engine_slide, enginebutton, tank_mat_select, tank_density, tank_strength, tank_price, tank_dia_text, tank_dia, tank_height_text, tank_height, tank_thickness, tank_weight, tank_price_overall, tank_error_message, prop_select, prop_density, prop_isp, prop_price, prop_weight, prop_price_overall, correction_message, isp_correction, thrust_correction, tankbutton, fair_mat_select, fair_thickness, fair_weight, fair_price_overall, fair_density, fair_strength, fair_price, stage_choice, nosecone, drag, nose_weight, nose_cost, sim_button, fairbutton, engine2, engine_slide2, stage1_thrust, stage1_mass, stage1_tw, stage2_thrust, stage2_mass, stage2_tw, stack_tw, rocket_cost, tank_mat_select2, tank_density2, tank_strength2, tank_price2, tank_dia_text2, tank_dia2, tank_height_text2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall2, tank_error_message2, prop_select2, prop_density2, prop_isp2, prop_price2, prop_weight2, prop_price_overall2, correction_message2, isp_correction2, thrust_correction2, fair_mat_select2, fair_thickness2, fair_weight2, fair_price_overall2, fair_density2, fair_strength2, fair_price2, nosecone2, drag2, nose_weight2, nose_cost2, engine_thrust, engine_thrust2, engine_isp, engine_isp2, rocket_altitude, rocket_velocity, rocket_acceleration, alt_bar, alt_bar_perc, countdown, escape_message, stage1_text, stage2_text, enginebutton2, tankbutton2, fairbutton2)
% Function for simulation - it is contained here instead of as a separate file
% due to the animating graph. A separate file would only return the final
% result to the main script, whereas this can iterate

    ScreenSize = get(groot, 'ScreenSize');
    ScreenLength = ScreenSize(3);
    ScreenHeight = ScreenSize(4);

    for pos = 1:length(engine)
        engine(pos).Position(4) = 0;
    end
    
    engine_slide.Position(4) = 0;
    stage1_thrust.Position(4) = 0;
    stage1_mass.Position(4) = 0;
    stage1_tw.Position(4) = 0;
    enginebutton.Position(4) = 0;
    
    tank_mat_select.Position(4) = 0;
    tank_density.Position(4) = 0;
    tank_strength.Position(4) = 0;
    tank_price.Position(4) = 0;
    tank_dia_text.Position(4) = 0;
    tank_dia.Position(4) = 0; 
    tank_height_text.Position(4) = 0; 
    tank_height.Position(4) = 0;
    tank_thickness.Position(4) = 0;
    tank_weight.Position(4) = 0;
    tank_price_overall.Position(4) = 0;
    tank_error_message.Position(4) = 0;
    prop_select.Position(4) = 0;
    prop_density.Position(4) = 0;
    prop_isp.Position(4) = 0;
    prop_price.Position(4) = 0;
    prop_weight.Position(4) = 0;
    prop_price_overall.Position(4) = 0;
    correction_message.Position(4) = 0;
    isp_correction.Position(4) = 0;
    thrust_correction.Position(4) = 0;
    tankbutton.Position(4) = 0;
    
    fair_mat_select.Position(4) = 0;
    fair_thickness.Position(4) = 0;
    fair_weight.Position(4) = 0;
    fair_price_overall.Position(4) = 0;
    fair_density.Position(4) = 0;
    fair_strength.Position(4) = 0;
    fair_price.Position(4) = 0;
    stage_choice.Position(4) = 0;
    nosecone.Position(4) = 0;
    drag.Position(4) = 0;
    nose_weight.Position(4) = 0;
    nose_cost.Position(4) = 0;
    fairbutton.Position(4) = 0;
    
    for pos = 1:length(engine2)
        engine2(pos).Position(4) = 0;
    end
    
    engine_slide2.Position(4) = 0;
    stage2_thrust.Position(4) = 0;
    stage2_mass.Position(4) = 0;
    stage2_tw.Position(4) = 0;
    stack_tw.Position(4) = 0;
    rocket_cost.Position(4) = 0;
    
    tank_mat_select2.Position(4) = 0;
    tank_density2.Position(4) = 0;
    tank_strength2.Position(4) = 0;
    tank_price2.Position(4) = 0;
    tank_dia_text2.Position(4) = 0;
    tank_dia2.Position(4) = 0; 
    tank_height_text2.Position(4) = 0; 
    tank_height2.Position(4) = 0;
    tank_thickness2.Position(4) = 0;
    tank_weight2.Position(4) = 0;
    tank_price_overall2.Position(4) = 0;
    tank_error_message2.Position(4) = 0;
    prop_select2.Position(4) = 0;
    prop_density2.Position(4) = 0;
    prop_isp2.Position(4) = 0;
    prop_price2.Position(4) = 0;
    prop_weight2.Position(4) = 0;
    prop_price_overall2.Position(4) = 0;
    correction_message2.Position(4) = 0;
    isp_correction2.Position(4) = 0;
    thrust_correction2.Position(4) = 0;
    
    fair_mat_select2.Position(4) = 0;
    fair_thickness2.Position(4) = 0;
    fair_weight2.Position(4) = 0;
    fair_price_overall2.Position(4) = 0;
    fair_density2.Position(4) = 0;
    fair_strength2.Position(4) = 0;
    fair_price2.Position(4) = 0;
    nosecone2.Position(4) = 0;
    drag2.Position(4) = 0;
    nose_weight2.Position(4) = 0;
    nose_cost2.Position(4) = 0;

    stage1_text.Position(4) = 0;
    stage2_text.Position(4) = 0;
    enginebutton2.Position(4) = 0;
    tankbutton2.Position(4) = 0;
    fairbutton2.Position(4) = 0;
    
    button.Position(4) = 0;
    % Set ALL construction objects to be invisible


    rocket_altitude.Position(4) = 0.06*ScreenHeight;
    rocket_velocity.Position(4) = 0.06*ScreenHeight;
    rocket_acceleration.Position(4) = 0.06*ScreenHeight;
    alt_bar.Position(4) = 0.6;
    % Make graph stat variables visible - will be iterated through time as
    % the data is plotted
    
    if strcmp(stage2_thrust.String, "Stage 2 Thrust: ") == 1
    % If rocket is single stage
    
        rocket_mass = str2double(string(extractBetween(stage1_mass.String, "Mass: ", "kg")));
        drag_per_v2 = str2double(string(extractBetween(drag.String, "Estimated drag: ", " Newtons/v2")));
        thrust = str2double(engine_thrust.String);
        isp = str2double(engine_isp.String);
        prop_weight_num = str2double(prop_weight.String([25:end]));
        % Set variables gained from the construction of the rocket

        mfr = thrust / (isp * 9.81);
        % Mass flow rate equation is derived from rocket thrust equation

        velocity(1) = 0;
        altitude(1) = 0;
        acc_thrust = thrust / rocket_mass;
        acc_drag = drag_per_v2 * (velocity ^ 2) / rocket_mass;
        acc_grav = (3.98603 * 10^14) / ((6371000 + altitude)^2);
        % The purpose of these is to initialize variables and provide
        % further organization to the script

        subplot("Position", [0.2 0.2 0.6 0.6]);
        plot([], []); 
        axis([0 1 0 1]);
        % Initialize plot by setting an empty graph
    
        exit_var = 0;
        time_count = 1;
        while exit_var ~= 1
        % While program is not exited by script...

            if time_count == 1
            % Initial calculation (contains no drag)
                acc_total_num = acc_thrust - acc_grav;
                acceleration(1) = acc_total_num;
                velocity(1) = acc_total_num;
                altitude(1) = velocity(1);
                prop_weight_num = prop_weight_num - mfr;
                rocket_mass = rocket_mass - mfr;
                time_count = 2;
        
            elseif time_count > 1 && prop_weight_num > 0
            % While there is still propellant left in the rocket, ...

                acc_thrust = thrust / rocket_mass;
        
                if altitude(time_count - 1) >= 100000
                    acc_drag = 0;
                else
                    acc_drag = drag_per_v2 * (1 - (altitude(time_count - 1) / 100000)^2) * (velocity(time_count - 1) ^ 2) / rocket_mass;
                end
        
                acc_grav = (3.98603 * 10^14) / (6371000 + altitude(time_count - 1))^2;
                acc_total_num = acc_thrust - acc_drag - acc_grav;
                acceleration(time_count) = acc_total_num;
                velocity(time_count) = velocity(time_count - 1) + acc_total_num;
                velocity_num = velocity(time_count - 1) + acc_total_num;
                altitude(time_count) = altitude(time_count - 1) + velocity(time_count);
                time_count = time_count + 1;
                prop_weight_num = prop_weight_num - mfr;
                rocket_mass = rocket_mass - mfr;
            
        
            elseif time_count > 1 && prop_weight_num <= 0
            % When propellant runs out... (no thrust)
        
                if altitude(time_count - 1) >= 100000
                    acc_drag = 0;
                else
                    acc_drag = drag_per_v2 * (1 - (altitude(time_count - 1) / 100000)^2) * (velocity(time_count - 1) ^ 2) / rocket_mass;
                end
        
                acc_grav = (3.98603 * 10^14) / (6371000 + altitude(time_count - 1))^2;
                acc_total_num = 0 - acc_drag - acc_grav;
                acceleration(time_count) = acc_total_num;
                velocity(time_count) = velocity(time_count - 1) + acc_total_num;
                velocity_num = velocity(time_count - 1) + acc_total_num;
                altitude(time_count) = altitude(time_count - 1) + velocity(time_count);
                time_count = time_count + 1;

                if velocity_num <= 0 || time_count >= 5001
                % If either rocket escapes gravity or velocity is 0
                    exit_var = 1;
                end
                
            end

        end
    
    else
    % If rocket has two stages

        tot_rocket_mass = str2double(string(extractBetween(stage1_mass.String, "Mass: ", "kg"))) + str2double(string(extractBetween(stage2_mass.String, "Mass: ", "kg")));
        stage1_mass = str2double(string(extractBetween(stage1_mass.String, "Mass: ", "kg")));
        stage2_mass = str2double(string(extractBetween(stage2_mass.String, "Mass: ", "kg")));
        drag_per_v2 = str2double(string(extractBetween(drag2.String, "Estimated drag: ", " Newtons/v2")));
        stage1_thrust = str2double(engine_thrust.String);
        stage2_thrust = str2double(engine_thrust2.String);
        isp1 = str2double(engine_isp.String);
        isp2 = str2double(engine_isp2.String);
        prop_weight_num1 = str2double(prop_weight.String([25:end]));
        prop_weight_num2 = str2double(prop_weight2.String([25:end]));
        % Set variables gained from the construction of the rocket

        mfr1 = stage1_thrust / (isp1 * 9.81);
        mfr2 = stage2_thrust / (isp2 * 9.81);
        % Mass flow rate equation is derived from rocket thrust equation

        velocity(1) = 0;
        altitude(1) = 0;
        acc_thrust1 = stage1_thrust / tot_rocket_mass;
        acc_thrust2 = stage2_thrust / stage2_mass;
        acc_drag1 = drag_per_v2 * (velocity ^ 2) / tot_rocket_mass;
        acc_drag2 = drag_per_v2 * (velocity ^ 2) / stage2_mass;
        acc_grav = (3.98603 * 10^14) / ((6371000 + altitude)^2);

        subplot("Position", [0.2 0.2 0.6 0.6]);
        plot([], []); 
        axis([0 1 0 1]);
        % Initialize plot by setting an empty graph

        exit_var = 0;
        time_count = 1;
        while exit_var ~= 1
        % While program is not exited by script...
        %<SM:WHILE>

            if time_count == 1
            % Initial calculation (contains no drag)

                acc_total_num = acc_thrust1 - acc_grav;
                acceleration(1) = acc_total_num;
                velocity(1) = acc_total_num;
                altitude(1) = velocity(1);
                prop_weight_num1 = prop_weight_num1 - mfr1;
                tot_rocket_mass = tot_rocket_mass - mfr1;
                time_count = 2;
        
            elseif time_count > 1 && prop_weight_num1 > 0
            % If stage 1 contains propellant...
                acc_thrust1 = stage1_thrust / tot_rocket_mass;
        
                if altitude(time_count - 1) >= 100000
                    acc_drag = 0;
                else
                    acc_drag = drag_per_v2 * (1 - (altitude(time_count - 1) / 100000)^2) * (velocity(time_count - 1) ^ 2) / tot_rocket_mass;
                end
        
                acc_grav = (3.98603 * 10^14) / (6371000 + altitude(time_count - 1))^2;
                acc_total_num = acc_thrust1 - acc_drag - acc_grav;
                acceleration(time_count) = acc_total_num;
                velocity(time_count) = velocity(time_count - 1) + acc_total_num;
                velocity_num = velocity(time_count - 1) + acc_total_num;
                altitude(time_count) = altitude(time_count - 1) + velocity(time_count);
                time_count = time_count + 1;
                prop_weight_num1 = prop_weight_num1 - mfr1;
                tot_rocket_mass = tot_rocket_mass - mfr1;
            
        
            elseif time_count > 1 && prop_weight_num1 <= 0 && prop_weight_num2 > 0
            % STAGE SEPARATION - Stage 1 runs out of propellant

                acc_thrust2 = stage2_thrust / stage2_mass;
        
                if altitude(time_count - 1) >= 100000
                    acc_drag = 0;
                else
                    acc_drag = drag_per_v2 * (1 - (altitude(time_count - 1) / 100000)^2) * (velocity(time_count - 1) ^ 2) / stage2_mass;
                end
        
                acc_grav = (3.98603 * 10^14) / (6371000 + altitude(time_count - 1))^2;
                acc_total_num = acc_thrust2 - acc_drag - acc_grav;
                acceleration(time_count) = acc_total_num;
                velocity(time_count) = velocity(time_count - 1) + acc_total_num;
                velocity_num = velocity(time_count - 1) + acc_total_num;
                altitude(time_count) = altitude(time_count - 1) + velocity(time_count);
                time_count = time_count + 1;
                prop_weight_num2 = prop_weight_num2 - mfr2;
                stage2_mass = stage2_mass - mfr2;

            elseif time_count > 1 && prop_weight_num1 <= 0 && prop_weight_num2 <= 0
            % Both stages have ran out of propellant

                if altitude(time_count - 1) >= 100000
                    acc_drag = 0;
                else
                    acc_drag = drag_per_v2 * (1 - (altitude(time_count - 1) / 100000)^2) * (velocity(time_count - 1) ^ 2) / stage2_mass;
                end

                acc_grav = (3.98603 * 10^14) / (6371000 + altitude(time_count - 1))^2;
                acc_total_num = 0 - acc_drag - acc_grav;
                acceleration(time_count) = acc_total_num;
                velocity(time_count) = velocity(time_count - 1) + acc_total_num;
                velocity_num = velocity(time_count - 1) + acc_total_num;
                altitude(time_count) = altitude(time_count - 1) + velocity(time_count);
                time_count = time_count + 1;

                if velocity_num <= 0 || time_count >= 5001
                % If either rocket escapes gravity or velocity is 0
                    exit_var = 1;
                end
                
            end
        end
    
    
    
    end

    countdown.Position(4) = 0.05*ScreenHeight;
    % Make the countdown visible

    for sec = linspace(4, 0, 5)
    % 5, 4, 3, 2, 1.. booster ignition!

        for centisec = linspace(99, 0, 100)
        % Just to make it look cooler, iterate over centiseconds
            countdown.String = "T- " + string(sec) + ":" + string(centisec);
            pause(0.01)
        end
    end
    
    time_interval = linspace(1, time_count - 1, time_count - 1);
    subplot("Position", [0.2 0.2 0.6 0.6]);
    % Set plot for flight data

    for n = time_interval
    % Iterate over time

        if altitude(n) < 10000
        % If the altitude is greater than 10,000 meters, write kilometers
        % instead of meters

            rocket_altitude.String = "Altitude: " + string(altitude(n)) + " m";
        else
            rocket_altitude.String = "Altitude: " + string(altitude(n) / 1000) + " km";
        end

        rocket_velocity.String = "Velocity: " + string(velocity(n)) + " m/s";
        rocket_acceleration.String = "Acceleration: " + string(acceleration(n)) + " m/s2";

        plot(time_interval, altitude);
        axis([0 time_interval(n) 0 1.01*altitude(n)]);
        % Animated plot

        if n <= 30
        % For the first 30 seconds, animate the graph relatively slowly
            pause(0.1)
        else
        % Past 30 seconds, accelerate the rate at which the graph is
        % animated
            pause(7.02/(n ^ 1.25))
        end
        
        countdown.String = "T+ " + string(n);
        % Iterate over time for countdown


        alt_bar_perc.Position(4) = 0.6 * (altitude(n) / altitude(time_count - 1));
        % Make the altitude bar more filled over time, ultimiately
        % completely filling the bar when it's at max altitude
    end

    if velocity(time_count - 1) < 100
    % If the velocity (assumedly) approaches zero
        rocket_velocity.String = "Velocity: 0 m/s";
    else
    % If the rocket escapes gravity
        escape_message.Position(4) = 0.03*ScreenHeight;
    end
end

% WOW!