﻿
#Область УтвердитьОтклонить
&НаСервере
Функция НайтиСоздатьФизЛицо(отказ)
	
	фио = "" + Объект.Фамилия + " " + Объект.Имя + " " + Объект.Отчество;
	
	запрос = Новый Запрос;
	
	запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ФизическиеЛица.Ссылка
	|ИЗ
	|	Справочник.ФизическиеЛица КАК ФизическиеЛица
	|ГДЕ
	|	ФизическиеЛица.Наименование ПОДОБНО &ФИО";
	
	запрос.УстановитьПараметр("ФИО",фио);
	
	результат = запрос.Выполнить();
	
	Если Не результат.Пустой() Тогда
		
		выборка = результат.Выбрать();
		выборка.Следующий();
		
		физЛицо = выборка.Ссылка;
		
	Иначе
		
		новыйФизЛицо = Справочники.ФизическиеЛица.СоздатьЭлемент();
		
		новыйФизЛицо.Наименование = фио;
		новыйФизЛицо.Телефон = Объект.Телефон;
		
		новыйФизЛицо.Записать();
		
		физЛицо = новыйФизЛицо.Ссылка;
		
	КонецЕсли;
	
	Возврат физЛицо;
	
КонецФункции

&НаСервере
Функция ПодразделениеДляКонтрагентПолучить()
	
	Позиция = Найти(Строка(Объект.Подразделение),"(");
	
	Если Позиция = 0 Тогда
		подразделение = Объект.Подразделение;
	Иначе
		подразделение = Справочники.СтруктурныеЕдиницы.НайтиПоНаименованию(СокрЛП(Лев(Объект.Подразделение, Позиция - 1)), Истина);
	КонецЕсли;
	
	Возврат подразделение;
	
КонецФункции

&НаСервере
Функция КонтрагентыИерархияНайтиРодитель(отказ)
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Контрагенты.Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Наименование = ""Работники""
	|	И Контрагенты.Подразделение = &Подразделение";
	#КонецОбласти
	
	запрос.УстановитьПараметр("Подразделение",ПодразделениеДляКонтрагентПолучить());
	
	результат = запрос.Выполнить();
	Если Не результат.Пустой() Тогда
		
		выборка = результат.Выбрать();
		выборка.Следующий();
		
		контрагентРодитель = выборка.Ссылка;
		
	Иначе
		
		отказ = Истина;
		
		Сообщить("Не найдена директория ""Работники"" для подразделения " + Объект.Подразделение);
		
		контрагентРодитель = Справочники.Контрагенты.ПустаяСсылка();
		
	КонецЕсли;
	
	Возврат контрагентРодитель;
	
КонецФункции

&НаСервере
Функция НайтиСоздатьКонтрагент(отказ)
	
	наименование = "" + Объект.Должность + " " + Объект.Фамилия + " " + Лев(Объект.Имя,1) + ". " + Лев(Объект.Отчество,1) + ".";
	наименованиеПолное = "" + Объект.Должность + Объект.Фамилия + " " + Объект.Имя + " " + Объект.Отчество;
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Контрагенты.Ссылка
	|ИЗ
	|	Справочник.Контрагенты КАК Контрагенты
	|ГДЕ
	|	Контрагенты.Наименование = &Наименование
	|	И Контрагенты.НаименованиеПолное ПОДОБНО &НаименованиеПолное";
	#КонецОбласти
	
	запрос.УстановитьПараметр("Наименование",наименование);
	запрос.УстановитьПараметр("НаименованиеПолное",наименованиеПолное);
	
	результат = запрос.Выполнить();
	
	Если Не результат.Пустой() Тогда
		
		выборка = результат.Выбрать();
		выборка.Следующий();
		
		контрагент = выборка.Ссылка
		
	Иначе
		
		новыйКонтрагент = Справочники.Контрагенты.СоздатьЭлемент();
		
		новыйКонтрагент.Наименование = наименование;
		новыйКонтрагент.НаименованиеПолное = наименованиеПолное;
		новыйКонтрагент.ТипВеденияВзаиморасчетов = Перечисления.ТипыВеденияВзаиморасчетов.ПоДоговору;
		новыйКонтрагент.Покупатель = Истина;
		новыйКонтрагент.ЭтоСотрудник = Истина;
		
		новыйСтрокаМенеджеры = новыйКонтрагент.Менеджеры.Добавить();
		новыйСтрокаМенеджеры.Менеджер = Справочники.Менеджеры.БезМенеджера;
		новыйСтрокаМенеджеры.ГруппаПродукта = Справочники.КД_ГруппыНоменклатуры.НайтиПоНаименованию("МКИ", Истина);
		новыйСтрокаМенеджеры.ТипЦен = Справочники.ТипыЦен.НайтиПоКоду("000000010");
		новыйСтрокаМенеджеры.ОсновнаяОрганизация = Справочники.Организации.НайтиПоНаименованию("Седельников",Истина);
		
		новыйКонтрагент.КД_КаналСбыта = Справочники.КД_КаналыСбыта.НайтиПоНаименованию("Сотрудники", Истина);
		новыйКонтрагент.КД_Состояние = Справочники.КД_СостоянияТТ.НайтиПоКоду("000000001");
		
		новыйКонтрагент.Родитель = КонтрагентыИерархияНайтиРодитель(отказ);
		
		новыйКонтрагент.Записать();
		
	КонецЕсли;
	
	Возврат контрагент;
	
КонецФункции

&НаСервере
Функция СотрудникиИерархияНайтиРодитель()
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Сотрудники.Ссылка
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|ГДЕ
	|	Сотрудники.Родитель = ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка)
	|	И Сотрудники.ЭтоГруппа
	|	И Сотрудники.СтруктурнаяЕдиница = &СтруктурнаяЕдиница";
	#КонецОбласти
	
	запрос.УстановитьПараметр("СтруктурнаяЕдиница", Объект.Подразделение);
	
	результат = запрос.Выполнить();
	
	Если Не результат.Пустой() Тогда
		
		выборка = результат.Выбрать();
		выборка.Следующий();
		
		родитель = выборка.Ссылка;
		
	Иначе
		
		родитель = Справочники.Сотрудники.ПустаяСсылка();
		
	КонецЕсли;
	
	Возврат родитель;
	
КонецФункции

&НаСервере
Функция НайтиСоздатьСотрудник(отказ, контрагент)
	
	наименование = "" + Объект.Фамилия + " " + Объект.Имя + " " + Объект.Отчество;
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Сотрудники.Ссылка
	|ИЗ
	|	Справочник.Сотрудники КАК Сотрудники
	|ГДЕ
	|	Сотрудники.Наименование = &Наименование
	|	И Сотрудники.Контрагент = &Контрагент
	|	И Сотрудники.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
	|	И Сотрудники.КатегорияРаботника = &КатегорияРаботника
	|	И Сотрудники.Должность = &Должность
	|	И Сотрудники.ФизЛицо = &ФизЛицо";
	#КонецОбласти
	
	запрос.УстановитьПараметр("Наименование", наименование);
	запрос.УстановитьПараметр("Контрагент", контрагент);
	запрос.УстановитьПараметр("СтруктурнаяЕдиница", Объект.Подразделение);
	запрос.УстановитьПараметр("КатегорияРаботника", Объект.Категория);
	запрос.УстановитьПараметр("Должность", Объект.Должность);
	запрос.УстановитьПараметр("ФизЛицо", Объект.ФизЛицо);
	
	результат = запрос.Выполнить();
	
	Если Не результат.Пустой() Тогда
		
		выборка = результат.Выбрать();
		выборка.Следующий();
		
		сотрудник = выборка.Ссылка
		
	Иначе
		
		новыйСотрудник = Справочники.Сотрудники.СоздатьЭлемент();
		
		новыйСотрудник.Наименование = наименование;
		новыйСотрудник.СтруктурнаяЕдиница = Объект.Подразделение;
		новыйСотрудник.Контрагент = контрагент;
		новыйСотрудник.ФизЛицо = Объект.ФизЛицо;
		новыйСотрудник.КатегорияРаботника = Объект.Категория;
		новыйСотрудник.Должность = Объект.Должность;
		
		новыйСтрокаПлановыеНачисления = новыйСотрудник.ПлановыеНачисления.Добавить();
		новыйСтрокаПлановыеНачисления.ВидРасчета = Справочники.ВидыРасчетов.Оклад;
		
		новыйСотрудник.Родитель = СотрудникиИерархияНайтиРодитель();
		
		новыйСотрудник.Записать();
		
		сотрудник = новыйСотрудник.Ссылка;
		
	КонецЕсли;
	
	Возврат сотрудник;
	
КонецФункции

&НаСервере
Процедура УтвердитьНаСервере()
	
	отказ = Ложь;
	
	НачатьТранзакцию();
	
	Объект.ФизЛицо = НайтиСоздатьФизЛицо(отказ);
	контрагент = НайтиСоздатьКонтрагент(отказ);
	сотрудник = НайтиСоздатьСотрудник(отказ, контрагент);
	
	Если Не отказ Тогда
		
		ЗафиксироватьТранзакцию();
		
		Объект.Контрагент = контрагент;
		Объект.Сотрудник = сотрудник;
		
	Иначе
		ОтменитьТранзакцию();
	КонецЕсли;
	
	Объект.Статус = Перечисления.СтатусыБизнесПроцессыЗадачи.Утвержден;
	
	Записать();
	
	Объект.Ссылка.ПолучитьОбъект().ВыполнитьЗадачу();
	
КонецПроцедуры

&НаСервере
Функция УтвердитьЗавершение()
	
	запрос = Новый Запрос;
	
	#Область ТекстЗапроса
	запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПриказПриемНаРаботу.Ссылка
	|ИЗ
	|	Задача.ПриказПриемНаРаботу КАК ПриказПриемНаРаботу
	|ГДЕ
	|	ПриказПриемНаРаботу.БизнесПроцесс = &БизнесПроцесс
	|	И НЕ ПриказПриемНаРаботу.Выполнена
	|	И ПриказПриемНаРаботу.Ссылка <> &Ссылка";
	#КонецОбласти
	
	запрос.УстановитьПараметр("БизнесПроцесс", Объект.БизнесПроцесс);
	запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	результат = запрос.Выполнить();
	
	Если Не результат.Пустой() Тогда
		
		выборка = результат.Выбрать();
		выборка.Следующий();
		
		Возврат выборка.Ссылка;
		
	КонецЕсли;

КонецФункции

&НаКлиенте
Процедура Утвердить(Команда)
	
	УтвердитьНаСервере();
	
	ФормаДополнение = ПолучитьФорму("Задача.ПриказПриемНаРаботу.Форма.ФормаЗадачиДополнение",Новый Структура("Ключ",УтвердитьЗавершение()),ЭтаФорма);
	ФормаДополнение.ЗакрыватьПриЗакрытииВладельца = Ложь;
	
	ФормаДополнение.Открыть();
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ОтклонитьНаСервере()
	
	Объект.Статус = Перечисления.СтатусыБизнесПроцессыЗадачи.Отклонен;
	
	Объект.Ссылка.ПолучитьОбъект().ВыполнитьЗадачу();
	
КонецПроцедуры

&НаКлиенте
Процедура Отклонить(Команда)
	
	ОтклонитьНаСервере();
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры
#КонецОбласти