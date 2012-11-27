# lizk
# coding=utf-8

import shutil
import os
import os.path


def visit(args, directoryName, filesInDirectory):
    for filename in filesInDirectory:
        path = "%s/%s" % (directoryName, filename)
        if os.path.isdir(path) == True:
            continue
        if filename.startswith(".") == True \
                or filename.endswith(".py") == True \
                or filename.endswith(".csv") == True: 
            continue
        
        #print path
        f = open(path)
        text = f.read()
        #print text
        f.close()
        
        start = text.find("<style")
        end = text.find("</style>")
        if start == -1 or end == -1:
            start = text.find("</head>")
            end = start
        if start == -1 or end == -1:
            continue
        
        prefix = text[:start]
        suffix = text[end+len("</style>"):]
        link = '<link rel="stylesheet" type="text/css" href="style.css" />'
        
        text = prefix + link + suffix
        f = open(path, "w")
        f.write(text)
        f.close()
        
        if os.path.exists("../abc") == False:
            os.mkdir("../abc")
        np = "../abc/%s" % (filename, )
        shutil.copy(path, np)


def main():
    print "Current Director:%s" % (os.getcwd(), )
    os.path.walk(".", visit, 0) 


if __name__ == "__main__":
    main()
