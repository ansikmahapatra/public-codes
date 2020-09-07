SinOsc t => dac;

class three{
130.81 => float c0;
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
246.94 => float b;}

three x;



fun void note(float a, float b)
{
    a => t.freq;
    b::second => now;
}

while(true){ 
    note(x.c0,.2);
    note(x.d,.2);
    note(x.e,.2);
    note(x.f,.2);
    note(x.g,.2);
    note(x.a,.2);
    note(x.b,.2);
    note(x.c0,.2);
}
