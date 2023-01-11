#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_MENU(){
  if [[ -z $1 ]]
  then
    echo -e "Please provide an element as an argument."
  else
    if [[  $1 =~ ^[0-9]+$ ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$1'")
      if [[ ! -z $ATOMIC_NUMBER ]]
      then
        ATOMIC_PROPERTIES=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements full join properties using(atomic_number) left join types using(type_id) WHERE atomic_number = '$1'")
      fi
    else
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol = '$1'") 
      if [[ ! -z $SYMBOL ]]
      then
        ATOMIC_PROPERTIES=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements full join properties using(atomic_number) left join types using(type_id) WHERE symbol = '$1'")
      else
        ATOMIC_PROPERTIES=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements full join properties using(atomic_number) left join types using(type_id) WHERE name = '$1'")
      fi
    fi
    if [[ ! -z $ATOMIC_PROPERTIES ]]
      then 
        echo "$ATOMIC_PROPERTIES" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT BAR TYPE
        do
          echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
        done
    else
      echo "I could not find that element in the database."
    fi
  fi
}

MAIN_MENU $1
