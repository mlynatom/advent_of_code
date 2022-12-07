import sys
import re

class Directory:
    def __init__(self, name, parent_dir) -> None:
        self.name = name
        self.subdirectories = []
        self.files = []
        self.parent_directory = parent_dir
        self.size = 0

    def __str__(self) -> str:
        dirs = " "
        for dir in self.subdirectories:
            dirs+= dir.name
            dirs += " "
        files_str = ""
        for file in self.files:
            files_str += file.name
            files_str += " "
        return f"name: {self.name}, dirs: {dirs}, files: {files_str}, size: {self.size}"

class File:
    def __init__(self, size, name) -> None:
        self.size = size
        self.name = name


def process_file(filepath:str):
    #instructions = []
    root_dir = Directory("/", None)
    current_dir = root_dir
    with open(filepath, "r") as file:
        found_ls = False
        for line in file:
            
            if line[0:4]  == "$ cd":
                found_ls = False
                command_dir = line[5:-1]
                if command_dir == "/":
                    current_dir = root_dir
                elif command_dir == "..":
                    current_dir = current_dir.parent_directory
                else:
                    for dir in current_dir.subdirectories:
                        if dir.name == command_dir:
                            current_dir = dir
                            break
            elif line[0:4] == "$ ls":
                found_ls = True
            elif line[0:3] == "dir":
                name_dir = line[4:-1]
                current_dir.subdirectories.append(Directory(name_dir, current_dir))
            else:
                splitted = line.split(" ")
                size = int(splitted[0])
                name = re.sub("\n", "", splitted[1])
                current_dir.files.append(File(size, name))
    return root_dir

def print_structure(root_dir:Directory):
    print(root_dir)
    if len(root_dir.subdirectories) != 0:
        for dir in root_dir.subdirectories:
            print_structure(dir)

def compute_sizes(root_dir:Directory):
    for dir in root_dir.subdirectories:
        root_dir.size += compute_sizes(dir)
    for file in root_dir.files:
        root_dir.size += file.size

    return root_dir.size

def find_smallest_enough(root_dir:Directory, needed_space:int):
    current_best = float('inf')
    if root_dir.size >= needed_space and root_dir.size < current_best:
        current_best = root_dir.size

    for dir in root_dir.subdirectories:
        tmp_val = find_smallest_enough(dir, needed_space=needed_space)
        if tmp_val < current_best:
            current_best = tmp_val

    return current_best


def sum_dirs(root_dir:Directory, max_val:int = 100000):
    ret_val = 0
    if root_dir.size <= max_val:
        ret_val += root_dir.size
    
    for dir in root_dir.subdirectories:
        ret_val += sum_dirs(dir, max_val)

    return ret_val

if __name__ == "__main__":
    root_dir = process_file(sys.argv[1])
    #print_structure(root_dir)
    compute_sizes(root_dir)
    #print_structure(root_dir)

    my_sum = sum_dirs(root_dir, 100000)
    print(my_sum)

    total_size = root_dir.size
    TOTAL_DISK_SIZE = 70000000
    UPDATE_NEED = 30000000
    required_space = UPDATE_NEED - (TOTAL_DISK_SIZE - total_size)

    best = find_smallest_enough(root_dir, required_space)
    print(required_space)
    print(best)
    
    
    