﻿
#Область ОбработчикиСобытий

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КлючОбъекта = Параметры.КлючОбъекта;
	КлючТекущихНастроек = Параметры.КлючТекущихНастроек;
	
	РанееСохранённыеНастройки.Параметры.УстановитьЗначениеПараметра("КлючОбъекта", КлючОбъекта);
	РанееСохранённыеНастройки.Параметры.УстановитьЗначениеПараметра("Пользователь", ПараметрыСеанса.ТекущийПользователь);
	
	Если ЗначениеЗаполнено(КлючТекущихНастроек) Тогда
		Элементы.РанееСохранённыеНастройки.ТекущаяСтрока = КлючТекущихНастроек;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура РанееСохранённыеНастройкиВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СохранитьНастройкуОтчёта();
	
КонецПроцедуры

&НаКлиенте
Процедура РанееСохранённыеНастройкиПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ИмяСохраняемойНастройки = Элемент.ТекущиеДанные.Наименование;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура РанееСохранённыеНастройкиПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура РанееСохранённыеНастройкиПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
	Если Элемент.ВыделенныеСтроки.Количество() > 0 Тогда
		ОтчётыКлиент.ПоказатьВопросОбУдаленииНастроекОтчётов(Элемент.ВыделенныеСтроки, Элемент);
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяСохраняемойНастройкиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	Элементы.РанееСохранённыеНастройки.ТекущаяСтрока = НайтиНастройкуОтчётаПоИмени(Текст, КлючОбъекта);
КонецПроцедуры

#КонецОбласти

#Область ДействияКоманд

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьНастройкуОтчёта();
КонецПроцедуры

#КонецОбласти

#Область ДополнительныеПроцедурыИФункции

// Выполняет поиск уже существующей настройки отчёта с указанным именем.
//
// Параметры
//  ИмяНастройкиОтчёта  - Строка - Имя настройки отчёта для поиска.
//  КлючОбъекта  - Строка - Ключ объекта (отчёта), для которого производится поиск
//                 по имени.
//
// Возвращаемое значение:
//   СправочникСсылка.НастройкиОтчётов, Неопределено   - Возвращает настройку отчёта при
//                 положительном результате поиска. Если совпадение не найдено, будет
//                 возвращено значение Неопределено.
//
&НаСервереБезКонтекста
Функция НайтиНастройкуОтчётаПоИмени(ИмяНастройкиОтчёта, КлючОбъекта)

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиОтчётов.Ссылка
	|ИЗ
	|	Справочник.НастройкиОтчётов КАК НастройкиОтчётов
	|ГДЕ
	|	НастройкиОтчётов.КлючОбъекта = &КлючОбъекта
	|	И НастройкиОтчётов.Наименование = &Наименование
	|	И НастройкиОтчётов.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("КлючОбъекта", КлючОбъекта);
	Запрос.УстановитьПараметр("Наименование", ИмяНастройкиОтчёта);
	Запрос.УстановитьПараметр("Пользователь", ПараметрыСеанса.ТекущийПользователь);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат Неопределено;
	Иначе
	
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	
	КонецЕсли; 

КонецФункции // НайтиНастройкуОтчётаПоИмени()

// Создаёт новый элемент справочника "НастройкиОтчётов" с соответствующим ключом объекта.
//
// Параметры
//  ИмяНастройкиОтчёта  - Строка - Имя создаваемой настройки отчёта.
//  КлючОбъекта  - Произвольный - Ключ объекта создаваемой настройки отчёта.
//
// Возвращаемое значение:
//   СправочникСсылка.НастройкиОтчётов   - Созданная настройка отчёта.
//
&НаСервереБезКонтекста
Функция СоздатьНовуюНастройкуОтчёта(ИмяНастройкиОтчёта, КлючОбъекта)

	НастройкиОтчётовОбъект = Справочники.НастройкиОтчётов.СоздатьЭлемент();
	НастройкиОтчётовОбъект.Наименование = ИмяНастройкиОтчёта;
	НастройкиОтчётовОбъект.КлючОбъекта = КлючОбъекта;
	НастройкиОтчётовОбъект.Записать();
	
	Возврат НастройкиОтчётовОбъект.Ссылка;

КонецФункции // СоздатьНовуюНастройкуОтчёта()

// Инициирует сохранение настройки отчёта в информационной базе.
//
&НаКлиенте
Процедура СохранитьНастройкуОтчёта()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли; 
	
	СохраняемаяНастройка = НайтиНастройкуОтчётаПоИмени(ИмяСохраняемойНастройки, КлючОбъекта);
	
	Если СохраняемаяНастройка <> Неопределено Тогда
	
		// Настройка с таким именем уже существует.
		ОписаниеОповещения = Новый ОписаниеОповещения("ОбработатьВопросОЗаменеНастройкиОтчёта", ЭтотОбъект, СохраняемаяНастройка);
		
		ТекстСообщения = НСтр("ru = 'Заменить настройку отчёта ""[ИмяСохраняемойНастройки]""?'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "[ИмяСохраняемойНастройки]", ИмяСохраняемойНастройки);
		ПоказатьВопрос(ОписаниеОповещения, ТекстСообщения, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	
	Иначе
	
		// Создаём новую настройку отчёта.
		СохраняемаяНастройка = СоздатьНовуюНастройкуОтчёта(ИмяСохраняемойНастройки, КлючОбъекта);
		ВернутьСохраняемуюНастройкуОтчёта(СохраняемаяНастройка)
	
	КонецЕсли; 

КонецПроцедуры // СохранитьНастройкуОтчёта()

// Процедура возвращает сохраняемую настройку отчёта в вызывающий модуль.
//
// Параметры:
//  СохраняемыйВариант  - СправочникСсылка.НастройкиОтчётов - Сохраняемая настройка отчёта.
//
&НаКлиенте
Процедура ВернутьСохраняемуюНастройкуОтчёта(СохраняемаяНастройка)

	Закрыть(Новый ВыборНастроек(СохраняемаяНастройка));

КонецПроцедуры // ВернутьСохраняемуюНастройкуОтчёта()

// Процедура обратного вызова для обработки вопроса о необходимости замены настройки
// отчёта.
//
// Параметры:
//  РезультатВопроса  - КодВозвратаДиалога, Неопределено - Результат выбора пользователя.
//                 Если пользователь отказался от выбора будет возвращено значение
//                 Неопределено.
//  СохраняемаяНастройка  - СправочникСсылка.НастройкиОтчётов - Сохраняемая настройка отчёта.
//
&НаКлиенте
Процедура ОбработатьВопросОЗаменеНастройкиОтчёта(РезультатВопроса, СохраняемаяНастройка) Экспорт

	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ВернутьСохраняемуюНастройкуОтчёта(СохраняемаяНастройка);	
	КонецЕсли; 

КонецПроцедуры // ОбработатьВопросОЗаменеНастройкиОтчёта()

#КонецОбласти
