import time
time_constant = "10"
begin_var = "10"
inventory = []
def print_inventory(): 
    if len(inventory) > 0: 
        print("INVENTORY: " + str(inventory))

print("-------------------------\n\n     WELCOME TO GAME\n       begin? (y/n)\n\n-------------------------")
begin = input()

while type(begin_var) == str:
    if begin == "y" or begin == "Y":
        print("\nYou wake up, sweat beading on your forehead. You're used to the blistering cold by now, but seeing your breath briefly reminds you why you're here.")
        print("Sound SLEEP seems like a distant memory. The lack of light peering through the edges of the TENT tell you that, for now at least, you can keep your RADIO off.")
        print("\nType any of the words in CAPS to interact with them.")
        first_choice = input()
        first_var = "10"
        begin_var = 10
    
    elif begin == "n" or begin == "N":
        print("\nWell dang. That's kinda stinky of you.")
        begin_var = 10

    elif begin != "y" or begin != "Y" or begin != "N" or begin != "n":
        print("That wasn't an option, you sussy baka.")
        print("begin? (y/n)")
        begin = input()

while type(first_var) == str:
    if first_choice.lower() == "tent":
        print("\nYou lift yourself off of your mattress and walk towards the front of the tent. As you reach for the ZIPPER, you see your BOOTS in the darkness.")
        first_var = 10
        tent_var = "10"
        second_var = "tent"
        
    elif first_choice.lower() == "sleep":
        print("\nIt's time you got some sleep. Having calmed yourself down, you quickly doze off...")
        first_var = 10
        sleep_var = "10"
        time.sleep(2)
        print("...")
        time.sleep(2)
        print("...")
        time.sleep(2)
        print("Are the gunshots all just a dream? Are you hallucinating? It certainly wouldn't be the first time...")
        print("Should you WAKE up, or go back to SLEEP?")
        second_var = "sleep"
        
    elif first_choice.lower() == "radio":
        print("\nMaybe you're just paranoid, or maybe not. Your radio buzzes on to a calm static. What frequency should you set it to?")
        first_var = 10
        second_var = "radio"
        
    elif first_choice.lower() != "tent" or first_choice.lower() != "sleep" or first_choice.lower() != "radio":
        print(str(first_choice.lower()) + " was not an option.")
        first_choice = input()

while second_var == "tent":
    second_choice = input()
    
    if second_choice.lower() == "boots":
        print("BOOTS has been added to inventory")
        inventory.append("boots")
        
    elif second_choice.lower() == "zipper":
        print("\nThe sound of your tent's zipper being pulled down pierces the otherwise silent night. Relief pours over you when you see the TENTS of the others.")
        print("A ways away, you see the GUARDSMEN holding their rifles. Thank God your midnight shift isn't for a while. The snow on the TREES shimmer in the moonlight.")
        print_inventory()
        second_var == "post zipper"
        tent_var == input()
        
    elif second_choice.lower() != "boots" or second_choice.lower() != "zipper":
        print(str(second_choice.lower()) + " was not an option.")

while second_var == "sleep":
    second_choice = input()
    
    if second_choice.lower() == "wake":
        print("It sounds too real to be a hallucination. Your eyes quickly find your GEAR in the corner of the room.")
        print("The gunshots are getting closers. There isn't much time. There might be a way to RUN and make it out alive.")
        second_var == "wake sleep"
        sleep_var == input()
        
    elif second_choice.lower() == "sleep":
        print("\nHours after you fall asleep, you awake in a place you've never seen before. You try to lift your arms, to no avail.")
        time.sleep(3)
        print("\nAll the years of constant, utter survival has numbed your body from any pain.")
        time.sleep(2)
        print("\nYou are finally free.")
        time.sleep(2)
        print("\nYOU HAVE DIED")
        print("Ending 1 of __: No Sleep")
        second_var = "no sleep"
        
    elif second_choice.lower() != "wake" or second_choice.lower() != "sleep":
        print(str(second_choice.lower()) + " was not an option.")

while second_var == "radio":
    second_choice = input()
    
    if int(second_choice) > 0 and int(second_choice.lower()) < 50:
        print("\nYou tune in to frequency " + str(second_choice) + " and listen.")
        time.sleep(4)
        print("...")
        time.sleep(2)
        print("Nothing...")
        time.sleep(2)
        print("You let out a cough, and hear it echoed softly in the radio. Someone is here. Someone is listening. Instinctively, you draw your handgun.")
        print("\nShould you STAY put, or MOVE outside the tent?")
        print("HANDGUN has been added to inventory")
        inventory.append("handgun")
        second_var == "gun radio"
        gun_radio_var == input()
        
    elif int(second_choice) > 50 and int(second_choice) < 100:
        print("You tune in to frequency " + str(second_choice) + " and listen. Is that... Russian? It sounds like whoever it is, they're transmitting coordinates.")
        print("Should you LISTEN to more on your own, or REPORT the hearing to your com lead?")
        second_var = "russin radio"
        russian_radio == input()
        
    elif int(second_choice) > 100:
        print("You tune in to frequency " + str(second_choice) + " and listen. The voice sounds American, but it's hard to tell.")
        print("The voice speaks of a leaking of government documents revealing a secret military force comprised of United Nations member states.")
        print("\nDid your leaks finally reach the general public? Is this war finally coming to an end?")
        time.sleep(5)
        print("A private pops his head into your tent - they're questioning everyone, and you're up next. Should you GIVE in to interrogation, or is it time to RUN?")
        second_var = "interrogation radio"
        inter_radio == input()
        
    elif int(second_choice) < 0 or second_choice.isnumeric() == False:
        print(str(second_choice.lower()) + " was not an option.")

while tent_var == "tents":
    third_choice == input()
    print("TEST TEST TEST")
    print_inventory()
    tent_var = "yeet"