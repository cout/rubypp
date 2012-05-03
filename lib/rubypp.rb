class RubyPP
  class Environment
    def initialize(preprocessor)
      @preprocessor = preprocessor
    end

    def puts(*lines)
      @preprocessor.output.puts(*lines)
    end

    def binding
      return super
    end
  end

  attr_reader :input
  attr_reader :output
  attr_reader :filename

  def initialize(input, output, filename)
    @input = input
    @output = output
    @filename = filename
    @linenum = 1
    @environment = Environment.new(self)
    @binding = @environment.binding
  end

  def getline
    line = @input.gets
    @linenum += 1 if not line.nil?
    return line
  end

  def preprocess
    success = false
    begin
      loop do
        line = getline
        break if line.nil?
        case line
        when /(.*[^\\]|^)\#\{(.*?)\}(.*)/
          @output.puts "#{$1}#{evaluate($2, @linenum)}#{$3}"
        when /^\#ruby\s+<<(.*)/
          marker = $1
          str = ''
          evalstart = @linenum
          loop do
            line = getline
            if line.nil? then
              raise "End of input without #{marker}"
            end
            break if line.chomp == marker
            str << line
          end
          result = evaluate(str, evalstart)
          @output.puts result if not result.nil?
        when /^\#ruby\s+(.*)/
          str = line = $1
          while line[-1] == ?\\
            str.chop!
            line = getline
            break if line.nil?
            line.chomp!
            str << line
          end
          result = evaluate(str, @linenum)
          @output.puts result if not result.nil?
        else
          @output.puts line
        end
      end
      success = true
    ensure
      if not success then
        $stderr.puts "Error on line #{@linenum}:"
      end
    end
  end

  def evaluate(str, linenum)
    result = eval(str, @binding, @filename, linenum)
    return result
  end
end

def rubypp(input_file, output_file)
  input = input_file ? File.open(input_file) : $stdin
  output = output_file ? File.open(output_file, 'w') : $stdout

  success = false
  begin
    preprocessor = RubyPP.new(input, output, input_file || "(stdin)")
    preprocessor.preprocess()
    success = true
  ensure
    if not success then
      File.unlink(output_file) rescue Errno::ENOENT
    end
  end
end

