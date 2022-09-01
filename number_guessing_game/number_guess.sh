#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

# Login screen
LOGIN_SCREEN () {
  # If function called with argument
  if [[ $1 ]]
  then
    # Print argument
    echo -e "\n$1"
  fi

  # Ask for username
  echo -e "\nEnter your username:"
  read USERNAME

  LEN=$(echo $USERNAME | wc -m)

  #check db for username
  USER_ID=$($PSQL "SELECT user_id from users where username='$USERNAME'")

  #if doesn't exist
  if [[ -z $USER_ID ]]
  then
    #insert new user into database
    NEW_USER=$($PSQL "INSERT INTO users(username) values('$USERNAME')")
    
    #greet new user
    echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
    
    #get user id
    USER_ID=$($PSQL "SELECT user_id from users where username='$USERNAME'")
    
    #send to game
    GAME
  else
    #get game info
    GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) from games where user_id=$USER_ID")
    BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games where user_id=$USER_ID")
    
    #welcome back
    echo -e "\nWelcome back, $(echo $USERNAME | sed -E 's/^ *| *$//g')! You have played $(echo $GAMES_PLAYED | sed -E 's/^ *| *$//g') games, and your best game took $(echo $BEST_GAME | sed -E 's/^ *| *$//g') guesses."
    #send to game
    GAME 
  fi
return
}

GAME() {
echo -e "\nGuess the secret number between 1 and 1000:"
#read GUESS

RANDOM_NUMBER=$(( $RANDOM % 1000 + 1 ))

#collect count of guesses
while true
  do
    let "GUESSES++"

    read GUESS
  # If input isn't an integer 
    if [[ ! $GUESS =~ ^[0-9]+$ ]]
    then 

      # Print error message
      echo -e "\nThat is not an integer, guess again:"

      # Ask for input again
      continue
    fi

    #If lower
    if [[ $GUESS -gt $RANDOM_NUMBER ]]
    then
      echo -e "\nIt's lower than that, guess again:"
    continue
    fi

    #if higher
    if [[ $GUESS -lt $RANDOM_NUMBER ]]
    then
        echo -e "\nIt's higher than that, guess again:"
    continue
    fi

  #guessed it correctly
    # Display congrats message and exit the loop
    echo -e "\nYou guessed it in $(echo $GUESSES | sed -E 's/^ *| *$//g') tries. The secret number was $(echo $RANDOM_NUMBER | sed -E 's/^ *| *$//g'). Nice job!"

    # Add game to database
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $GUESSES)")
  
  break
done
}

LOGIN_SCREEN

