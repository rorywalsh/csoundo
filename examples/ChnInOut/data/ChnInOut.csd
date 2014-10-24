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

gi_wave ftgen 1, 0, 8192, 9, 0.5, 1, 0

chn_k "mouse_x", 1
chn_k "mouse_y", 1
chnset 0, "mouse_x"
chnset 0, "mouse_y"

instr 1
    idur = p3
    iamp = p4
    
    k1 chnget "mouse_y"    
    k2 chnget "mouse_x"    
    a1 oscil iamp * k1, 100 * 8 ^ k2, gi_wave
    
    out a1
endin

</CsInstruments>
<CsScore>
i 1 0 [60 * 60 * 24] 0.707
</CsScore>
</CsoundSynthesizer>
