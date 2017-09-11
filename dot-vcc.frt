\ Read and print Vcc by measuring internal 1.1V reference
\  #require bitnames.frt
\  #require star-slash.frt
\  #require dot-2dr.frt


\ Set up the ADC to read the internal 1.1 Vref
: adc.ref ( -- )
  \ ADCSRA
  %10000110   \ ADPS2 | ADPS1 = prescaler: 64
  ADCSRA c!
  \ ADMUX
  %01001110  \ Ref=Vcc   Input Ch = 1.1V reference
  ADMUX c!
  \ ADCSRA
  ADCSRA c@         \ Get current ADCSRA
  %10000000         \ ADEN   ADC enabled
  or ADCSRA c!
;

: adc.init.pin ( bitmask portaddr -- )
  over over high
  pin_input
;
  
1 6 lshift constant ADSC_MSK \ ADStartConversion bitmask
: adc.start
  \ start conversion
  ADSC_MSK ADCSRA high
;

: adc.wait
  \ wait for completion of conversion
  begin
    ADCSRA c@ ADSC_MSK and 0=
  until
;

\ Get the ADC reading for the internal 1.1V reference
: vref.get ( -- )
  adc.ref 250 0 do 1ms loop \ Give it some time to settle
  adc.start adc.wait \ Start ADC & wait for conversion
  ADC @ \ Get 10bit reading
;

\ Use vref.get result to calculate the current Vcc in volts * 100
: vcc ( -- v ) 
    110 1024 vref.get */  \ Vcc is 1024 and vref is 110 (1.1 * 100)
;

\ Print Vcc to two decimal places
: .vcc ( -- )
    vcc 7 .2dr ."  volts"
;

