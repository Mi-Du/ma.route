
download stm data from : http://www.stm.info/sites/default/files/gtfs/gtfs_stm.zip
extract stm data to a fold
put all *.bat, *.ctl files to the same fold
run load-stm.bat, which will prompt a oracle user/password for each line/table.
after finish, check if there are *.bad files in the folder, which means some error happened when load a text file.
