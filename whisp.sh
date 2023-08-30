#!/bin/bash

# Activate the virtual environment (if required)
# source venv/bin/activate

# Get the file path and model from command-line arguments
filePath=$1
model=$2

# Run the whisper command
whisper "$filePath" --language English --model "$model"
