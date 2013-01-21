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

; Create sine table
gi_sin ftgen 1, 0, 8192, 10, 1

; Define chn busses
chn_k "amp", 1       ; Amplitude
chn_k "freq", 1      ; Frequency
chn_k "c", 1         ; Carrier amount
chn_k "m", 1         ; Modulation amount
chn_k "index", 1     ; FM Index
chn_k "lfo_amp", 1   ; LFO amplitude
chn_k "lfo_rate", 1  ; LFO rate

instr 1
    idur = p3  ; Duration
    iamp = p4  ; Amplitude
    
    ; Read values from chn busses
    kamp chnget "amp"    
    kfreq chnget "freq"    
    kc chnget "c"    
    km chnget "m"    
    kindex chnget "index"    
    klfo_amp chnget "lfo_amp"    
    klfo_rate chnget "lfo_rate"    

    ; FM Synthesizer
    klfo oscil 0.5, klfo_rate, gi_sin, 0.75
    klfo = (klfo + 0.5) * klfo_amp    
    a1 foscil iamp * kamp, kfreq + kfreq * klfo, kc, km, kindex, gi_sin
    
    ; Output
    out a1
endin

</CsInstruments>
<CsScore>
i 1 0 [60 * 60 * 24] 0.707  ; Turn on instrument 1
</CsScore>
</CsoundSynthesizer>
