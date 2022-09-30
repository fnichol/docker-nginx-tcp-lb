#!/bin/sh
# shellcheck disable=3043

set -eu

ME="$(basename "$0")"

entrypoint_log() {
  if [ -z "${NGINX_ENTRYPOINT_QUIET_LOGS:-}" ]; then
    echo "$@"
  fi
}

generate_templates() {
  local name value
  local srv_port upstream_hosts upstream_host upstreams upstream_port dst

  env | grep ^NGINX_TCP_ | sort | while read -r entry; do
    name="$(
      echo "$entry" \
        | cut -d= -f 1 \
        | sed 's/^NGINX_TCP_//' \
        | tr '[:upper:]' '[:lower:]'
    )"
    value="$(echo "$entry" | cut -d= -f 2-)"

    if [ "$(echo "$value" | awk -F: '{print NF}')" -ne 3 ]; then
      echo "$ME xxx Value for '$entry' must be of the form:" >&2
      echo "$ME xxx   <SRV_PORT>:<UPSTREAM_HOST>[,<UPSTREAM_HOST>..]:<UPSTREAM_PORT>" >&2
      exit 1
    fi

    srv_port="$(echo "$value" | cut -d: -f 1)"
    upstream_hosts="$(echo "$value" | cut -d: -f 2)"
    upstream_port="$(echo "$value" | cut -d: -f 3)"
    upstreams="$(
      echo "$upstream_hosts" | tr ',' '\n' | while read -r upstream_host; do
        echo "server ${upstream_host}:${upstream_port};"
      done | sed 's/^/    /'
    )"

    dst="/etc/nginx/templates/$name.conf.template"

    entrypoint_log "$ME --- creating $name.conf.template for: $value"
    echo "$upstreams"
    mkdir -p "$(dirname "$dst")"
    cat <<-EOF >"$dst"
	upstream ${name}_upstream {
	${upstreams}
	}

	server {
	    listen     ${srv_port};
	    proxy_pass ${name}_upstream;
	}
	EOF
  done
}

generate_templates

exit 0
