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

Ответ: 

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

     root@timohin:/home/timohin/netology# curl -X GET 'http://localhost:9200/'
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



Далее мы будем работать с этим экземпляром Elasticsearch.
Задача 2

В этом задании вы научитесь:

    создавать и удалять индексы,
    изучать состояние кластера,
    обосновывать причину деградации доступности данных.

Ознакомьтесь с документацией и добавьте в Elasticsearch 3 индекса в соответствии с таблицей:
Имя 	Количество реплик 	Количество шард
ind-1 	0 	1
ind-2 	1 	2
ind-3 	2 	4

Получите список индексов и их статусов, используя API, и приведите в ответе на задание.

Получите состояние кластера Elasticsearch, используя API.

Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?

Удалите все индексы.

Важно

При проектировании кластера Elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.
Задача 3

В этом задании вы научитесь:

    создавать бэкапы данных,
    восстанавливать индексы из бэкапов.

Создайте директорию {путь до корневой директории с Elasticsearch в образе}/snapshots.

Используя API, зарегистрируйте эту директорию как snapshot repository c именем netology_backup.

Приведите в ответе запрос API и результат вызова API для создания репозитория.

Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.

Создайте snapshot состояния кластера Elasticsearch.

Приведите в ответе список файлов в директории со snapshot.

Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.

Восстановите состояние кластера Elasticsearch из snapshot, созданного ранее.

Приведите в ответе запрос к API восстановления и итоговый список индексов.

Подсказки:

    возможно, вам понадобится доработать elasticsearch.yml в части директивы path.repo и перезапустить Elasticsearch.
