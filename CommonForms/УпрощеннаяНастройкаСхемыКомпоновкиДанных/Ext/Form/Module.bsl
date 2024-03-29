﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(отказ, стандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Переданный в параметре адрес сохраняется в качестве адреса исходной схемы
	АдресИсходнойСхемыКомпоновкиДанных = Параметры.АдресСхемыКомпоновкиДанных;
	УникальныйИдентификаторВладельца = Параметры.УникальныйИдентификатор;
	
	// Заголовок формы
	Заголовок = Параметры.Заголовок;
	
	ИмяТекущегоШаблонаСКД           	  = Параметры.ИмяШаблонаСКД;
	ВозвращатьИмяТекущегоШаблонаСКД 	  = Параметры.ВозвращатьИмяТекущегоШаблонаСКД;
	ВозвращатьПолноеИмяТекущегоШаблонаСКД = Параметры.ВозвращатьПолноеИмяТекущегоШаблонаСКД;
	
	// Заполнение списка шаблонов
	Если НЕ Параметры.ИсточникШаблонов = Неопределено Тогда
		
		ПолноеИмяИсточникаШаблонов = ОбщегоНазначения.ИмяТаблицыПоСсылке(Параметры.ИсточникШаблонов);
		МенеджерИсточникаШаблонов = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Параметры.ИсточникШаблонов);
		
		Для каждого МакетШаблона из МенеджерИсточникаШаблонов.ШаблоныСхемыКомпоновкиДанных() Цикл
			
			новаяСтрока = Шаблоны.Добавить();
			новаяСтрока.Синоним = МакетШаблона.Синоним;
			новаяСтрока.Имя = МакетШаблона.Имя;
			
			Если МакетШаблона.Свойство("ПолноеИмяИсточникаШаблонов") И ЗначениеЗаполнено(МакетШаблона.ПолноеИмяИсточникаШаблонов) Тогда				
				новаяСтрока.ПолноеИмяИсточникаШаблонов = МакетШаблона.ПолноеИмяИсточникаШаблонов;				
			Иначе
				новаяСтрока.ПолноеИмяИсточникаШаблонов = ПолноеИмяИсточникаШаблонов;			
			КонецЕсли; 
			
			новаяСтрока.ПолноеИмя = НоваяСтрока.ПолноеИмяИсточникаШаблонов + "." + НоваяСтрока.Имя;
			
			Если ВозвращатьПолноеИмяТекущегоШаблонаСКД Тогда
				Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.Добавить(НоваяСтрока.ПолноеИмя, НоваяСтрока.Синоним);
			Иначе
				Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.Добавить(НоваяСтрока.Имя, НоваяСтрока.Синоним);
			КонецЕсли; 			
			
		КонецЦикла;
		
		Если ПустаяСтрока(ИмяТекущегоШаблонаСКД) Тогда
			
			Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.Добавить("", НСтр("ru = 'Произвольная'"));
			
		КонецЕсли;
		
		ТекущийШаблонСхемыКомпоновкиДанных = ИмяТекущегоШаблонаСКД;
		Элементы.ТекущийШаблонСхемыКомпоновкиДанных.Видимость = Истина;
		
	Иначе
		
		Элементы.ТекущийШаблонСхемыКомпоновкиДанных.Видимость = Ложь;
		
	КонецЕсли;
	
	// Исходная схема компоновки данных копируется в редактируемую схему компоновки данных
	СкопироватьСхемуКомпоновкиДанных(АдресРедактируемойСхемыКомпоновкиДанных, АдресИсходнойСхемыКомпоновкиДанных);
	
	// Компоновщик настроек инициализируется редактируемой схемой компоновки данных
	ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, АдресРедактируемойСхемыКомпоновкиДанных, Параметры.АдресНастроекКомпоновкиДанных);
	
	Элементы.РедактироватьСхемуКомпоновки.Видимость = Не Параметры.НеРедактироватьСхемуКомпоновкиДанных;
	Элементы.ГруппаОтбор.Видимость                  = Не Параметры.НеНастраиватьОтбор;
	Элементы.ГруппаПараметры.Видимость              = Не Параметры.НеНастраиватьПараметры;
	Элементы.ГруппаПорядок.Видимость                = Не Параметры.НеНастраиватьПорядок;
	Элементы.ГруппаУсловноеОформление.Видимость     = Не Параметры.НеНастраиватьУсловноеОформление;
	Элементы.ГруппаПоля.Видимость                   = Не Параметры.НеНастраиватьВыбор;
	
	//Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
	//	Элементы.РедактироватьСхемуКомпоновки.Видимость = Ложь;		
	//	Элементы.ФормаЗагрузитьСхемуИзФайла.Видимость = Ложь;	
	//КонецЕсли; 
	
	НеПомещатьНастройкиВСхемуКомпоновкиДанных = Параметры.НеПомещатьНастройкиВСхемуКомпоновкиДанных;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(выбранноеЗначение, источникВыбора)
	
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
		
		ИзмененаСхемаКомпоновкиДанных(ЭтаФорма, выбранноеЗначение);
		
	#КонецЕсли
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытий

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборПриИзменении(элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиОтборДоступныеПоляОтбораВыбор(элемент, выбраннаяСтрока, поле, стандартнаяОбработка)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура КомпоновщикНастроекНастройкиПараметрыДанныхПриИзменении(элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиКоманд

&НаКлиенте
Процедура ЗавершитьРедактирование(команда)
	
	Если РедактируемаяСхемаКомпоновкиДанныхМодифицированность Тогда
		
		Если Не НеПомещатьНастройкиВСхемуКомпоновкиДанных Тогда
			
			// Настройки компоновщика настроек помещаются в редактируемую схему
			ПоместитьНастройкиВСхемуКомпоновкиДанных(КомпоновщикНастроек, АдресРедактируемойСхемыКомпоновкиДанных);
			
		КонецЕсли;
		
		// Исходная схема замещается редактируемой схемой
		УстановитьСхемуКомпоновкиДанных(АдресИсходнойСхемыКомпоновкиДанных, АдресРедактируемойСхемыКомпоновкиДанных);
		
	Иначе
		
		// Настройки компоновщика настроек помещаются в исходную схему
		Если Не НеПомещатьНастройкиВСхемуКомпоновкиДанных Тогда
			
			ПоместитьНастройкиВСхемуКомпоновкиДанных(КомпоновщикНастроек, АдресИсходнойСхемыКомпоновкиДанных);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Модифицированность = Ложь;
	
	Если ВозвращатьИмяТекущегоШаблонаСКД И ЗначениеЗаполнено(УникальныйИдентификаторВладельца) Тогда
		
		Закрыть(СформироватьСтруктуруВозврата());
		
	ИначеЕсли ЗначениеЗаполнено(УникальныйИдентификаторВладельца) Тогда
		
		Закрыть(ПолучитьНастрокиКомпоновщика(КомпоновщикНастроек, УникальныйИдентификаторВладельца));
		
	Иначе
		
		Закрыть(Неопределено);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьСхемуКомпоновки(Команда)
	
	ОткрытьКонструкторСхемыКомпоновкиДанных();
	
КонецПроцедуры

&НаКлиенте
Процедура ТекущийШаблонСхемыКомпоновкиДанныхОбработкаВыбора(элемент, выбранноеЗначение, стандартнаяОбработка)
	
	Если ВыбранноеЗначение <> Неопределено И ВыбранноеЗначение <> ИмяТекущегоШаблонаСКД Тогда
		
		ТекстВопроса = НСтр("ru='Текущие настройки будут потеряны. Продолжить?'");
		Результат = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
		Если Результат = КодВозвратаДиалога.Да Тогда
			
			Если ВозвращатьПолноеИмяТекущегоШаблонаСКД Тогда
				НайденныеСтроки = Шаблоны.НайтиСтроки(Новый Структура("ПолноеИмя", ВыбранноеЗначение));			
			Иначе
				НайденныеСтроки = Шаблоны.НайтиСтроки(Новый Структура("Имя", ВыбранноеЗначение));			
			КонецЕсли;			
			
			Если НайденныеСтроки.Количество() = 0 Тогда
				СтандартнаяОбработка = Ложь;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru='Ошибка загрузки шаблона. Выберите другой шаблон.'"),
					,"ТекущийШаблонСхемыКомпоновкиДанных");
				Возврат;				
			КонецЕсли; 
			ЗагрузитьИзМакета(НайденныеСтроки[0].ПолноеИмяИсточникаШаблонов, НайденныеСтроки[0].Имя, КомпоновщикНастроек, АдресРедактируемойСхемыКомпоновкиДанных);
			Модифицированность = Истина;
			РедактируемаяСхемаКомпоновкиДанныхМодифицированность = Истина;
			ИмяТекущегоШаблонаСКД = ВыбранноеЗначение;			
			
			ПустойЭлемент =  Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.НайтиПоЗначению("");
			Если ПустойЭлемент <> Неопределено Тогда
				Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.Удалить(ПустойЭлемент);
			КонецЕсли;
			
		Иначе
			
			СтандартнаяОбработка = Ложь;
			ТекущийШаблонСхемыКомпоновкиДанных = ИмяТекущегоШаблонаСКД;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти 

#Область ДополнительныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьКонструкторСхемыКомпоновкиДанных()
	
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
		
		// Настройки компоновщика настроек помещаются в редактируемую схему
		Если Не НеПомещатьНастройкиВСхемуКомпоновкиДанных Тогда
			ПоместитьНастройкиВСхемуКомпоновкиДанных(КомпоновщикНастроек, АдресРедактируемойСхемыКомпоновкиДанных);
		КонецЕсли;
		
		// Создается копия редактируемой схемы
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXDTO(СериализаторXDTO.ЗаписатьXDTO(ПолучитьИзВременногоХранилища(АдресРедактируемойСхемыКомпоновкиДанных)));
		
		// Копия редактируемой схемы открывается в конструкторе
		Конструктор = Новый КонструкторСхемыКомпоновкиДанных(СхемаКомпоновкиДанных);
		Конструктор.Редактировать(ЭтаФорма);
		
	#Иначе
		
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Для того, чтобы редактировать схему компоновки, необходимо запустить конфигурацию в режиме толстого клиента.'"));
		
	#КонецЕсли
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УстановитьСхемуКомпоновкиДанных(АдресПриемник, АдресСхемаИсточник, ПроверятьНаИзменение = Ложь, БылиИзменения = Ложь)
	
	Если ЭтоАдресВременногоХранилища(АдресСхемаИсточник) Тогда
		
		СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемаИсточник);
		
	Иначе
		
		СхемаКомпоновкиДанных = АдресСхемаИсточник;
		
	КонецЕсли;
	
	Если ПроверятьНаИзменение Тогда
		
		БылиИзменения = Ложь;
		
		Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
			
			ТекущаяСКД = ПолучитьИзВременногоХранилища(АдресПриемник);
			Если ТипЗнч(ТекущаяСКД) = Тип("СхемаКомпоновкиДанных") Тогда
				
				Если СегментыСервер.ПолучитьXML(СхемаКомпоновкиДанных) <> СегментыСервер.ПолучитьXML(ТекущаяСКД) Тогда
					
					БылиИзменения = Истина;
					
				КонецЕсли
				
			Иначе
				
				БылиИзменения = Истина;
				
			КонецЕсли;
			
		Иначе
			
			БылиИзменения = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
		
		ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресПриемник);
		
	Иначе
		
		АдресПриемник = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура СкопироватьСхемуКомпоновкиДанных(АдресПриемник, АдресИсточник)
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресИсточник);
	
	Если ТипЗнч(СхемаКомпоновкиДанных) = Тип("СхемаКомпоновкиДанных") Тогда
		
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXDTO(СериализаторXDTO.ЗаписатьXDTO(СхемаКомпоновкиДанных));
		
	Иначе
		
		СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
		
	КонецЕсли;
	
	Если ЭтоАдресВременногоХранилища(АдресПриемник) Тогда
		
		ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресПриемник);
		
	Иначе
		
		АдресПриемник = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, АдресСхемыКомпоновкиДанных, АдресНастроекКомпоновкиДанных = Неопределено)
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	Если ЗначениеЗаполнено(АдресНастроекКомпоновкиДанных) Тогда
		НастройкиКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресНастроекКомпоновкиДанных);
	КонецЕсли;
	
	Попытка
		КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных));
	Исключение
	КонецПопытки;
	
	Если ЗначениеЗаполнено(АдресНастроекКомпоновкиДанных) Тогда
		КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиКомпоновкиДанных);
	Иначе
		КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КонецЕсли;
	
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПоместитьНастройкиВСхемуКомпоновкиДанных(КомпоновщикНастроек, АдресСхемыКомпоновкиДанных)
	
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(АдресСхемыКомпоновкиДанных);
	
	КомпоновкаДанныхКлиентСервер.ОчиститьНастройкиКомпоновкиДанных(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	КомпоновкаДанныхКлиентСервер.СкопироватьНастройкиКомпоновкиДанных(СхемаКомпоновкиДанных.НастройкиПоУмолчанию, КомпоновщикНастроек.ПолучитьНастройки());
	
	ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, АдресСхемыКомпоновкиДанных);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьНастрокиКомпоновщика(КомпоновщикНастроек, УникальныйИдентификатор)
	
	КомпоновщикНастроек.Восстановить(СпособВосстановленияНастроекКомпоновкиДанных.ПроверятьДоступность);
	
	Возврат ПоместитьВоВременноеХранилище(КомпоновщикНастроек.ПолучитьНастройки(), УникальныйИдентификатор);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗагрузитьИзМакета(ПолноеИмяИсточникаШаблонов, ИмяМакета, КомпоновщикНастроек, АдресСхемыКомпоновкиДанных)
	
	ПоместитьВоВременноеХранилище(ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ПолноеИмяИсточникаШаблонов).ПолучитьМакет(ИмяМакета), АдресСхемыКомпоновкиДанных);
	ИнициализироватьКомпоновщикНастроек(КомпоновщикНастроек, АдресСхемыКомпоновкиДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		Ответ = Вопрос(НСтр("ru='При закрытии формы введенная в нее информация будет утеряна. Закрыть?'"),РежимДиалогаВопрос.ДаНет);
		Если Ответ <> КодВозвратаДиалога.Да Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСхемуИзФайлаНаСервере(ТекстXML)
	
	Попытка
		
		ЧтениеXML = Новый ЧтениеXML();
		ЧтениеXML.УстановитьСтроку(ТекстXML);
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		ИзмененаСхемаКомпоновкиДанных(ЭтаФорма, СхемаКомпоновкиДанных);
		
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСхемуИзФайлаНаСервереВеб(АдресФайлаВоВременномХранилище)
	
	Попытка
		
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВоВременномХранилище);
		
		ИмяВременногоФайла = ПолучитьИмяВременногоФайла("xml");
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.Прочитать(ИмяВременногоФайла, КодировкаТекста.UTF8);
		ТекстXML = ТекстовыйДокумент.ПолучитьТекст();
		
		ЧтениеXML = Новый ЧтениеXML();
		ЧтениеXML.УстановитьСтроку(ТекстXML);
		
		СхемаКомпоновкиДанных = СериализаторXDTO.ПрочитатьXML(ЧтениеXML);
		ИзмененаСхемаКомпоновкиДанных(ЭтаФорма, СхемаКомпоновкиДанных);
		
	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайла(Команда)
	
	ОбщегоНазначенияКлиент.ПредложитьУстановкуРасширенияРаботыСФайлами();
	
	НачатьПодключениеРасширенияРаботыСФайлами(Новый ОписаниеОповещения("ЗагрузитьСхемуИзФайлаЗавершение2", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайлаЗавершение2(Подключено, ДополнительныеПараметры) Экспорт
	
	Если Подключено Тогда
		
		ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		ВыборФайла.ПолноеИмяФайла = "";
		ВыборФайла.Заголовок = НСтр("ru = 'Выбор схемы компоновки данных'");
		ВыборФайла.Фильтр = НСтр("ru = 'Схема компоновки данных (*.xml)|*.xml'");
		
		ВыборФайла.Показать(Новый ОписаниеОповещения("ЗагрузитьСхемуИзФайлаЗавершение1", ЭтотОбъект, Новый Структура("ВыборФайла", ВыборФайла)));
		
	Иначе
		
		#Если ВебКлиент Тогда
			
			АдресФайлаВоВременномХранилище = "";
			ИмяФайла = "";
			Если НЕ ПоместитьФайл(АдресФайлаВоВременномХранилище, ИмяФайла, ИмяФайла, Истина, УникальныйИдентификатор) Тогда
				Возврат;
			КонецЕсли;
			
			ЗагрузитьСхемуИзФайлаНаСервереВеб(АдресФайлаВоВременномХранилище);
			
		#КонецЕсли
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайлаЗавершение1(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	ВыборФайла = ДополнительныеПараметры.ВыборФайла;
	
	
	Если (ВыбранныеФайлы <> Неопределено) Тогда
		
		ТекстовыйДокумент = Новый ТекстовыйДокумент;
		ТекстовыйДокумент.НачатьЧтение(Новый ОписаниеОповещения("ЗагрузитьСхемуИзФайлаЗавершение", ЭтотОбъект, Новый Структура("ТекстовыйДокумент", ТекстовыйДокумент)), ВыборФайла.ПолноеИмяФайла, КодировкаТекста.UTF8);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьСхемуИзФайлаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ТекстовыйДокумент = ДополнительныеПараметры.ТекстовыйДокумент;
	
	
	Текст = ТекстовыйДокумент.ПолучитьТекст();
	
	ЗагрузитьСхемуИзФайлаНаСервере(Текст);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзмененаСхемаКомпоновкиДанных(форма, схемаКомпоновкиДанных)
	
	// Получена схема из конструктора схемы компоновки данных
	Форма.Модифицированность = Истина;
	Форма.РедактируемаяСхемаКомпоновкиДанныхМодифицированность = Истина;
	
	// Редактируемая схема компоновки данных замещается схемой, полученной из конструктора
	былиИзменения = Ложь;
	УстановитьСхемуКомпоновкиДанных(Форма.АдресРедактируемойСхемыКомпоновкиДанных, СхемаКомпоновкиДанных, Истина, былиИзменения);
	
	Если былиИзменения Тогда
		
		Если Форма.Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.НайтиПоЗначению("") = Неопределено Тогда
			Форма.Элементы.ТекущийШаблонСхемыКомпоновкиДанных.СписокВыбора.Добавить("", НСтр("ru = 'Произвольная'"));
		КонецЕсли;
		
		Форма.ИмяТекущегоШаблонаСКД = "";
		Форма.ТекущийШаблонСхемыКомпоновкиДанных = Форма.ИмяТекущегоШаблонаСКД;
		
	КонецЕсли;
	
	// Компоновщик настроек инициализируется редактируемой схемой
	ИнициализироватьКомпоновщикНастроек(Форма.КомпоновщикНастроек, Форма.АдресРедактируемойСхемыКомпоновкиДанных);
	
КонецПроцедуры

&НаСервере
Функция СформироватьСтруктуруВозврата()
	
	структураВозврата = Новый Структура("АдресХранилищаНастройкиКомпоновщика, ИмяТекущегоШаблонаСКД");
	структураВозврата.АдресХранилищаНастройкиКомпоновщика =  ПолучитьНастрокиКомпоновщика(КомпоновщикНастроек, УникальныйИдентификаторВладельца);
	структураВозврата.ИмяТекущегоШаблонаСКД = ИмяТекущегоШаблонаСКД;
		
	Возврат структураВозврата;
	
КонецФункции

#КонецОбласти 