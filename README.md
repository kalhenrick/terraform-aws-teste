# Terraform Test AWS

## Passo para execução 

- Configurar o ambiente usando o "aws configure" com as credenciais de acesso (KEY e SECRET) ao ambiente, com permissão para permissão para criar os recursos;
- Executar:
```sh
terraform plan
terraform apply
```
- Será gerado um output com o ip publico da ec2 com nginx instalado e o nome do bucket de logs;
- Caso deseje acessar a ec2, conectar através do Session Manager;
- Os log são são enviado para um bucket no s3, atráves do logrotate diariamente. Caso queira força o envio, acessar a ec2 e executar **logrotate -f /etc/logrotate.d/nginx**.
- Após a criação da ec2, algumas chamadas são feitas ao nginx para gerar log no access.log e enviadas para o bucket.
- Após a execução do terraform, com o output do ip, ainda é necessario espera até 5 minutos para que a instalação seja concluida, para poder acessar o ip e os log no bucket.

## Recuros Criados
- **VPC**
- **SUBNET**
- **ACL**
- **SECURITY GROUP**
- **INTERNET GATEWAY**
- **S3**
- **EC2**
- **IAM ROLE**
- **ELASTIC IP**
- **NETWORK INTERFACE**
- **ROUTE TABLE**
