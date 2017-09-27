set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set nf [open stop_and_wait.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam stop_and_wait.nam &
	exit 0
}


set n(0) [$ns node]
set n(1) [$ns node]

$ns duplex-link $n(0) $n(1) 100Kb 10ms DropTail

for {set i 0} {$i < 2} {incr i} {
	set udp($i) [new Agent/UDP]
	set cbr($i) [new Application/Traffic/CBR]
	$udp($i) set class_ 2
	$cbr($i) set packetSize_ 500
	$cbr($i) set interval_ 0.1
	$cbr($i) attach-agent $udp($i)
	$cbr($i) set rate 1Kb
	$ns attach-agent $n($i) $udp($i)
}

set null0 [new Agent/Null]
set null1 [new Agent/Null]
$ns attach-agent $n(1) $null1
$ns attach-agent $n(0) $null0
$ns connect $udp(0) $null1
$ns connect $udp(1) $null0

for { set i 0 } { $i < 4} {set i [expr $i + 0.3]} {

		$ns at [expr $i + 0.1] "$cbr(0) start"
		$ns at [expr $i + 0.15] "$cbr(0) stop"
		$ns at [expr $i+0.2] "$cbr(1) start"
		$ns at [expr $i+0.25] "$cbr(1) stop"

}

$ns at 1.2 "finish"
$ns run

