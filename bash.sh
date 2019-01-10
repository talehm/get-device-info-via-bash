#! /bin/bash
exec > Version.html ;
echo '<html>
<head>
  <title>Bootstrap Example</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="styles.css">
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
</head>
<body>
<div class="container">
<h1 class="header"> Tp-link T2600G-28TS Swicth Information of Teleport LLC</h1>
<div class="list-group col-sm-12">'

while IFS="\t" read -r p || [ -n "$p" ]
do
	IFS='	' read -r -a array <<< "$p"	
	APname=${array[0]}
	ip_address=${array[1]}


	sed -i "/#/d" logs/"$APname.info.log"
	name=$(sed -nr '/Name/ s/.*Name([^"]+).*/\1/p' logs/"$APname.info.log")
	version=$(sed -nr '/Hardware Version/ s/.*Hardware Version([^"]+).*/\1/p' logs/"$APname.info.log")
	number_of_ports=$(grep -r "LinkUp" logs/"$APname.info.log" | wc -l)
	if [[ $version == *"2.0"* ]]; then
	  	class="info"
	      else 
		class="danger"
	fi

   echo  '<a href="http://192.168.24.25" class="list-group-item list-group-item-success col-sm-4"><span class="hostname">'$name'</span></a>
    <a href="#" class="list-group-item list-group-item-'$class' col-sm-4">SW Version <b>'$version'</b></a>
    <a href="#" class="list-group-item list-group-item-warning">Port Count -<b>' $number_of_ports'</b></a>
    <a href="#" class="list-group-item list-group-item-danger">Fourth item</a>'

done < host.txt
echo '
</div></body>
</html> '
