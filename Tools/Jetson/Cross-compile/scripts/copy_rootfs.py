import os
import shutil
 
path ='/home/jason/Documents/rootfs'

def remove_softlink(dir_path):
    for home, dirs, files in os.walk(dir_path):
        for filename in files:
            file_path = os.path.join(home, filename)
            if os.path.islink(file_path):
                realpath = os.path.join(os.path.dirname(file_path), os.readlink(file_path))
                if not dir_path in realpath:
                    realpath = dir_path + realpath
                print(file_path, "<--", realpath)
                os.unlink(file_path)
                try:
                    shutil.copyfile(realpath, file_path)
                except Exception as err:
                    print(err)

 
if __name__ =="__main__":
    remove_softlink(path)