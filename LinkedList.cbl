      $set sourceformat(variable)
       identification division.
       program-id. LinkedList.

       environment division.
       configuration section.

       data division.
       working-storage section.
       78 78-list-max-size             value 100.
       01 ws-chars                     pic x occurs 78-list-max-size.
       01 ws-heap-addresses            pointer value null occurs 78-list-max-size.
       01 ws-substring-removed         pic x comp-x value 0.
         88 ws-substring-removed-false value 0.
         88 ws-substring-removed-true  value 1.
       01 ws-substring-previous        pointer value null.
       01 ws-substring-next            pointer value null.

       local-storage section.
       copy "AllocateMemory.cpy"       replacing ==()== by ==ls==.
       01 ls-loop                      pic x comp-x.
       01 ls-head                      pointer value null.
       01 ls-remove-head               pointer value null.

       linkage section.
       copy "LinkedList.cpy"           replacing ==()== by ==lk==.
       01 lk-input                     pic x(78-list-max-size).
       01 lk-input-length              pic x comp-x.
       01 lk-node-ptr                  pointer value null.

       procedure division.

           entry "splitstring" using lk-input
               perform varying ls-loop from 1 by 1 until ls-loop > 78-list-max-size
                   move lk-input(ls-loop:1) to ws-chars(ls-loop)
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
                   move ls-loop to lk-position
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
               display lk-position ": " lk-val " -> "
               if lk-next-node not = null
                   call "print" using lk-next-node
               end-if
               goback.

           entry "delete" using lk-node-ptr
               set address of lk-node to lk-node-ptr
               if lk-next-node not = null
                   call "delete" using lk-next-node
               end-if
               call "CBL_FREE_MEM" using by value lk-node-ptr
               set lk-node-ptr to null
               goback.

           entry "remove" using lk-node-ptr, lk-input, lk-input-length
               set ls-head to lk-node-ptr
               set address of lk-node to lk-node-ptr
               perform varying ls-loop from 1 by 1 until lk-next-node is = null

                   if lk-val is = lk-input(1:1)                            *> If node value is equal to first character in input
                       call "removesubstring" using lk-node
                                                    lk-input
                                                    lk-input-length
                       end-call
                   end-if

                   if ws-substring-removed = 1
                       if ws-substring-previous is = null
                           set ls-head to ws-substring-next                    *> Return new head to LinkedList if original head was removed
                       end-if
                       set ws-substring-removed-false to true
                       set address of lk-node to ws-substring-next
                       if ws-substring-next is = null                          *> End of LinkedList was removed, so return early
                           goback returning ls-head
                       end-if
                   else
                       set address of lk-node to lk-next-node
                   end-if

               end-perform
               goback returning ls-head.

           entry "removesubstring" using lk-node, lk-input, lk-input-length
               set ls-remove-head to address of lk-node
               set ws-substring-previous to lk-prev-node
               perform varying ls-loop from 1 by 1 until lk-val not = lk-input(ls-loop:1)  *> Loop unless the next node's value does not equal next character in input
                   if (ls-loop = lk-input-length and lk-val = lk-input(ls-loop:1))         *> Complete match has been found!

                       move lk-next-node to ws-substring-next
                       set lk-next-node to null

                       *> Update nodes prior and after the substring to point to each other
                       if ws-substring-next not = null                         *> Null when substring is at end of LinkedList
                           move ws-substring-next to address of lk-node
                           set lk-prev-node to ws-substring-previous
                       end-if
                       if ws-substring-previous not = null                     *> Null when substring is at beginning of LinkedList
                           move ws-substring-previous to address of lk-node
                           set lk-next-node to ws-substring-next
                       end-if

                       call "delete" using ls-remove-head
                       set ws-substring-removed-true to true
                   else
                       set address of lk-node to lk-next-node
                   end-if
               end-perform
               goback.
           
       end program LinkedList.