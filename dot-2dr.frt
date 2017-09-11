\ Print a signed number n with two digits after the decimal point
\ right justifed by r places e.g 25 5 .2dr | 0.25   -12 7 2d.r |  -0.12

: .2dr 
    ( n r --   )
    >r s>d \ Save justification & convert to double
    swap over dabs \ Save sign & convert to absolute
    <# # # [char] . hold  #s rot sign #> \ Convert 2 digits, insert "." and convert rest & sign
    r> over - spaces type  \ Recover justification and print
;
