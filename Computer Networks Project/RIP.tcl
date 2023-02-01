set val(stop)   10.0                         ;# time of simulation end

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

$ns rtproto DV

#Open the nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

set nt [open trace.tr w]
$ns trace-all $nt


#Define a 'finish' procedure
proc finish {} {
        global ns nf
        $ns flush-trace
 #Close the trace file
        close $nf
 #Execute nam on the trace file
        exec nam out.nam &
        exit 0
}
#===================================
#        Nodes Definition        
#===================================
#Create 11 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes
$ns duplex-link $n10 $n9 20.0Mb 10ms DropTail
$ns queue-limit $n10 $n9 50
$ns duplex-link $n10 $n0 20.0Mb 10ms DropTail
$ns queue-limit $n10 $n0 50
$ns duplex-link $n0 $n2 20.0Mb 10ms DropTail
$ns queue-limit $n0 $n2 50
$ns duplex-link $n2 $n7 20.0Mb 10ms DropTail
$ns queue-limit $n2 $n7 50
$ns duplex-link $n7 $n4 20.0Mb 10ms DropTail
$ns queue-limit $n7 $n4 50
$ns duplex-link $n4 $n1 20.0Mb 10ms DropTail
$ns queue-limit $n4 $n1 50
$ns duplex-link $n1 $n3 20.0Mb 10ms DropTail
$ns queue-limit $n1 $n3 50
$ns duplex-link $n3 $n8 20.0Mb 10ms DropTail
$ns queue-limit $n3 $n8 50
$ns duplex-link $n8 $n5 20.0Mb 10ms DropTail
$ns queue-limit $n8 $n5 50
$ns duplex-link $n5 $n6 20.0Mb 10ms DropTail
$ns queue-limit $n5 $n6 50
$ns duplex-link $n1 $n0 20.0Mb 10ms DropTail
$ns queue-limit $n1 $n0 50

#Give node position (for NAM)
$ns duplex-link-op $n10 $n9 orient right-up
$ns duplex-link-op $n10 $n0 orient right-down
$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n2 $n7 orient right-down
$ns duplex-link-op $n7 $n4 orient right-up
$ns duplex-link-op $n4 $n1 orient left-up
$ns duplex-link-op $n1 $n3 orient left-down
$ns duplex-link-op $n3 $n8 orient right-up
$ns duplex-link-op $n8 $n5 orient right-down
$ns duplex-link-op $n5 $n6 orient left-down
$ns duplex-link-op $n1 $n0 orient left-up

set tcp0 [new Agent/TCP]
$ns attach-agent $n10 $tcp0

#Create a Null agent (a traffic sink) and attach it to node n(7)
set sink [new Agent/TCPSink]
$ns attach-agent $n7 $sink
$ns connect $tcp0 $sink

#Create a FTP Traffic source and connect it to TCP connection
set ftp [new Application/FTP]
$ftp attach-agent $tcp0
$ftp set type_ FTP
$ftp set packet_size_ 1500
$ftp set interval_ 0.010
$ftp set rate_ 1mb

#Schedule events for the FTP application and the network dynamics
$ns at 0.5 "$ftp start"
$ns rtmodel-at 1.5 down $n0 $n2
$ns rtmodel-at 2.5 up $n0 $n2
$ns at 3.5 "$ftp stop"

#Call the finish procedure after 3.5 seconds of simulation time
$ns at 3.5 "finish" 

#Run the simulation
$ns run


