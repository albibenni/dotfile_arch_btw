#!/bin/bash
# Set up environment for AI Commit tool
mkdir -p ~/.config/ai-commit

# Create .env file with placeholder API key
echo "AI_GATEWAY_API_KEY=your_key_here" >>~/.config/ai-commit/.env

# Notify user of next steps
echo "AI Commit environment set up at ~/.config/ai-commit"
echo "Please add your AI_GATEWAY_API_KEY to the .env file located there."
