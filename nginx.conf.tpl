worker_processes  2;
worker_rlimit_nofile 8192;

events {
  worker_connections  1024;  ## Default: 1024
}

http {

  default_type application/octet-stream;
  log_format   main '$remote_addr - $remote_user [$time_local]  $status '
    '"$request" $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for"';
  sendfile     on;
  tcp_nopush   on;
  server_names_hash_bucket_size 128;

  {{range services}}
  upstream {{.Name}}{{range service .Name}} {
    server {{.Address}}:{{.Port}}{{end}} max_fails=3 fail_timeout=10s;
  }
  {{end}}

  server {
    listen 80 default_server;

    location / {
        return 200;
    }

    {{range services}}
    location /{{.Name }}/ {
        proxy_pass http://{{.Name }}/;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
    }
    {{end}}

    location /status {
      return 200;
    }

  }
}