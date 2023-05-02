#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $(date)
exec < games.csv
while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
  if (($YEAR != "year"))
  then
    echo -e "Line 1, year $YEAR, round $ROUND, winner $WINNER, opponent $OPPONENT"
    "$($PSQL "INSERT INTO teams (name) SELECT name FROM (SELECT '$WINNER' AS name) new_name WHERE new_name.name NOT IN (SELECT name FROM teams)")"
	  echo -e "Line 2"
    "$($PSQL "INSERT INTO teams (name) SELECT name FROM (SELECT '$OPPONENT' AS name) new_name WHERE new_name.name NOT IN (SELECT name FROM teams)")"
	  echo -e "Line 3"
    "$($PSQL "INSERT INTO games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) SELECT $YEAR,'$ROUND',(SELECT team_id FROM teams WHERE name = '$WINNER'),(SELECT team_id FROM teams WHERE name = '$OPPONENT'),$WINNERGOALS, $OPPONENTGOALS ")"
  fi
done
echo $(date)