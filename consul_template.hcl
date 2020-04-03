consul {
  address = "localhost:8500"
  retry {
    enabled  = true
    attempts = 12
    backoff  = "250ms"
  }
}
template {
  source      = "/etc/nginx/nginx.conf.tpl"
  destination = "/etc/nginx/nginx.conf"
  command     = "nginx -s reload"
}
