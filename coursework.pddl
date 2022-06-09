(define (domain coursework)
    (:requirements
        :strips 
        :typing 
        :equality
        :conditional-effects
    )

    ;Types used for the creation of the submarine crew and areas they can visit 
    ;Allows types and sub types making actions easier to define 
    ;For example the action give order can only occur with captain and navigator types
    (:types
        person
        captain 
        navigator
        engineer
        scientist
        security
        
        bridge
        medbay
        engineering
        scienceLab
        launchBay
        messHall
        
        submarine
        miniMine
        miniExplore
        
        seaport 
        emptyRegion
        ridge 
        vortex
        abyssalPlain
        
        underWaterBase
        mineral
        
        data
        vortexData
        mineralData
        sensorData
        baseData
        
    )


    (:predicates
        ;Underwater base, its location and if the submarine is currently there
        (underWaterBase ?b)
        (baseAt ?b ?wa)
        (atBase ?s ?b)
        
        ;Minerals and its current location
        (mineral ?o)
        (mineralAt ?o ?wa)
        
        ;submarine information, its location, what is in it, wreck location
        (AtSeaArea ?s ?wa)
        (submarine ?s)
        (inSub ?x ?y)
        (miniSubmarine ?m)
        (submarineWreckAt ?w)
       
       ;Submarine room information, and the paths between rooms
        (subRoom ?r)
        (roomPath ?x ?y)
        
        ;Different under water areas (ridge,vortex)
        (seaArea ?wa)
        
        ;Information about crewmates, hungry, location in Submarine
        (personIn ?p ?r)
        (person ?p)
        (healthy ?p)
        (hungry ?h)
        
        ;Use for specific events or information, as a true flalse flag 
        (order)
        (shieldUp)
        (vortexSafe)
        (landedAtPlain)
        (sensorDeployed)
        (baseTakenOver)
        (securityPresent)
        (submarineDestroyed)
        (missionStart)
        
        (baseVisit)
        (sensorDataCollected)
        (sampleDataCollected)
        (vortexDataCollected)
        
        ;Data gathered from Submarine missions and its current location
        (data ?d)
        (DataIn ?d ?s)
        (DataAt ?d ?wa)
        
        ;Is the engineer asleep on the job
        (engineerasleep)
        
        ;The missions the Submarine can take        
        (mission1)
        (mission2)
        (mission3)
        (mission4)
        (missionAll)
 
    )
    
    
   ;Allows crew to change rooms - bridge to messHall etc
    (:action MoveSubRoom
        :parameters
            (?x ?y ?p)
        :precondition
            (and
                (roomPath ?x ?y) ;From one room to another
                
                (personIn ?p ?x) ;must be in the first room
            )
        :effect
            (and
                (personIn ?p ?y) ;person is now in the next room
                
                (not(personIn ?p ?x)) ;person is no longer in the previous room
            )
    )
    
    
   ;Captain orders navigator at bridge to move submarine, the types only Allow
   ;for the p1 and p2 to be the captain and navigator
    (:action giveOrder
        :parameters
            (?p1 - captain ?p2 - navigator ?s - bridge)
        :precondition
            (and
                (personIn ?p1 ?s) ;captain must be in the bridge
                
                (personIn ?p2 ?s) ;navigator must be in the bridge
                
                (healthy ?p1) ;captain must not be injured
                
                (not(hungry ?p1)) ;captain must not be hungry
                
                (not(hungry ?p2)) ;navigator must not be hungry
            )
        :effect
            (and
                (order) ;the order to move the submarine has been given
            )
    )
    
    
   ;If a crew mate is injured they can be healed
   ;Person must be injured and in the medbay to get healed
    (:action healMedbay
        :parameters
            (?p - person ?r - medbay)
        :precondition
            (and
                (personIn ?p ?r) ;person must be in the medbay
                
                (not(healthy ?p)) ;they must be injured
            )
        :effect
            (and
                (healthy ?p) ;the person will now be healthy
            )
    )
    
    
    ;If a crew mate is hungry they can get some food here
    ;person must be hugnry and in the messHall
    (:action EatFood
        :parameters
            (?p - person ?r - messHall)
        :precondition
            (and
                (personIn ?p ?r) ;person must be in the messHall
                
                (hungry ?p) ;they must be hungry
            )
        :effect
            (and
                (not(hungry ?p)) ;the person will now be full :)
            )
    )
    
    
   ;Move the submarine to a new underwater area 
   ;submarine must be at the start region and will then be at the next region
    (:action moveSeaArea 
        :parameters 
            (?s ?wa1 ?wa2)
        :precondition   
            (and 
                (seaArea ?wa1) ;the starting sea area
                (seaArea ?wa2) ;the desired sea area
                                
                (submarine ?s) ;the submarine the crew are in
                
                (AtSeaArea ?s ?wa1) ;the submarine must be at the starting point
                
                (order) ;the order to travel must be given
            )
                                
        :effect         
            (and 
                (AtSeaArea ?s ?wa2) ;now at the desired area
                
                (not (AtSeaArea ?s ?wa1)) ;no longer at the starting point
                
                (not(order)) ;the order has now been completed
            )
    )
   
    
   ;Deploy the mining submarine from the launch bay at a ridge
   ;mini sub must be in the launchBay, must be an engineer present 
   ;must be at a ridge
   ;results in the mineral being retrieved and placed in the launchBay
    (:action deployMiner
        :parameters 
            (?s - submarine ?r - launchBay ?m - miniMine ?wa - ridge ?o - mineral ?p - engineer)
        :precondition
            (and
                (AtSeaArea ?s ?wa) ;the submarine location must match the mineral
                (mineralAt ?o ?wa) ;current mineral location
                
                (inSub ?r ?m) ;mining minusub must be in the launchBay
                
                (personIn ?p ?r) ;engineer must be present in the launchBay
                
                (not(hungry ?p)) ;the engineer must not be hungry
            )
        :effect
            (and
                (not(mineralAt ?o ?wa)) ;the mineral is no longer at the ridge
                (inSub ?r ?o) ;the mineral is now in the launchBay
            )
    )
    
    
   ;Deploy the explorer submarine from the launch bay, engineer required
   ;same as the mini mine sub instead the engineer must be in the mini sub
    (:action deployExplorer
        :parameters 
            (?s - submarine ?r - launchBay ?m - miniExplore ?wa - abyssalPlain ?p - engineer)
        :precondition
            (and
                (AtSeaArea ?s ?wa) ;the submarine must be at an abyssalPlain
                
                (inSub ?r ?m) ;the explorer must be in the launchBay
                
                (personIn ?p ?r) ;an engineer must be in the launchBay
                
                (not(hungry ?p)) ;must not be hungry
            )
        :effect
            (and
                (AtSeaArea ?m ?wa) ;the explorer is now outside the submarine
                
                (inSub ?p ?m) ;the engineer is in the explorer
                
                (not (inSub ?r ?m)) ;mini sub no longer in the launchBay
            )
    )
    
    
   ;Deploy the sensor at a vortex from an explorer submarine and retrieve data
   ;sets the sensorDeployed flag to true allowing the mini sub to return 
    (:action deploySensorNet
        :parameters 
            (?s - submarine ?r - launchBay ?m - miniExplore ?wa - abyssalPlain ?p1 - engineer ?p2 - engineer)
        :precondition
            (and
                (not (= ?p1 ?p2)) ; required as it was using the same engineer
                
                (AtSeaArea ?s ?wa) ;the submarine must still be present
                (AtSeaArea ?m ?wa) ;explorer must be at an abyssalPlain
                
                (inSub ?p1 ?m) ;engineer is in the explorer
                
                (personIn ?p2 ?r) ;a second engineer is in the launchBayh
                
                (not(sensorDeployed)) ;the sensor has not already been deployed
                (not(sensorDataCollected)) ;no data has been collected yet
            )
        :effect
            (and
                (sensorDeployed) ;the sensor net has now been deployedl
            )
    )
    
    
    ;Deploy the sensor at a vortex from an explorer submarine and retrieve data
    ;crew mate returns back to the launch bay with the mini sub and disembarks
    (:action returnExplorer
        :parameters 
            (?s - submarine ?r - launchBay ?m - miniExplore ?wa - abyssalPlain ?p1 - engineer ?p2 - engineer ?d - sensorData)
        :precondition
            (and
                (not (= ?p1 ?p2)) ; required as it was using the same engineer
                
                (AtSeaArea ?s ?wa) ;the submarine must still be present
                (AtSeaArea ?m ?wa) ;explorer must be at an abyssalPlain
                
                (inSub ?p1 ?m) ;engineer is in the explorer
                (personIn ?p2 ?r) ;a second engineer is in the launchBay
                
                (sensorDeployed) ;the sensor must be deployed
                (not(sensorDataCollected)) ;no data has been collected yet
            )
        :effect
            (and
                (inSub ?r ?m) ;the sub is now back in the launchBay
                
                (sensorDataCollected) ;the data has now been collected
                
                (personIn ?p1 ?r) ;the engineer is now back in the launchBay
                
                (not(inSub ?p1 ?m)) ;engineer no longer in the explorer
                
                (not(AtSeaArea ?m ?wa)) ;the explorer is no longer outside
                
                (DataIn ?d ?s) ;the data is now in the submarine
            )
    )
    
    
   ;Move to an area containing an underwater base
   ;area must be abyssalPlain and a base must be present
    (:action SubmarineToBase
        :parameters 
            (?s - submarine ?wa - abyssalPlain ?b - underWaterBase)
        :precondition
            (and
                (baseAt ?b ?wa) ;there must be a base at the abyssalPlain
                (AtSeaArea ?s ?wa) ;the submarine must be in the same area
            )
        :effect
            (and
                (AtSeaArea ?s ?wa) 
                (atBase ?s ?b) ;submarine is now at the base
            )
    )
    
    
   ;Commence base visit mission
   ;alot of parameters required as this involes 3 crew mates and the minisub 
   ;captain and security get inside minisub and an engineer must be present to launch it
    (:action deployShuttleToBase
        :parameters 
            (?s - submarine ?wa - abyssalPlain ?b - underWaterBase ?p1 - captain ?p2 - engineer ?p3 - security ?r - launchBay ?m - miniExplore)
        :precondition
            (and
                (baseAt ?b ?wa) 
                (AtSeaArea ?s ?wa) ;must be an area with a base
                
                (inSub ?r ?m) ;the explorer is in the launchBay
                
                (personIn ?p1 ?r) ;captain is in the launchBay
                (personIn ?p2 ?r) ;engineer is in the launchBay
                (personIn ?p3 ?r) ;security must be in the launchBay
            )
        :effect
            (and
                (not(inSub ?r ?m)) ;the explorer is no longer in the launchBay
                
                (not(personIn ?p1 ?r)) ;the captain is no longer in the launchBay
                (not(personIn ?p3 ?r)) ;the security is no longer in the launchBay
                
                (inSub ?p1 ?m) ;captain is now in the explorer
                (inSub ?p3 ?m) ;security is now in the explorer
                
                (AtSeaArea ?m ?wa) ;the explorer is now outside 
                
                (missionStart) ;the mission has begun
            )
    )
    
    
   ;Version of base visit mission were nothing bad occurs
   ;The base has not been taken over so the captain goes to the base and back 
    (:action missionGoesGood
        :parameters 
            (?s - submarine ?wa - abyssalPlain ?b - underWaterBase ?p1 - captain ?p2 - engineer ?p3 - security ?r - launchBay ?m - miniExplore ?d - baseData)
        :precondition
            (and
                (baseAt ?b ?wa) ;base must be at abyssalPlain
                (AtSeaArea ?s ?wa) ;submarine must be at the same abyssalPlain
                (AtSeaArea ?m ?wa) ;the explorer must be at the same abyssalPlain
                
                (inSub ?p1 ?m) ;the captain must be in the explorer
                (inSub ?p3 ?m) ;the security must be in the explorer
                (personIn ?p2 ?r) ;the engineer must be in the launchBay
                
                (not(baseTakenOver)) ;the base has not been taken over
                (missionStart) ;the mission has started
            )
        :effect
            (and
                (baseVisit) ;the base visit goes well
                (inSub ?r ?m) ;the explorer returns to the launchBay
                
                (personIn ?p1 ?r) ;the captain is now in the launchBay
                (personIn ?p3 ?r) ;the security is now in the launchBay
                
                (not(inSub ?p1 ?m)) ;the captain is no longer in the explorer
                (not(inSub ?p3 ?m)) ;security is no longer in the explorer
                
                (not(AtSeaArea ?m ?wa)) ;the explorer is no longer outside
                (not(missionStart)) ;the mission is over
                
                (DataIn ?d ?s) ;base data has been retrieved
            )
    )
    
    
   ;Version of base visit mission were the base is taken over
   ;the base has been taken over but the security personel is present so the 
   ;captain is not injured 
    (:action missionGoesBad
        :parameters 
            (?s - submarine ?wa - abyssalPlain ?b - underWaterBase ?p1 - captain ?p2 - engineer ?p3 - security ?r - launchBay ?m - miniExplore ?d - baseData)
        :precondition
            (and
                (baseAt ?b ?wa) ;base must be at an abyssalPlain
                (AtSeaArea ?s ?wa) ;submarine must be at the abyssalPlain
                
                (inSub ?p1 ?m) ;the captain must be in the explorer
                (inSub ?p3 ?m) ;security must be in the explorer
                
                (personIn ?p2 ?r) ;engineer must be in the launchBay
                
                (baseTakenOver) ;the base has been taken over
                (missionStart) ;the mission has started
                (securityPresent) ;the security protects the captain
            )
        :effect
            (and
                (baseVisit) ;base visit concluded
                 
                (inSub ?r ?m) ;explorer back in the launchBay
                
                (personIn ?p1 ?r) ;captain now in the launchBay
                (personIn ?p3 ?r) ;security now in the launchBay
                
                (not(inSub ?p1 ?m)) ;captain no longer in the explorer
                (not(inSub ?p3 ?m)) ;security no longer in the explorer
                
                (not(AtSeaArea ?m ?wa)) ;explorer no longer outside
                
                (not(missionStart)) ;mission over
                
                (DataIn ?d ?s) ;base data retrieved
            )
    )
    
    
    ;Version of base visit mission were the base is taken over and the captin is injured
    (:action missionGoesBadInjury
        :parameters 
            (?s - submarine ?wa - abyssalPlain ?b - underWaterBase ?p1 - captain ?p2 - engineer ?p3 - security ?r - launchBay ?m - miniExplore ?d - baseData)
        :precondition
            (and
                (baseAt ?b ?wa) ;base must be at an abyssalPlain
                (AtSeaArea ?s ?wa) ;submarine must be at the abyssalPlain
                
                (inSub ?p1 ?m) ;captain must be in the explorer
                (inSub ?p3 ?m) ;security must be in the explorer
                
                (personIn ?p2 ?r) ;engineer must be in the launchBay
                
                (baseTakenOver) ;the base has been taken over
                (missionStart) ;the mission has begun
                (not(securityPresent)) ;the security fails to protect the captain
            )
        :effect
            (and
                (baseVisit) ;base visit completed
                
                (inSub ?r ?m) ;explorer back in the launchBay
                
                (personIn ?p1 ?r) ;captain back in the launchBay
                (personIn ?p3 ?r) ;security now in the launchBay
                
                (not(inSub ?p1 ?m)) ;captain no longer in the explorer
                (not(inSub ?p3 ?m)) ;security no longer in the explorer
                
                (not(AtSeaArea ?m ?wa)) ;explorer no longer outside
                (not(missionStart)) ;mission over
                
                (DataIn ?d ?s) ;base data retrieved
                
                (not(healthy ?p1)) ;the captain was injured
            )
    )
    
    
    ;scientist studies the mineral sample in the science lab
     (:action studyMineralSample
        :parameters 
            (?o - mineral ?r1 - launchBay ?r2 - scienceLab ?p - scientist ?d - mineralData ?s - submarine)
        :precondition
            (and
               (inSub ?r1 ?o) ;the mineral must be in the launchBay
               
               (personIn ?p ?r1) ;only the scientist can move the mineral
               
               (not(sampleDataCollected)) ;data has not been gathered from the sample yet
               
               (not(hungry ?p)) ;the scientist must not be hungry
            )
        :effect
            (and
                (personIn ?p ?r2) ;the scientist is now in the lab
                
                (inSub ?r2 ?o) ;the mineral is now in the scienceLab
                
                (sampleDataCollected) ;some data has been gathered
                
                (not(inSub ?r1 ?o)) ;the mineral is no longer in the launchBay
                
                (DataIn ?d ?s) ;the data is now in the submarine
            )
    )
    
    
   ;Study a vortex if currently at one
    (:action studyVortex
        :parameters 
            (?r - scienceLab ?p - scientist ?wa - vortex ?s - submarine ?d - vortexData)
        :precondition
            (and
               (personIn ?p ?r) ;scientist must be in the lab
               
               (AtSeaArea ?s ?wa) ;the submarine must be in an area containing a vortex
               
               (not(vortexDataCollected)) ;data has not been collected yet
               
               (not(hungry ?p)) ;scientist must not be hungry
            )
        :effect
            (and
                (vortexDataCollected) ;data has been gathered
                
                (DataIn ?d ?s) ;the vortex data is now in the submarine
            )
    )
    
    
   ;Attempt to enter a vortex, arriving at another vortex 
    (:action enterVortex
        :parameters 
            (?wa1 - vortex ?wa2 - vortex ?s - submarine)
        :precondition
            (and
               (AtSeaArea ?s ?wa1) ;submarine must be at a vortex
               
               (shieldUp) ;the pressure shield must be up
               
               (not(engineerasleep)) ;the engineer is awake
            )
        :effect
            (and
                (not(AtSeaArea ?s ?wa1)) ;the submarine is no longer at start
                
                (AtSeaArea ?s ?wa2) ;submarine has traveled through the vortex
                
                (vortexSafe) ;the submarine traveled safely
            )
    )
    
    
   ;Attempt to enter a vortex with no shield
    (:action enterVortexDeath
        :parameters 
            (?wa - vortex ?s - submarine)
        :precondition
            (and
               (AtSeaArea ?s ?wa) ;submarine must be at a vortex
               
               (not(shieldUp)) ;the shield is down
               
               (engineerasleep) ;the engineer is asleep
            )
        :effect
            (and
                (submarineDestroyed) ;the submarine is destroyed 
                
                (submarineWreckAt ?wa) ;the wreck is logged
            )
    )
    
    
   ;Power up the shield to prevent destruction of submarine 
    (:action powerUpShields
        :parameters 
            (?r - bridge ?p - engineer)
        :precondition
            (and
               (personIn ?p ?r) ;engineer must be in the bridge
               
               (not(shieldUp)) ;the shield must already be down
               
               (not(hungry ?p)) ;engineer must not be hungry
            )
        :effect
            (and
                (shieldUp) ;the shield is now up
            ) 
    )
    
    
    ;Mission 1 - crew are in wrong starting positions 
    ;mineral data must then be gathered and returned to base
    (:action mission1
        :parameters 
            (?s - submarine ?wa - seaport ?d1 - mineralData)
        :precondition
            (and
               (not(mission1))
               
               (AtSeaArea ?s ?wa)
               
               (DataIn ?d1 ?s)
            )
        :effect
            (and
                (and
                    (DataAt ?d1 ?wa)
                    
                    (not (DataIn ?d1 ?s))
                    
                    (mission1)
                )
            )
    )
    
    
    ;Mission 2 - crew must gather data from a vortex and then gather data
    ;from an abyssalPlain and return to base
    (:action mission2
        :parameters 
            (?s - submarine ?wa - seaport ?d1 - vortexData ?d2 - sensorData)
        :precondition
            (and
               (AtSeaArea ?s ?wa)
               
               (DataIn ?d1 ?s)
               (DataIn ?d2 ?s)
               
               (not(mission2))
            )
        :effect
            (and
                (and
                    (DataAt ?d1 ?wa)
                    (DataAt ?d2 ?wa)
                    
                    (not (DataIn ?d1 ?s))
                    (not (DataIn ?d2 ?s))
                    
                    (mission2)
                )
            )
    )
    
    
    ;mission 3 - the crew must visit an underwater base 
    ;and return with base data (3 different paths)
    (:action mission3
        :parameters 
            (?s - submarine ?wa - seaport ?d - baseData)
        :precondition
            (and
               (AtSeaArea ?s ?wa)
               (DataIn ?d ?s)
               
               (not(mission3))
            )
        :effect
            (and
                (and
                    (DataAt ?d ?wa)
                    (not (DataIn ?d ?s))
                    
                    (mission3)
                )
            )
    )
    
    ;mission4 - the crew must venture into a vortex and return safely
    ;this also tests the new hunger feature
    (:action mission4
        :parameters 
            (?s - submarine ?wa - seaport)
        :precondition
            (and
               (AtSeaArea ?s ?wa)
               
               (not(mission4))
               
               (vortexSafe)
            )
        :effect
            (and
                (and
                    (mission4)
                )
            )
    )
    
    ;mission 4 - small difference, the engineer is asleep so the pressure is not
    ;activated and the submarine is destroyed as a result
     (:action mission4Fail
        :parameters 
            (?s - submarine)
        :precondition
            (and
               (not(mission4))
               
               (submarineDestroyed)
            )
        :effect
            (and
                (and
                    (mission4)
                )
            )
    )
    
    
    ;Combines all the missions into one 
    (:action missionAll
        :parameters 
            (?s - submarine ?wa - seaport ?d1 - vortexData ?d2 - mineralData ?d3 - sensorData ?d4 - baseData)
        :precondition
            (and
               (AtSeaArea ?s ?wa)
               
               (DataIn ?d1 ?s)
               (DataIn ?d2 ?s)
               (DataIn ?d3 ?s)
               (DataIn ?d4 ?s)
               
               (not(missionAll))
            )
        :effect
            (and
                (and
                    (DataAt ?d1 ?wa)
                    (DataAt ?d2 ?wa)
                    (DataAt ?d3 ?wa)
                    (DataAt ?d4 ?wa)
                    
                    (not (DataIn ?d1 ?s))
                    (not (DataIn ?d2 ?s))
                    (not (DataIn ?d3 ?s))
                    (not (DataIn ?d4 ?s))
                    
                    (missionAll)
                )
            )
    )
    
)