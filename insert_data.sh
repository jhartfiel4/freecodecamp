#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #insert winner teams into teams table
  if [[ $WINNER != "winner" ]]
  then
    #get team_id
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name ='$WINNER'")

    #if not found
    if [[ -z $WIN_ID ]]
    then
      #insert team
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      if [[ $INSERT_WINNER_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $WINNER
      fi
    fi
  fi
  #insert opponents into teams table
  if [[ $OPPONENT != "opponent" ]]
  then
    #get team_id
    OPP_ID=$($PSQL "SELECT team_id from teams WHERE name = '$OPPONENT'")

    #if not found
    if [[ -z $OPP_ID ]]
    then
      #insert team
      INSERT_OPP_RESULT=$($PSQL " INSERT INTO teams(name) VALUES ('$OPPONENT')")
      if [[ $INSERT_OPP_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams, $OPPONENT
      fi
    fi
  fi

  if [[ $YEAR != "year" && $WINNER_ID != "winner_id" && $OPP_ID != "opponent_id" ]]
  then
    #get winner_id
    WINNER_ID=$($PSQL "SElECT team_id from teams where name= '$WINNER'")
    #get opponent_id
    OPPONENT_ID=$($PSQL "SELECT team_id from teams where name = '$OPPONENT'")

    #if not found
    if [[ -z $WINNER_ID ]]
    then
      #set to null
      WINNER_ID=null
    fi
    
    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #set to null
      OPPONENT_ID=null
    fi

    #insert game
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_goals, opponent_goals, winner_id, opponent_id) VALUES ($YEAR, '$ROUND', $WINNER_GOALS, $OPPONENT_GOALS, $WINNER_ID, $OPPONENT_ID)")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo Inserted into games, $YEAR, $ROUND
    fi
  fi

done