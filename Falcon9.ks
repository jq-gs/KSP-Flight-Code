// Falcon 9 Launch

function main {
    doCountdown().
    doLaunch().
    doAscent().
    doStaging().
    doShutdown().
}


 function doCountdown {
 print "Counting down:".
 from {local countdown is 10.} until countdown = 0 step {set countdown to countdown - 1.} do {
     print "..." + countdown.
     wait 1.
     
    }
 print "Liftoff!".
 RCS on.         
}

function doLaunch {
    lock throttle to 0.75.
    doSafeStage().
}

 function doSafeStage {
     wait until stage:ready.
     stage.
 }

function doAscent {
    until apoapsis > 21500 {
        lock angle to 0.0000000890244 * alt:radar^2 - 0.00535976 * alt:radar + 90.6098.
        // New Equation -0.00000001 * alt:radar^2 - 0.0032 * alt:radar + 91.5.
        // Old Equation: 0.0000000890244 * alt:radar^2 - 0.00535976 * alt:radar + 90.6098.
        if alt:radar < 300 {
            lock steering to heading(90, 90).
        } else {
            lock steering to heading(90, angle).
        }
    }   
}

function doStaging {   
    until 0 {
        if apoapsis >= 21500 {
            print "MECO".
            global lock throttle to 0.
            wait 2.
            print "Stage Separation".
            stage.
            wait 7.
            Boostback ().
            break.
        }
    }
}

function Boostback {
        print "Boostback Burn Startup".
        global lock throttle to 1.
        lock steering to heading(90,0).
}
        //set availThrust to ship:availablethrust.
        // if ship:availablethrust < (availThrust - 10) {
        // stage. 
        // wait 1.
        // } 
        // set availThrust to ship:availablethrust.



function doShutdown{
    lock throttle to 0.
    lock steering to prograde.
    wait until false.
}

main().
