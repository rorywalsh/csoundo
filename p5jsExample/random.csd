<CsoundSynthesizer>
<CsOptions>
-m0d
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

instr 1
  kfreq chnget "pitch"
  kpan chnget "pan"
  kamp chnget "amp"
  kchanged changed kfreq
  if(kchanged==1) then
        event "i", 10, 0, 3, kfreq, kpan, kamp/60000
  endif
endin


instr 10
  aexp expon p6, p3, 0.001
  a1 oscil aexp, p4
  outs a1*p5, a1*(1-p5)
endin


</CsInstruments>
<CsScore>
i1 0 z
</CsScore>
</CsoundSynthesizer>
