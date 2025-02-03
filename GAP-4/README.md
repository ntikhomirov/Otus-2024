# Otus-2024 GAP-4
## Grafana - Продвинутое Использование

### Подготовка Окружения к ДЗ
В данном задании была переиспользована виртуальная машина из прошлого занятия.

## Установка Плагина для WordPress - PromPress
PromPress позволяет отправлять метрики WordPress в формате Prometheus.
Настраиваем дополнительный target в prometheus.yml


---  
* Не хотелось кликать мышкой все настройки были внесены вручную.
* Включил флаг в конфигурационном файле grafana.ini (provisioning = true). Это дало возможность использовать конфигурацию дашбордов из файлов.  
![img](img/1.png)  
[Файл конфигурации](dashboards.yaml)  
* Разместил [дерево папок и файлов](dashboards) по пути, указанному в файле (/var/lib/grafana/dashboards):  
![img](img/2.png)  
* Использовал часть стандартных шаблонов с сайта Grafana (Prometheus Blackbox Exporter, MySQL Exporter Quickstart and Dashboard, Node Exporter Full), а также созданные по запросу (WordPress, Общая панель):  
![img](img/3.png)  
![img](img/4.png)  
![img](img/5.png)  
![img](img/6.png)  

### Задание со Звездочкой (со **)
* Настроил два канала отправки сообщений в разделе Contact Points: почта и Telegram. Для почты необходимо было включить необходимые настройки в конфигурационном файле grafana.ini:  
![img](img/7.png)  
* Настройка каналов производится через интерфейс Grafana:  
![img](img/8.png)  
* Создал правила для событий в разделе Alert Rules:  
![img](img/9.png)  
* Создал правила отправки сообщений в Notification Policies:  
![img](img/10.png)  

### Проверка
Когда WordPress перестает корректно отвечать, сообщения отправляются в Telegram и на почту:  
![img](img/11.png)  
![img](img/12.png)  

* Создал дашборд "Общая панель" и связал все панели с соответствующими:  
![img](img/5.png)  
Пример использования линковки:  
![img](img/13.png)  

### Проверка
* Остановил MySQL (все базы данных недоступны, что приводит к недоступности WordPress):  
![img](img/14.png)  
* Кликаем по панели, переходим в основной раздел - MySQL Exporter Quickstart and Dashboard:  
![img](img/15.png)  
![img](img/16.png)  
