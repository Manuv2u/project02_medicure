provider "aws" {
 region = "ap-south-1"
}
resource "aws_instance" "k8s_server" {
 ami = "ami-02eb7a4783e7e9317"
 instance_type = "t2.medium"


 vpc_security_group_ids = ["sg-06324f2cbe37f2999"]
 key_name = "project"
   root_block_device {
      volume_size = 20
      volume_type = "gp2"
    }
   tags = {
        name = "k8s-server"
    }
 provisioner "remote-exec" {
 inline = [
 "sudo apt-get update -y",
 "sudo apt-get install docker.io -y",
 "sudo systemctl start docker",
 "sudo wget https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64",
 "sudo chmod +x /home/ubuntu/minikube-linux-amd64",
 "sudo cp minikube-linux-amd64 /usr/local/bin/minikube",
 "curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl",
 "sudo chmod +x /home/ubuntu/kubectl",
 "sudo cp kubectl /usr/local/bin/kubectl",
 "sudo groupadd docker",
 "sudo usermod -aG docker ubuntu",
 ]
 connection {
 type = "ssh"
 host = self.public_ip
 user = "ubuntu"
 private_key = file("./project.pem")
     }
   }
}
output "public_ip" {
  value = aws_instance.k8s_server.public_ip
}
