/*	simple Hello World, for cc65, for NES
 *  writing to the screen with rendering ON, via a vram buffer
 *	using neslib
 *	Doug Fraker 2018
 */	
 

// using a buffer, we have more flexibility, since we can adjust the 
// screen position of a PPU write, and can piggy back multiple data 
// sets into 1 push, doing more than 1 update per frame, and 
// the data sets can have zeroes, since they are not zero terminated

#include "LIB/neslib.h"
#include "LIB/nesdoug.h"

#define BLACK 0x0f
#define DK_GY 0x00
#define LT_GY 0x10
#define WHITE 0x30
// there's some oddities in the palette code, black must be 0x0f, white must be 0x30

#pragma bss-name(push, "ZEROPAGE")

unsigned char i;

const unsigned char text[] = "Escape Vilvania";

const unsigned char palette[]={
BLACK, DK_GY, LT_GY, WHITE,
0,0,0,0,
0,0,0,0,
0,0,0,0
}; 







void main (void) {

	ppu_off(); // screen off
	
	pal_bg(palette); 
					 
	vram_adr(NTADR_A(10, 14));

	i = 0;
	while(text[i]){
		vram_put(text[i]); // this pushes 1 char to the screen
		++i;
	}	
	
	// vram_adr and vram_put only work with screen off
	// NOTE, you could replace everything between i = 0; and here with...
	// vram_write(text,sizeof(text));
	// does the same thing
	
	ppu_on_all(); //	turn on screen

	while (1){
		// infinite loop
		// game code can go here later.
		
		pal_fade_to(0,4); // fade from black to normal

		pal_fade_to(4,0); // fade from normal to black

	}
}
	
	