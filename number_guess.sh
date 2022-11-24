#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -n "Enter your username:"
read USERNAME 
# get player_id from games table
USERNAME_CHECK=$($PSQL "SELECT DISTINCT name FROM players WHERE name LIKE '$USERNAME'")
# extract number of games played
GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games JOIN players USING(player_id) WHERE name='$USERNAME'")
# extract number of guesses from best game
BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games JOIN players USING(player_id) WHERE name='$USERNAME'")
if [[ -z $USERNAME_CHECK ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  # insert new player
  INSERT_NEW_PLAYER=$($PSQL "INSERT INTO players(name) VALUES('$USERNAME')")
else
  echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi
# Game logic starts here
SECRET_NUMBER=$(( ($RANDOM % 1000) + 1 ))
echo -n "Guess the secret number between 1 and 1000:"
NUMBER_OF_GUESSES=1
while read NUMBER_GUESS
do
  if [[ ! $NUMBER_GUESS =~ ^[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  else 
    if [[ $NUMBER_GUESS == $SECRET_NUMBER ]]
    then
      echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
      PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name='$USERNAME'")
      INSERT_PLAYER_ID=$($PSQL "INSERT INTO games(player_id, number_of_guesses) VALUES($PLAYER_ID, $NUMBER_OF_GUESSES)")
    break;
    else 
      if [[ $NUMBER_GUESS -gt $SECRET_NUMBER ]]
      then
        echo -n "It's lower than that, guess again:"
        let NUMBER_OF_GUESSES++
      elif [[ $NUMBER_GUESS -lt $SECRET_NUMBER ]]
      then
        echo -n "It's higher than that, guess again:"
        let NUMBER_OF_GUESSES++
      fi
    fi
  fi
done





 


