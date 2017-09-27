set ns [new Simulator]

$ns color 1 Blue
$ns color 2 Red

set nf [open network_class.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam network_class.nam &
	exit 0
}

for {set i 0} { $i < 4 } { incr i } {
	set n1($i) [$ns node]
}

set r1 [$ns node]
set r2 [$ns node]

for {set i 0} { $i < 4 } { incr i } {
	set n2($i) [$ns node]
}

#linking nodes of network 1 with router
for {set i 0} { $i < 4} {incr i} {
	$ns duplex-link $n1($i) $r1 1Mb 10ms DropTail
}


#linking nodes of network 2 with router
for {set i 0} { $i < 4} {incr i} {
	$ns duplex-link $n2($i) $r2 1Mb 10ms DropTail
}

$ns duplex-link $r1 $r2 10Mb 10ms DropTail

#connect n1(2) to n2(0)
set udp0 [new Agent/UDP]
set cbr0 [new Application/Traffic/CBR]
set null0 [new Agent/Null]
$udp0 set class_ 1
$cbr0 set packetSize 1024
$cbr0 set interval 0.005
$cbr0 set rate 500Kb
$cbr0 attach-agent $udp0
$ns attach-agent $n1(2) $udp0
$ns attach-agent $n2(0) $null0
$ns connect $udp0 $null0


#connect n2(3) to n1(1)
set udp1 [new Agent/UDP]
set cbr1 [new Application/Traffic/CBR]
set null1 [new Agent/Null]
$udp1 set class_ 2
$cbr1 set packetSize 1024
$cbr1 set interval 0.005
$cbr1 set rate 700Kb
$cbr1 attach-agent $udp1
$ns attach-agent $n2(3) $udp1
$ns attach-agent $n1(1) $null1
$ns connect $udp1 $null1

for {set i 0} {$i < 4} {incr i} {

	$ns at 0.0 "$n1($i) label \"10.10.2.[expr 100+$i]\""
	$ns at 0.0 "$n2($i) label \"172.24.3.[expr 42+$i]\""

}
$ns at 0.0 "$r1 label \"10.10.2.1\""
$ns at 0.0 "$r2 label \"172.24.3.1\"" 
$ns at 0.4 "$cbr0 start"
$ns at 0.6 "$cbr1 start"
$ns at 3.6 "$cbr1 stop"
$ns at 4.0 "$cbr0 stop"
$ns at 4.2 "finish"
$ns run

