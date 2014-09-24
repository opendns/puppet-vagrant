#!/usr/bin/env python
# http://www.rabbitmq.com/tutorials/tutorial-two-python.html
import pika
import argparse


argp = argparse.ArgumentParser()
argp.add_argument('-s', '--server', metavar='server',
                  help='Address of rabbitmq server.',
                  default='localhost')
args = argp.parse_args()

connection = pika.BlockingConnection(pika.ConnectionParameters(args.server))
channel = connection.channel()
channel.queue_declare(queue='hello')
channel.basic_publish(exchange='',
                      routing_key='hello',
                      body='Hello World!')
print " [x] Sent 'Hello World!'"
connection.close()
