(define (problem staffMineral)
    (:domain coursework)
    
    (:objects
    
    ;In this mission or problem, the crew are not in their correct rooms 
    ;to begin the mission, first they all must move before the mission can start.
    ;The captain will then give the order and the submarine will move to the ridge 
    ;where minerals are present, the mining mini sub will then deploy to collect the minerals 
    ;(an engineer must be present in the launch bay) and deposit them in the launch
    ;bay. The scientist will then move the minerals to the sciencelab and study them
    ;getting valuable data which will then be delivered to the seaport, finishing the 
    ;mission.
    
    
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
     
    ;Minerals that can be mined 
     mineral1 - mineral 
     
     
    ;Types of mini submarines stored in the launchBay 
     mining1 - miniMine 
     
    ;Data stored from missions
     mineralData1 - mineralData
     mineralData1 - data
   
  )
    
    
  (:init
  
       (not(mission1))
  
      ;Minerals
       (mineral mineral1)
       
       
      ;Flags
       (not(order))
       (not(sampleDataCollected))

  
      ;The submarines
       (submarine submarine1)  
       (miniSubmarine mining1)
       
       
      ;Where the mini submarine are located
       (inSub launchbay1 mining1)
       
      
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
       
       
       ;The health of the crewmates injured/healthy
       (healthy captain1)
       (healthy navigator1)
       (healthy engineer1)
       (healthy engineer2)
       (healthy scientist1)
       (healthy security1)
       
       
       
      ;Where the crewmates are initally located
       (personIn captain1 launchbay1)
       (personIn navigator1 medbay1)
       (personIn engineer1 sciencelab1)
       (personIn engineer2 launchbay1)
       (personIn scientist1 sciencelab1)
       (personIn security1 bridge1)
       
 
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
      
      
      ;Where some minerals are located
       (mineralAt mineral1 ridge1)
      
      
  )


    (:goal
        (and
           (mission1)
        )
    )
)