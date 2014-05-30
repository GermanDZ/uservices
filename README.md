uservices
=========

Micro Services demoing Combi micro bus

# AMQP Server

Launch a rabbitmq server with:

  docker run -d --name amqp_server -p 12345:5672 -e RABBITMQ_PASS="mypass" tutum/rabbitmq:latest

# Launch the microservice

  docker run -ti --rm -e AMQP_HOST=172.17.42.1 -e AMQP_PORT=12345 germandz/uservices magic_strings
