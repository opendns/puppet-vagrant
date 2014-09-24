#!/bin/bash -x

R="sudo /usr/sbin/rabbitmqctl"

$R stop_app
sleep 1
# $R reset
$R join_cluster rabbit@rabbit
sleep 1
$R start_app
sleep 1
