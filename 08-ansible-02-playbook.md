# Домашнее задание к занятию 2 «Работа с Playbook» - Тимохин Максим

## Основная часть.

1. Подготовьте свой inventory-файл prod.yml.
```
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_connection: docker
vector:
  hosts:
    vector-01:
      ansible_connection: docker
```
2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает vector.
```
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - name: Mess with clickhouse distrib
      block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
            mode: "0644"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib (rescue)
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
            mode: "0644"
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Flush handlers to restart clickhouse
      ansible.builtin.meta: flush_handlers
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      become: true
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc != 82
      changed_when: create_db.rc == 0

- name: Install vector
  hosts: clickhouse
  handlers:
    - name: Start vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
    - name: Get vector distrib
      ansible.builtin.get_url:
        url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-1.x86_64.rpm"
        dest: "./vector-{{ vector_version }}.rpm"
        mode: "0644"
      notify: Start vector service
    - name: Install vector packages
      become: true
      ansible.builtin.yum:
        name:
          - vector-{{ vector_version }}.rpm
    - name: Flush handlers to restart vector
      ansible.builtin.meta: flush_handlers
```
3. При создании tasks рекомендую использовать модули: get_url, template, unarchive, file.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите ansible-lint site.yml и исправьте ошибки, если они есть.
```
timohin@ubuntu:~$ ansible-lint site.yml WARNING  Overriding detected file kind 'yaml' with 'playbook' for given positional argument: site.yml
```
6. Попробуйте запустить playbook на этом окружении с флагом --check.
```
Playbook завершился ошибкой.
timohin@ubuntu:~$ ansible-playbook site.yml -i inventory/prod.yml --check
PLAY [Install Vector] ***********************************************************************************************************************************************************************************************************************
TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [vector-01]
TASK [Get Vector distrib] *******************************************************************************************************************************************************************************************************************
ok: [vector-01]
TASK [Install Vector packages] **************************************************************************************************************************************************************************************************************
fatal: [vector-01]: FAILED! => {"changed": false, "module_stderr": "/bin/sh: sudo: command not found\n", "module_stdout": "", "msg": "MODULE FAILURE\nSee stdout/stderr for the exact error", "rc": 127}
PLAY RECAP **********************************************************************************************************************************************************************************************************************************
vector-01                  : ok=2    changed=0    unreachable=0    failed=1    skipped=0    rescued=0    ignored=0
```
7. Запустите playbook на prod.yml окружении с флагом --diff. Убедитесь, что изменения на системе произведены.
```
timohin@ubuntu:~$ ansible-playbook site.yml -i inventory/prod.yml --diff
PLAY [Install Clickhouse] *******************************************************************************************************************************************************************************************************************
TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]
TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}
TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]
TASK [Install clickhouse packages] **********************************************************************************************************************************************************************************************************
ok: [clickhouse-01]
TASK [Create database] **********************************************************************************************************************************************************************************************************************
ok: [clickhouse-01]
PLAY [Install vector] ***********************************************************************************************************************************************************************************************************************
TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [vector-01]
TASK [Get vector distrib] *******************************************************************************************************************************************************************************************************************
ok: [vector-01]
TASK [Install vector packages] **************************************************************************************************************************************************************************************************************
ok: [vector-01]
PLAY RECAP **********************************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
Изменения в Докере.
```
timohin@ubuntu:~$ docker exec -it f44fbd836371 /bin/bash
[root@f44fbd836371 /]# cat /etc/vector/vector.toml
#                                    __   __  __
#                                    \ \ / / / /
#                                     \ V / / /
#                                      \_/  \/
#
#                                    V E C T O R
#                                   Configuration
#
# ------------------------------------------------------------------------------
# Website: https://vector.dev
# Docs: https://vector.dev/docs
# Chat: https://chat.vector.dev
# ------------------------------------------------------------------------------
# Change this to use a non-default directory for Vector data storage:
# data_dir = "/var/lib/vector"
# Random Syslog-formatted logs
[sources.dummy_logs]
type = "demo_logs"
format = "syslog"
interval = 1
# Parse Syslog logs
# See the Vector Remap Language reference for more info: https://vrl.dev
[transforms.parse_logs]
type = "remap"
inputs = ["dummy_logs"]
source = '''
. = parse_syslog!(string!(.message))
'''
# Print parsed logs to stdout
[sinks.print]
type = "console"
inputs = ["parse_logs"]
encoding.codec = "json"
# Vector's GraphQL API (disabled by default)
# Uncomment to try it out with the `vector top` command or
# in your browser at http://localhost:8686
#[api]
#enabled = true
#address = "127.0.0.1:8686"
```
8. Повторно запустите playbook с флагом --diff и убедитесь, что playbook идемпотентен.
```
timohin@ubuntu:~$ ansible-playbook -i inventory/prod.yml site.yml --diff
PLAY [Install Clickhouse] ******************************************************************************************************************************************************
TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [clickhouse-01]
TASK [Get clickhouse distrib] **************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}
TASK [Get clickhouse distrib] **************************************************************************************************************************************************
ok: [clickhouse-01]
TASK [Install clickhouse packages] *********************************************************************************************************************************************
ok: [clickhouse-01]
TASK [Create database] *********************************************************************************************************************************************************
ok: [clickhouse-01]
PLAY [Install vector] **********************************************************************************************************************************************************
TASK [Gathering Facts] *********************************************************************************************************************************************************
ok: [vector-01]
TASK [Get vector distrib] ******************************************************************************************************************************************************
ok: [vector-01]
TASK [Install vector packages] *************************************************************************************************************************************************
ok: [vector-01]
PLAY RECAP *********************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

## Playbook

Playbook разворачивает clichouse и vector на две виртуалки CentОS7 docker, собранные с помощью docker-compose файла, запускает службу `clichouse-server` и `vector`, а также создает базу `logs` в `clichouse`. 

 ### Install Clickhouse
Загружаются rpm пакеты и устанавливается Clickhouse. Создается база logs. 

### Variables
В каталоге group_vars задаются необходимые переменные дистрибутивов.

### Install vector
Загружаются пакеты для vector с последующей установкой и запуском службы.

|clickhouse_version|версия clickhous| 
|-|--------|
|vector_version|версия vector|
 

### Tags
|clickhouse|производит полную конфигурацию сервера clickhouse-01| 
|-|--------|
|vector|производит полную конфигурацию сервера vector-01|
    
   
Этапы развертывания playbook :
 - собрать и запустить из `docker-compose.yml` файла две виртуальные машины.
```shell
docker-compose up
docker ps
```
 - запустить `ansible-playbook`:
```shell
ansible-playbook -i inventory/prod.yml site.yml
```

10. Готовый playbook выложите в свой репозиторий, поставьте тег 08-ansible-02-playbook на фиксирующий коммит, в ответ предоставьте ссылку на него.

 https://github.com/MrAgrippa/06-db/tree/main/img/08-02

