server {
	listen   80;
	root /var/www/spicyfox.com;
	index portal.php;
	server_name www.spicyfox.com;

	location / {
	try_files $uri $uri/ /portal.php;
	}

	error_page 404 /404.html;

  	location ~ \.php$ {
        proxy_set_header X-Real-IP  $remote_addr;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $host;
        proxy_pass http://127.0.0.1:8070;
        }


	location ~ /\.ht {
		deny all;
	}
}

server {
	listen   80;
	root /var/lib/tomcat6/webapps/war;
	server_name house.spicyfox.com;

	location / {
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	proxy_pass http://127.0.0.1:8080;
	}

}
