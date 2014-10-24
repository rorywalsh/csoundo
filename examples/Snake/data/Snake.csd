;Rory Walsh.

<CsoundSynthesizer>
<CsOptions>
-o dac -+rtaudio=null -d -+msg_color=0 -m0 -b512
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 64
nchnls = 2

0dbfs = 1

instr 1
kIndex chnget "note"
kOctave chnget "numberOfNotes"
kchanged1 changed kIndex                          
kchanged2 changed kOctave
kMute randh 1, 10, 1

if(kchanged1==1) then  
	if(kIndex<16) then
	kNote tab int(kIndex), 2
	event "i", 10, 0, 1, cpspch(kNote+7)*round(abs(kMute));
	endif
endif     

if(kchanged2==1) then
	event "i", 20, 0, 3
endif
endin


instr 10
aexp expon .5, p3, 0.001
a1 oscil aexp, p4, 1
outs a1, a1
endin
 
instr 20
aexp expon .5, p3, 0.001
a1 randi aexp, 1000
a2 oscil a1, 200, 1
outs a2, a2
endin


</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 16 -2 0 .02 .04 .05 .07 .09 .11 1 1.02 1.04 1.05 1.07 1.09 1.11 2 2.02
i 1 0 [60 * 60 * 24]
</CsScore>
</CsoundSynthesizer>
