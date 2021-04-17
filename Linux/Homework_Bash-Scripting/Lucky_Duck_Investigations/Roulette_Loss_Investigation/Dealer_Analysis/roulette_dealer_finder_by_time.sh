#!/bin/bash 

#roulette_dealer_finder_by_time.sh accepts three arguments to identify the roulette dealer working at that specified date and time.
    #Dealer schedules to analyze must be located in the same directory as this script. 
    #Results will output to terminal

#print status
printf "Analyzing data\n"

#date in format mmdd, e.g. 0310, is the first argument
shiftDate=$1

#time in the format "hh:mm:ss MM", e.g. "05:00:00 AM", is the second argument
shiftTime=$2

#get specified day's schedule
schedule=$( find . -type f -name "$shiftDate*" )

#get specified shift time
shift=$( grep "$shiftTime" $schedule )


#get scheduled roulette dealer
dealer=$( echo $shift | awk '{print $5 " " $6}' )


#print results
printf "\nIdentified Roulette Dealer\n" 
printf "\nDate      Time        First and Last Name\n"  
printf "$shiftDate   $shiftTime       $dealer\n" 

#print status
printf "\nAnalysis complete\n" 