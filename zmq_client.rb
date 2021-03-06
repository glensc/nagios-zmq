require 'rubygems'
require 'zmq'
require 'json'
require 'pp'
Thread.abort_on_exception = true

zmq = ZMQ::Context.new
subscriber = zmq.socket(ZMQ::SUB)
subscriber.connect("tcp://*:6666")
subscriber.setsockopt(ZMQ::SUBSCRIBE,"")

def handle_servicecheck(payload)
  puts "Received service check:"
  pp payload
end

def handle_hostcheck(payload)
  puts "Received host check:"
  pp payload
end

def handle_notification(payload)
  puts "Received notification:"
  pp payload
end

while true
  raw= subscriber.recv
  info=JSON.parse(raw)
  context=info["context"]
  payload=info["payload"]
  case context
  when "SERVICECHECK"
    handle_servicecheck(payload)
  when "HOSTCHECK"
    handle_hostcheck(payload)
  when "NOTIFICATION"
    handle_notification(payload)
  else
    puts "Unknown context #{context}"
  end
end

exit 0
