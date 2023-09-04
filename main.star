REDIS_CLIENT_PORT_ID = "client"
REDIS_CLIENT_PORT_NUMBER = 6379
REDIS_CLIENT_PORT_PROTOCOL = "TCP"

def run(
    plan,

    # The name to give the created Redis service
    service_name = "redis", # type:string

    # The container image that the Redis service will be started with
    image = "redis:alpine", # type:string
):
    redis_service_config= ServiceConfig(
        image = image,
        ports = {
            REDIS_CLIENT_PORT_ID: PortSpec(number = REDIS_CLIENT_PORT_NUMBER, transport_protocol = REDIS_CLIENT_PORT_PROTOCOL)
        }
    )

    redis = plan.add_service(name = service_name, config = redis_service_config)

    return {"service-name": REDIS_SERVICE_NAME, "hostname": redis.hostname, "client-port": REDIS_CLIENT_PORT_NUMBER}
