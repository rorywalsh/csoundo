Example by Rory Walsh.

<CsoundSynthesizer>
<CsOptions>
-o dac -+rtaudio=null -d -m0 -b512
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2

0dbfs = 1
gaSig init 0
gaSigL init 0
gaSigR init 0


instr 1
kmod chnget "mod"
kcar chnget "car"
amod lfo .1, kmod
acar oscil amod, kcar, 1
gaSig = acar
endin

;global delay
instr 2
acombL comb gaSig*.1, 2, .3
acombR comb gaSig*.1, 2, .42
outs acombL, acombR
endin
 


</CsInstruments>
<CsScore>
f1 0 1024 10 1 0.5 .2
i1 0 [60 * 60 * 24]
i2 0 [60 * 60 * 24]

</CsScore>
</CsoundSynthesizer>
