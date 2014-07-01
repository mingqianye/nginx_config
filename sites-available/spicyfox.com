server {
	listen   80;
	root /var/www/spicyfox.com;
	index index.php;
	server_name spicyfox.com;

	error_page 404 /404.html;

  	location / {
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
	root /var/lib/tomcat6/webapps/house.spicyfox.com;
	server_name www.lahuhouse.com lahuhouse.com;

	location / {
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	proxy_pass http://127.0.0.1:8080;
	}
}
