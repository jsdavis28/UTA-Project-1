#!/bin/bash 

#dealer_finder_by_time_and_game.sh accepts three arguments to identify the desired game dealer working at that specified date and time.
    #Dealer schedules to analyze must be located in the same directory as this script. 
    #Results will output to terminal

#print status
printf "Analyzing data\n"

#date in format mmdd, e.g. 0310, is the first argument
shiftDate=$1

#time in the format "hh:mm:ss MM", e.g. "05:00:00 AM", is the second argument
shiftTime=$2

#game as a string (with quotes for spaces), e.g. "Texas hold EM", is the fourth argument
game=$3

#get specified day's schedule
schedule=$( find . -type f -name "$shiftDate*" )

#get specified shift time
shift=$( grep "$shiftTime" $schedule )

#determine type of game requested
if [[ ${game,,} =~ "blackjack" ]]; then
    #get scheduled blackjack dealer
    dealer=$( echo $shift | awk '{print $3 " " $4}' )
elif [[ ${game,,} =~ "roulette" ]]; then
    #get scheduled roulette dealer
    dealer=$( echo $shift | awk '{print $5 " " $6}' )
elif [[ ${game,,} =~ "texas hold em" ]]; then
    #get scheduled blackjack dealer
    dealer=$( echo $shift | awk '{print $7 " " $8}' )
else 
    printf "\n error finding game."
fi
    
#print results
printf "\nIdentified $game Dealer\n" 
printf "\nDate      Time        First and Last Name\n"  
printf "$shiftDate   $shiftTime       $dealer\n" 

#print status
printf "\nAnalysis complete\n" 