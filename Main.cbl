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
       01 ls-substring-length      pic x comp-x.
       01 ls-cmdline               pic x(78-list-max-size).
       01 ls-substring             pic x(6) value "Angela".

       linkage section.

       procedure division.
           accept ls-cmdline from command-line

           call "initialize" using ls-cmdline
                         returning ws-head
           end-call

           call "print" using ws-head

           set ls-substring-length to length of ls-substring
           call "remove" using ws-head
                               ls-substring
                               ls-substring-length
                     returning ws-head
           end-call

           display "After Remove String:"
           call "print" using ws-head

           call "delete" using ws-head

           goback.

       end program Main.