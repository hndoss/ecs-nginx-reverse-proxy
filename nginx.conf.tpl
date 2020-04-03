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
    {{.Address}}:{{.Port}}{{end}}
  }
  {{end}}

  server {
    listen 80 default_server;

    location / {
        if ($request_method !~ ^(GET|POST|HEAD|OPTIONS|PUT|DELETE)$) {
            return 405;
        }
        proxy_pass $arg_url;
    }
  }
}