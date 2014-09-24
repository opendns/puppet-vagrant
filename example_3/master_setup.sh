#!/bin/bash -x

R="sudo /usr/sbin/rabbitmqctl"

$R stop_app
$R reset
$R join_cluster rabbit@coney
$R start_app
$R set_policy ha-all "" '{"ha-mode":"all","ha-sync-mode":"automatic"}'

    

