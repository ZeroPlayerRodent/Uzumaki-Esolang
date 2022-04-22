require "big"

zero = BigInt.new("0")

inst = zero
arr = Array(Array(Char)).new

code = if ARGV.size > 0
         File.read(ARGV[0])
       else
         puts "No file specified."
         exit
       end



code = code.split(/\r?\n+/)
while inst < code.size
arr << code[inst].chars
inst+=1
end

arr.pop(1)

jumpin = false
corner = false
jumpy = 0
jumpx = 0

y = zero
x = zero

movey = 0
movex = 1

acc = zero

offset = 0

queue = Array(BigInt).new
queue << zero

front = 0
back = -1

dir = "right"

printmode = false

turn_num = BigInt.new("1")

macro is_in
    if !arr[y][x].in_set? "`QIDPMOCAXSGWJKRHBVZVE#"
        print "ERROR: Invalid Character '" + arr[y][x] + "'."
        exit
    end
end

macro get_a
  if byte = STDIN.read_byte
    queue.insert(back, byte.to_big_i)
  else
    queue.insert(back, zero)
  end
end

macro move
    corner = false
    x += movex
    y += movey
end

macro moveback
    x -= movex
    y -= movey
end

macro term
    if turn_num > arr.size
        exit
    end
end

macro jump(xy, j, amount, turn)
    moveback
    {{xy}} += {{j}}
    offset += {{amount}}
    turn_num += {{turn}}
end

macro spiral_check(movey, movex, dir, offset)
    movey = {{movey}}
    movex = {{movex}}
    offset += {{offset}}
    dir = {{dir}}
    turn_num += 1
    corner = true
end

macro skip
    move
    keep_spiral
    is_in
end

macro keep_spiral
    term
    if arr[y].size != arr.size
        print "Not a perfect spiral!"
        exit
    end
    if x > arr[y].size || x < 0 || y > arr.size || y < 0
        puts "ERROR: IP out of bounds."
        exit
    end
    if x == (arr[y].size - 1 - offset) && y == offset 
        #Top right
        spiral_check 1, 0, "down", 0
    end
    if x == (arr[y].size - 1 - offset) && y == (arr.size - 1 - offset)
        #Bottom right
        spiral_check 0, -1, "left", 0
    end
    if x == offset && y == (arr.size - 1 - offset)
        #Bottom left
        spiral_check -1, 0, "up", 0
    end
    if x == offset && y == offset + 2
        #Top left
        spiral_check 0, 1, "right", 2
    end
end

macro is_corner
    if arr[y].size != arr.size
        print "Not a perfect spiral!"
        exit
    end
    if x == (arr[y].size - 1 - offset) && y == offset 
        #Top right
        corner = true
    end
    if x == (arr[y].size - 1 - offset) && y == (arr.size - 1 - offset)
        #Bottom right
        corner = true
    end
    if x == offset && y == (arr.size - 1 - offset)
        #Bottom left
        corner = true
    end
    if x == offset && y == offset + 2
        #Top left
        corner = true
    end
    
    if dir == "right" && x == offset - 2 && y == offset
        corner = true
    end
end

while 0
        jumpin = false
        case arr[y][x]
        when 'E'; puts queue
        when '#'; printmode = true
        when 'Q'; queue.insert(back, zero)
        when 'I'
            if queue.size > 0
            queue[front] += 1
            end
        when 'D' 
            if queue.size > 0
            queue[front] -= 1
            end
        when 'P'
            if queue.size > 0
            queue[front] += 10
            end
        when 'M'
            if queue.size > 0
            queue[front] -= 10
            end
        when 'O'
            if queue.size > 0
            print queue[front]
            end
        when 'C'
            if queue.size > 0
            print (queue[front]%=255).to_i.chr
            end
        when 'A'
            if queue.size > 0
            acc = queue[front]
            end
        when 'X'
            if queue.size > 0
            queue.delete_at(front)
            end
        when 'Z'
            if queue.size > 0
            queue.insert(back, queue[front])
            end
        when 'S'; get_a
        when 'V'
            if queue.size > 0
            queue[front] += acc
            end
        when 'G' 
            maybe_a_num = gets.not_nil!.chomp
                if maybe_a_num.index(/[^0-9]/)
                    queue.insert(back, zero)
                else
                    queue.insert(back, maybe_a_num.to_big_i)
                end
        when 'W'
            case dir
            when "right"
                moveback
                y = 0
                offset = 0
                turn_num = 1
            when "left"
                moveback
                y = arr.size - 1
                offset = 0
                turn_num = 3
            when "down"
                moveback
                x = arr[y].size - 1
                offset = 0
                turn_num = 2
            when "up"
                moveback
                x = 0
                offset = 0
                turn_num = 4
            end
        when 'J'
            if queue.size > 0
            if queue[front] == acc
                skip
            end
            end
        when 'K'
            if queue.size > 0
            if queue[front] != acc
                skip
            end
            end
        when 'R'
            if front == 0
                front = -1
                back = 0
            else
                front = 0
                back = -1
            end
        when 'H'
            case dir
            when "right"; jump y, -2, -2, -4
            when "left"; jump y, 2, -2, -4
            when "down"; jump x, 2, -2, -4
            when "up"; jump x, -2, -2, -4
            end
        when 'B'
            if corner == true
                puts "ERROR: Attempt to jump inward while IP is on corner."
                exit
            end
            move
            is_corner
            if corner == true
                puts "ERROR: Attempt to jump inward while IP is not aligned with inner layer."
                exit
            end
            moveback
            moveback
            is_corner
            if corner == true
                puts "ERROR: Attempt to jump inward while IP is not aligned with inner layer."
                exit
            end
            move
            
            case dir
            when "right"
                jumpy = y + 2
                jumpx = x
            when "left"
                jumpy = y - 2
                jumpx = x
            when "down"
                jumpy = y
                jumpx = x - 2
            when "up"
                jumpy = y
                jumpx = x + 2
            end
            
            jumpin = true
            
            while x != jumpx || y != jumpy
                move
                keep_spiral
            end
            
        end
        
    while printmode == true
        move
        keep_spiral
        if arr[y][x] != '#'
            print arr[y][x]
        end
        if arr[y][x] == '#'
            printmode = false
            break
        end
    end
    if jumpin == false
        move
        keep_spiral
    end
    is_in
end 
 
