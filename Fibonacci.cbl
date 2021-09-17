       identification division.
       program-id. Fibonacci.

       environment division.
       configuration section.

       data division.
       working-storage section.
       78 78-max       value 4000000.
       01 ws-prev      pic x(4) comp-x.
       01 ws-curr      pic x(4) comp-x.
       01 ws-temp      pic x(4) comp-x.
       01 ws-total     pic x(4) comp-x.
       01 ws-display   pic x(4).

       procedure division.

           move 1 to ws-prev
           move 2 to ws-curr
           move 0 to ws-total

           perform until ws-curr > 78-max
               if function mod(ws-curr, 2) = 0
                   add ws-curr to ws-total
               end-if

               move ws-curr to ws-temp
               add ws-prev to ws-curr
               move ws-temp to ws-prev
           end-perform

           move ws-total to ws-display
           display ws-display

           goback.

       end program Fibonacci.