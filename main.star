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
    """
    This will return a struct that contains the following properties:
    - service_name: the name of the service that was created
    - hostname: a future reference (https://docs.kurtosis.com/concepts-reference/future-references) to the hostname of the created Redis service
    - port_number: the port number of the client port
    """
    redis_service_config= ServiceConfig(
        image = image,
        ports = {
            REDIS_CLIENT_PORT_ID: PortSpec(number = REDIS_CLIENT_PORT_NUMBER, transport_protocol = REDIS_CLIENT_PORT_PROTOCOL)
        }
    )

    redis = plan.add_service(name = service_name, config = redis_service_config)

    return struct(
        service_name = service_name,
        hostname = redis.hostname,
        port_number = REDIS_CLIENT_PORT_NUMBER,
    )
