FROM nginx:alpine

COPY consul_template.hcl /etc/nginx/consul_template.hcl

COPY nginx.conf.tpl /etc/nginx/nginx.conf.tpl

COPY entrypoint.sh /bin/entrypoint.sh

RUN wget https://releases.hashicorp.com/consul-template/0.20.0/consul-template_0.20.0_linux_amd64.zip && \
        unzip consul-template_0.20.0_linux_amd64.zip -d /bin && \
        chmod +x /bin/entrypoint.sh

ENTRYPOINT ["/bin/entrypoint.sh"]

CMD ["-config=/etc/nginx/consul_template.hcl"]