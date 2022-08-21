# Пример работы с IaaS aitu.cloud с использованием Terraform

В примере используется официальный провайдер Openstack:

<https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs>

## Использование:
Переменные окружения для Openstack можно скачать с `ui.aitu.cloud -> API Access -> Download OpenStack RC File -> OpenStack RC File`

```
export OS_PROJECT_NAME=yourprojectname
export OS_USERNAME=yourusername
export OS_PASSWORD=yourpassword
expoty OS_USER_DOMAIN_NAME=Public
export OS_PROJECT_ID=yourprojectid
export OS_PROJECT_DOMAIN_ID=yourprojectdomainid
expoty OS_REGION_NAME=Qshy
export OS_INTERFACE=public
export OS_IDENTITY_API_VERSION=3
terraform init
terraform plan
terraform apply
```

## Содержимое:

* [main.tf](main.tf) - параметры доступа к облаку, ключевая пара, образ
* [networks.tf](networks.tf) - сеть, subnet, security group etc.
* [vms.tf](vms.tf) - виртуальная машина, ее диски и сетевой порт
* [versions.tf](versions.tf) - требуемые версии Terraform и провайдеров
