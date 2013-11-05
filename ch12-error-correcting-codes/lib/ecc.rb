require 'pp'
require 'xpmr'

class Integer
  N_BYTES = [42].pack('i').size
  N_BITS = N_BYTES * 8
  MAX = 2 ** (N_BITS - 2) - 1
  MIN = -MAX - 1
end


class ECC
  NOT_FOUND = -1

  M5 = [ 0,
    2863311530,
    3435973836,
    1717986918,
    4042322160,
    1515870810,
    1010580540,
    2526451350,
    4278255360,
    1437226410,
    869020620,
    2573637990,
    267390960,
    2774181210,
    3275539260,
    1771465110,
    4294901760,
    1431677610,
    859032780,
    2576967270,
    252702960,
    2779077210,
    3284352060,
    1768527510,
    16776960,
    2857719210,
    3425907660,
    1721342310,
    4027518960,
    1520805210,
    1019462460,
    2523490710]

  @@m5_sorted = M5.each_with_index.map { |x,i| [x,i] }
  @@m5_sorted.sort!

  def write_xpm(file_name, image, base_xpmr)
    t = File.read('xpm.template')

    c = "\""
    count = 0
    image.each do |pixel|
      c += base_xpmr.bw_colors_reverse[pixel]
      if count == base_xpmr.values[0]
        c += "\"\n\""
        count = 0
      end
      count += 1
    end

    t.sub!('$content', c)

    f = File.open(file_name, 'w')
    f.write(t)
    f.close()
  end

  # Very naive and very slow approximate search
  def approx_search(l, value)
    match = NOT_FOUND
    closest = Integer::MAX

    l.each do |a|
      num, idx = a
      #puts "num: #{num} value: #{value} bits: #{num_bits_diff(value, num)} idx: #{idx}"
      if num_bits_diff(value, num) < closest
        closest = num_bits_diff(value, num)
        match = idx
      end
    end

    #puts "match: #{match}"
    match
  end

  def encode(image)
  # takes a list of integers and encodes them for transfer
    space_image = []
    image.bw_pixels.each do |i|
      space_image << M5[i]
    end

    space_image
  end

  def decode(image)
    fixed_image = []
    image.each do |i|
      fixed_image << approx_search(@@m5_sorted, i)
    end

    fixed_image
  end

  # Found at http://graphics.stanford.edu/~seander/bithacks.html#CountBitsSetParallel
  def num_bits_diff(x, y)
    v = x ^ y
    c =  ((v & 0xfff) * 0x1001001001001 & 0x84210842108421) % 0x1f
    c += (((v & 0xfff000) >> 12) * 0x1001001001001 & 0x84210842108421) % 0x1f
    c += ((v >> 24) * 0x1001001001001 & 0x84210842108421) % 0x1f

    c
  end

  @@powers_of_two = (0..32).each.collect { |n| 1 << n }

  def introduce_error(image, bits_of_error=1)
    err_image = []
    image.each do |pixel|
      new_pixel = pixel
      (0..bits_of_error-1).each do |b|
        bit2flip = @@powers_of_two.sample
        new_pixel = new_pixel ^ bit2flip
        #print("pixel=",pixel," bit2flip=", bit2flip," diff=",num_bits_diff(new_pixel, pixel), " new_pixel=",(new_pixel))
      end
      err_image << new_pixel
    end

    err_image
  end

end

ecc = ECC.new
puts("Reading in the image for transfer...")
image = XPMR.new(File.read('./avatar-small.rb'))
puts("Done reading image.")

(1..10).each do |bit_error|
  puts "bit_error=%d" % bit_error
  puts "    Encoding image for transfer..."
  space_image = ecc.encode(image)
  puts "    Done encoding image."

  puts "    Introducing error..."
  space_image = ecc.introduce_error(space_image, bit_error)
  puts "    Havok caused."

  if space_image == image.bw_pixels
    puts "    Space image not changed!"
  else
    puts "    Space image damaged!"
  end

  puts "    Fixing image..."
  fixed_image = ecc.decode(space_image)
  puts "    Image fixed."

  if image.bw_pixels.eql? fixed_image
    puts "Image matches!"
  else
    puts "Image doesn't match!"
  end

  ecc.write_xpm("%d.xpm" % bit_error, fixed_image, image)
end


