       identification division.
       program-id. Problem3.

       environment division.
       configuration section.

       data division.
       working-storage section.
       78 78-max       value 100.
       01 ws-temp      pic x(1) comp-x value 1.
       01 ws-total     pic x(2) comp-x value 0.
       01 ws-display   pic 9.

       procedure division.

           perform varying ws-temp from 1 by 1 until ws-temp = 78-max
               if function mod(ws-temp, 3) = 0
                   add ws-temp to ws-total
               else if function mod(ws-temp, 5) = 0
                   add ws-temp to ws-total
               end-if
           end-perform

           move ws-total to ws-display
           display ws-display

           goback.

       end program Problem3.