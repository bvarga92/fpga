#ifndef _VGA_H_
#define _VGA_H_

	#include <mblaze_nt_types.h>

	/* felbontas */
	#define COLS 100
	#define ROWS 75

	/* nehany szin */
	typedef ubyte color_t;
	#define COLOR_BLACK   ((color_t)0x00)
	#define COLOR_WHITE   ((color_t)0xFF)
	#define COLOR_RED     ((color_t)0xE0)
	#define COLOR_GREEN   ((color_t)0x1C)
	#define COLOR_BLUE    ((color_t)0x03)
	#define COLOR_MAGENTA ((color_t)0xE3)
	#define COLOR_YELLOW  ((color_t)0xFC)
	#define COLOR_ORANGE  ((color_t)0xA8)
	#define COLOR_LBLUE   ((color_t)0x33)
	#define COLOR_BRICK   ((color_t)0x64)
	#define COLOR_SKY     ((color_t)0x57)
	#define COLOR_RUBY    ((color_t)0xA0)

	/* beszinezi a megadott pixelt */
	void vgaSetPixel(ubyte x, ubyte y, color_t color);

	/* kitolti a kepernyot a megadott szinnel */
	void vgaClearScreen(color_t color);

	/* egyenes rajzolasa (Bresenham-algoritmus) */
	void vgaDrawLine(ubyte x1, ubyte y1, ubyte x2, ubyte y2, color_t color);

	/* karakter kiirasa az adott pozicioba */
	void vgaPutChar(char c, ubyte x, ubyte y, color_t chcolor, color_t bgcolor);

	/* nullterminalt sztring kiirasa */
	void vgaPrint(char *str, ubyte x, ubyte y, color_t chcolor, color_t bgcolor);

	/* elojeles egesz szam kiirasa (max. 10 jegyu) */
	void vgaPrintInt(int32_t n, ubyte x, ubyte y, color_t chcolor, color_t bgcolor);

#endif
