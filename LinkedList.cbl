      $set sourceformat(variable)
       identification division.
       program-id. LinkedList.

       environment division.
       configuration section.

       data division.
       working-storage section.
       78 78-list-max-size         value 100.
       01 ws-chars                 pic x occurs 78-list-max-size.
       01 ws-heap-addresses        pointer value null occurs 78-list-max-size.

       local-storage section.
       copy "AllocateMemory.cpy"   replacing ==()== by ==ls==.
       01 ls-loop                  pic x comp-x.
       01 ls-head                  pointer value null.

       linkage section.
       copy "LinkedList.cpy"       replacing ==()== by ==lk==.
       01 lk-input                 pic x(78-list-max-size).
       01 lk-node-ptr              pointer value null.

       procedure division.

           entry "splitstring" using lk-input
               perform varying ls-loop from 1 by 1 until ls-loop > 78-list-max-size
                   move lk-input(ls-loop:ls-loop) to ws-chars(ls-loop)
               end-perform
               goback.

           entry "initialize" using lk-input

               call "splitstring" using lk-input

               perform varying ls-loop from 1 by 1 until ls-loop > 78-list-max-size
                   move length of lk-node to ls-alloc-local-size
                   call "CBL_ALLOC_MEM" using ls-alloc-local-ptr
                                              by value ls-alloc-local-size
                                              by value ls-alloc-local-type
                                    returning ls-alloc-local-return
                   end-call
                   if ls-alloc-local-return not = 0
                       display "Out of Memory!"
                       goback returning ls-alloc-local-return
                   end-if

                   set address of lk-node to ls-alloc-local-ptr
                   move low-values to lk-node(1:ls-alloc-local-size)
                   set ws-heap-addresses(ls-loop) to address of lk-node
                   move ws-chars(ls-loop) to lk-val
               end-perform

               perform varying ls-loop from 1 by 1 until ls-loop > 78-list-max-size
                   set address of lk-node to ws-heap-addresses(ls-loop)

                   if ls-loop is = 1
                       set ls-head to address of lk-node
                       set lk-prev-node to null
                       set lk-next-node to ws-heap-addresses(ls-loop + 1)
                   end-if

                   if ls-loop is not = 1 and not = 78-list-max-size
                       set lk-prev-node to ws-heap-addresses(ls-loop - 1)
                       set lk-next-node to ws-heap-addresses(ls-loop + 1)
                   end-if

                   if ls-loop is = 78-list-max-size
                       set lk-prev-node to ws-heap-addresses(ls-loop - 1)
                       set lk-next-node to null
                   end-if

                   end-perform

               goback returning ls-head

           entry "print" using lk-node-ptr
               set address of lk-node to lk-node-ptr
               if lk-next-node not = null
                   display lk-val " -> "
                   call "print" using lk-next-node
               end-if
               goback.

           entry "delete" using lk-node-ptr
               set address of lk-node to lk-node-ptr
               if lk-next-node not = null
                   call "delete" using lk-next-node
               end-if
               call "CBL_FREE_MEM" using by value lk-node-ptr
               goback.
           
       end program LinkedList.