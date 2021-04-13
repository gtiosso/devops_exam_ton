# DevOps Exam Ton "By: Guilherme Tiosso"

## Motivação:								
Por aqui toda a nossa infra é gerenciada pelo terraform, nesse desafio queremos testar seu conhecimento com Infra-as-code.

## Objetivo:								
* Criar uma instância t2-micro na AWS utilizando algum plataforma de IAS (Cloudformation, Terraform, Ansible ou a que você se sentir mais confortável);
* Utilizar boas práticas de segurança para garantir que essa máquina não seja comprometida ou não esteja exposta a acessos indevidos;
* Criar alarmes para monitorar tanto as capacidades básicas da máquina (CPU, RAM) quanto o que você achar interessante;


## Extras:								
Na instância criada, expor a porta 443 com algum serviço de entrega HTTP de sua escolha sendo executado (Apache, Nginx)
Terraform é um plus (utilizando módulos)

## Entrega:

### Criado ambiente na AWS utilizando os seguintes recursos e ferramentas:

#### Ferramentas:
* **Terraform** - Utilizado para provisionar todo ambiente na AWS;
* **Ansible** - Utilizado para provisionar todas as configurações desejadas na Instância EC2, tais como: instalação e configuração do Apache;
* **Jenkins** - Utilizado para realizar o deploy de todo ambiente;
* **Shell Script** - Utilizado para realizar deploy de todo ambiente;

#### Serviços AWS:
* **S3** - Utilizado para armazenar estados do terraform;
* **VPC** - Utilizado para provisionar todo ambiente;
* **Subnet** - Utilizado para provisionar todas as configurações de Rede do ambiente, segregados por rede privada e pública (Em caso de ambientes produtivos, será aplicado boas práticas de Alta disponibilidade - Multi AZ);
* **Security Group** - Utilizado para prover controle de acesso ao ambiente, com regras de entrada e saída;
* **EC2** - Utilizado para provisionar instâncias no ambiente;
* **Cloudwatch** - Utilizado para provisionar monitoramento e alarmes para as instâncias EC2;


## Uso:

1. Clone este repositório em sua máquina:
```# git clone https://github.com/gtiosso/devops_exam_ton.git```

2. Ajuste as configurações do ambiente desejado:

* **```terraforms/configs/prod/```**: Path dos arquivos para configurações de ambiente de produção;
* **```terraforms/configs/lab/```**: Path dos arquivos para configurações de ambiente de testes;

2.1. Para ajustar as configurações de inicialização do terraform vá em: ```terraforms/configs/prod/prod-init.tfvars```:
```hcl
bucket  = "devops-exam-ton-tiosso-terraform-state"
profile = "prod"
region  = "us-east-1"
```

* **bucket** - Informe o nome do bucket desejado para backend do terraform, onde serã salvos os estados;
* **profile** - Informe o nome do profile referente a conta AWS onde está o bucket do backend do terraform. **OBS: Este profile deverá estar configurado no arquivo ```~/.aws/credentials```**;
* **region** - Informe o nome da region onde está o bucket do backend do terraform;

2.2. Para ajustar as configurações dos recursos que serão provisionados na AWS via terraform vá em: ```terraforms/configs/prod/prod-vars.tfvars```:
```hcl
# Provider Vars
region           = "us-east-1"
credentials_file = "~/.aws/credentials"
profile          = "prod"
context          = "devops-exam-ton-tiosso"
environment      = "prod"

# S3 Backend Vars
bucket_name = "devops-exam-ton-tiosso-terraform-state"

# VPC Vars
vpc = {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

sg = {
  name        = "sg_tiosso"
  description = "Security Group for Application X"
}

sg_ingress = [
  {
    from_port = "22",
    to_port   = "22",
    protocol  = "tcp",
    cidr_blocks = [
      "170.244.28.224/32", #PUT HERE THE DESIRED ORIGIN IP RANGES
    ]
  },
  {
    from_port = "443",
    to_port   = "443",
    protocol  = "tcp",
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
]

sg_egress = [
  {
    from_port = "0",
    to_port   = "0",
    protocol  = "-1",
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
]


# Cloudwatch Vars
metric_alarm = {
  name                = "cpu-monitoring"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80"
  description         = "This metric monitors ec2 cpu utilization"
}

# EC2 Vars
key_name = "aws-instance"
instance = {
  name                        = "devops-exam-ton-tiosso"
  type                        = "t2.micro"
  associate_public_ip_address = true
  private_ip                  = ""
  source_dest_check           = false
  root_volume_size            = "8"
  root_volume_type            = "standard"
}
```

Provider Vars
* **region** - Informe o nome da region desejada para criar todos os recursos AWS;
* **credentials_file** - Informe o arquivo onde estão as configurações do aws cli;
* **profile** - Informe o nome do profile referente a conta AWS onde serão criados todos os recursos via terraform. **OBS: Este profile deverá estar configurado no arquivo referenciado na opção  ```credentials_file```**;
* **context** - Informe o nome de contexto, este será base para nomenclatura de varios recursos que serão criados (VPC, Subnet, Internet Gateway, entre outros);          = "devops-exam-ton-tiosso"
* **environment** - Informe qual o ambiente que será provisionado (prod ou lab);

S3 Backend Vars
* **bucket_name** - Informe o nome do bucket que será criado para o backend do terraform (O mesmo informado nas configurações de inicialização do terraform);

VPC Vars
**IMPORTANTE: Valide se no campo abaixo está definido o IP de saída da máquina que irá rodar o Ansible, caso não, altere!**
```hcl
...
sg_ingress = [
  {
    from_port = "22",
    to_port   = "22",
    protocol  = "tcp",
    cidr_blocks = [
      "170.244.28.224/32", #PUT HERE THE DESIRED ORIGIN IP RANGES
    ]
  },
...
```
* **[Uso](terraforms/vpc/README.md)**;

Cloudwatch Vars
* **[Uso](terraforms/cloudwatch/README.md)**;

EC2 Vars
* **[Uso](terraforms/ec2/README.md)**;

## Deploy:
### Existem duas possibilidades de ambientes para realizar o deploy.
* **[Production](#Production)**;
* **[Lab](#Lab)**;

#### Production:
Este ambiente fará deploy de recursos baseados em **```Multi AZ```**, ou seja, utilizará 2 zonas de disponibilidade da AWS, criando toda a estrutura da VPC para que se distribua entre as mesmas;

#### Lab:
Este ambiente fará deploy de recursos baseados em apenas 1 zona de disponibilidade da AWS, criando toda a estrutura da VPC apenas nessa zona;

### Existem duas possibilidades de realizar o deploy:
* **[Shell](#Shell)**;
* **[Jenkins](#Jenkins)**;

#### Shell:

* **Script** - ```deploy.sh```
* **Uso**:
```hcl
Usage: ./deploy.sh --access_key 'ACCESS_KEY' --secret_key 'SECRET_KEY' --environment 'ENVIRONMENT' (-a|--apply|-d|--destroy) (-h|--help)
OPTIONS:
--access_key: AWS Access Key for authentication
--secret_key: AWS Secret Key for authentication
--environment: Desired environment (prod or lab)
-a|--apply: Apply terraform to create or update all resources on AWS
-d|--destroy: Destroy all resources on AWS
-h|--help: Show this guide
```
* **Apply Example** - ```./deploy.sh --access_key 'AKIA2LKDSOPAKDSAP567' --secret_key 'o92kKopdsadsaKOPKspokDksoapkDAS2bwMEedPL' --environment 'prod' -a```
* **Destroy Example** - ```./deploy.sh --access_key 'AKIA2LKDSOPAKDSAP567' --secret_key 'o92kKopdsadsaKOPKspokDksoapkDAS2bwMEedPL' --environment 'prod' -d```

#### Jenkins:

##### Requisítos Minimos:

* Jenkins instalado e rodando;
* Terraform instalado no Jenkins, com permissões de execução para o usuário do Jenkins;
* Ansible instalado no Jenkins, com permissões de execução para o usuário do Jenkins;
* Plugin de Multibranch Pipeline instalado no Jenkins;
* Acesso liberado do Jenkins ao Github e AWS;


##### Configuração:

**OBS: Leia os Passos 1 e 2, antes de executar**

1. Crie 2 Credenciais no Jenkins (```Manage Jenkins -> Manage Credentials -> Stores scoped to Jenkins -> Jenkins -> Global credentials (unrestricted) -> Add Credentials```), com as seguintes informações:
```hcl
Kind: Secret text
Scope: Global
Secret: [INFORME A AWS ACCESS KEY QUE SERÁ UTILIZADA PARA O DEPLOY]
ID: 'pipeline-aws-access-key'
Description: [INFORME UMA DESCRIÇÂO QUE AJUDE NO ENTENDIMENTO DO QUE SE TRATA TAL CREDENCIAL]
```
```hcl
Kind: Secret text
Scope: Global
Secret: [INFORME A AWS SECRET KEY QUE SERÁ UTILIZADA PARA O DEPLOY]
ID: 'pipeline-aws-secret-key'
Description: [INFORME UMA DESCRIÇÂO QUE AJUDE NO ENTENDIMENTO DO QUE SE TRATA TAL CREDENCIAL]
```

2. Caso o deploy de ambos ambientes seja realizado em contas diferentes, siga os passos abaixo:
2.1. Crie 4 Credenciais (2 para ambientes de Lab e 2 para ambientes de Prod) no Jenkins (```Manage Jenkins -> Manage Credentials -> Stores scoped to Jenkins -> Jenkins -> Global credentials (unrestricted) -> Add Credentials```), com as seguintes informações:
```hcl
Kind: Secret text
Scope: Global
Secret: [INFORME A AWS ACCESS KEY QUE SERÁ UTILIZADA PARA O DEPLOY]
ID: [INFORME 'pipeline-aws-lab-access-key' em caso de ser para lab, ou 'pipeline-aws-prod-access-key' em caso de ser para prod)
Description: [INFORME UMA DESCRIÇÂO QUE AJUDE NO ENTENDIMENTO DO QUE SE TRATA TAL CREDENCIAL]
```
```hcl
Kind: Secret text
Scope: Global
Secret: [INFORME A AWS SECRET KEY QUE SERÁ UTILIZADA PARA O DEPLOY]
ID: [INFORME 'pipeline-aws-lab-secret-key' em caso de ser para lab, ou 'pipeline-aws-prod-secret-key' em caso de ser para prod)
Description: [INFORME UMA DESCRIÇÂO QUE AJUDE NO ENTENDIMENTO DO QUE SE TRATA TAL CREDENCIAL]
```
**Repita o processo acima caso os ambientes rodem em contas diferentes**

2.2. Altere no arquivo ```Jenkinsfile```, dexando o nome das credencials para ambos ambientes igual ao ```ID``` que foi criado no Jenkins, abaixo segue local que deverá ser alterado:
```hcl
    accessKeyLab = credentials('pipeline-aws-lab-access-key')
    secretKeyLab = credentials('pipeline-aws-lab-secret-key')

    accessKeyProd = credentials('pipeline-aws-prod-access-key')
    secretKeyProd = credentials('pipeline-aws-prod-secret-key')
```

3. Crie um novo Job em seu Jenkins do tipo **```Multibranch Pipeline```**;
3.1. Nas configurações do JOB, em **```Branch Sources -> Project Repository```** informe este projeto: **```https://github.com/gtiosso/devops_exam_ton.git```**;
3.2. Nas configurações do JOB, em **```Branch Sources -> Credentials```** informe **```none```**;
3.3. Nas configurações do JOB, em **```Build Configuration -> Mode```** informe **```by Jenkinsfile```**;
3.4. Nas configurações do JOB, em **```Build Configuration -> Script Path```** informe **```Jenkinsfile```** e crie o JOB;
4. Após criado, aguarde o fim do escaneamento das branchs e irá aparecer a branch de execução **```main```**. Selecione a mesma e clique em **```Build Now```**;
5. Siga com as instruções, conforme desejado;

**OBS:**
* **A branch ```main``` executará o deploy do ambiente de ```prod```**
* **A branch ```lab``` (ou qualquer outra branch diferente da ```main```) executará o deploy do ambiente de ```lab```**


## Validação:
Após o deploy realizado, siga as instruções abaixo:

* Configure no arquivo **```/etc/hosts```** a seguinte entrada
```IP_DA_INSTÂNCIA_EC2 www.devops-exam-ton-tiosso.com devops-exam-ton-tiosso.com```

* Acesse pelo seu navegador a seguinte URL **```https://www.devops-exam-ton-tiosso.com```** ou **```https://devops-exam-ton-tiosso.com```**
