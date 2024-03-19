#!/bin/bash

SOURCE_MIC="$1"
SINK_HEADPHONES="$2"
if [[ -z "$SOURCE_MIC" || -z "$SINK_HEADPHONES" ]]; then
    echo "Error: Must provide numbers for mic and headphones."
    echo "Usage: discord-game-audio-setup.sh <SOURCE_MIC> <SINK_HEADPHONES>"
    echo "Use 'pactl list sources' to get all sources."
    echo "Use 'pactl list sinks' to get all sinks."
    exit 1
fi

echo -n "Null sink (Game): "
pactl load-module module-null-sink sink_name=Game sink_properties=device.description=Game

echo -n "Null sink (GameAndMic): "
pactl load-module module-null-sink sink_name=GameAndMic sink_properties=device.description=GameAndMic

echo -n "Loopback (Game to headphones): "
pactl load-module module-loopback source=Game.monitor sink=$SINK_HEADPHONES

echo -n "Loopback (Game to GameAndMic): "
pactl load-module module-loopback source=Game.monitor sink=GameAndMic

echo -n "Loopback (mic to GameAndMic): "
pactl load-module module-loopback source=$SOURCE_MIC sink=GameAndMic

echo -e "\nIf all above succeeded, open pavucontrol and do the following:"
echo " - Set the output stream of your game window to 'Game'"
echo " - Set the input stream of Discord to 'Monitor of GameAndMic'"
echo -e "\nIf some modules failed, use 'pactl list modules' and 'pactl unload-module <n>' to clean up."

