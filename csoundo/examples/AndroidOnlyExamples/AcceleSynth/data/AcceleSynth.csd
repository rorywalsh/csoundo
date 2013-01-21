Example by Rory Walsh.

<CsoundSynthesizer>
<CsOptions>
-o dac -d -+msg_color=0 -m0 -b512
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2

instr 1

kfreq chnget "pitch"
kpan chnget "pan"
kamp chnget "amp"
a1 oscil kamp/2, kfreq, 1
a2 oscil kamp/4, kfreq*.99, 1
a3 oscil kamp/4, kfreq*.98, 1

aoutL=a1*.5 + a2*.8 + a3*.2
aoutR=a1*.5 + a2*.2 + a3*.8
outs aoutL, aoutR
endin

 
</CsInstruments>
<CsScore>
f 1 0 16384 10 1 0.5 0.3 0.25 0.2 0.167 0.14 0.125 .111   ; Sawtooth
;f 1 0 256 7 0 128 1 0 -1 128 0
i 1 0 [60 * 60 * 24]
</CsScore>
</CsoundSynthesizer>
