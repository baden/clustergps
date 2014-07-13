# Эксперимент крастерного приложения

## Цели эксперимента

Цель - разработка самодостаточного кластерного приложения на Erlang.
За основу была взята [статья с Хабра](http://habrahabr.ru/post/227943/).

## Зависимости

* HTTP-сервер — [cowboy 0.10.0](https://github.com/extend/cowboy/tree/0.10.0)
* логгер — [lager](https://github.com/basho/lager)
* система сборки — [erlang.mk](https://github.com/extend/erlang.mk)
* сборщик релиза — [relx](https://github.com/erlware/relx)

## Установка зависимостей

### Установить систему сборки [erlang.mk](https://github.com/extend/erlang.mk)

Система призвана заменить тяжеловесный rebar.

```bash
        make erlang.mk
```
