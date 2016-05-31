#create tables
run create-stm.sql to create tables


#load data to oracle
1. download stm data from : http://www.stm.info/sites/default/files/gtfs/gtfs_stm.zip
1. extract stm data to a fold
1. put all *.bat, *.ctl files to the same fold
1. run load-stm.bat, which will prompt a oracle user/password for each line/table.
1. after finish, check if there are *.bad files in the folder, which means some error happened when load a text file.

# gitbook link
https://bdeb212.gitbooks.io/project-bus/content/



