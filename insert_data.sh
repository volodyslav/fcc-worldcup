#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "$($PSQL "TRUNCATE TABLE games, teams;")"
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WG OG
do 
  if [[ $WINNER != "winner" && $OPPONENT != "opponent" ]]
  then
    echo "$($PSQL "INSERT into teams(name) values('$WINNER')" )"
    WIN_ID="$($PSQL "select team_id from teams where name='$WINNER'" )"
    echo "$($PSQL "INSERT into teams(name) values('$OPPONENT')" )"
    OPP_ID="$($PSQL "select team_id from teams where name='$OPPONENT'" )"
    echo "$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WIN_ID, $OPP_ID, $WG, $OG)")"
  fi
done