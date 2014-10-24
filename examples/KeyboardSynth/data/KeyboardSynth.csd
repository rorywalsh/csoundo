<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2

0dbfs = 1

instr 1
kFreq chnget "freq"
;kAmp chnget "amp"
kHrms chnget "hrms"
kGo changed kFreq
if(kGo==1) then
   event "i", 10, 0, 3, cpspch(kFreq), .6, kHrms 
endif
endin


instr 10
aexp expon p5/10, p3, 0.001
a1 buzz aexp, p4, p6, 1
outs a1, a1
endin


</CsInstruments>
<CsScore>
f1 0 1024 10 1
i1 0 3600
</CsScore>
</CsoundSynthesizer>
