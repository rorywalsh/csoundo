<CsoundSynthesizer>
<CsOptions>
-o dac -+rtaudio=null -d -+msg_color=0 -m0 -b512
</CsOptions>
<CsInstruments>
sr = 44100
kr = 1470
ksmps = 30
nchnls = 1
0dbfs = 1

gi_sin ftgen 1, 0, 8192, 10, 1

instr 1
    ; Keep Csound running
endin

instr 2
    idur = p3
    iamp = p4
    ifreq = p5
    
    k1 line iamp, idur, 0
    a1 oscil k1, ifreq, gi_sin
    
    out a1
endin

</CsInstruments>
<CsScore>
i 1 0 [60 * 60 * 24]
i 2 0 4 0.5 262

</CsScore>
</CsoundSynthesizer>
