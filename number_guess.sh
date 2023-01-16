#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

PLAY_GAME() {
  HIDDEN_NUMBER=$(( $RANDOM % 1000 + 1 ))
    echo "Enter your username:"
  read USERNAME
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")
  if [[ -z $USER_ID ]]
  then
    echo "Welcome, $USERNAME! It looks like this is your first time here."
    INSERT_USER_RESULT=$($PSQL "INSERT INTO users(name) VALUES ('$USERNAME')")
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE name = '$USERNAME'")
  else
    GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games where user_id = $USER_ID")
    MIN_GUESS=$($PSQL "SELECT MIN(guesses) FROM games where user_id = $USER_ID")
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $MIN_GUESS guesses."
  fi
  GUESSES=0
  GUESS=-1
  echo "Guess the secret number between 1 and 1000:"
  while [[ ! $GUESS == $HIDDEN_NUMBER ]]
  do
    #echo $HIDDEN_NUMBER
    read GUESS
    ((GUESSES+=1))
    while [[ ! $GUESS =~ ^[0-9]+$ ]]
    do
      echo "That is not an integer, guess again:"
      read GUESS
    done
    if [[  $GUESS -lt $HIDDEN_NUMBER ]]; then
      echo "It's higher than that, guess again:"
    elif [[  $GUESS -gt $HIDDEN_NUMBER ]]; then
      echo "It's lower than that, guess again:"
    fi
  done
  INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(user_id, guesses) VALUES ($USER_ID, $GUESSES)")
  echo -e "You guessed it in $GUESSES tries. The secret number was $HIDDEN_NUMBER. Nice job!"
}

PLAY_GAME
