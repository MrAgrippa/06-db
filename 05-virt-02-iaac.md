# Домашнее задание к занятию 2. «Применение принципов IaaC в работе с виртуальными машинами» - Тимохин Максим

## Задача 1

    Опишите основные преимущества применения на практике IaaC-паттернов.
    Какой из принципов IaaC является основополагающим?

### Ответ:

Основные преимущества применения IaaC (Infrastructure as Code) паттернов на практике включают:

1. Автоматизация и повторяемость: IaaC позволяет автоматизировать процесс создания, настройки и управления инфраструктурой. Это позволяет повысить эффективность, ускорить развертывание и обеспечить повторяемость процессов.

2. Контроль версий и отслеживаемость: IaaC позволяет хранить код инфраструктуры в системе контроля версий (например, Git), что обеспечивает возможность отслеживания изменений, восстановления предыдущих состояний и сотрудничества между командами.

3. Масштабируемость: IaaC позволяет легко масштабировать инфраструктуру, добавляя, удаляя или изменяя компоненты с использованием кода. Это делает процесс масштабирования гибким и предсказуемым.

4. Управление конфигурациями: IaaC позволяет управлять конфигурациями инфраструктуры с помощью кода, что обеспечивает централизованное и управляемое уровень инфраструктурной конфигурации. Это упрощает изменение и поддержку инфраструктуры.

5. Поддержка DevOps-практик: IaaC является важной составляющей DevOps-практик, позволяющих объединить разработку и операции. Благодаря автоматизации, контролю версий и гибкости, IaaC помогает обеспечить непрерывную поставку и развертывание приложений.

Основополагающим принципом IaaC является описание инфраструктуры с использованием кода. Использование кода для определения и настройки инфраструктуры позволяет автоматизировать и повторять процессы, а также достичь преимуществ контроля версий и масштабируемости.

## Задача 2

    Чем Ansible выгодно отличается от других систем управление конфигурациями?
    Какой, на ваш взгляд, метод работы систем конфигурации более надёжный — push или pull?

### Ответ:

Ansible выгодно отличается от других систем управления конфигурациями по нескольким причинам:

1. Простота использования: Ansible имеет простой и понятный язык описания конфигурации, основанный на YAML. 

2. Агентless-архитектура: Ansible не требует установки агентов на управляемые хосты. Вместо этого он использует SSH для установки и выполнения задач на удаленных хостах. Это упрощает развертывание и обеспечивает легкость поддержки и масштабирования.

3. Мощная оркестрация: Ansible помимо управления конфигурациями также предлагает мощные возможности оркестрации, позволяющие запускать и управлять группами задач на нескольких хостах одновременно.
   
5. Широкое сообщество и экосистема: Ansible имеет широкое сообщество пользователей и непрерывно развивается как open-source проект.

В отношении метода работы системы конфигурации (push или pull), оба подхода имеют свои преимущества и недостатки:

- Метод push предполагает, что центральный сервер отправляет изменения на управляемые хосты, руководствуясь заранее определенными правилами и конфигурацией. Этот метод обеспечивает более быструю и мгновенную доставку изменений, что особенно важно для реагирования на срочные изменения или устранения уязвимостей.
- Метод pull, с другой стороны, предполагает, что управляемые хосты периодически проверяют обновления и получают изменения из центрального репозитория. Этот метод обеспечивает большую автономность и гибкость для управляемых хостов, так как они могут определять частоту и время обновлений. Однако, это может вызвать некоторую задержку в доставке изменений, особенно если управляемые хосты проверяют обновления редко.

Оба метода имеют свое место в различных сценариях и зависят от требований и ограничений инфраструктуры.

## Задача 3

Установите на личный компьютер:

    VirtualBox,
    Vagrant,
    Terraform,
    Ansible.

![1](https://github.com/MrAgrippa/06-db/blob/main/img/05-02/1.PNG)

![2](https://github.com/MrAgrippa/06-db/blob/main/img/05-02/2.PNG)

![3](https://github.com/MrAgrippa/06-db/blob/main/img/05-02/3.PNG)

![4](https://github.com/MrAgrippa/06-db/blob/main/img/05-02/4.PNG)

## Задача 4

Воспроизведите практическую часть лекции самостоятельно.

    Создайте виртуальную машину.
    Зайдите внутрь ВМ, убедитесь, что Docker установлен с помощью команды

docker ps,

Vagrantfile из лекции и код ansible находятся в папке.

Примечание. Если Vagrant выдаёт ошибку:

URL: ["https://vagrantcloud.com/bento/ubuntu-20.04"]     
Error: The requested URL returned error: 404:

выполните следующие действия:

    Скачайте с сайта файл-образ "bento/ubuntu-20.04".
    Добавьте его в список образов Vagrant: "vagrant box add bento/ubuntu-20.04 <путь к файлу>".

Приложите скриншоты в качестве решения на эту задачу.

![7](https://github.com/MrAgrippa/06-db/blob/main/img/05-02/7.PNG)

![9](https://github.com/MrAgrippa/06-db/blob/main/img/05-02/9.PNG)

![10](https://github.com/MrAgrippa/06-db/blob/main/img/05-02/10.PNG)
