#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [[ -z $1 ]]
then 
    echo "Please provide an element as an argument."
else
    # search by atomic number
    echo "SELECT atomic_number FROM elements WHERE atomic_number = $1"
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")

    if [[ -z $ATOMIC_NUMBER ]]
    then
    # search by symbol
    echo "SELECT atomic_number FROM elements WHERE atomic_number = $1"
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    fi
    
    if [[ -z $ATOMIC_NUMBER ]]
    then
    # Not found
        echo "I could not find that element in the database."
    else
    # display properties
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    fi
fi