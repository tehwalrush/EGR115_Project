import re
rel_time = "0"
while type(rel_time) == str or type(rel_time) == float:
    time = input("How much non-relativistic time has elapsed? ")
    speed = input("How fast are you moving as a percent of C? ")
    if str(speed) == "100":
        rel_time = "infinity"
    else:
        speed_var = float(1 - ((float(speed) / 100) ** 2))
        rel_time = float(time) / ((speed_var) ** 0.5)
    rel_time_stripped = ' '.join(re.findall("[\d]*\.[\d]{2}", str(rel_time)))
    print("Relativistic time elapsed is " + str(rel_time_stripped))