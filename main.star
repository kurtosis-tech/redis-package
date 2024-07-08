REDIS_CLIENT_PORT_ID = "client"
REDIS_CLIENT_PORT_NUMBER = 6379
REDIS_CLIENT_PORT_PROTOCOL = "TCP"

APPLICATION_PROTOCOL = "redis"
DATA_DIRECTORY_PATH = "/data/"

REDIS_MIN_CPU = 10
REDIS_MAX_CPU = 1000
REDIS_MIN_MEMORY = 32
REDIS_MAX_MEMORY = 1024


def run(
    plan,
    # The name to give the created Redis service
    service_name="redis",  # type:string
    # The container image that the Redis service will be started with
    image="redis:alpine",  # type:string
    port_number=REDIS_CLIENT_PORT_NUMBER,  # type:int
    persistent=True,  # type:bool
    min_cpu=REDIS_MIN_CPU,  # type:int
    max_cpu=REDIS_MAX_CPU,  # type:int
    min_memory=REDIS_MIN_MEMORY,  # type:int
    max_memory=REDIS_MAX_MEMORY,  # type:int
    node_selectors=None,  # type:dict
):
    """
    This will return a struct that contains the following properties:
    - service_name: the name of the service that was created
    - hostname: a future reference (https://docs.kurtosis.com/concepts-reference/future-references) to the hostname of the created Redis service
    - port_number: the port number of the client port\
    - persistent(bool): Whether the data should be persisted. Defaults to True; Note that this isn't supported on multi node k8s cluster as of 2023-10-16
    - min_cpu (int): Define how much CPU millicores the service should be assigned at least.
    - max_cpu (int): Define how much CPU millicores the service should be assign max.
    - min_memory (int): Define how much MB of memory the service should be assigned at least.
    - max_memory (int): Define how much MB of memory the service should be assigned max.
    - node_selectors (dict[string, string]): Define a dict of node selectors - only works in kubernetes example: {"kubernetes.io/hostname": node-name-01}
    """
    if persistent:
        files[DATA_DIRECTORY_PATH] = Directory(
            persistent_key="data-{0}".format(service_name),
        )
        env_vars["REDISDATA"] = DATA_DIRECTORY_PATH + "/redis-data"
    if node_selectors == None:
        node_selectors = {}

    redis_service_config = ServiceConfig(
        image=image,
        ports={
            REDIS_CLIENT_PORT_ID: PortSpec(
                number=REDIS_CLIENT_PORT_NUMBER,
                transport_protocol=REDIS_CLIENT_PORT_PROTOCOL,
                application_protocol=APPLICATION_PROTOCOL,
            )
        },
        min_cpu=min_cpu,
        max_cpu=max_cpu,
        min_memory=min_memory,
        max_memory=max_memory,
        node_selectors=node_selectors,
    )

    redis = plan.add_service(name=service_name, config=redis_service_config)

    url = "{protocol}}://{hostname}:{port}".format(
        protocol=APPLICATION_PROTOCOL, hostname=redis.hostname, port=port_number
    )

    return struct(
        url=url,
        service_name=service_name,
        hostname=redis.hostname,
        port_number=port_number,
        min_cpu=min_cpu,
        max_cpu=max_cpu,
        min_memory=min_memory,
        max_memory=max_memory,
        node_selectors=node_selectors,
    )
