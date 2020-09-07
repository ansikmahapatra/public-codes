SinOsc t => dac;

class two
{
    65.41 => float c;
    69.30 => float c_sharp;
    73.42 => float d;
    77.78 => float d_sharp;
    82.41 => float e;
    87.31 => float f;
    92.50 => float f_sharp;
    98.00 => float g;
    103.83 => float g_sharp;
    110.00 => float a;
    116.54 => float a_sharp;
    123.47 => float b;
}

class three
{
    130.81 => float c;
    138.59 => float c_sharp;
    146.83 => float d;
    155.56 => float d_sharp;
    164.81 => float e;
    174.61 => float f;
    185.00 => float f_sharp;
    196.00 => float g;
    207.65 => float g_sharp;
    220.00 => float a;
    233.08 => float a_sharp;
    246.94 => float b;
}

class four
{
    261.63 => float c;
    277.18 => float c_sharp;
    293.66 => float d;
    311.13 => float d_sharp;
    329.63 => float e;
    349.23 => float f;
    369.99 => float f_sharp;
    392.00 => float g;
    415.30 => float g_sharp;
    440.00 => float a;
    466.16 => float a_sharp;
    493.88 => float b;
}

class five
{
    523.25 => float c;
    554.37 => float c_sharp;
    587.33 => float d;
    622.25 => float d_sharp;
    659.25 => float e;
    698.46 => float f;
    739.99 => float f_sharp;
    783.99 => float g;
    830.61 => float g_sharp;
    880.00 => float a;
    932.33 => float a_sharp;
    987.77 => float b;
}

class six
{
    523.25 => float c;
    554.37 => float c_sharp;
    587.33 => float d;
    622.25 => float d_sharp;
    659.25 => float e;
    698.46 => float f;
    739.99 => float f_sharp;
    783.99 => float g;
    830.61 => float g_sharp;
    880.00 => float a;
    932.33 => float a_sharp;
    987.77 => float b;
}

class seven
{
    523.25 => float c;
    554.37 => float c_sharp;
    587.33 => float d;
    622.25 => float d_sharp;
    659.25 => float e;
    698.46 => float f;
    739.99 => float f_sharp;
    783.99 => float g;
    830.61 => float g_sharp;
    880.00 => float a;
    932.33 => float a_sharp;
    987.77 => float b;
}


fun void note(float a, float b)
{
    a => t.freq;
    b::second => now;
}

two ii;
three iii;
four iv;
five v;

while(true)
{
    note(iii.c,.2);
    note(iii.d,.2);
    note(iii.e,.2);
    note(iii.f,.2);
    note(iii.g,.2);
    note(iii.a,.2);
    note(iii.b,.2);
    note(iv.c,.4);
    note(iii.b,.2);
    note(iii.a,.2);
    note(iii.g,.2);
    note(iii.f,.2);
    note(iii.e,.2);
    note(iii.d,.2);
    note(iii.c,.2);
    
    note(iv.c,.2);
    note(iv.d,.2);
    note(iv.e,.2);
    note(iv.f,.2);
    note(iv.g,.2);
    note(iv.a,.2);
    note(iv.b,.2);
    note(v.c,.4);
    note(iv.b,.2);
    note(iv.a,.2);
    note(iv.g,.2);
    note(iv.f,.2);
    note(iv.e,.2);
    note(iv.d,.2);
    note(iv.c,.2);
    
    note(v.c,.2);
    note(v.d,.2);
    note(v.e,.2);
    note(v.f,.2);
    note(v.g,.2);
    note(v.a,.2);
    note(v.b,.2);
    note(v.c,.4);
    note(v.b,.2);
    note(v.a,.2);
    note(v.g,.2);
    note(v.f,.2);
    note(v.e,.2);
    note(v.d,.2);
    note(v.c,.2);
}
