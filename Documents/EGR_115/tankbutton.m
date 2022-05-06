function tankbutton(button, event, engine, engine_slide, tank_mat_select, tank_density, tank_strength, tank_price, tank_dia_text, tank_dia, tank_height_text, tank_height, tank_thickness, tank_weight, tank_price_overall, tank_error_message, prop_select, prop_density, prop_isp, prop_price, prop_weight, prop_price_overall, correction_message, isp_correction, thrust_correction, fair_mat_select, fair_thickness, fair_weight, fair_price_overall, fair_density, fair_strength, fair_price, stage_choice, nosecone, drag, nose_weight, nose_cost, sim_button, engine2, engine_slide2, stage1_thrust, stage1_mass, stage1_tw, stage2_thrust, stage2_mass, stage2_tw, stack_tw, tank_mat_select2, tank_density2, tank_strength2, tank_price2, tank_dia_text2, tank_dia2, tank_height_text2, tank_height2, tank_thickness2, tank_weight2, tank_price_overall2, tank_error_message2, prop_select2, prop_density2, prop_isp2, prop_price2, prop_weight2, prop_price_overall2, correction_message2, isp_correction2, thrust_correction2, fair_mat_select2, fair_thickness2, fair_weight2, fair_price_overall2, fair_density2, fair_strength2, fair_price2, nosecone2, drag2, nose_weight2, nose_cost2)

ScreenSize = get(groot, 'ScreenSize');
ScreenLength = ScreenSize(3);
ScreenHeight = ScreenSize(4);

for pos = 1:length(engine)
    engine(pos).Position(4) = 0;
end

engine_slide.Position(4) = 0;
stage1_thrust.Position(4) = 0.03*ScreenHeight;
stage1_mass.Position(4) = 0.03*ScreenHeight;
stage1_tw.Position(4) = 0.03*ScreenHeight;

tank_mat_select.Position(4) = 0.36;

tank_density.Position(4) = 0.03*ScreenHeight;
tank_strength.Position(4) = 0.03*ScreenHeight;
tank_price.Position(4) = 0.03*ScreenHeight;

tank_dia_text.Position(4) = 0.03*ScreenHeight;
tank_dia.Position(4) = 0.03*ScreenHeight; 
tank_height_text.Position(4) = 0.03*ScreenHeight; 
tank_height.Position(4) = 0.03*ScreenHeight;
tank_thickness.Position(4) = 0.05*ScreenHeight;
tank_weight.Position(4) = 0.05*ScreenHeight;
tank_price_overall.Position(4) = 0.05*ScreenHeight;
tank_error_message.Position(4) = 0.05*ScreenHeight;

if strcmp(tank_price_overall.String, "Tank Cost: ") == 0
    prop_select.Position(4) = 0.36;
    prop_density.Position(4) = 0.03*ScreenHeight;
    prop_isp.Position(4) = 0.03*ScreenHeight;
    prop_price.Position(4) = 0.03*ScreenHeight;
    prop_weight.Position(4) = 0.03*ScreenHeight;
    prop_price_overall.Position(4) = 0.03*ScreenHeight;
    correction_message.Position(4) = 0.06*ScreenHeight;
    isp_correction.Position(4) = 0.03*ScreenHeight;
    thrust_correction.Position(4) = 0.03*ScreenHeight;
end

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
sim_button.Position(4) = 0;

for pos = 1:length(engine2)
    engine2(pos).Position(4) = 0;
end

engine_slide2.Position(4) = 0;
stage2_thrust.Position(4) = 0;
stage2_mass.Position(4) = 0;
stage2_tw.Position(4) = 0;
stack_tw.Position(4) = 0;

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

% DISPLAY ONLY UICONTROLS THAT ARE ON TANK SECTION