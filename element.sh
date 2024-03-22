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
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    fi

    if [[ -z $ATOMIC_NUMBER ]]
    then
    # search by name
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
    fi

    if [[ -z $ATOMIC_NUMBER ]]
    then
    # Not found
        echo "I could not find that element in the database."
    else
    # get elements data
    ELEMENTS_DATA=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
    echo $ELEMENTS_DATA
    # get properties data
    PROPERTIES_DATA=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
    echo $PROPERTIES_DATA
    # get types data
    TYPE_ID=1
    TYPES_DATA=$($PSQL "SELECT type_id, type FROM types WHERE type_id = $TYPE_ID")
    echo $TYPES_DATA
    # display properties
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    fi
fi