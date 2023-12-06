REDIS_CLIENT_PORT_ID = "client"
REDIS_CLIENT_PORT_NUMBER = 6379
REDIS_CLIENT_PORT_PROTOCOL = "TCP"

REDIS_MIN_CPU = 10
REDIS_MAX_CPU = 1000
REDIS_MIN_MEMORY = 32
REDIS_MAX_MEMORY = 1024

def run(
    plan,

    # The name to give the created Redis service
    service_name = "redis", # type:string

    # The container image that the Redis service will be started with
    image = "redis:alpine", # type:string

    min_cpu = REDIS_MIN_CPU, # type:int
    max_cpu = REDIS_MAX_CPU, # type:int
    min_memory = REDIS_MIN_MEMORY, # type:int
    max_memory = REDIS_MAX_MEMORY, # type:int
):
    """
    This will return a struct that contains the following properties:
    - service_name: the name of the service that was created
    - hostname: a future reference (https://docs.kurtosis.com/concepts-reference/future-references) to the hostname of the created Redis service
    - port_number: the port number of the client port
    - min_cpu (int): Define how much CPU millicores the service should be assigned at least.
    - max_cpu (int): Define how much CPU millicores the service should be assign max.
    - min_memory (int): Define how much MB of memory the service should be assigned at least.
    - max_memory (int): Define how much MB of memory the service should be assigned max.
    """
    redis_service_config= ServiceConfig(
        image = image,
        ports = {
            REDIS_CLIENT_PORT_ID: PortSpec(number = REDIS_CLIENT_PORT_NUMBER, transport_protocol = REDIS_CLIENT_PORT_PROTOCOL)
        }
        min_cpu=min_cpu,
        max_cpu=max_cpu,
        min_memory=min_memory,
        max_memory=max_memory,
    )

    redis = plan.add_service(name = service_name, config = redis_service_config)

    return struct(
        service_name = service_name,
        hostname = redis.hostname,
        port_number = REDIS_CLIENT_PORT_NUMBER,
        min_cpu=min_cpu,
        max_cpu=max_cpu,
        min_memory=min_memory,
        max_memory=max_memory,
    )
