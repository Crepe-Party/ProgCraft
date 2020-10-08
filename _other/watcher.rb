#args [file_to_lauch, directory (defaulr is file_to_launch dir)]
unless ARGV[0]
    puts "error: file_to_launch argument missing"
    exit
end
script_path = ARGV[0]
unless File.file? script_path
    puts "error: invalid file (#{script_path})"
    exit
end
dir_path = File.dirname script_path
dir_path = ARGV[1] if ARGV[1]
unless File.directory? dir_path
    puts "error: invalid dir (#{dir_path})"
    exit
end

def get_dir_struct path
    child_struct = []
    children = Dir.children path
    children.each {|child|
        child_path = "#{path}/#{child}"
        child_val = nil
        if File.directory? child_path
            child_val = get_dir_struct child_path
        else
            child_val = child_path
        end
        child_struct.push child_val
    }

    child_struct
end
def get_sub_files arg, paths_to_ignore
    array = []
    struct = arg #arg is a struct
    struct = get_dir_struct arg if arg.class == String #arg is a path
    struct.each{ |child|
        if child.class == Array
            array += get_sub_files child, paths_to_ignore
            next
        end
        next if paths_to_ignore.reduce(false){|acc, val| acc || child.include?(val)} 
        array.push child
    }
    array
end

#.watchignore
paths_to_ignore = []
paths_to_ignore = File.readlines("#{dir_path}/.watchignore").map(&:chomp) if File.exists? "#{dir_path}/.watchignore"

#prepare watch lists
files_to_watch = get_sub_files dir_path, paths_to_ignore
watch_list = {}
files_to_watch.each{ |file_path|
    puts "watching #{file_path}"
    watch_list[file_path] = File.mtime file_path
}

current_pid = nil

loop do
    restart_app = false
    restart_app = true unless current_pid

    watch_list.keys.each{ |file_path|
        mtime = File.mtime file_path
        #compare time stamps
        if watch_list[file_path] != mtime
            restart_app = true
            puts "file updated: #{file_path}"
            watch_list[file_path] = mtime
        end
    }

    if restart_app
        #start and kill process instead
        if current_pid
            puts "stopping process: #{current_pid}"
            begin
                Process.kill "KILL", current_pid
            rescue => exception
                puts "process wasn't running"
            end
        end
        puts "starting process: #{script_path}";
        puts "______________"
        current_pid = Process.spawn "ruby #{script_path}"
        Process.detach current_pid
    end

    sleep 1 #watch rate
end