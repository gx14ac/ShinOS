%macro cdecl 1-*nolist

    %rep %0 - 1
        push %{-1:-1}
        %rotate
    %endrep
    %rotate -1

        call %1
    
    %if < %0
        add sp, (_BTS_ >> 3) * (%0 - 1)
    %endif
    
%endmacro