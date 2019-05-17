# FPGA Mario

This project makes use of USB keyboard, VGA display, and audio to make a functional Super Mario Bros. clone complete with animation, powerups, enemy interaction, and collision detection. This project was written mostly in System Verilog, with the keyboard interface written in C.

[Here](https://youtu.be/x40uQ9v1n20) is a video showcasing a demo of this project.

## Getting Started

* Make sure an FPGA board is available. This is necessary to run the project. Ensure the FPGA board is properly connected to a VGA display and a USB keyboard.
* First download the [DE2 Control Panel](https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=53&No=30&PartNo=4) app and follow the instructions on the website to ensure a successful installation.
* Download and import the project into Quartus Prime. Upon a successful compile, connect the FPGA via the USB-Blaster. If music is desired, load a .wav file of your choice onto the board via DE2 Control Panel, then disconnect the Control Panel.
* Next, click start in Quartus to flash the FPGA with the program. The display should show the Super Mario Bros. logo. If the program fails to start, ensure that Control Panel is disconnected.
* Restart the FPGA by pressing KEY0. This will cause Mario to appear.
* Open Eclipse and start the USB-reading via the NIOS-II console. This may fail several times. Upon a successful keyboard read, the user should be able to control Mario!

## Built With

* [Quartus Prime](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/overview.html) - The IDE used for System Verilog code
* [Eclipse](https://www.eclipse.org/downloads/) - The IDE used for C code
* [Rishi's ECE 385 Helper Tools](https://ece.illinois.edu/academics/courses/profile/ECE385) - Python scripts to convert sprites to RAM files

## Contributing

Please contact simha.nikhil@gmail.com if you are interested in contributing to this project.

## Authors

* **Nikhil Simha** - *System Verilog and C programming* - [Github](https://github.com/nicklesimba)
* **Pranith Bottu** - *System Verilog programming* - [Github](https://github.com/pranithbottu)

## Acknowledgments

* Thanks to Rishi's Helper Tools for enabling us to use sprites
* Thanks to Koushik Roy for the VHDL audio driver
* All rights to Mario and related properties belong to Nintendo
