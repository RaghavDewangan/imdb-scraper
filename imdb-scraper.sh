#!/bin/bash

OMDB_API_KEY=8e17519

if [ -z $OMDB_API_KEY ]; then # -z checks the length of the variable
    echo "Please include API key"
    exit 1
  #exit 1 means script not executed properly, basic sanity check 
fi

if [ -z "$1" ]; then # addtl sanity check to verify input of first parameter
    echo "Usage: $0 <movie-title>"
    exit 1
fi

#we want to access the first parameter, hence we use $1
# $1, $2, etc... is how you access certain params 
# $0 is the name of the script (initial param)


movie_title=$(echo "$1" | tr " " "+") # take value of first param, transform all spaces into "+" signs (tr)

#echo $movie_title

api_endpoint="http://www.omdbapi.com/?t=${movie_title}&apikey=${OMDB_API_KEY}"

data=$(curl -s "$api_endpoint" ) #executes API, gives full data

if [ "$data" = '{"Response":"False","Error":"Movie not found!"}' ]; then
    echo "Movie is not found in database" # error message, will return echoed statement instead
    exit 1
fi

title=$(echo "$data" | jq -r ".Title") # subshell of data, use jq to parse json output
year=$(echo "$data" | jq -r ".Year")
genre=$(echo "$data" | jq -r ".Genre")
rating=$(echo "$data" | jq -r ".imdbRating")
summary=$(echo "$data" | jq -r ".Plot")

echo "Title: $title"
echo "Year: $year"
echo "Genre: $genre"
echo "Rating: $rating"
echo "Plot: $summary"

#ex url: http://www.omdbapi.com/?t=Barbie&plot=full