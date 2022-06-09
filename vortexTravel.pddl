(define (problem vortexTravel)
    (:domain coursework)
    
    (:objects
    
    
    ;People serving on the submarine
     captain1 - captain
     navigator1 - navigator
     engineer1 engineer2 - engineer
     scientist1 - scientist
     security1 - security
     
     captain1 - person
     navigator1 - person
     engineer1 - person
     scientist1 - person
     security1 - person
     
     
    ;Rooms in the submarine
     bridge1 - Bridge
     medbay1 - medbay
     engineering1 - engineering
     sciencelab1 - scienceLab
     launchbay1 - launchBay
     messHall1 - messHall
     
     
    ;The submarine itself
     submarine1 - submarine
     
     
    ;The underwater areas the submarine can travel to
     seaport1 - seaport
     emptyRegion1 - emptyRegion
     ridge1 - ridge
     vortex1 vortex2 - vortex 
     abyssalPlain1 abyssalPlainWithBase - abyssalPlain

  )
    
    
  (:init
       (not(mission4))

      ;Flags
       (not(order))
       (not(vortexSafe))
       
       ;To destroy or not destroy the submarine choose between engineerasleep and not engineerasleep
       
       (not(shieldUp))
       ;(engineerasleep)
       (not(engineerasleep))
  
      ;The submarines
       (submarine submarine1)  
       
       
      ;The different sea areas
       (seaArea seaport1)
       (seaArea emptyRegion1)
       (seaArea ridge1)
       (seaArea vortex1)
       (seaArea vortex2)
       (seaArea abyssalPlain1)
       (seaArea abyssalPlainWithBase)
       
      
      ;Crewmates serving on the submarine
       (person captain1)
       (person navigator1)
       (person scientist1)
       (person engineer1)
       (person engineer2)
       (person security1)
       
       
      ;Where the crewmates are initally located
       (personIn captain1 bridge1)
       (personIn navigator1 bridge1)
       (personIn engineer1 bridge1)
       (personIn engineer2 sciencelab1)
       (personIn scientist1 sciencelab1)
       
       
       ;The health of the crewmates injured/healthy
       (healthy captain1)
       (healthy navigator1)
       (healthy engineer1)
       (healthy engineer2)
       (healthy scientist1)
       (healthy security1)
       
       
       ;Are the crewmates hungry or not
      (hungry captain1)
      (hungry navigator1)
      (hungry engineer1)
      (hungry engineer2)
      (hungry scientist1)
      (hungry security1)
       
       
       ;The different rooms located in the submarine
       (subRoom bridge1)
       (subRoom medbay1)
       (subRoom engineering1)
       (subRoom sciencelab1)
       (subRoom launchbay1)
       (subRoom messHall1)
      
      
      ;The room layout of the submarine
      ;People will have to move from one room to other 
      ;To reach their goal
       (roomPath bridge1 messHall1)
       (roomPath messHall1 bridge1)
       (roomPath messHall1 medbay1)
       (roomPath medbay1 messHall1) 
       (roomPath medbay1 engineering1)
       (roomPath engineering1 medbay1)
       (roomPath engineering1 sciencelab1)
       (roomPath sciencelab1 engineering1)
       (roomPath sciencelab1 launchbay1)
       (roomPath launchbay1 sciencelab1)
      
      
      ;Where the submarine will start
       (AtSeaArea submarine1 seaport1)
      
      
  )


    (:goal
        (and
            (mission4)
        )
    )
)