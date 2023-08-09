# Домашнее задание к занятию 4. «PostgreSQL» - Тимохин Максим

## Задача 1

Используя Docker, поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL, используя psql.

Воспользуйтесь командой \? для вывода подсказки по имеющимся в psql управляющим командам.

Найдите и приведите управляющие команды для:

    вывода списка БД,
    подключения к БД,
    вывода списка таблиц,
    вывода описания содержимого таблиц,
    выхода из psql.

![1](https://github.com/MrAgrippa/06-db/blob/main/img/06-04/1.JPG)

![2](https://github.com/MrAgrippa/06-db/blob/main/img/06-04/2.JPG)

![3](https://github.com/MrAgrippa/06-db/blob/main/img/06-04/3.JPG)

![4](https://github.com/MrAgrippa/06-db/blob/main/img/06-04/4.JPG)

![5](https://github.com/MrAgrippa/06-db/blob/main/img/06-04/5.JPG)

## Задача 2

Используя psql, создайте БД test_database.

Изучите бэкап БД.

Восстановите бэкап БД в test_database.

Перейдите в управляющую консоль psql внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу pg_stats, найдите столбец таблицы orders с наибольшим средним значением размера элементов в байтах.

Приведите в ответе команду, которую вы использовали для вычисления, и полученный результат.

![2.1](https://github.com/MrAgrippa/06-db/blob/main/img/06-04/2.1.JPG)

![2.2](https://github.com/MrAgrippa/06-db/blob/main/img/06-04/2.2.JPG)

![2.3](https://github.com/MrAgrippa/06-db/blob/main/img/06-04/2.3.JPG)

![2.4](https://github.com/MrAgrippa/06-db/blob/main/img/06-04/2.4.JPG)

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.

Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?

![3.1](https://github.com/MrAgrippa/06-db/blob/main/img/06-04/3.1.JPG)

Можно было исключить ручное разбиение: 

```sql CREATE RULE orders_insert_to_more AS ON INSERT TO orders WHERE ( price > 499 ) DO INSTEAD INSERT INTO orders_more_499_price VALUES (NEW.*);
CREATE RULE orders_insert_to_less AS ON INSERT TO orders WHERE ( price <= 499 ) DO INSTEAD INSERT INTO orders_less_499_price VALUES (NEW.*);
```  

## Задача 4

Используя утилиту pg_dump, создайте бекап БД test_database.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца title для таблиц test_database?

![4.1](https://github.com/MrAgrippa/06-db/blob/main/img/06-04/4.1.JPG)


