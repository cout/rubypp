spec = Gem::Specification.new do |s|
  s.name = 'rubypp'
  s.version = '0.0.1'
  s.summary = 'A preprocessor that uses ruby to transform text'
  s.homepage = 'http://github.com/cout/rubypp/'
  s.author = 'Paul Brannan'
  s.email = 'curlypaul924@gmail.com'
  s.description = <<-END
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
  END

  s.executables = [ 'rubypp' ]
  s.test_files = [ 'test/test_rubypp.rb' ]
  s.has_rdoc = true
  s.extra_rdoc_files = 'README'
end

