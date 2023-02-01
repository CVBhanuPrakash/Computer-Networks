BEGIN {
 highest_packet_id = 0;
 total_recieved_packet
}

{
 action = $1;
 time = $2;
 node_1 = $3;
 node_2 = $4;
 src = $5;
 flow_id = $8;
 node_1_address = $9;
 node_2_address = $10;
 seq_no = $11;
 packet_id = $12;
 if ( packet_id > highest_packet_id ) highest_packet_id = packet_id;
 if ( start_time[packet_id] == 0 ) start_time[packet_id] = time;
 if ( action != "d" ) {
 if ( action == "r" ) {
 total_recieved_packet++;
 end_time[packet_id] = time;
 }
 }else {
 end_time[packet_id] = -1;
 }
}
END {
 total_delay;
 for ( packet_id = 0; packet_id <= highest_packet_id; packet_id++ ) {
 start = start_time[packet_id];
 end = end_time[packet_id];
 packet_duration = end - start;
 total_delay+=packet_duration;
 }
 printf("Average delay = %f\n",total_delay/total_recieved_packet);
} 
