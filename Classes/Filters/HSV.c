//
//  HSV.m
//  ImageFilters
//

//
// This code has been copied from the internet
//

#include "HSV.h"

static double rgb_max (const RGB *rgb)
{
    if (rgb->r > rgb->g)
        return (rgb->r > rgb->b) ? rgb->r : rgb->b;
    else
        return (rgb->g > rgb->b) ? rgb->g : rgb->b;
}

static double rgb_min (const RGB *rgb)
{
    if (rgb->r < rgb->g)
        return (rgb->r < rgb->b) ? rgb->r : rgb->b;
    else
        return (rgb->g < rgb->b) ? rgb->g : rgb->b;
}

void rgb_to_hsv (const RGB *rgb, HSV *hsv)
{
    float max, min, delta;
    
    max = rgb_max (rgb);
    min = rgb_min (rgb);
    
    hsv->v = max;
    delta = max - min;
    
    if (delta > 0.0001)
    {
        hsv->s = delta / max;
        
        if (rgb->r == max)
        {
            hsv->h = (rgb->g - rgb->b) / delta;
            if (hsv->h < 0.0)
                hsv->h += 6.0;
        }
        else if (rgb->g == max)
        {
            hsv->h = 2.0 + (rgb->b - rgb->r) / delta;
        }
        else if (rgb->b == max)
        {
            hsv->h = 4.0 + (rgb->r - rgb->g) / delta;
        }
        
        hsv->h /= 6.0;
    }
    else
    {
        hsv->s = 0.0;
        hsv->h = 0.0;
    }
    
    hsv->a = rgb->a;
}


void hsv_to_rgb (const HSV *hsv, RGB *rgb)
{
    int    i;
    float f, w, q, t;
    float hue;
    
    if (hsv->s == 0.0)
    {
        rgb->r = hsv->v;
        rgb->g = hsv->v;
        rgb->b = hsv->v;
    }
    else
    {
        hue = hsv->h;
        
        if (hue == 1.0)
            hue = 0.0;
        
        hue *= 6.0;
        
        i = (int) hue;
        f = hue - i;
        w = hsv->v * (1.0 - hsv->s);
        q = hsv->v * (1.0 - (hsv->s * f));
        t = hsv->v * (1.0 - (hsv->s * (1.0 - f)));
        
        switch (i)
        {
            case 0:
                rgb->r = hsv->v;
                rgb->g = t;
                rgb->b = w;
                break;
            case 1:
                rgb->r = q;
                rgb->g = hsv->v;
                rgb->b = w;
                break;
            case 2:
                rgb->r = w;
                rgb->g = hsv->v;
                rgb->b = t;
                break;
            case 3:
                rgb->r = w;
                rgb->g = q;
                rgb->b = hsv->v;
                break;
            case 4:
                rgb->r = t;
                rgb->g = w;
                rgb->b = hsv->v;
                break;
            case 5:
                rgb->r = hsv->v;
                rgb->g = w;
                rgb->b = q;
                break;
        }
    }
    
    rgb->a = hsv->a;
}


void rgb_to_hsl (const RGB *rgb, HSL *hsl)
{
    float max, min, delta;
    
    max = rgb_max (rgb);
    min = rgb_min (rgb);
    
    hsl->l = (max + min) / 2.0;
    
    if (max == min)
    {
        hsl->s = 0.0;
        hsl->h = -1.0;
    }
    else
    {
        if (hsl->l <= 0.5)
            hsl->s = (max - min) / (max + min);
        else
            hsl->s = (max - min) / (2.0 - max - min);
        
        delta = max - min;
        
        if (delta == 0.0)
            delta = 1.0;
        
        if (rgb->r == max)
        {
            hsl->h = (rgb->g - rgb->b) / delta;
        }
        else if (rgb->g == max)
        {
            hsl->h = 2.0 + (rgb->b - rgb->r) / delta;
        }
        else if (rgb->b == max)
        {
            hsl->h = 4.0 + (rgb->r - rgb->g) / delta;
        }
        
        hsl->h /= 6.0;
        
        if (hsl->h < 0.0)
            hsl->h += 1.0;
    }
    
    hsl->a = rgb->a;
}

static float hsl_value (float n1, float n2, float hue)
{
    float val;
    
    if (hue > 6.0)
        hue -= 6.0;
    else if (hue < 0.0)
        hue += 6.0;
    
    if (hue < 1.0)
        val = n1 + (n2 - n1) * hue;
    else if (hue < 3.0)
        val = n2;
    else if (hue < 4.0)
        val = n1 + (n2 - n1) * (4.0 - hue);
    else
        val = n1;
    
    return val;
}


void hsl_to_rgb (const HSL *hsl, RGB *rgb)
{
    if (hsl->s == 0)
    {
        rgb->r = hsl->l;
        rgb->g = hsl->l;
        rgb->b = hsl->l;
    }
    else
    {
        float m1, m2;
        
        if (hsl->l <= 0.5)
            m2 = hsl->l * (1.0 + hsl->s);
        else
            m2 = hsl->l + hsl->s - hsl->l * hsl->s;
        
        m1 = 2.0 * hsl->l - m2;
        
        rgb->r = hsl_value (m1, m2, hsl->h * 6.0 + 2.0);
        rgb->g = hsl_value (m1, m2, hsl->h * 6.0);
        rgb->b = hsl_value (m1, m2, hsl->h * 6.0 - 2.0);
    }
    
    rgb->a = hsl->a;
}
