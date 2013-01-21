<CsoundSynthesizer>
<CsOptions>
-g -odac C:\Users\Conor\Documents\Processing\libraries\csoundo\examples\Squares\data\__CSOUNDO__.csd
</CsOptions>
<CsInstruments>
sr = 44100
kr = 441
ksmps = 100

nchnls = 2

instr 1

krate chnget "rate1"
;kmod chnget "mod"
;kfreq chnget "pitch"
kamp chnget "amp1"
;kamp=5000
kfreq=400
;krate=11
kmod=100

a2 oscil kmod, krate, 1
a1 oscil kamp, kfreq+a2, 1


outs a1, a1
endin


 
</CsInstruments>
<CsScore>
f 1 0 1024 10 1
i 1 0 [60 * 60 * 24]

</CsScore>
</CsoundSynthesizer>
