#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"


# Check if input argument provided is a string
if [[ $1 ]];
then
  INPUT=$1
  # Check if input matches pattern
  if [[ $INPUT =~ ^[0-9]+$ ]];
  then
    #use atomic_number to find element
    QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $INPUT;")
    #if atomic_number does not exist
    if [[ -z $QUERY_RESULT ]]
    then
      echo "Please enter a valid element as an argument."
    else
      #return  result
      echo $QUERY_RESULT | while IFS=' | ' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  else
    #use symbol or name to find element
    QUERY_RESULT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol = '$INPUT' OR name = '$INPUT';")
    if [[ -z $QUERY_RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      #return result
      echo $QUERY_RESULT | while IFS=' | ' read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  fi
else
  echo "Please provide an element as an argument."
fi