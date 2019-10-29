#!/bin/bash
source Master.config
#noOfIterations=2
#intervalInSec=2
i=1
remoteDepth="4"

#cqOut="PROV \n1\n\nNON PROV\n2\n\nACMDFY \n3\n\nEPS\n4\n\nRSS\n5"
cqOut="PROV \n$PROV\n\nNON PROV\n$NON_PROV\n\nACMDFY
\n$ACMDFY\n\nEPS\n$EPS\n\nRSS\n$RSS"


#echo -e $cqOut

getQueueDepth_custom()
{
# cq | xargs |

PROV=$(echo -e $cqOut | xargs | cut -d ' ' -f 2)
NON_PROV=$(echo -e $cqOut | xargs | cut -d ' ' -f 5)
ACMDFY=$(echo -e $cqOut | xargs | cut -d ' ' -f 7)
totalCnt=$((PROV+NON_PROV+ACMDFY))
echo "$totalCnt"
}


getRemoteDepth()
{
	# Retruning a dummy remote queue depth
	# echo $remoteDepth
	echo $(getQueueDepth_custom)
}

validateQueueDepthTest()
{
	queueDepth=$(getRemoteDepth)
	echo "QueueDepth: $queueDepth"
	if [[ "$queueDepth" != "0" ]]
	then
	 echo ">>Remote queue is still non zero"
	 echo ">>Calling mtasCq -c"
	 echo ">>Calling mtasCqReply "
	 # mtasCQ -c
	 # mtasCReply -c
	 return 1
	else
	  echo ">>Remote queue depth is zero"
	  return 0
	fi
	
}



echo "Calling queueDepthFunction for $noOfIterations time for an interval of $intervalInSec"
while [[ $i -le $noOfIterations ]]
do
#echo ">>in while loop"
echo "----------------------------------------"
validateQueueDepthTest  #Validate queue funtion returns 
retValue=$?
echo "----------------------------------------"

# 


# If the retValue from validataQueueDepthTest is 1,means no pending requests in queue

if [[ $retValue -eq 0 ]]
then
echo "Queue depth returns zero"
echo "Breaking the while loop"
break
fi

sleep $intervalInSec
i=$((i+1))
remoteDepth=$((remoteDepth-1)) # decrementing the remoteDepth value by one
done




