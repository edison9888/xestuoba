# lizk
# coding=utf-8


import stat
import os
import os.path


def fileLine(filename):
    creatTime = os.stat(filename)[stat.ST_MTIME]
    line = "%s|data/%s|0|0|%s|%s|25\n" % (filename, filename, creatTime, creatTime)
    return (creatTime, line)


def ls_cmp(s1, s2):
    return cmp(s1[0], s2[0])


def visit(args, directoryName, filesInDirectory):
    ls = args
    for filename in filesInDirectory:
        # ignore hidden files & python/csv files
        if filename.startswith(".") == True \
                or filename.endswith(".py") == True \
                or filename.endswith("all-wcprops") == True \
                or filename.endswith("entries") == True \
                or filename.endswith("prop-base") == True \
                or filename.endswith("props") == True \
                or filename.endswith("text-base") == True \
                or filename.endswith("tmp") == True \
                or filename.endswith(".svn-base") == True \
                or filename.endswith(".csv") == True: 
                    
            continue
            
        s = fileLine(filename)
        ls.append(s)


def main():
    print os.getcwd()
    ls = []
    os.path.walk(".", visit, ls)
    ls.sort(ls_cmp)
    f = open("sex.csv", "w")
    for s in ls:
        f.write(s[1])
    f.close()


if __name__ == "__main__":
    main()
