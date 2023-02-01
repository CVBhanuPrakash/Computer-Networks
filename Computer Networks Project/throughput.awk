BEGIN {
startTime = 0
finishTime = 0
flag = 0
fsize=0
throughput = 0
latency = 0

#packet delivery ratio variables
recieve=0
drop=0
total=0
ratio=0
sent=0
}

#throughput calculation
{
if($1=="r"&&$4==7)
{
fsize+=$6
if(flag==0)
{
startTime=$2
flag=1
}
finishTime = $2
}
}
#packet delivery calculation
{
if($1=="r"&&$4==7)
{
recieve++
}
if($1=="d")
{
drop++
}
}

END{
latency=finishTime-startTime
throughput = (fsize*8)/latency
printf("\n Latency : %f",latency)
printf("\n Throughput : %f\n",throughput)

total=recieve+drop
ratio=(recieve/total)*100
printf("\n Total packet sent : %d",total)
printf("\n Total packet drop : %d",drop)
printf("\n Packet delivery ratio : %d\n",ratio) 
}
