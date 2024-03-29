﻿Перем мRegExp Экспорт;

// Функция раскладывает адрес на адрес сервера и адрес картинки
//
Функция РазложитьАдрес(Знач Адрес) Экспорт
	
	Адрес = СтрЗаменить(Адрес, "http://", "");
	Результат = Новый Структура();
	СтрокиАдреса = СтрЗаменить(Адрес, "/", Символы.ПС);
	Результат.Вставить("АдресСервера", СтрПолучитьСтроку(СтрокиАдреса, 1));	
	АдресКартинки = "";
	Для Сч = 2 По СтрЧислоСтрок(СтрокиАдреса) Цикл
		АдресКартинки = АдресКартинки + СтрПолучитьСтроку(СтрокиАдреса, Сч) + "/";
	КонецЦикла;
	Результат.Вставить("АдресКартинки", Лев(АдресКартинки, СтрДлина(АдресКартинки)-1));	
	
	Возврат Результат;
	
КонецФункции

// Функция скачивает картинку с указанного ресурса
// и возвращает в виде объекта "Картинка"
Функция ПолучитьКартинку(Адрес, Расширение) Экспорт
	
	ВремФайл = ПолучитьИмяВременногоФайла(Расширение);
	
	СтруктураАдреса = РазложитьАдрес(Адрес);
	
	Попытка
		ПроксиСервер = БПАГ.ПолучитьПрокси();
		Соединение = Новый HTTPСоединение(СтруктураАдреса.АдресСервера, , , , ПроксиСервер);
		Соединение.Получить(СтруктураАдреса.АдресКартинки, ВремФайл);				
		Возврат Новый Картинка(ВремФайл);
	Исключение	
	КонецПопытки;
	
	Возврат Новый Картинка();
	
КонецФункции

// Функция скачивает указанную страницу
//
Функция ПолучитьСтраницу(Адрес, ИмяФайла) Экспорт
	
	СтруктураАдреса = РазложитьАдрес(Адрес);
	
	Попытка
		ПроксиСервер = БПАГ.ПолучитьПрокси();
		Соединение = Новый HTTPСоединение(СтруктураАдреса.АдресСервера, , , , ПроксиСервер);
		Соединение.Получить(СтруктураАдреса.АдресКартинки, ИмяФайла);				
		Возврат Истина
	Исключение	
		//Предупреждение(ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции

// Функция формирует подсказку для изображения на форме
//
Функция СформироватьПодсказку(ПараметрыКартинки) Экспорт
	
	Возврат "Параметры: " +  ПараметрыКартинки.Ширина + "x" + ПараметрыКартинки.Высота + Символы.ПС +
			"Размер: " + ПараметрыКартинки.Размер + " Кб";
	
КонецФункции

// Функция возвращает структуру для хранения результата по
// конкретной картинке
Функция ПолучитьСтруктуруРезультата() Экспорт
	
	Возврат Новый Структура(
	"Ссылка,
	|Страница,
	|Имя,
	|ПолноеИмя,
	|Расширение,
	|Ширина,
	|Высота,
	|Размер,
	|Миниатюра,
	|РазмерМиниатюры,
	|ШиринаМиниатюры,
	|ВысотаМиниатюры,
	|Дополнительно,
	|Система");
	
КонецФункции

// Функция получает текст из файла и помещает в переменную
//
Функция ПолучитьТекстИзФайла(ИмяФайла, Текст) Экспорт
		
	Файл = Новый ТекстовыйДокумент;
	Попытка
		Файл.Прочитать(ИмяФайла, КодировкаТекста.Системная);
		Текст = Файл.ПолучитьТекст();		
	Исключение
		//Предупреждение(ОписаниеОшибки());
		Возврат Ложь;		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Функция выполняет поиск картинок с помощью указанной системы
// и возвращает результат в виде массива структур следующего вида:
// 		Структура.Ссылка
//		Структура.Имя
//		Структура.ПорлноеИмя
//		Структура.Страница
//		Структура.Высота
//		Структура.Ширина
//		Структура.Размер
//		Структура.Миниатюра
//		Структура.Дополнительно
//
Функция НайтиКартинки(ПоисковаяСистема = 0, ПараметрыПоиска, КоличествоЭлементов, НачальныйЭлемент) Экспорт
	
	Если ПоисковаяСистема = 1 Тогда
		Возврат НайтиКартинкиGoogle(ПараметрыПоиска, КоличествоЭлементов, НачальныйЭлемент);
	Иначе
		Возврат НайтиКартинкиЯндекс(ПараметрыПоиска, КоличествоЭлементов, НачальныйЭлемент);
	КонецЕсли;
			
КонецФункции


//****ПАКЛ->
Функция ПолучитьМассивСлужебныхСимволов()
	
	СлужебныеСимволы = Новый Массив();
	СлужебныеСимволы.Добавить(Символы.ВК);
	СлужебныеСимволы.Добавить(Символы.ВТаб);
	СлужебныеСимволы.Добавить(Символы.НПП);
	СлужебныеСимволы.Добавить(Символы.ПС);
	СлужебныеСимволы.Добавить(Символы.ПФ);
	СлужебныеСимволы.Добавить(Символы.Таб);
		
	Возврат СлужебныеСимволы;
	
КонецФункции

Процедура ПропуститьКомментарии(Строка, НомерСимвола)
	
	ЭтоКомментарий = Ложь;
	ЭтоНачалоКомментария = Ложь;
	ЭтоДлинныйКомментарий = Ложь;
	
	Пока НомерСимвола > 0 И НомерСимвола <= СтрДлина(Строка) Цикл
		
		ТекСимвол = Сред(Строка, НомерСимвола, 1);
		
		Если ТекСимвол = Символы.ВК ИЛИ ТекСимвол = Символы.ПС Тогда
			
			Если НЕ ЭтоДлинныйКомментарий Тогда
				ЭтоНачалоКомментария = Ложь;
				ЭтоКомментарий = Ложь;
			КонецЕсли;
			
		ИначеЕсли ТекСимвол = Символы.Таб ИЛИ ТекСимвол = " " ИЛИ ТекСимвол = "(" ИЛИ ТекСимвол = ")" Тогда
			
		ИначеЕсли ТекСимвол = "/" Тогда
			Если НЕ ЭтоДлинныйКомментарий Тогда
				Если ЭтоНачалоКомментария Тогда
					ЭтоНачалоКомментария = Ложь;
					ЭтоКомментарий = Истина;
				Иначе
					ЭтоНачалоКомментария = Истина;
					ЭтоКомментарий = Ложь;
					ЭтоДлинныйКомментарий = Ложь;
				КонецЕсли;
			Иначе
				Если ЭтоНачалоКомментария Тогда
					ЭтоДлинныйКомментарий = Ложь;
					ЭтоНачалоКомментария = Ложь;
					ЭтоКомментарий = Ложь;
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли ТекСимвол = "*" Тогда
			Если ЭтоНачалоКомментария Тогда
				ЭтоНачалоКомментария = Ложь;
				ЭтоКомментарий = Истина;
				ЭтоДлинныйКомментарий = Истина;
			Иначе
				ЭтоНачалоКомментария = Истина;
			КонецЕсли;         
		Иначе
			Если НЕ ЭтоКомментарий Тогда
				Прервать;
			КонецЕсли;			 
		КонецЕсли;
		
		НомерСимвола = НомерСимвола + 1;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьПравилаКонвертацииHEX16()
		
	Конвертер = Новый Соответствие();
	СимволыHex = "0123456789abcdef"; 
	Число = 0;
	
	Для ВторойРазряд = 1 По 16 Цикл 
		
		Для ПервыйРазряд = 1 По 16 Цикл 
			Конвертер.Вставить(Сред(СимволыHex, ВторойРазряд, 1) + Сред(СимволыHex, ПервыйРазряд, 1), Число);
			Число = Число + 1;
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Конвертер;
	
КонецФункции

Функция ПарсингСтроки(Строка, НомерСимвола, ОписаниеОшибки)
	
	Результат = "";
	ПропуститьКомментарии(Строка, НомерСимвола);
	
	Конвертер = Новый Соответствие();
	Если Найти(Строка, "\u") > 0 Тогда
		Конвертер = ПолучитьПравилаКонвертацииHEX16();
	КонецЕсли;
	
	// Кавычка в начале строки
	Кавычка = Сред(Строка, НомерСимвола, 1);
	
	НомерСимвола = НомерСимвола + 1;
	
	Пока НомерСимвола > 1 И НомерСимвола <= СтрДлина(Строка) Цикл
		ТекСимвол = Сред(Строка, НомерСимвола, 1);
		Если ТекСимвол = "\" Тогда
			// Спецсимвол
			НомерСимвола = НомерСимвола + 1;
			ТекСимвол = Сред(Строка, НомерСимвола, 1);
			Если ТекСимвол = """" ИЛИ ТекСимвол = "'" ИЛИ ТекСимвол = "\" ИЛИ ТекСимвол = "/" Тогда
				Результат = Результат + ТекСимвол;		
				НомерСимвола = НомерСимвола + 1;
			ИначеЕсли ТекСимвол = "b" Тогда
				Результат = Результат + Символ(8);
				НомерСимвола = НомерСимвола + 1;
			ИначеЕсли ТекСимвол = "f" Тогда
				Результат = Результат + Символы.ПФ;
				НомерСимвола = НомерСимвола + 1;
			ИначеЕсли ТекСимвол = "n" Тогда
				Результат = Результат + Символы.ПС;
				НомерСимвола = НомерСимвола + 1;
			ИначеЕсли ТекСимвол = "r" Тогда
				Результат = Результат + Символы.ВК;
				НомерСимвола = НомерСимвола + 1;
			ИначеЕсли ТекСимвол = "t" Тогда
				Результат = Результат + Символы.Таб;
				НомерСимвола = НомерСимвола + 1;
			ИначеЕсли ТекСимвол = "u" Тогда
				// HEX
				НомерСимвола = НомерСимвола + 1;				
				СтаршийБайт = Конвертер[НРег(Сред(Строка, НомерСимвола, 2))];
				МладшийБайт = Конвертер[НРег(Сред(Строка, НомерСимвола + 2, 2))];
				Если (СтаршийБайт = Неопределено) ИЛИ (МладшийБайт = Неопределено) Тогда
					ОписаниеОшибки = ОписаниеОшибки + "Неверный формат hex-строки. Позиция " + НомерСимвола + Символы.ПС;
					Прервать;					
				КонецЕсли;							
				Результат = Результат + Символ(256 * СтаршийБайт + МладшийБайт);
				НомерСимвола = НомерСимвола + 4;
			КонецЕсли;
		ИначеЕсли ТекСимвол = Кавычка Тогда
			НомерСимвола = НомерСимвола + 1;
			Прервать;
		Иначе
			Результат = Результат + ТекСимвол;
			НомерСимвола = НомерСимвола + 1;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ПарсингБулево(Строка, НомерСимвола, ОписаниеОшибки)
	
	Результат = Неопределено;
	
	ПропуститьКомментарии(Строка, НомерСимвола);
	
	Если Сред(Строка, НомерСимвола, 4) = "true" Тогда
		Результат = Истина;
		НомерСимвола = НомерСимвола + 4;
	ИначеЕсли Сред(Строка, НомерСимвола, 5) = "false" Тогда
		Результат = Ложь;
		НомерСимвола = НомерСимвола + 5;
	Иначе
		ОписаниеОшибки = ОписаниеОшибки + "Неверный формат значения булево. Позиция " + НомерСимвола + Символы.ПС;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПарсингNULL(Строка, НомерСимвола, ОписаниеОшибки)
	
	Результат = Неопределено;
	
	ПропуститьКомментарии(Строка, НомерСимвола);
	
	Если Сред(Строка, НомерСимвола, 4) = "null" Тогда
		Результат = NULL;
		НомерСимвола = НомерСимвола + 4;		
	Иначе
		ОписаниеОшибки = ОписаниеОшибки + "Неверный формат значения NULL. Позиция " + НомерСимвола + Символы.ПС;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПарсингЧисла(Строка, НомерСимвола, ОписаниеОшибки)
	
	Результат = "";
	
	ДопустимыеСимволы = Новый Массив();
	Для Сч = 0 По 9 Цикл
		ДопустимыеСимволы.Добавить(Строка(Сч));
	КонецЦикла;
	ДопустимыеСимволы.Добавить("+");
	ДопустимыеСимволы.Добавить("-");
	ДопустимыеСимволы.Добавить(".");
	ДопустимыеСимволы.Добавить("e");
	ДопустимыеСимволы.Добавить("E");
	
	ПропуститьКомментарии(Строка, НомерСимвола);
	
	Пока НомерСимвола > 1 И НомерСимвола <= СтрДлина(Строка) Цикл
		ТекСимвол = Сред(Строка, НомерСимвола, 1);
		Если ДопустимыеСимволы.Найти(ТекСимвол) <> Неопределено Тогда
			Результат = Результат + ТекСимвол;
			НомерСимвола = НомерСимвола + 1;
		Иначе
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	ПреобразовыватьВЧисла = Ложь;
	
	Если ПреобразовыватьВЧисла Тогда
		Попытка
			Результат = Число(Результат);
		Исключение
			ОписаниеОшибки = ОписаниеОшибки + "Не удалось преобразовать строку """ + Результат + """ в число" + Символы.ПС;
		КонецПопытки;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПарсингОбъекта(Строка, НомерСимвола, ОписаниеОшибки)
	
	Объект = Новый Соответствие();
	
	ИмяСвойства = Неопределено;
	ЗначениеСвойства = Неопределено;
	
	ПропуститьКомментарии(Строка, НомерСимвола);
	
	ТекСимвол = Сред(Строка, НомерСимвола, 1);
	Если ТекСимвол <> "{" Тогда
		ОписаниеОшибки = ОписаниеОшибки + "Неожиданный символ начала объекта " + НомерСимвола + ": " + ТекСимвол + Символы.ПС;
		Возврат Объект;
	КонецЕсли;
	
	НомерСимвола = НомерСимвола + 1;
	
	ВыполнятьЧтениеОбъекта = Истина;
	
	Пока ВыполнятьЧтениеОбъекта Цикл
		
		#Если Клиент Тогда
		ОбработкаПрерыванияПользователя();
		#КонецЕсли
		
		ПропуститьКомментарии(Строка, НомерСимвола);
		
		ТекСимвол = Сред(Строка, НомерСимвола, 1);
		
		Если ТекСимвол = "}" Тогда
			НомерСимвола = НомерСимвола + 1;
			ВыполнятьЧтениеОбъекта = Ложь;
		ИначеЕсли ТекСимвол = "," Тогда
			НомерСимвола = НомерСимвола + 1;
			ПропуститьКомментарии(Строка, НомерСимвола);
		ИначеЕсли НомерСимвола > СтрДлина(Строка) Тогда
			ОписаниеОшибки = ОписаниеОшибки + "Отсутствует закрывающий тэг ""}"" объекта" + Символы.ПС;	
			ВыполнятьЧтениеОбъекта = Ложь;
		КонецЕсли;
		
		Если ВыполнятьЧтениеОбъекта Тогда
			ИмяСвойства = ПолучитьИмяСвойства(Строка, НомерСимвола, ОписаниеОшибки);
			Объект.Вставить(ИмяСвойства, ПолучитьЗначениеСвойства(Строка, НомерСимвола, ОписаниеОшибки));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Объект;
	
КонецФункции

Функция ПарсингМассива(Строка, НомерСимвола, ОписаниеОшибки)
	
	Массив = Новый Массив();
	
	ПропуститьКомментарии(Строка, НомерСимвола);
	
	ТекСимвол = Сред(Строка, НомерСимвола, 1);
	Если ТекСимвол <> "[" Тогда
		ОписаниеОшибки = ОписаниеОшибки + "Неожиданный символ начала массива" + НомерСимвола + ": " + ТекСимвол + Символы.ПС;
		Возврат Массив;
	КонецЕсли;
	
	НомерСимвола = НомерСимвола + 1;
	
	ВыполнятьЧтениеМассива = Истина;
	
	Пока ВыполнятьЧтениеМассива Цикл
		
		#Если Клиент Тогда
		ОбработкаПрерыванияПользователя();
		#КонецЕсли
	
		ПропуститьКомментарии(Строка, НомерСимвола);
		
		ТекСимвол = Сред(Строка, НомерСимвола, 1);
		
		Если ТекСимвол = "]" Тогда
			НомерСимвола = НомерСимвола + 1;
			ВыполнятьЧтениеМассива = Ложь;
		ИначеЕсли ТекСимвол = "," Тогда
			НомерСимвола = НомерСимвола + 1;
			ПропуститьКомментарии(Строка, НомерСимвола);
		ИначеЕсли НомерСимвола > СтрДлина(Строка) Тогда
			ОписаниеОшибки = ОписаниеОшибки + "Отсутствует закрывающий тэг ""]"" массива" + Символы.ПС;	
			ВыполнятьЧтениеМассива = Ложь;
		КонецЕсли;
				
		Если ВыполнятьЧтениеМассива Тогда
			Массив.Добавить(ПолучитьЗначениеСвойства(Строка, НомерСимвола, ОписаниеОшибки));
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Массив;
	
КонецФункции

Функция ПолучитьЗначениеСвойства(Строка, НомерСимвола, ОписаниеОшибки)
	
	ЗначениеСвойства = Неопределено;
	
	ПропуститьКомментарии(Строка, НомерСимвола);
	
	ТекСимвол = Сред(Строка, НомерСимвола, 1);
	Если ТекСимвол = "{" Тогда
		ЗначениеСвойства = ПарсингОбъекта(Строка, НомерСимвола, ОписаниеОшибки);
	ИначеЕсли ТекСимвол = "[" Тогда
		ЗначениеСвойства = ПарсингМассива(Строка, НомерСимвола, ОписаниеОшибки);
	ИначеЕсли ТекСимвол = """" ИЛИ ТекСимвол = "'" Тогда
		ЗначениеСвойства = ПарсингСтроки(Строка, НомерСимвола, ОписаниеОшибки);
	ИначеЕсли ТекСимвол = "p" ИЛИ ТекСимвол = "t" Тогда
		ЗначениеСвойства = ПарсингБулево(Строка, НомерСимвола, ОписаниеОшибки);
	ИначеЕсли ТекСимвол = "n" Тогда
		ЗначениеСвойства = ПарсингNULL(Строка, НомерСимвола, ОписаниеОшибки);
	Иначе
		ЗначениеСвойства = ПарсингЧисла(Строка, НомерСимвола, ОписаниеОшибки);
	КонецЕсли;
	
	Возврат ЗначениеСвойства;
	
КонецФункции

Функция ПолучитьИмяСвойства(Строка, НомерСимвола, ОписаниеОшибки)
	
	СлужебныеСимволы = ПолучитьМассивСлужебныхСимволов();
		
	ИмяСвойства = "";
	НачалоИмениФормат1 = Ложь; // Когда начиначется с "
	НачалоИмениФормат2 = Ложь; // Когда начиначется с '
	
	ПропуститьКомментарии(Строка, НомерСимвола);
	
	Пока НомерСимвола > 1 И НомерСимвола <= СтрДлина(Строка) Цикл
		
		ТекСимвол = Сред(Строка, НомерСимвола, 1);
		
		Если ТекСимвол = """" Тогда
			НачалоИмениФормат1	= НЕ НачалоИмениФормат1;
			НомерСимвола = НомерСимвола + 1;
			Если НЕ НачалоИмениФормат1 Тогда
				Если Сред(Строка, НомерСимвола, 1) <> ":" Тогда
					ОписаниеОшибки = ОписаниеОшибки + "Неверный формат имени свойства. Позиция " + НомерСимвола + ": " + ИмяСвойства + Символы.ПС;
					Прервать;	
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ТекСимвол = "'" Тогда
			НачалоИмениФормат2	= НЕ НачалоИмениФормат2;
			НомерСимвола = НомерСимвола + 1;
			Если НЕ НачалоИмениФормат2 Тогда
				Если Сред(Строка, НомерСимвола, 1) <> ":" Тогда
					ОписаниеОшибки = ОписаниеОшибки + "Неверный формат имени свойства. Позиция " + НомерСимвола + ": " + ИмяСвойства + Символы.ПС;
					Прервать;	
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ТекСимвол = ":" Тогда	
			НомерСимвола = НомерСимвола + 1;
			Если НЕ НачалоИмениФормат1 И НЕ НачалоИмениФормат2 Тогда				
				Прервать;
			Иначе
				ИмяСвойства = ИмяСвойства + ТекСимвол;
			КонецЕсли;
		Иначе
			Если ЗначениеЗаполнено(ТекСимвол) И СлужебныеСимволы.Найти(ТекСимвол) = Неопределено Тогда
				ИмяСвойства = ИмяСвойства + ТекСимвол;
			КонецЕсли;
			НомерСимвола = НомерСимвола + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ИмяСвойства;
	
КонецФункции


Функция ПарсингСтр(Строка, ОписаниеОшибки) Экспорт
	
	Результат = Неопределено;
			
	НомерСимвола = 1;
	ОписаниеОшибки = "";
	
	//ПодготовитьДанныеДляЧтения(Строка);//Удалить
	Строка = СтрЗаменить(Строка, Символы.ПС, "");

	ПропуститьКомментарии(Строка, НомерСимвола);
	
	ТекСимвол = Сред(Строка, НомерСимвола, 1);
	
	Если ТекСимвол = "{" Тогда
		Результат = ПарсингОбъекта(Строка, НомерСимвола, ОписаниеОшибки);
	ИначеЕсли ТекСимвол = "[" Тогда
		Результат = ПарсингМассива(Строка, НомерСимвола, ОписаниеОшибки);
	Иначе
		ОписаниеОшибки = "Неверный формат";
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции
//<-ПАКЛ
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//													ЯНДЕКС														//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

Функция НайтиКартинкиЯндекс(ПараметрыПоиска, КоличествоЭлементов, НачальныйЭлемент)
	
	КартинокНаСтранице = 30;
	
	Попытка
		мRegExp = Новый COMОбъект("VBScript.RegExp");  
	Исключение	
		Отказ = Истина;
	КонецПопытки;

	мRegExp.IgnoreCase = Истина; //Игнорировать регистр
	мRegExp.Global = Истина; //Поиск всех вхождений шаблона	

	РезультатыПоиска = Новый Массив;
	
	ВремHTML = ПолучитьИмяВременногоФайла("html");	
	
	ТекущаяСтраница = Цел(НачальныйЭлемент / КартинокНаСтранице);
	СтартоваяКартинка = НачальныйЭлемент - (ТекущаяСтраница * КартинокНаСтранице) - 1;
	Пока (ТекущаяСтраница * КартинокНаСтранице) < (НачальныйЭлемент + КоличествоЭлементов) Цикл		
				
		НомерВызова = ?(ТекущаяСтраница = 0, "", "p=" + ТекущаяСтраница + "&");
		
		// Запрос страницы HTML
		Если НЕ ПолучитьСтраницу("images.yandex.ru/yandsearch?" + НомерВызова+ "text=" + СтрЗаменить(СокрЛП(ПараметрыПоиска), " ", "+") + "&rpt=image&ed=1", ВремHTML) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		Текст = "";		
		Файл = Новый ТекстовыйДокумент;
		Попытка
			Файл.Прочитать(ВремHTML, КодировкаТекста.Системная);
			Текст = Файл.ПолучитьТекст();		
		Исключение
			//Предупреждение(ОписаниеОшибки());
			Возврат Неопределено;		
		КонецПопытки;
				
		РегулярноеВыражение = "<div class=""b-images-item (?:.*?)""(?:.|\n)*?&quot;html_href&quot;:&quot;(.*?)&quot;,&quot;href&quot;:&quot;(.*?)&quot;,&quot;height&quot;:&quot;(.*?)&quot;,&quot;width&quot;:&quot;(.*?)&quot;(?:.|\n)*?&quot;detail_url&quot;:&quot;(.*?)&quot;(?:.*?)&quot;thmb_href&quot;:&quot;(.*?)&amp;";
				
		// Поиск регулярного выражения
		мRegExp.Pattern = РегулярноеВыражение;
		Matches = мRegExp.Execute(Текст);
		Вхождений = Matches.Count;
		Для Сч = СтартоваяКартинка По Вхождений - 1 Цикл				
			SubMatches = Matches.Item(Сч).SubMatches;
			Если SubMatches.Count = 6 Тогда
				
				Результат = ПолучитьСтруктуруРезультата();
				ЗаполнитьРезультатЯндекс(Результат, SubMatches);											
				
				Если ЯвляетсяГрафическимФорматом(Результат.Расширение) Тогда
					РезультатыПоиска.Добавить(Результат);
				КонецЕсли;
				
				Если РезультатыПоиска.Количество() = КоличествоЭлементов Тогда
					Прервать;	
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Если РезультатыПоиска.Количество() = КоличествоЭлементов Тогда
			Прервать;	
		КонецЕсли;
												
		ТекущаяСтраница = ТекущаяСтраница + 1;
		
		Если ТекущаяСтраница > 20 Тогда //Защитка от изменения формата
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
		
	УдалитьФайлы(ВремHTML);
	
	Возврат РезультатыПоиска;
	
КонецФункции

// Процедура заполняет структуру результата из SubMatch регулярного выражения
// Здесь получаются все основные параметры изображения
Процедура ЗаполнитьРезультатЯндекс(Результат, Источник)
	
	Ссылка = СтрЗаменить(Источник.Item(1), "%2F", "/");
	ВремСтроки = СтрЗаменить(Ссылка, "/", Символы.ПС);
	ЧислоВременныхСтрок = СтрЧислоСтрок(ВремСтроки);
	Если ЧислоВременныхСтрок > 1 Тогда
		ПолноеИмя = СтрПолучитьСтроку(ВремСтроки, ЧислоВременныхСтрок);
		ДопСтроки = СтрЗаменить(ПолноеИмя, ".", Символы.ПС);
		ЧислоДопСтрок = СтрЧислоСтрок(ДопСтроки);
		Если ЧислоДопСтрок > 1 Тогда
			Расширение = СтрПолучитьСтроку(ДопСтроки, ЧислоДопСтрок);
			Имя = "";
			Для Сч = 1 По ЧислоДопСтрок-1 Цикл
				Имя = Имя + СтрПолучитьСтроку(ДопСтроки, Сч) + ".";
			КонецЦикла;
			ДлинаИмени = СтрДлина(Имя);
			Если ДлинаИмени > 0 Тогда
				Имя	= Лев(Имя, ДлинаИмени - 1);
			КонецЕсли;
			Результат.Имя = Имя;
			Результат.Расширение = Расширение;
		КонецЕсли;		
		Результат.ПолноеИмя = ПолноеИмя;
	КонецЕсли;
	
	Результат.Ссылка = Ссылка;
	Результат.Миниатюра = Источник.Item(5);
	Результат.ШиринаМиниатюры = Источник.Item(3);
	Результат.ВысотаМиниатюры = Источник.Item(2);
	Результат.Система = 1;
	ДополнительнаяИнф = СтрЗаменить(Источник.Item(4), "&amp;", "&");
	ДополнительнаяИнф = Лев(ДополнительнаяИнф, СтрДлина(ДополнительнаяИнф) - 1);
	Результат.Дополнительно = ДополнительнаяИнф;
	
КонецПроцедуры


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//													GOOGLE														//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Функция выполняет поиск картинок на сайте images.google.com
//
Функция НайтиКартинкиGoogle(ПараметрыПоиска, КоличествоЭлементов, НачальныйЭлемент)
	
	Попытка
		мRegExp = Новый COMОбъект("VBScript.RegExp");  
	Исключение	
		Отказ = Истина;
	КонецПопытки;

	мRegExp.IgnoreCase = Истина; //Игнорировать регистр
	мRegExp.Global = Истина; //Поиск всех вхождений шаблона	

	РезультатыПоиска = Новый Массив;
	
	ВремHTML = ПолучитьИмяВременногоФайла("html");
	
	Порция = 0; 
	Пока Порция < КоличествоЭлементов Цикл		
		
		// Запрос страницы HTML
		//Если НЕ ПолучитьСтраницу("images.google.ru/images?q=" + СтрЗаменить(СокрЛП(ПараметрыПоиска), " ", "+") + "&ndsp=20&start=" + (Порция + НачальныйЭлемент) +  "&filter=0&safe=Off", ВремHTML) Тогда
		Если НЕ ПолучитьСтраницу("ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&imgsz=medium&q=" + СтрЗаменить(СокрЛП(ПараметрыПоиска), " ", "+") + "&start=" + (Порция + НачальныйЭлемент), ВремHTML) Тогда
			Возврат Неопределено;	
		КонецЕсли;		
			
		Текст = "";		
		Если НЕ ПолучитьТекстИзФайла(ВремHTML, Текст) Тогда
			Возврат Неопределено;	
		КонецЕсли;
		
		ОписаниеОшибки = "";
		ДанныеСтр = ПарсингСтр(Текст, ОписаниеОшибки);
		
		Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
			Сообщить("Не удалось обработать данные:" + Символы.ПС + ОписаниеОшибки);
			Возврат Неопределено;
		КонецЕсли;
				
		ДанныеОбъекта = ДанныеСтр["responseData"];
		
		Если ДанныеОбъекта <> Неопределено Тогда
			
			ВложеннаяИнформация = ДанныеОбъекта["results"];
			
			Если ВложеннаяИнформация <> Неопределено Тогда
			
				Для Каждого Информация ИЗ ВложеннаяИнформация Цикл
				
					Результат = ПолучитьСтруктуруРезультата();
					ЗаполнитьРезультатGoogle(Результат, Информация);
					
					РезультатыПоиска.Добавить(Результат);
					Если РезультатыПоиска.Количество() = КоличествоЭлементов Тогда
						Прервать;
					КонецЕсли;
					
				КонецЦикла;
				
			//Иначе
			//	
			//	Сообщить("Получен ответ JSON неизвестного формата:" + Символы.ПС + ОписаниеОшибки);
			//	Возврат Неопределено;
				
			КонецЕсли;
			
		//Иначе
		//	
		//	Сообщить("Получен ответ JSON неизвестного формата:" + Символы.ПС + ОписаниеОшибки);
		//	Возврат Неопределено;
			
		КонецЕсли;
		
		//////Старое->
		//////РегулярноеВыражение = "imgres\?imgurl=(.*?)&amp;imgrefurl=(.*?)&amp;usg.*?&amp;h=(.*?)&amp;w=(.*?)&amp;sz=(.*?)&.*?;tbnid=(.*?):";	
		////РегулярноеВыражение = "<td style=.*?break-word"">.*?<a href=""/url\?q=(.*?)"".*?img height=""(.*?)"" src=""(.*?)"" width=""(.*?)""";
		////// Поиск регулярного выражения
		////мRegExp.Pattern = РегулярноеВыражение;
		////Matches = мRegExp.Execute(Текст);
		////Вхождений = Matches.Count;
		////Для Сч = 0 По Вхождений - 1 Цикл				
		////	SubMatches = Matches.Item(Сч).SubMatches;
		////	Если SubMatches.Count = 4 Тогда
		////		Результат = ПолучитьСтруктуруРезультата();
		////		ЗаполнитьРезультатGoogle(Результат, SubMatches);
		////		//Если ЯвляетсяГрафическимФорматом(Результат.Расширение) Тогда
		////			РезультатыПоиска.Добавить(Результат);
		////		//КонецЕсли;
		////		Если РезультатыПоиска.Количество() = КоличествоЭлементов Тогда
		////			Прервать;	
		////		КонецЕсли;
		////	КонецЕсли;
		////КонецЦикла;
		//////<-Старое
		
		
		
		Если РезультатыПоиска.Количество() = КоличествоЭлементов Тогда
			Прервать;	
		КонецЕсли;
					
		Порция = Порция + 20;
		
	КонецЦикла;
	
	УдалитьФайлы(ВремHTML);
	
	Возврат РезультатыПоиска;
	
КонецФункции

Функция ЯвляетсяГрафическимФорматом(Формат)
	
	ТекФормат = ВРег(Формат);
	
	СтрутураФорматов = Новый Массив;
	СтрутураФорматов.Добавить("JPEG");
	СтрутураФорматов.Добавить("JPG");
	СтрутураФорматов.Добавить("JPE");
	СтрутураФорматов.Добавить("GIF");
	СтрутураФорматов.Добавить("PNG");
	СтрутураФорматов.Добавить("TIFF");
	СтрутураФорматов.Добавить("TIF");
	СтрутураФорматов.Добавить("EPS");
		
	Если СтрутураФорматов.Найти(ТекФормат) = Неопределено Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Процедура заполняет структуру результата из SubMatch регулярного выражения
// Здесь получаются все основные параметры изображения
Процедура OLDЗаполнитьРезультатGoogle(Результат, Источник)
	
	Ссылка = Источник.Item(2);
	ВремСтроки = СтрЗаменить(Ссылка, "/", Символы.ПС);
	ЧислоВременныхСтрок = СтрЧислоСтрок(ВремСтроки);
	Если ЧислоВременныхСтрок > 1 Тогда
		ПолноеИмя = СтрПолучитьСтроку(ВремСтроки, ЧислоВременныхСтрок);
		ДопСтроки = СтрЗаменить(ПолноеИмя, ".", Символы.ПС);
		ЧислоДопСтрок = СтрЧислоСтрок(ДопСтроки);
		Если ЧислоДопСтрок > 1 Тогда
			Расширение = СтрПолучитьСтроку(ДопСтроки, ЧислоДопСтрок);
			Имя = "";
			Для Сч = 1 По ЧислоДопСтрок-1 Цикл
				Имя = Имя + СтрПолучитьСтроку(ДопСтроки, Сч) + ".";
			КонецЦикла;
			ДлинаИмени = СтрДлина(Имя);
			Если ДлинаИмени > 0 Тогда
				Имя	= Лев(Имя, ДлинаИмени - 1);
			КонецЕсли;
			Результат.Имя = ДекодироватьURL(Имя);
			Если Найти(Результат.Имя, "%") > 0 Тогда
				Результат.Имя = ДекодироватьURL(Имя, Истина);
			КонецЕсли;
			
			Результат.Имя = СтрЗаменить(Результат.Имя, "%25", "");
			Результат.Имя = СтрЗаменить(Результат.Имя, "%", "");
			
			Если СтрДлина(Результат.Имя) > 14 Тогда
				Результат.Имя = Лев(Результат.Имя, 14);
			КонецЕсли;
				
			Результат.Расширение = Расширение;
		КонецЕсли;		
		Результат.ПолноеИмя = ПолноеИмя;
	КонецЕсли;
	
	Результат.Ссылка = ДекодироватьURL(Ссылка);
	Если Найти(Результат.Ссылка,"%") > 0 Тогда
		 Результат.Ссылка = ДекодироватьURL(Ссылка, Ложь);
	КонецЕсли;
	
	Результат.Страница = Источник.Item(0);
	Результат.Высота = Источник.Item(1);
	Результат.Ширина = Источник.Item(3);
	//Результат.Размер = Источник.Item(4);
	//Результат.Миниатюра = "http://images.google.com/images?q=tbn:" + Источник.Item(5);
	Результат.Миниатюра = Источник.Item(2);
	//Результат.Система = 0;
	
КонецПроцедуры

Процедура ЗаполнитьРезультатGoogle(Результат, Источник)
	
	Ссылка = Источник["url"];
	ВремСтроки = СтрЗаменить(Ссылка, "/", Символы.ПС);
	ЧислоВременныхСтрок = СтрЧислоСтрок(ВремСтроки);
	Если ЧислоВременныхСтрок > 1 Тогда
		ПолноеИмя = СтрПолучитьСтроку(ВремСтроки, ЧислоВременныхСтрок);
		ДопСтроки = СтрЗаменить(ПолноеИмя, ".", Символы.ПС);
		ЧислоДопСтрок = СтрЧислоСтрок(ДопСтроки);
		Если ЧислоДопСтрок > 1 Тогда
			Расширение = СтрПолучитьСтроку(ДопСтроки, ЧислоДопСтрок);
			Имя = "";
			Для Сч = 1 По ЧислоДопСтрок-1 Цикл
				Имя = Имя + СтрПолучитьСтроку(ДопСтроки, Сч) + ".";
			КонецЦикла;
			ДлинаИмени = СтрДлина(Имя);
			Если ДлинаИмени > 0 Тогда
				Имя	= Лев(Имя, ДлинаИмени - 1);
			КонецЕсли;
			Результат.Имя = Имя;
			Результат.Расширение = Расширение;
		КонецЕсли;		
		Результат.ПолноеИмя = ПолноеИмя;
	КонецЕсли;
	
	Результат.Ссылка = Ссылка;
	Результат.Страница = Источник["originalContextUrl"];
	Результат.Высота = Источник["height"];
	Результат.Ширина = Источник["width"];
	Результат.Миниатюра = Источник["tbUrl"];
	Результат.ВысотаМиниатюры = Источник["tbHeight"];
	Результат.ШиринаМиниатюры = Источник["tbWidth"];
	Результат.Система = 0;
	
КонецПроцедуры


Функция Из16ВЧисло(Знач Значение)

    Результат = 0;
    Множитель = 1;
    Пока Значение <> "" Цикл
        Результат = Результат + Множитель * (Найти("0123456789ABCDEF", Прав(Значение,1))-1);
        Множитель = Множитель * 16;
        Значение = Лев(Значение,СтрДлина(Значение)-1);
    КонецЦикла;
    Возврат Результат;

КонецФункции

Функция ДекодироватьURL(URL, WindowsFileURI=Истина)

    ДлинаСтроки = СтрДлина(URL);
    Инд = 1;
    Результат = "";
    ПолныйКод = 0;
    ОсталосьСимволов = 0;

    Пока Инд <= ДлинаСтроки Цикл

        Код = КодСимвола(URL, Инд);

        Если Код = 37 Тогда
            // Символ(37) = "%"
            Код = Из16ВЧисло(Сред(URL, Инд+1, 2));
            Инд = Инд + 2;
        ИначеЕсли ОсталосьСимволов = 0 Тогда
            Если (Код = 43) и (не WindowsFileURI) Тогда
                // Символ(43) = "+"
                Код = 32; // Символ(32) = " " (пробел)
            КонецЕсли;
            Результат = Результат + Символ(Код);
            Инд = Инд + 1;
            Продолжить;
        КонецЕсли;

        Если Код <= 127 Тогда
            // Код = 0b0ххххххх
            Результат = Результат + Символ(Код);
        ИначеЕсли Код <= 191 Тогда
            // Код = 0b10хххххх
            ПолныйКод = (ПолныйКод*64) + (Код%64); // shl(ПолныйКод, 6) + (Код & 0x3F)
            ОсталосьСимволов = ОсталосьСимволов - 1;
            Если ОсталосьСимволов = 0 Тогда
                Результат = Результат + Символ(ПолныйКод);
            КонецЕсли;
        ИначеЕсли Код <= 223 Тогда
            // Код = 0b110ххххх
            ПолныйКод = Код % 32; // Код & 0x1F
            ОсталосьСимволов = 1;
        ИначеЕсли Код <= 239 Тогда
            // Код = 0b1110хххх
            ПолныйКод = Код % 16; // Код & 0x0F
            ОсталосьСимволов = 2;
        ИначеЕсли Код <= 247 Тогда
            // Код = 0b11110ххх
            ПолныйКод = Код % 8; // Код & 0x07
            ОсталосьСимволов = 3;
        ИначеЕсли Код <= 251 Тогда
            // Код = 0b111110хх
            ПолныйКод = Код % 4; // Код & 0x03
            ОсталосьСимволов = 4;
        ИначеЕсли Код <= 253 Тогда
            // Код = 0b1111110х
            ПолныйКод = Код % 2; // Код & 0x01
            ОсталосьСимволов = 5;
        КонецЕсли;

        Инд = Инд + 1;
    КонецЦикла;

    Возврат Результат;
КонецФункции