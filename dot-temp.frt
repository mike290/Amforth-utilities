\ Retrieves temperature from a *single* DS18B20
\ Some code marked [c] COPYRIGHT 2012 Bradford J. Rodriguez.
\ See 1wire.frt in Amforth library: /common/lib

\ Developed to run on top of Arduino UNO standard build of Amforth but should run 
\ on other Amforth implementations which include Onewire words 1w.reset & 1w.slot
\ By default these are compiled to use pin 12 of the Arduino == PortB Pin4 of ATmega328P

\ Not incuded in standard UNO build:
\ #require star-slash.frt
\ #require dot-2dr.frt

\ Sends and receives a single byte of data from the sensor [c]
: 1w.touch
    ( send_c1 -- recv_c2 ) 
    1w.slot 1w.slot 1w.slot 1w.slot
    1w.slot 1w.slot 1w.slot 1w.slot
;

: c!1w ( send_c -- ) 1w.touch drop ;    \ Send a byte - drop the received byte [c]
: c@1w ( -- recv_c ) $ff 1w.touch ;     \ Receive a byte [c]

\ Instructs the sensor to accept any command as there is only a single 1-wire device attached. [c]
\ Function commands such as 1w.convert & 1w.getscratch that address a single device require a
\ 1w.skiprom to talk to the only device present on the bus.
: 1w.skiprom ( -- )
   1w.reset if
      $cc c!1w
   then
;

\ Get the contents of the scratchpad onto stack - CRC is ToS. Single sensor only.
: 1w.getscratch 
    ( -- c0 c1 c2 c3 c4 c5 c6 c7 crc ) \ c1 & c0 contain temperature data.
    1w.skiprom
    $BE c!1w
    c@1w c@1w c@1w c@1w
    c@1w c@1w c@1w c@1w 
    c@1w 
;

\ Send start conversion code to DS18B20 and wait for maximum time. Single sensor only.
: 1w.convert
    (   --   )
    1w.skiprom
    $44 c!1w           \  Maximum 12 bit conversion delay should be 750mS however
    780 0 do 1ms loop  \  wait 780mS to allow for timing errors e.g. non-crystal clock
;
    
\ Convert c1 & c0 into a single 16 bit number representing hundredths of a degree
\ Note: DS18B20 provides resolution to 0.0625 degC however datasheet
\ specifies device accuracy as only +-0.5degC
: ds18b20.decode
    ( c0 c1  -- T_hundredths)
    8 lshift + \ Combine the two bytes into a single 16 bit cell
    100 16 */  \ Convert to hundredths
;

\ Get the temperature in hundredths of a degC (no CRC check)
: temp.get
    (   --  T_hundredths )
    1w.convert 1w.getscratch
    7 0 do drop loop \ Drop CRC and c2 - c7
    ds18b20.decode
;

\ Print the temperature in decimal format e.g. 14.25 degC
: .temp
    (  --  )
    temp.get 7 .2dr ."  degC"  \ Print temperature justified right 7 places
;

