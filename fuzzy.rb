class Fuzzy
  def self.find(strings, input)
    @weights = Array.new(strings.length, -1)
    @strings = strings.dup
    ret = Array.new
    regexp = /#{build_regexp(input)}/
    @strings.each_index do |i|
      assign_weights(i, regexp)
    end

    @weights.each_index do |i|
      if @weights[i] == -1
        @weights.delete_at(i)
        strings.delete_at(i)
      end
    end

    @weights.map.with_index.sort_by(&:first).map(&:last).each do |index|
      ret.push strings[index]
    end

    return ret
  end

  # build the regular expression
  def self.build_regexp(string)
    regexp = ""
    string.each_char do |c|
      regexp << "(\w*)#{c}"
    end
    regexp << "(\w*)"
  end

  def self.assign_weights(index, regexp)
    weight = @strings[index] =~ regexp
    if weight == nil
      return
    end
    @weights[index] += (weight+1)
    if !done(index)
      @strings[index] = @strings[index][weight+1..@strings[index].length]
      assign_weights(index, /#{regexp.source[5..regexp.source.length]}/)
    end
  end

  def self.done(index)
    @strings[index] == nil || @weights[index] == -1 ? true : false
  end

  private_class_method :build_regexp, :assign_weights, :done
end
