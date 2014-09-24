#!/usr/bin/env python
# http://www.rabbitmq.com/tutorials/tutorial-two-python.html
# and https://github.com/rabbitinaction/sourcecode/blob/master/python/chapter-5/hello_world_mirrored_queue_consumer.py
import pika
import argparse

argp = argparse.ArgumentParser()
argp.add_argument('-s', '--server', metavar='server',
                  help='Address of rabbitmq server.',
                  default='localhost')
args = argp.parse_args()

connection = pika.BlockingConnection(pika.ConnectionParameters(host=args.server))
channel = connection.channel()
channel.exchange_declare(exchange="hello-exchange", #/(hwcmq.3) Declare the exchange
                         type="direct",
                         passive=False,
                         durable=True,
                         auto_delete=False)

queue_args = {"x-ha-policy" : "all" } #/(hwcmq.4) Set queue mirroring policy

channel.queue_declare(queue="hello-mirror", arguments=queue_args) #/(hwcmq.5) Declare the queue
channel.queue_bind(queue="hello-mirror",     
                   exchange="hello-exchange",
                   routing_key="hola")


channel.basic_publish(exchange='hello-exchange',
                      routing_key='hola',
                      body='Hello Mirror World!')
print " [x] Sent 'Hello Mirror World!'"
connection.close()
