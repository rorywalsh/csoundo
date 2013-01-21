<CsoundSynthesizer>
<CsOptions>
-o dac -+rtaudio=null -d -+msg_color=0 -m0 -b512
</CsOptions>
<CsInstruments>
sr = 44100
kr = 4410
ksmps = 10
nchnls = 1
0dbfs = 1

chn_k "elapsed", 1

chnset 0, "elapsed"

instr 1
    k1 chnget "elapsed"
    chnset k1 + 1, "elapsed"
    
endin

</CsInstruments>
<CsScore>
i 1 0 [60 * 60 * 24]

</CsScore>
</CsoundSynthesizer>
