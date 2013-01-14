# lizk
# coding=utf-8


import stat
import os
import os.path
import string

g_init_dir=''

def copyfile(srcFileName, destFileName):
    
    open(destFileName, "wb").write(open(srcFileName, "rb").read())


def fileLine(filename, directoryName):
    filepath = directoryName + "/" + filename
    print directoryName
    print filepath
    if os.path.isdir(filepath):
        return None
    creatTime = os.stat(filepath)[stat.ST_MTIME]
    
    title = filename[3:]
    indexOfLastSlash = directoryName.rfind('/')
    category = directoryName[indexOfLastSlash+1:indexOfLastSlash+4]
    refCategoryID = int(category);
#    refCategoryIDStr = directoryName[0:3] 
#    print "%s" % (directoryName)       
#if refCategoryIDStr.isdigit() == False:
#       refCategoryID = string.atoi(refCategoryIDStr);
        
    line = "%s|data/%s|0|0|%s|%s|%d\n" % (title, filename, creatTime, creatTime, refCategoryID)
    return (creatTime, line)


def ls_cmp(s1, s2):
    return cmp(s1[0], s2[0])


def visit(args, directoryName, filesInDirectory):
    if directoryName.endswith("data"):
        return
    ls = args
    for filename in filesInDirectory:
        # ignore hidden files & python/csv files
        if filename.startswith(".") == True \
                or filename.endswith(".py") == True \
                or filename.endswith(".css") == True \
                or filename.endswith(".sql") == True \
                or filename.endswith(".db") == True \
                or filename.endswith(".csv") == True: 
            continue
            
        s = fileLine(filename, directoryName)
        if s == None:
            continue
        ls.append(s)
        #copy files to directory where this py file resides.
        sourceFile = directoryName + "/" + filename
        targetFile = os.path.join(os.path.join(g_init_dir, "data"), filename)
        #open(targetFile, "wb").write(open(sourceFile, "rb").read())
        copyfile(sourceFile, targetFile)


def main():
    g_init_dir = os.getcwd()
    print "Working Directory: %s", (os.getcwd())
    
    arrangedDataDir = os.path.join(g_init_dir, "arranged_data")
    
    ls = []
    os.path.walk(arrangedDataDir, visit, ls)
    #ls.sort(ls_cmp)
    f = open("items.csv", "w")
    
    #copy style.css to data dir
    sourceFile = g_init_dir + "/style.css"
    targetFile = os.path.join(os.path.join(g_init_dir, "data"), "style.css")
    copyfile(sourceFile, targetFile)
        
    for s in ls:
        f.write(s[1])
    f.close()


if __name__ == "__main__":
    main()
