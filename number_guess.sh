#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USER_NAME

USER_NAME_CHECK=$($PSQL "select name from users where name='$USER_NAME' ")
GAMES_PLAYED=$($PSQL "select count(*) from users inner join games using(u_id) where name ='$USER_NAME'")
BEST=$($PSQL "select min(guess) from users inner join games using(u_id) where name ='$USER_NAME' ")

if [[ -z $USER_NAME_CHECK ]]
then
INSERT_USER=$($PSQL "insert into users(name) values('$USER_NAME')")
echo  "Welcome, $USER_NAME! It looks like this is your first time here."
else
echo "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST guesses."
fi

RANDOM_NUM=$(( ($RANDOM % 1000) + 1 ))
GUESS=1
echo "Guess the secret number between 1 and 1000:"

while read NUM
do
if [[ ! $NUM =~ ^[0-9]+$ ]]
then
echo "That is not an integer, guess again:"
else
   if [[ $NUM -eq $RANDOM_NUM ]]
   then
   break;
   else
       if [[ $NUM -gt $RANDOM_NUM ]]
       then
       echo -n "It's lower than that, guess again:"
       elif [[ $NUM -lt $RANDOM_NUM ]]
       then
       echo -n "It's higher than that, guess again:"
       fi
   fi
fi
GUESS=$(( $GUESS + 1 ))
done

if [[ $GUESS == 1 ]]
  then
    echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUM. Nice job!"
  else
    echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUM. Nice job!"  
fi

USER_ID=$($PSQL "select u_id from users where name='$USER_NAME' ")
INSERT_GAME=$($PSQL "insert into games(guess,u_id) values('$GUESS','$USER_ID')")