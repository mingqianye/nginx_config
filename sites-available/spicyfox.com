server {
	listen   80;
	root /var/www/spicyfox.com;
	index portal.php;
	server_name spicyfox.com;

	location / {
	try_files $uri $uri/ /portal.php;
	}

	location /doc/ {
		alias /usr/share/doc/;
		autoindex on;
		allow 127.0.0.1;
		deny all;
	}


	#error_page 404 /404.html;

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
