Example by Conor Robotham

<CsoundSynthesizer>
<CsOptions>
-o dac -d -+msg_color=0 -m0 -b512
</CsOptions>
<CsInstruments>
sr = 44100
kr = 441
ksmps = 100
nchnls = 2
0dbfs = 1

instr 1


krate chnget "rate"
ktoggle chnget "toggle"

if(ktoggle == 1) then
	kamp=1
else
	kamp=0
endif

kfreq=100
kmod=kfreq/2

kmod oscil kmod, krate, 1
a1 oscili kamp, kfreq+kmod, 1

outs a1, a1
endin


 
</CsInstruments>
<CsScore>
f 1 0 1024 7 0 1000 1 24 0
i 1 0 [60 * 60 * 24]
</CsScore>
</CsoundSynthesizer>
