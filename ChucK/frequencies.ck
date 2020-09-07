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
    1046.50 => float c;
    1108.73 => float c_sharp;
    1174.66 => float d;
    1244.51 => float d_sharp;
    1318.51 => float e;
    1396.91 => float f;
    1479.98 => float f_sharp;
    1567.98 => float g;
    1661.22 => float g_sharp;
    1760.00 => float a;
    1864.66 => float a_sharp;
    1975.53 => float b;
}

class seven
{
    2093.00 => float c;
    2217.46 => float c_sharp;
    2349.32 => float d;
    2489.02 => float d_sharp;
    2637.02 => float e;
    2793.83 => float f;
    2959.96 => float f_sharp;
    3135.96 => float g;
    3322.44 => float g_sharp;
    3520.00 => float a;
    3729.31 => float a_sharp;
    3951.07 => float b;
}

class eight
{
    4186.01 => float c;
    4434.92 => float c_sharp;
    4698.63 => float d;
    4978.03 => float d_sharp;
    5274.04 => float e;
    5587.65 => float f;
    5919.91 => float f_sharp;
    6271.93 => float g;
    6644.88 => float g_sharp;
    7040.00 => float a;
    7458.62 => float a_sharp;
    7902.13 => float b;
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
six vi;
seven vii;
eight viii;
