# install-nginx-server
Install nginx server faster

###1. Launch ./install-server.sh
```
./install-server.sh
```

when it stop follow instructions

###2. launch ./finish-install.sh

```
./finish-install.sh
```


###3. Change the port 80 to Port 81 and save

#####modify default config and set port on 81

```
nano /etc/nginx/sites-available/default
```

###4. create new config as site.conf and paste this content

```
nano /etc/nginx/sites-available/site.conf
```

paste the next content 


```
server {
    listen 80;
    #Your server name
    server_name www.yoursite.extension;
    #The entry point of your application, where nginx will redirect all incoming requests
    root /[project_directory];
    
    location / {
            # try to serve file directly, fallback to index.php
            try_files $uri /index.php$is_args$args;
    }
    
    #Symfony
    # optionally disable falling back to PHP script for the asset directories;
    # nginx will return a 404 error when files are not found instead of passing the
    # request to Symfony (improves performance but Symfony's 404 page is not #displayed)
    # location /bundles {
    #     try_files $uri =404;
    # }

    #FOR SYMFONY FAST CGI
    location ~ ^/index\.php(/|$) {
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;
        fastcgi_read_timeout 600;


        # optionally set the value of the environment variables used in the application
        # fastcgi_param APP_ENV prod;
        # fastcgi_param APP_SECRET <app-secret-id>;
        # fastcgi_param DATABASE_URL "mysql://db_user:db_pass@host:3306/db_name";

        # When you are using symlinks to link the document root to the
        # current version of your application, you should pass the real
        # application path instead of the path to the symlink to PHP
        # FPM.
        # Otherwise, PHP's OPcache may not properly detect changes to
        # your PHP files (see
        #https://github.com/zendtech/ZendOptimizerPlus/issues/126
        # for more information).
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;
        # Prevents URIs that include the front controller. This will 404:
        # http://domain.tld/index.php/some-path
        # Remove the internal directive to allow URIs like this
        internal;
    }

    # return 404 for all other php files not matching the front controller
    # this prevents access to other php files you don't want to be accessible.
    
    location ~ \.php$ {
        return 404;
    }

    #Configure end point for errors logs
    
    error_log /var/log/nginx/site_error.log;
    access_log /var/log/nginx/site_access.log;

    #need nginx-extras to work IMPORTANT : put it on /etc/nginx/nginx.conf[http]
    #add_header X-Frame-Options "SAMEORIGIN";
    #client_max_body_size 10M;
    #server_tokens off;
    #more_set_headers 'Server: Copany-Server';
}
```

#####Nginx Config for Laravel project

```
server { 
    listen 80; 
    listen [::]:80 
    ipv6only=on;#you can remove this
     
    # Webroot Directory for Laravel project
    root /[laravel_project]/public; 
    index index.php index.html index.htm; 
    
    # Your Domain Name 
    server_name laravel.site.co; 
    
    location / { 
        try_files $uri $uri/ /index.php?$query_string; 
    }  
    
    # PHP-FPM Configuration Nginx 
    location ~ \.php$ { 
        try_files $uri =404; 
        fastcgi_split_path_info ^(.+\.php)(/.+)$; 
        fastcgi_pass unix:/var/run/php/php7.3-fpm.sock; 
        fastcgi_index index.php; 
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name; include fastcgi_params; 
    } 
    
    #Log files for Debugging 
    access_log /var/log/nginx/laravel-access.log; 
    error_log /var/log/nginx/laravel-error.log;
}

```

#####enable this new config

```
ln -s /etc/nginx/sites-available/emsit.conf /etc/nginx/sites-enabled/
```

#####Add these to prevent header buffer overflow _(to /etc/nginx/nginx.conf)_
```
fastcgi_buffers 16 16k;
fastcgi_buffer_size 32k;
proxy_buffer_size   128k;
proxy_buffers   4 256k;
proxy_busy_buffers_size   256k;
add_header X-Frame-Options "SAMEORIGIN";
client_max_body_size 10M;
server_tokens off;
more_set_headers 'Server: Copany-Server';
```
#####Test configs and reload nginx
```
sudo service nginx reload
```
#####Change the permissions of project & give the owns to www-data user (http user)
```
chown -R www-data:root /[repertoire_du_projet] 
```
Change access on entry point of your application
```
chmod 755 /[project_directory]/[entry_point]
```
don't forget to create project database, update schema and migrate
