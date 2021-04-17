#!/bin/bash 

#playerAnalysis.sh creates a list of loss incidents from company data to analyze suspected players. 
    #A complete dataset of incidents must be located in the same directory as this script.
    #Raw data will print to loss_data and a summary of the provided data to Roulette_Losses.  
    #Analysis results will output to the file Notes_Player_Analysis

#print status
printf "Analyzing data\n"

#set line delimiter on for loop
IFS=$'\n'

#gather all raw loss data from directory (Lucky_Duck_Investigations/Roulette_Loss_Investigation/Player_Analysis)
grep - * --exclude='*.sh' > loss_data

#clean-up raw loss data
printf "\nIdentified Incidents\n" | tee -a Roulette_Losses
printf "\nDate      Time            Losses          Player Names\n" | tee -a Roulette_Losses
for line in $(cat loss_data); do
        #get date
        lossDate=$( echo $line | cut -d "_" -f1 ) 

        #get time
        lossTime=$( echo $line | cut -d$'\t'  -f1 | cut -d ":" -f2-4 | sed 's/ //g' )

        #get loss amount
        lossAmount=$( echo $line | cut -d$'\t' -f2 | cut -d ' ' -f1 )

        #get players
        players=$( echo $line | cut -f 2-3 | sed 's/  */ /g' | sed 's/\s/ /g' | cut -d ' ' -f2- | sed 's/, */, /g' | sed 's/ ,/,/g' ) 

        #print results to Roulette_Losses
        printf "$lossDate   $lossTime       $lossAmount        $players\n" | tee -a Roulette_Losses
done 

#copy loss_data file to Dealer_Analysis directory
cp loss_data ../Dealer_Analysis/loss_data 

#initialize player list
playerList=()

#initialize incident count
incidents=0

#analyze each incident from file
printf "\nIdentified Incidents\n" | tee -a Notes_Player_Analysis
printf "\nDate      Time        Players     Names\n" | tee -a Notes_Player_Analysis
for line in $(cat loss_data); do
        #get date
        lossDate=$( echo $line | cut -d "_" -f1 ) 

        #get time
        lossTime=$( echo $line | cut -d$'\t'  -f1 | cut -d ":" -f2-4 | sed 's/ //g' )

        #get players
        players=$( echo $line | cut -f 2-3 | sed 's/  */ /g' | sed 's/\s/ /g' | cut -d ' ' -f2- | sed 's/, */, /g' | sed 's/ ,/,/g' ) 

        #get number of players
        num=$( echo $players | awk -F, '{print NF}' )

        #add each new player to the player list
        for ((i=1; i <= $num; i++)); do  
            player=$( echo $players | cut -d , -f$i | sed 's/^[ ]*//' ) 
            if ! [[ ${playerList[*]} =~ "$player" ]]; then 
                playerList+=( $player ) 
            fi
        done

        #print results to Notes_Player_Analysis
        printf "$lossDate   $lossTime       $num        $players\n" | tee -a Notes_Player_Analysis

        #increment incident count
        ((incidents++))
done 

#count each player and times played in Notes_Player_Analysis
printf "\n\nTimes played per player\n" | tee -a Notes_Player_Analysis
printf "\nPlays     Player Name\n" | tee -a Notes_Player_Analysis
for suspect in ${playerList[*]}; do 
    plays=$( grep $suspect Notes_Player_Analysis | wc -l )
    printf "$plays          $suspect\n" | tee -a Notes_Player_Analysis
done

#list number of identified incidents
printf "\n\nTotal number of incidents: $incidents\n" | tee -a Notes_Player_Analysis

#list number of unique players
printf "\n\nTotal unique players: ${#playerList[@]}\n" | tee -a Notes_Player_Analysis

#print status
printf "\nAnalysis complete in file Notes_Player_Analysis\n" 
