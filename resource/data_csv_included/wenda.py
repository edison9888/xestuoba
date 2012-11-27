# lizk
# coding=utf-8

import shutil
import os
import os.path


def visit(args, directoryName, filesInDirectory):
    for filename in filesInDirectory:
        #print filename
        shutil.move(directoryName+"/"+filename, directoryName+"/"+"问答："+filename)


def main():
    print os.getcwd()
    os.path.walk(".", visit, 0) 


if __name__ == "__main__":
    main()
