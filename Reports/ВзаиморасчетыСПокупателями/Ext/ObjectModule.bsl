﻿Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	ДокументРезультат.ОриентацияСтраницы=ОриентацияСтраницы.Портрет;
   	ДокументРезультат.АвтоМасштаб = Истина;
	
	СтандартнаяОбработка = Ложь;
	
	МассивЗаголовковРесурсов = Новый Массив;
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	//Создадим и инициализируем процессор компоновки, предварительно проверим параметры
	Если НЕ МакетКомпоновки.ЗначенияПараметров.Найти("НачалоПериода") = Неопределено 
		И НЕ МакетКомпоновки.ЗначенияПараметров.Найти("КонецПериода") = Неопределено 
		И НЕ МакетКомпоновки.ЗначенияПараметров["НачалоПериода"].Значение = Дата(1,1,1)
		И НЕ МакетКомпоновки.ЗначенияПараметров["КонецПериода"].Значение = Дата(1,1,1)
		И МакетКомпоновки.ЗначенияПараметров["НачалоПериода"].Значение > МакетКомпоновки.ЗначенияПараметров["КонецПериода"].Значение Тогда
		
		Сообщение	 		= Новый СообщениеПользователю;
		Сообщение.Текст	 	= "Дата начала периода не должна превышать дату окончания";
		Сообщение.Сообщить();
		
		Возврат;
		
	КонецЕсли;

	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	//Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	//Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	ТаблицаЗафиксирована = Ложь;

	ДокументРезультат.ФиксацияСверху = 0;
	//Основной цикл вывода отчета
	Пока Истина Цикл
		//Получим следующий элемент результата компоновки
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();

		Если ЭлементРезультата = Неопределено Тогда
			//Следующий элемент не получен - заканчиваем цикл вывода
			Прервать;
		Иначе
			// Зафиксируем шапку
			Если  Не ТаблицаЗафиксирована 
				  И ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
				  И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) <> Тип("ДиаграммаКомпоновкиДанных") Тогда

				ТаблицаЗафиксирована = Истина;
				ДокументРезультат.ФиксацияСверху = ДокументРезультат.ВысотаТаблицы;

			КонецЕсли;
			//Элемент получен - выведем его при помощи процессора вывода
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		КонецЕсли;
	КонецЦикла;

	ПроцессорВывода.ЗакончитьВывод();

КонецПроцедуры
