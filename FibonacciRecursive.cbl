      $set sourceformat(variable)
       identification division.
       program-id. FibonacciRecursive.

       environment division.
       configuration section.

       data division.
       working-storage section.
       01 ws-total             pic x(4) comp-x.

       local-storage section.
       01 ls-cmdline           pic x comp-x.
       01 ls-return            pic x(4) comp-5.
       copy "Fibonacci.cpy"    replacing ==()== by ==ls==.
       copy "ErrorCodes.cpy"   replacing ==()== by ==ls==.

       linkage section.
       01 lk-max-index         pic x comp-x.
       copy "Fibonacci.cpy"    replacing ==()== by ==lk==.

       procedure division.
           accept ls-cmdline from command-line

           call "errorcheck" using ls-cmdline returning ls-return

           if ls-return not = 0
               display "CODE: " ls-return
               goback
           end-if


           call "fibonacci" using  ls-fibonacci
                                   ls-cmdline
           end-call

           display ws-total

           goback.

           entry "fibonacci" using     lk-fibonacci
                                   lk-max-index

               if lk-index = lk-max-index
                   move lk-total to ws-total
                   goback
               end-if

               add lk-curr to ls-total
               move lk-curr to ls-temp
               move lk-curr to ls-curr
               add lk-prev to ls-curr
               move ls-temp to ls-prev
               move lk-index to ls-index
               add 1 to ls-index

               call "fibonacci" using  ls-fibonacci
                                       lk-max-index
               end-call
           goback.

           entry "errorcheck" using lk-max-index

               if lk-max-index = 0
                   display "ERROR: Please enter a non-zero numerical value."
                   set ls-zero-value-88 to true
                   goback returning ls-error-code
               else if lk-max-index > 50
                   display "ERROR: Please enter a numerical value between 0 - 50."
                   set ls-large-value-88 to true
                   goback returning ls-error-code
               end-if

           goback returning ls-error-code. *> Return 0 - OK!

       end program FibonacciRecursive.