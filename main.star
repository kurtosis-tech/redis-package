REDIS_IMAGE = "redis:alpine"

REDIS_CLIENT_PORT_ID = "client"
REDIS_CLIENT_PORT_NUMBER = 6379
REDIS_CLIENT_PORT_PROTOCOL = "TCP"

REDIS_SERVICE_NAME = "redis"

def run(plan, args):

    redis_service_config= ServiceConfig(
        image = REDIS_IMAGE,
        ports = {
            REDIS_CLIENT_PORT_ID: PortSpec(number = REDIS_CLIENT_PORT_NUMBER, transport_protocol = REDIS_CLIENT_PORT_PROTOCOL)
        }
    )

    redis = plan.add_service(service_name = REDIS_SERVICE_NAME, config = redis_service_config)

    return {"service-name": REDIS_SERVICE_NAME, "hostname": redis.hostname}
    
