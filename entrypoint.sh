set -e

cmd="$1"

if [[ "$cmd" != 'server' && "$cmd" != 'api' && "$cmd" != 'client' && "$cmd" != 'uchiwa' ]]; then
  echo "Usage: $0 <server|api|client|uchiwa>" >&2
  exit 1
fi

case "$cmd" in
  server|api|client)
    export RABBITMQ_URL="amqp://${RABBITMQ_DEFAULT_USER}:${RABBITMQ_DEFAULT_PASS}@rabbitmq:5672/%2f${RABBITMQ_DEFAULT_VHOST#'/'}"
    export REDIS_URL="redis://redis:${REDIS_SERVICE_PORT}/0"
    exec "/opt/sensu/bin/sensu-$cmd" -d /etc/sensu/conf.d -e /etc/sensu/extensions
    ;;
  uchiwa)
    sed -i "s|POD_NAMESPACE|${POD_NAMESPACE}|g" /etc/sensu/uchiwa.json
    exec "/opt/uchiwa/bin/$cmd" -c /etc/sensu/uchiwa.json -p /opt/uchiwa/src/public
    ;;
esac
