class Array
  def to_h(hash={})
    a = to_a
    0.step(a.size,2) { |i| hash[a[i]]=a[i+1] }
    hash
  end
end
