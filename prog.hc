// BouncingBall.hc

// Function to write a string to the terminal
U0 WriteStr(STR str) {
    __asm {
        mov rdi, 1         ; File descriptor for stdout
        mov rsi, str       ; Address of the string
        mov rdx, strlen(str); Length of the string
        mov rax, 1         ; System call for write
        syscall            ; Invoke the system call
    }
}

// Function to clear the screen
U0 ClearScreen() {
    WriteStr("\033[2J\033[H"); // ANSI escape codes to clear screen and reset cursor
}

// Main program
U0 Main() {
    // Initialize screen dimensions
    I64 screenWidth = 80;
    I64 screenHeight = 25;

    // Ball position and velocity
    I64 x = screenWidth / 2;
    I64 y = screenHeight / 2;
    I64 dx = 1;
    I64 dy = 1;

    // Animation loop
    while (1) {
        // Clear screen
        ClearScreen();

        // Move cursor and draw the ball
        WriteStr("\033[");
        WriteStr(itoa(y));   // Convert y-coordinate to string
        WriteStr(";");
        WriteStr(itoa(x));   // Convert x-coordinate to string
        WriteStr("H");
        WriteStr("O");

        // Update ball position
        x += dx;
        y += dy;

        // Check for collisions with screen edges
        if (x <= 1 || x >= screenWidth) {
            dx = -dx; // Reverse horizontal direction
        }
        if (y <= 1 || y >= screenHeight) {
            dy = -dy; // Reverse vertical direction
        }

        // Delay for smooth animation
        Wait(0.05);
    }
}
