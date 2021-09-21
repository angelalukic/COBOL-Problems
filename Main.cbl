      $set sourceformat(variable)
       identification division.
       program-id. Main.

       environment division.
       configuration section.

       data division.
       working-storage section.
       01 ws-head                  pointer value null.

       local-storage section.
       copy "LinkedList.cpy"       replacing ==()== by ==ls==.
       01 ls-cmdline               pic x(78-list-max-size).

       linkage section.

       procedure division.
           accept ls-cmdline from command-line

           call "initialize" using ls-cmdline
                         returning ws-head
           end-call

           call "print" using ws-head

           call "delete" using ws-head

           goback.

       end program Main.