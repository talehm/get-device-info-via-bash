#! /usr/bin/expect
#file rename -force  test host.txt
#set f [open "host.txt"]
#set array [split [read $f] "\t"]
set filename "host.txt" 
set result {}
set f [open $filename r] # Get device info from host.txt 
foreach line [split [read $f] \n] {
	lappend result [lindex $line 0] [lindex $line 1]
	array set results $result # get ip address of device
	
}
foreach {key value} [array get results] {
	incr x
	if { $x > 1 } {
		spawn sshpass -p admin ssh admin@$value # login to device via ssh / You need to install sshpass feature.
		expect ">"
		send "enable\r\n"
		log_file -a -noappend logs/$key.info.log ; # specify log file 
		set infos [open logs/$key.info.log "w"]
		puts $infos "System Information\n"
		close $infos
		expect "#"
		send "sh system-info\r\n" # Get device information
		expect "#"
		send "sh int status\r\n" # Get status of interfaces of device 
		send "end\r\n"
		send "exit\r\n"
		send "exit\r\n"
		expect eof
		log_file; # Write outputs to log gile
	}
}
