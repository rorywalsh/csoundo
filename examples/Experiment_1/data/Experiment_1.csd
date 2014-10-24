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

gi_sin ftgen 1, 0, 8192, 10, 1

chn_a "left", 3
chn_a "right", 3

instr 1
    idur = p3     ; Duration
    iamp = p4     ; Amplitude
    ifreq = p5    ; Frequency
    ipan = p6     ; Pan
    i_index = p7  ; FM index amount
    
    imix = 0.75
        
    irandom random 0.995, 1.005
    a2 linseg 0, 0.05, 1, idur - 0.05, 0
    k2 line 0.5 + (3 * i_index), idur, 0.5
    a1 foscil iamp, ifreq * irandom, 1, 1.61803399, k2, 1
    
    a1 = a1 * a2
    
    aleft = a1 * sqrt(1 - ipan)
    aright = a1 * sqrt(ipan)
    
    outs aleft * sqrt(1 - imix), aright * sqrt(1 - imix)
    
    chnmix aleft * sqrt(imix), "left"
    chnmix aright * sqrt(imix), "right"
    event_i "i", 2, 0, 1, iamp * 0.4 * sqrt(1 - imix), ifreq * 3, ipan
endin

instr 2
    p3 = 0.2    ; Set duration
    idur = p3   ; Duration
    iamp = p4   ; Amplitude
    ifreq = p5  ; Frequency
    ipan = p6   ; Pan
    
    a1 line iamp, idur, 0
    a2 oscil a1, ifreq , 1
    
    outs a2 * sqrt(1 - ipan), a2 * sqrt(ipan)
    chnmix a2 * sqrt(1 - ipan), "left"
    chnmix a2 * sqrt(ipan), "right"
endin

instr 3
    iamp = p4        ; Amplitude
    imax_delay = 35
    imin_delay = 10
    
    a1 chnget "left"
    a2 chnget "right"
    chnclear "left"
    chnclear "right"
    
    ifb = 0.6
    it = 0.1
    
    alfo1 oscil 0.5, 0.1, 1
    alfo1 = (alfo1 + 0.5) * (imax_delay - imin_delay) + imin_delay
    alfo2 oscil 0.5, 0.11, 1, 0.3
    alfo2 = (alfo2 + 0.5) * (imax_delay - imin_delay) + imin_delay
       
    afb1 delayr it
    ad1 vdelay3 a1 + afb1, alfo1, imax_delay
    delayw ad1 * ifb

    afb2 delayr it
    ad2 vdelay3 a2 + afb2, alfo2, imax_delay
    delayw ad2 * ifb
    
    a3, a4 freeverb ad2, ad1, 0.8, 0.5    
    outs a3 * iamp, a4 * iamp
endin

</CsInstruments>
<CsScore>
i 3 0 [60 * 60 * 24] 0.8  ; Turn of fx for 24 hours
</CsScore>
</CsoundSynthesizer>
