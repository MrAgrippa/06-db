# Домашнее задание к занятию 5. «Elasticsearch» - Тимохин Максим

## Задача 1

В этом задании вы потренируетесь в:

    установке Elasticsearch,
    первоначальном конфигурировании Elasticsearch,
    запуске Elasticsearch в Docker.

Используя Docker-образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:

    составьте Dockerfile-манифест для Elasticsearch,
    соберите Docker-образ и сделайте push в ваш docker.io-репозиторий,
    запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины.

Требования к elasticsearch.yml:

    данные path должны сохраняться в /var/lib,
    имя ноды должно быть netology_test.

В ответе приведите:

    текст Dockerfile-манифеста,
    ссылку на образ в репозитории dockerhub,
    ответ Elasticsearch на запрос пути / в json-виде.

Подсказки:

    возможно, вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum,
    при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml,
    при некоторых проблемах вам поможет Docker-директива ulimit,
    Elasticsearch в логах обычно описывает проблему и пути её решения.

### Ответ: 

Ссылка на Докер Хаб https://hub.docker.com/r/mragrippa/netology-elastic

    root@timohin:/home/timohin/netology# DOCKER_BUILDKIT=0 docker build -t mragrippa/netology-elastic:1 .  

    Successfully built a8a910ae5ed7  
    Successfully tagged mragrippa/netology-elastic:1

    root@timohin:/home/timohin/netology# sudo docker push mragrippa/netology-elastic:1
    The push refers to repository [docker.io/mragrippa/netology-elastic]
    61927a2c4779: Pushed
    843f74087540: Pushed
    2b4d6f940fa4: Pushed
    6758c1776d18: Pushed
    2964648e072e: Pushed
    e5d5b907d324: Pushed
    c41972607388: Pushed
    7fdca66891b8: Pushed
    174f56854903: Mounted from library/centos
    8.6.2: digest: sha256:2b18cd754a5854502df075f78c6381246b23745b00be31856cb38f9c96                                c06f45 size: 2204

Запускаю образ

    root@timohin:/home/timohin/netology# docker run -d -p 9200:9200 mragrippa/netology-elastic:1
    afcd6b108c79f27720fc311f0544d4df6b826c4c1bd3a6389818a21774bb23ad 

Проверка работы образа:

     root@timohin:/home/timohin/netology# curl -X GET --insecure -u elastic:elastic 'http://localhost:9200/'
    {
      "name" : "netology_test",
      "cluster_name" : "netology",
      "cluster_uuid" : "pEd13WyWRYatfW_4cYvVhQ",
      "version" : {
        "number" : "8.6.2",
        "build_flavor" : "default",
        "build_type" : "tar",
        "build_hash" : "2d58d0f136141f03239816a4e360a8d17b6d8f29",
        "build_date" : "2023-08-13T08:31:20.314882762Z",
        "build_snapshot" : false,
        "lucene_version" : "9.4.2",
        "minimum_wire_compatibility_version" : "7.17.0",
        "minimum_index_compatibility_version" : "7.0.0"
      },
      "tagline" : "You Know, for Search"
    }


## Задача 2

В этом задании вы научитесь:

    создавать и удалять индексы,
    изучать состояние кластера,
    обосновывать причину деградации доступности данных.

Ознакомьтесь с документацией и добавьте в Elasticsearch 3 индекса в соответствии с таблицей:
Имя 	Количество реплик 	Количество шард
ind-1 	0 	1
ind-2 	1 	2
ind-3 	2 	4

### Ответ:

    root@timohin:/home/timohin/netology# curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
    {"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}                                                                           
    root@timohin:/home/timohin/netology# curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
    {"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}                                                                           
    root@timohin:/home/timohin/netology# curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'
    {"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"} 

Получите список индексов и их статусов, используя API, и приведите в ответе на задание.

### Ответ: 

    root@timohin:/home/timohin/netology# curl -X GET --insecure -u elastic:elastic 'http://localhost:9200/_cat/indices?v'
    health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   ind-1 JuepGy90SCWQLm0YXfBH5A   1   0          0            0       225b           225b
    yellow open   ind-3 TIrNoEHvTVmbM7v-UlYAUw   4   2          0            0       900b           900b
    yellow open   ind-2 84179rCxR1u0E8YgUOpaAQ   2   1          0            0       450b           450b

Получите состояние кластера Elasticsearch, используя API.

### Ответ: 

    root@timohin:/home/timohin/netology# curl -X GET --insecure -u elastic:elastic "https://localhost:9200/_cluster/health?pretty"
    {
      "cluster_name" : "elasticsearch",
      "status" : "yellow",
      "timed_out" : false,
      "number_of_nodes" : 1,
      "number_of_data_nodes" : 1,
      "active_primary_shards" : 7,
      "active_shards" : 7,
      "relocating_shards" : 0,
      "initializing_shards" : 0,
      "unassigned_shards" : 10,
      "delayed_unassigned_shards" : 0,
      "number_of_pending_tasks" : 0,
      "number_of_in_flight_fetch" : 0,
      "task_max_waiting_in_queue_millis" : 0,
      "active_shards_percent_as_number" : 41.17647058823529
    }

Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?

### Ответ: при создании индексов было указано количество реплик больше 1. В кластере 1 нода, поэтому реплицировать индексы некуда.

Удалите все индексы.

### Ответ: 

    root@timohin:/home/timohin/netology# curl -X DELETE --insecure -u elastic:elastic "https://localhost:9200/ind-1?pretty"
    root@timohin:/home/timohin/netology# curl -X DELETE --insecure -u elastic:elastic "https://localhost:9200/ind-2?pretty"
    root@timohin:/home/timohin/netology# curl -X DELETE --insecure -u elastic:elastic "https://localhost:9200/ind-3?pretty"

Важно

При проектировании кластера Elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В этом задании вы научитесь:

    создавать бэкапы данных,
    восстанавливать индексы из бэкапов.

Создайте директорию {путь до корневой директории с Elasticsearch в образе}/snapshots.

Используя API, зарегистрируйте эту директорию как snapshot repository c именем netology_backup.

Приведите в ответе запрос API и результат вызова API для создания репозитория.

### Ответ: 

    root@timohin:/home/timohin/netology# curl -X PUT --insecure -u elastic:elastic "https://localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d'
    ",
      "settings": {
        "location": "/opt/elasticsearch-8.2.0/snapshots"
      }
    }
    '
    {
       "type": "fs",
       "settings": {
         "location": "/opt/elasticsearch-8.2.0/snapshots"
       }
    }
    
    {
      "acknowledged" : true
    }

Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.

### Ответ: 

    root@timohin:/home/timohin/netology# curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
    {"acknowledged":true,"shards_acknowledged":true,"index":"test"}
    
    root@timohin:/home/timohin/netology# curl -X GET 'http://localhost:9200/test?pretty'
    {
      "test" : {
        "aliases" : { },
        "mappings" : { },
        "settings" : {
          "index" : {
            "routing" : {
              "allocation" : {
                "include" : {
                  "_tier_preference" : "data_content"
                }
              }
            },
            "number_of_shards" : "1",
            "provided_name" : "test",
            "creation_date" : "1678015657730",
            "number_of_replicas" : "0",
            "uuid" : "kwg5tgqdRQCy-x18jYFfWw",
            "version" : {
              "created" : "8060299"
            }
          }
        }
      }
    }

Создайте snapshot состояния кластера Elasticsearch.

### Ответ:

    root@timohin:/home/timohin/netology# curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true

Приведите в ответе список файлов в директории со snapshot.

### Ответ:

    [elasticsearch@fe18b5f27b80 snapshots]$ ll
    total 36
    -rw-r--r-- 1 elasticsearch elasticsearch  1107 Aug 13 11:55 index-0
    -rw-r--r-- 1 elasticsearch elasticsearch     8 Aug 13 11:55 index.latest
    drwxr-xr-x 5 elasticsearch elasticsearch  4096 Aug 13 11:55 indices
    -rw-r--r-- 1 elasticsearch elasticsearch 16595 Aug 13 11:55 meta-y1W7p4kFTO2S7PM8rZ75AQ.dat
    -rw-r--r-- 1 elasticsearch elasticsearch   401 Aug 13 11:55 snap-y1W7p4kFTO2S7PM8rZ75AQ.dat

Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.

### Ответ:

    root@timohin:/home/timohin/netology# curl -X PUT localhost:9200/test-2?pretty -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
    {
      "acknowledged" : true,
      "shards_acknowledged" : true,
      "index" : "test-2"
    }

Восстановите состояние кластера Elasticsearch из snapshot, созданного ранее.

Приведите в ответе запрос к API восстановления и итоговый список индексов.

### Ответ:

    root@timohin:/home/timohin/netology# curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?pretty -H 'Content-Type: application/json' -d'{"include_global_state":true}'
    {
      "accepted" : true
    }
    
    root@timohin:/home/timohin/netology# curl -X GET http://localhost:9200/_cat/indices?v
    health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
    green  open   test-2 3tb_oimsQ8aUk_gfKHpakw   1   0          0            0       225b           225b
    green  open   test   _aECYtWmQUeTgJAMnN-_wg   1   0          0            0       225b           225b
