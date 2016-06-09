# uart-image-tx
Sending 640x480 color images over UART connection to VGA monitor.

How it works: Each pixel of a 640x480 bitmap was encoded into the form RRRGGGBB using the 2 or 3 MSBs. These bytes are sent over the USB-UART connection, and stored in RAM. The image data is read from the RAM and displayed on the VGA monitor.