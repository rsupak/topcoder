MAX_BUCKET_SIZE = 10

def bucket_sort(array)
  buckets = fill_buckets(array, 3)
  sorter(buckets)
  buckets.reduce(&:+)
end

def fill_buckets(array, count)
  buckets = Array.new(count) { [] }
  array.each do |num|
    if num <= array.max / count
      buckets[0] << num
    elsif num <= 2 * array.max / count
      buckets[1] << num
    else
      buckets[2] << num
    end
  end
  buckets
end

def sorter(buckets)
  buckets.each do |bucket|
    heap_sort(bucket)
  end
end

def heap_sort(array)
  build_heap(array)
  last = array.size - 1
  until last <= 0
    swap(array, 0, last)
    last -= 1
    array[0..last] = build_heap(array[0..last])
  end
  array
end

def build_heap(array)
  array.each_index do |i|
    if array[i] > array [i / 2]
      swap(array, i, i / 2)
      build_heap(array)
    end
  end
end

def swap(array, first, last)
  array[first], array[last] = array[last], array[first]
end

shuffled_array = Array.new(10) { rand(-100...100) }

puts "Random Array: #{shuffled_array}"
puts "Sorted Array: #{bucket_sort(shuffled_array)}"
