<CsoundSynthesizer>
<CsOptions>
-o dac -+rtaudio=null -d -+msg_color=0 -m0 -b512
</CsOptions>
<CsInstruments>
sr = 44100
kr = 4410
ksmps = 10
nchnls = 2
0dbfs = 1

instr 1
    ; Keep synth running
endin

</CsInstruments>
<CsScore>
f 1 0 512 10 1 0 [1/3] 0 [1/5] 0 [1/7] 0 [1/9] 0 [1/11] 0 [1/13] 0 [1/15]
f 2 0 64 21 6 1

i 1 0 [60 * 60]  ; Turn on for 1 hour
</CsScore>
</CsoundSynthesizer>
