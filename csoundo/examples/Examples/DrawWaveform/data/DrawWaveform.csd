<CsoundSynthesizer>
<CsOptions>
-o dac -d -+msg_color=0 -m0 -b512
</CsOptions>
<CsInstruments>
sr = 44100
kr = 4410
ksmps = 10
nchnls = 2
0dbfs = 1

instr 1
a1 oscil .5, 400, 1
outs a1, a1
endin

</CsInstruments>
<CsScore>
f1 0 1024 10 1

i 1 0 [60 * 60]  ; Turn on for 1 hour
</CsScore>
</CsoundSynthesizer>
