# Exporters

## Sobre <a name = "sobre"></a>

Instalador de exporters do Prometheus usando o Ansible.

## Setup Inicial <a name = "setup"></a>

### Alternativa 1 - Docker
Instale o docker e o docker-compose, apos isso basta executar os comandos a seguir na raiz do projeto:

```bash
docker-compose up -d
docker exec -it ansible bash

root@99cbacafbe31:/home/ansible $ make install-node-exporter

###
### Antes de executar o script, por favor inclua os hosts no arquivo inventory/inventory.ini.
###

ansible-playbook -T 120 \
--extra-vars="exporter_action=install exporter=node_exporter" \
-i inventory/inventory.ini _install.yml

PLAY [node] ****************************************************************************************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] *****************************************************************************************************************************************************************************************************************************************************************************************
ok: [host2]
ok: [host1]
...
```

### Alternativa 2 - Local (MacBook e Linux)
Primeiro instale o ***make*** e o ***Python3***, e depois execute o script de instalação:

```bash
#Esse comando deverá instalar o Ansible e o SshPass
make setup-tools
```

---

## Como instalar um exporter? <a name = "install_exporter"></a>

- Adicione o host no arquivo [inventory/inventory.ini](inventory/inventory.ini) dentro do grupo desejado, ex. redis, nodes, redis-sentinel ...
- Verifique se os parâmetros no arquivo [_install.yml](_install.yml) estão corretos dentro do bloco relacionado ao grupo de hosts em que você pretende instalar.
- Caso pretenda instalar o exporter no grupo **nodes**, presente no arquivo [inventory/inventory.ini](inventory/inventory.ini), execute o comando ```make install-node-exporter```

---

## Como desinstalar um exporter? <a name = "uninstall_exporter"></a>

- Adicione o host no arquivo [inventory/inventory.ini](inventory/inventory.ini) dentro do grupo desejado, ex. redis, nodes, redis-sentinel ...
- Verifique se os parâmetros no arquivo [_uninstall.yml](_uninstall.yml) estão corretos dentro do bloco relacionado ao grupo de hosts em que você pretende desinstalar.
- Caso pretenda desinstalar o exporter no grupo **nodes**, presente no arquivo [inventory/inventory.ini](inventory/inventory.ini), execute o comando ```make uninstall-node-exporter```

---

## Como fazer o upgrade de um exporter? <a name = "upgrade_exporter"></a>

Mude a variável ```url_artifactory``` no arquivo [_install.yml](_install.yml) com o caminho para o binário atualizado e execute o comando de instalação ex. ```make install-node-exporter```

---

## Como adicionar um novo exporter no instalador? <a name = "add_exporter"></a>

No arquivo [_install.yml](_install.yml) copie um bloco, conforme o exemplo à seguir, cole no final do arquivo e altere os valores.

```yaml
- hosts: node   # Grupo de hosts presente no arquivo inventary.ini
  become: True  # Precisa escalar previlégios?
  become_user: root # Forçando para usar root
  vars:
    prometheus_exporters_params:
      - name: Node Exporter # Nome descritivo do serviço
        url_github: https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz # Arquivo TAR.GZ no github
        binary_name: node_exporter  # Nome que o binário reberá dentro do host de destino.
        service_name: node_exporter # Nome do serviço no systemd
        path_to_binary: /usr/local/bin/ # Path onde o binário ficará dentro do host de destino.
        exporter_username: root # Nome do usuário do binário.
        exporter_group: root    # Nome do grupo do binário.
        exporter_version: 1.1.2 # Versão do exporter, futuramente servirá de parametro para upgrades.
        exec_start_args: "" # Argumentos usados na chamada do binário.
  roles:
    - role: install # Nome da role que irá executar quando a condição à seguir for atendida.
      when: exporter == 'node_exporter' and exporter_action == 'install' # Testa os valores das variáveis exporter e exporter_action passadas pelo parametro --extra-vars do makefile
```

No arquivo [_uninstall.yml](_uninstall.yml) copie um bloco, conforme o exemplo à seguir, cole no final do arquivo e altere os valores.

```yaml
- hosts: node   # Grupo de hosts presente no arquivo inventary.ini
  become: True  # Precisa escalar previlégios?
  become_user: root # Forçando para usar root
  vars:
    prometheus_exporters_params:
      - name: Node Exporter # Nome descritivo do serviço
        binary_name: node_exporter # Nome do binário.
        service_name: node_exporter # Nome do serviço no systemd.
        path_to_binary: /usr/local/bin/ # Path onde está o binário.
        exporter_username: root # Nome do usuário do binário.
        exporter_group: root    # Nome do grupo do binário.
        files_to_remove: # Lista de arquivos que serão excluídos na desinstalação do exporter.
          - /etc/systemd/system/node_exporter.service
          - /usr/local/bin/node_exporter/
          - /etc/init.d/node_exporter
          - /var/lock/subsys/node_exporter
          - /var/lock/subsys/node_exporter
          - /var/run/node_exporter
  roles:
    - role: uninstall # Nome da role que irá executar quando a condição à seguir for atendida.
      when: exporter == 'node_exporter' and exporter_action == 'uninstall' # Testa os valores das variáveis exporter e exporter_action passadas pelo parametro --extra-vars do makefile
```

No arquivo [makefile](makefile) copie um bloco, conforme o exemplo à seguir, cole no final do arquivo e altere os valores.

```bash
install-node-exporter: # Nome do comando make
	ansible-playbook --ask-pass --ask-become-pass \
	--extra-vars="exporter_action=install exporter=node_exporter" \ # Diz qual é a ação desejada.
	-i inventory/inventory.ini _install.yml

uninstall-node-exporter:
	ansible-playbook --ask-pass --ask-become-pass \
	--extra-vars="exporter_action=uninstall exporter=node_exporter" \ # Diz qual é a ação desejada.
	-i inventory/inventory.ini _uninstall.yml
```