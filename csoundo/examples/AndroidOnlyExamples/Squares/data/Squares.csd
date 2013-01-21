<CsoundSynthesizer>
<CsOptions>
-o dac -+rtaudio=null -d -+msg_color=0 -m0 -b512
</CsOptions>
<CsInstruments>
sr = 44100
kr = 441
ksmps = 100
nchnls = 2
0dbfs = 1

instr 1

krate chnget "rate1"
;kmod chnget "mod"
;kfreq chnget "pitch"
ktoggle chnget "toggle1"

if(ktoggle == 1) then
	kamp=0.2
else
	kamp=0
endif

kfreq=440
kmod=kfreq/10

a2 oscil kmod, krate, 1
a1 oscil kamp, kfreq+a2, 1


outs a1, a1
endin

instr 2

krate chnget "rate2"
;kmod chnget "mod"
;kfreq chnget "pitch"
;kamp chnget "amp2"
ktoggle chnget "toggle2"

if(ktoggle == 1) then
	kamp=0.2
else
	kamp=0
endif

kfreq=220
kmod=kfreq/10


a2 oscil kmod, krate, 1
a1 oscil kamp, kfreq+a2, 1


outs a1, a1
endin

instr 3

krate chnget "rate3"
;kmod chnget "mod"
;kfreq chnget "pitch"
;kamp chnget "amp3"
ktoggle chnget "toggle3"

if(ktoggle == 1) then
	kamp=0.2
else
	kamp=0
endif

kfreq=277
kmod=kfreq/10


a2 oscil kmod, krate, 1
a1 oscil kamp, kfreq+a2, 1


outs a1, a1
endin

instr 4

krate chnget "rate4"
;kmod chnget "mod"
;kfreq chnget "pitch"
;kamp chnget "amp4"
ktoggle chnget "toggle4"

if(ktoggle == 1) then
	kamp=0.2
else
	kamp=0
endif

kfreq=330
kmod=kfreq/10


a2 oscil kmod, krate, 1
a1 oscil kamp, kfreq+a2, 1


outs a1, a1
endin

 
</CsInstruments>
<CsScore>
f 1 0 1024 10 1
i 1 0 [60 * 60 * 24]
i 2 0 [60 * 60 * 24]
i 3 0 [60 * 60 * 24]
i 4 0 [60 * 60 * 24]

</CsScore>
</CsoundSynthesizer>
