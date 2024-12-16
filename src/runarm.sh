#!/bin/bash

# Check if the script is called with a file name
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <filename.s>"
    exit 1
fi

# Extract the base name without extension
BASENAME=$(basename "$1" .s)

# Assemble the assembly file
arm-linux-gnueabihf-as -o "${BASENAME}.o" "$1"
if [ $? -ne 0 ]; then
    echo "Error: Assembly failed."
    exit 1
fi

# Link the object file
arm-linux-gnueabihf-ld -o "$BASENAME" "${BASENAME}.o"
if [ $? -ne 0 ]; then
    echo "Error: Linking failed."
    exit 1
fi

# Run the executable with QEMU
echo "Running program with QEMU..."
qemu-arm "./$BASENAME"
QEMU_EXIT_CODE=$?

# Check if QEMU executed
if [ $QEMU_EXIT_CODE -eq 0 ]; then
    echo "Program executed successfully."
else
    echo "Program executed, but QEMU returned exit code: $QEMU_EXIT_CODE"
fi
