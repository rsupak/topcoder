class PriorityQueue
  attr_accessor :heap
  def initialize
    @heap = [nil]
  end

  def <<(elem)
    @heap << elem
    bubble_up(@heap.size - 1)
  end

  def peek
    @heap[1]
  end

  def remove_min
    exchange(1, @heap.size - 1)
    min_elem = @heap.pop
    bubble_down(1)
    min_elem
  end

  def size
    @heap.size
  end

  private

  def bubble_up(index)
    parent_index = index / 2
    return if index <= 1
    return if @heap[parent_index] <= @heap[index]

    exchange(index, parent_index)
    bubble_up(parent_index)
  end

  def bubble_down(index)
    child_index = index * 2
    return if child_index > @heap.size - 1

    not_last_element = child_index < @heap.size - 1
    left_child = @heap[child_index]
    right_child = @heap[child_index + 1]

    if not_last_element && right_child < left_child
      child_index += 1
    end

    return if @heap[index] <= @heap[child_index]

    exchange(index, child_index)

    bubble_down(child_index)
  end

  def exchange(source, target)
    @heap[source], @heap[target] = @heap[target], @heap[source]
  end
end

def optimal_tourney_sort(array)
  sorted_array = []
  pq = PriorityQueue.new
  array.each { |num| pq << num }
  until pq.size == 1
    sorted_array << pq.peek
    pq.remove_min
  end
  sorted_array
end

pq = PriorityQueue.new
pq << 2
pq << 3
pq << 1
p pq

if $PROGRAM_NAME == __FILE__
  shuffled_array = Array.new(50) { rand(-100...100) }
  puts "Random Array: #{shuffled_array}"
  puts "Sorted Array: #{optimal_tourney_sort(shuffled_array)}"
end
