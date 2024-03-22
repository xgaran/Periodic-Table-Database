#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# There is any argument supplied?
if [[ -z $1 ]]
then 
    # No arguments
    echo "Please provide an element as an argument."
else
    # One or more arguments

    # 1. search by atomic number if numeric
    if [[ $1 =~ ^[0-9]+$ ]]
    then
         ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
    fi 

    # 2. search by symbol
    if [[ -z $ATOMIC_NUMBER ]]
    then
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1'")
    fi

    # 3. search by name
    if [[ -z $ATOMIC_NUMBER ]]
    then
        ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1'")
    fi

    # 4. found/not found actions
    if [[ -z $ATOMIC_NUMBER ]]
    then
        # Not found
        echo "I could not find that element in the database."
    else
        # found: find and output details

        # A - elements
        # A1 - get elements data
        ELEMENTS_DATA=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number = $ATOMIC_NUMBER")
        # A2 - parse elements data
        #if [[ ! -z $ELEMENTS_DATA ]]
        #then
            SYMBOL="$(echo "$ELEMENTS_DATA" | cut -d'|' -f2)"
            NAME="$(echo "$ELEMENTS_DATA" | cut -d'|' -f3)"
        #fi

        # B - properties
        # B1 - get properties data
        PROPERTIES_DATA=$($PSQL "SELECT atomic_number, atomic_mass, melting_point_celsius, boiling_point_celsius, type_id FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
        # B2 - parse properties data
        ATOMIC_MASS="$(echo "$PROPERTIES_DATA" | cut -d'|' -f2)"
        MELTING_POINT_CELSIUS="$(echo "$PROPERTIES_DATA" | cut -d'|' -f3)"
        BOILING_POINT_CELSIUS="$(echo "$PROPERTIES_DATA" | cut -d'|' -f4)"
        TYPE_ID="$(echo "$PROPERTIES_DATA" | cut -d'|' -f5)"

        # C - types
        # C1 - get types data
        TYPES_DATA=$($PSQL "SELECT type_id, type FROM types WHERE type_id = $TYPE_ID")
        # C2 - parse types data
        TYPE="$(echo "$TYPES_DATA" | cut -d'|' -f2)"

        # D - display info
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    fi
fi