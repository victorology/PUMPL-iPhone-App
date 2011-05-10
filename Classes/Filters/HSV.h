//
//  HSV.h
//  ImageFilters
//

//
// This code has been copied from the internet
//

typedef struct 
{
    float r, g, b, a;
} RGB;

typedef struct
{
    float h, s, v, a;
} HSV;

typedef struct 
{
    float h, s, l, a;
} HSL;


void rgb_to_hsv (const RGB *rgb, HSV  *hsv);
void hsv_to_rgb (const HSV *hsv, RGB *rgb);
void hsl_to_rgb (const HSL *hsl, RGB *rgb);
void rgb_to_hsl (const RGB *rgb, HSL *hsl);

