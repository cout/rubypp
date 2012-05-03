Rubypp is a preprocessor that uses ruby to transform text.  Syntax is
similar to the C preprocessor, e.g.:

    #include <stdio.h>
    
    #ruby <<END
      a = 42
      nil # the last value of the block gets inserted into the output stream
    END
    
    int main()
    {
      printf("The answer is: #{a}\n");
    }

