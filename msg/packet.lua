
packet = {}
packet.src = false
packet.dest = false
packet.protocol = false
packet.path = {}
packet.data = false

function send_packet(pkt, next_hop)
  rednet.send(next_hop, pkt, "msg")
end

function receive_packet(timeout)
  prev_hop, pkt = rednet.receive("msg", timeout)
  if pkt then
    local my_id = os.getComputerID()

    -- don't handle the packet if it has already been here
    if pkt.path[my_id] then
      return false
    end

    table.insert(pkt.path, my_id)
    return pkt
  end
end
