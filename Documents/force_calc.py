force = "0"
while type(force) == str or type(force) == float:
    mass = input("input mass of the object: ")
    acceleration = input("input acceleration of the object: ")
    force = float(mass) * float(acceleration)
    print("Net force on the object is " + str(force) + " Newtons")