variable "server_name" {
  description = "Server names"
  #type        = list(string)
  default     = [
    {
       name = "control-node"
    },
    {  
       name = "client1"
    },
    { 
       name = "client2"
    },
  ]
}

variable "control_node_userdata" {
  description = "userdata for control-node"
  type        = string
  default     = "userdata.tpl"
  #default     = ["file('userdata.tpl')", "file('userdata1.tpl')", "file('userdata2.tpl')"]
}