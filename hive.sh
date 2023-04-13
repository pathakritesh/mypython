#!/bin/bash

# Verify that the HQL file path is provided as a command-line argument
if [ $# -ne 1 ]
then
    echo "Usage: $0 <HQL file path>"
    exit 1
fi

# Parse the database and table names from the HQL file
database=$(grep -oP '(?<=^CREATE TABLE ).*\.(?=[^.]+)' $1 | tr -d '\n')
tablename=$(grep -oP '(?<=^CREATE TABLE ).*\.(?=[^.]+\()|[^\s]+\b' $1 | tail -n 1 | tr -d '\n')

# Create the Hive table
hive -e "CREATE TABLE \`$database.$tablename\` AS $(cat $1)"

# Verify that the table was created successfully
if [ $? -eq 0 ]
then
    echo "Table $database.$tablename created successfully."
else
    echo "Table creation failed."
fi
