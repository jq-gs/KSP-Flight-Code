// Falcon 9 Launch

function main {
    doCountdown().
    doLaunch().
    doAscent().
    doStaging().
    doShutdown().
}


 function doCountdown {
 PRINT "Counting down:".
 FROM {local countdown is 10.} UNTIL countdown = 0 STEP {set countdown to countdown - 1.} DO {
     PRINT "..." + countdown.
     WAIT 1.
}

function doLaunch {
    lock throttle to 1.
    wait 11.
    doSafeStage().
}

 function doSafeStage {
     wait until stage:ready.
     stage.
 }

function doAscent {
    lock angle to 8.90244E-8 alt:radar^2 - 0.00535976 * alt:radar + 90.6098.
    lock steering to heading(90, angle).
}

function doStaging {
    lock availThrust to ship:availablethrust.
    until apoapsis > 80000 {
        if ship:availablethrust < (availThrust - 10).
        stage. wait 1.
        set availThrust to ship:availablethrust.
    }
}



function doShutdown{
    lock throttle to 0.
    lock steering to prograde.
    wait until false.
}

main().