module IntegersEnumerable
  ##
  # @return [Hash] inmutable
  def integers_enumerable(array)
    array.inject({}) do |memo, name|
      memo[name] = memo.keys.count
      memo
    end.freeze
  end
end
