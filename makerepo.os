Функция ИнициализироватьНастройки()
    Настройки = новый Структура;
    Настройки.Вставить("ПутьКПрекоммиту","c:\repo\precommit1c\");
    Настройки.Вставить("ПутьКБуту","c:\repo\vanessa-bootstrap\");

    КопируемыеФайлыВХук = новый Массив;
    КопируемыеФайлыВХук.Добавить("pre-commit");
    КопируемыеФайлыВХук.Добавить("v8files-extractor.os");

    КопируемыеКаталогиВХук = новый Массив;
    КопируемыеКаталогиВХук.Добавить("tools");    
    КопируемыеКаталогиВХук.Добавить("ibService");
    КопируемыеКаталогиВХук.Добавить("V8Reader");

    КопируемыеКаталоги2 = новый Массив;
    КопируемыеКаталоги2.Добавить("examples");
    КопируемыеКаталоги2.Добавить("features");
    КопируемыеКаталоги2.Добавить("lib");
    КопируемыеКаталоги2.Добавить("license");
    КопируемыеКаталоги2.Добавить("spec");
    КопируемыеКаталоги2.Добавить("src");
    КопируемыеКаталоги2.Добавить("tools");
    КопируемыеКаталоги2.Добавить("vendor");

	Настройки.Вставить("КопируемыеФайлыВХук",КопируемыеФайлыВХук);
    Настройки.Вставить("КопируемыеКаталогиВХук",КопируемыеКаталогиВХук);
    Настройки.Вставить("КопируемыеКаталоги2",КопируемыеКаталоги2);
    Возврат Настройки;
КонецФункции

Процедура Копирование(МассивКаталогов,ИсходныйПуть,Добавка, Настройки)
    Слеш = ПолучитьРазделительПути();
    Для каждого Каталог Из МассивКаталогов Цикл
        СоздатьКаталог(Настройки.ПутьКНовомуРепозиторию+Слеш+Добавка+Слеш+Каталог);
        МассивФайлов = НайтиФайлы(ИсходныйПуть+Каталог,ПолучитьМаскуВсеФайлы(),Истина);
        Для каждого Файл Из МассивФайлов Цикл
            Если Файл.ЭтоКаталог() Тогда
                НовыйПуть=СтрЗаменить(Файл.ПолноеИмя,ИсходныйПуть,"");
                СоздатьКаталог(Настройки.ПутьКНовомуРепозиторию+Слеш+Добавка+Слеш+НовыйПуть);
            КонецЕсли;
        КонецЦикла;
        Для каждого Файл Из МассивФайлов Цикл
            Если Файл.ЭтоФайл() Тогда
                НовыйПуть=СтрЗаменить(Файл.ПолноеИмя,ИсходныйПуть,"");
                Сообщить(НовыйПуть);
                Попытка
                    КопироватьФайл(Файл.ПолноеИмя,Настройки.ПутьКНовомуРепозиторию+Слеш+Добавка+Слеш+НовыйПуть);
                Исключение
                    Сообщить(Файл.ПолноеИмя);
                КонецПопытки;
            КонецЕсли;
        КонецЦикла;
    КонецЦикла;    
КонецПроцедуры

Настройки = ИнициализироватьНастройки();
Слеш = ПолучитьРазделительПути();

// определеяем путь куда КопироватьФайл()
Настройки.Вставить("ПутьКНовомуРепозиторию","");
Для каждого Аргумент Из АргументыКоманднойСтроки Цикл    
    Если Аргумент = "here" Тогда
        Настройки.ПутьКНовомуРепозиторию = ТекущийКаталог();
    КонецЕсли;
КонецЦикла;

Если Настройки.ПутьКНовомуРепозиторию="" Тогда
    Сообщить("Не указан каталог куда создавать.");    
    ЗавершитьРаботу(1);
КонецЕсли;

Файл = Новый Файл(Настройки.ПутьКНовомуРепозиторию+Слеш+".git");
Если Файл.Существует() И Файл.ЭтоКаталог() ТОгда
Иначе
    Сообщить("Сначала создайте в этом каталоге git-репозитарий");    
    ЗавершитьРаботу(1);    
КонецЕсли;

// создаем hooks
СоздатьКаталог(Настройки.ПутьКНовомуРепозиторию+Слеш+".git\hooks");

// коипруем из корня
Для каждого Файл Из Настройки.КопируемыеФайлыВХук Цикл
    КопироватьФайл(Настройки.ПутьКПрекоммиту+Файл,Настройки.ПутьКНовомуРепозиторию+Слеш+".git\hooks"+Слеш+Файл);
КонецЦикла;

// копируем каталоги и содержимое
Копирование(Настройки.КопируемыеКаталогиВХук,Настройки.ПутьКПрекоммиту,".git\hooks",Настройки);
Копирование(Настройки.КопируемыеКаталоги2,Настройки.ПутьКБуту,"",Настройки);

// запуск
КодВозврата=""; 
ЗапуститьПриложение("git config --local core.quotepath false",,Истина,КодВозврата);

