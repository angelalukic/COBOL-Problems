      $set sourceformat(variable)
       identification division.
       program-id. BubbleSort.

       environment division.
       configuration section.

       data division.
       working-storage section.
       78 78-list-length   value 6.
       01 ws-list          pic x(5) occurs 78-list-length.
       01 ws-temp          pic x(5).
       01 ws-num           pic x comp-x.
       01 ws-swaps         pic 9.

       procedure division.

           perform list-init

           perform until ws-swaps = 0
               move 0 to ws-swaps
               perform varying ws-num from 1 by 1 until ws-num > 78-list-length - 1
                   if ws-list(ws-num) > ws-list(ws-num + 1)
                       move ws-list(ws-num) to ws-temp
                       move ws-list(ws-num + 1) to ws-list(ws-num)
                       move ws-temp to ws-list(ws-num + 1)
                       move 1 to ws-swaps
                   end-if
               end-perform
           end-perform

           perform varying ws-num from 1 by 1 until ws-num > 78-list-length
               display ws-list(ws-num)
           end-perform

           goback.

       list-init section.

           move "Where" to ws-list(1)
           move "What" to ws-list(2)
           move "How" to ws-list(3)
           move "Why" to ws-list(4)
           move "Who" to ws-list(5)
           move "When" to ws-list(6)
           exit section.

       end program BubbleSort.