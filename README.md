# makefileLibrary

Проект-генератор для Makefile в  репозиториях

## Overview

Задача проекта - максимально упростить создание и обновление Makefile в различных проектах, позволяя быстро раскатывать все новые фичи и изменения.
Для этого Makefile были превращены в Jinja темплейты и теперь собираются из мелких шагов, что позволяет иметь единообразные шаги в разных проектах.

## Запуск генератора

Для запуска можно использовать Makefile в данном репозитории, он содержит все необходимые таргеты, либо воспользоваться билдами в Teamcity

Список таргетов и их назначение:

- build - сборка образа
- build_migrations - сборка файлов миграции, используя локальные мейкфайлы
- build_migrations_from_docker - сборка файлов миграции, используя пересборку мейкфайлов через docker image
- build_project_docker - сборка Makefile для проекта с использование docker image
- build_project_local - сборка Makefile для проекта локально, требует установки зависимостей
- desc - описание
- env - настройка переменных окружения
- generate_all_docker - генерация Makefile для всех проектов с использованием docker image
- generate_all_local - генерация Makefile для всех проектов  локально, требует установки зависимостей
- help - список таргетов
- image_tag - генерация Tag для образа
- image_version - генерация версии image
- install_reqs_local - установка зависимостей
- push - публикация образа, только на билд агенте

## Файлы миграции

Проект умеет генерировать примерные замены шагов мейкфайлов на генерируемые шаги, ориентируясь на названия шагов, это может быть использовано для упрощения первичной переделки Makefile на темплейты

## Библиотека шагов

Генерация шагов Makefile ориентирована на использование шаблонных шагов из библиотеки.
Библиотека состоит из 2 частей : generalSteps и customSteps.
В generalSteps лежат основные, часто используемые шаги, в customSteps шаги, используемые 1-2 проектами.
В качестве названии файлов-шагов используются названия самого шага в makefile, они же будут использованы в обращении к Jinja-template.

## Перевод Makefile на template версию

Для начала можно построить файл миграции и посмотреть, какие шаги уже реализованы в библиотеке, после этого заменить эти шаги на {{ ruleslist.название_шага }}
Далее нужно выносить потенциально используемые шаги в отдельные темплейты, в идеале в Jinja темплейте останутся только референсы на шаги из библиотеки и настройка env, которая отличается в разных проектах.
После этого можно собрать Makefile из темплейта и diff'ом посмотреть различия , в идеале их не должно быть.