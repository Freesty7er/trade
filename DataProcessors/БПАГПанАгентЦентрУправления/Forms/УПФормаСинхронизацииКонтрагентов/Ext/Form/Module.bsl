﻿Процедура ОбновитьТорговуюТочку(ТТОбъект, Договор)
	
	СпецификаПользователя = БПАГ.ПолучитьСпецификуПользователя();
	ВидПрикладногоРешения = БПАГ.ПолучитьВидПрикладногоРешения();
	
	ПриоритетКонтактнойИнформацииПриСинхронизации = БПАГ.БПАГПолучитьНастройку("1СПриоритетКонтактнойИнформацииПриСинхронизации");	
	ВидАдресаДоставки = БПАГ.БПАГПолучитьНастройку("1СВидАдресаДоставки");
	ВидТелефонаДоставки = БПАГ.БПАГПолучитьНастройку("1СВидТелефонаДоставки");
	//РежимКонтроляВзаиморасчетовВЗаявке = БПАГ.БПАГПолучитьНастройку("1СРежимКонтроляВзаиморасчетовВЗаявке");
	//РежимКонтроляВзаиморасчетовВРеализации = БПАГ.БПАГПолучитьНастройку("1СРежимКонтроляВзаиморасчетовВРеализации");
	
	Если СокрЛП(ТТОбъект.Наименование) = "" Тогда
		ТТОбъект.Наименование = Договор;
	КонецЕсли;
	
	//Адрес
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КонтрагентыКонтактнаяИнформация.Представление КАК Наименование
	|ИЗ
	|	Справочник." + ?(ВидПрикладногоРешения = "УТ11", "Партнеры", "Контрагенты") + ".КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	|ГДЕ
	|	КонтрагентыКонтактнаяИнформация.Ссылка = &Ссылка
	|	И КонтрагентыКонтактнаяИнформация.Вид = &Вид";
	
	Запрос.УстановитьПараметр("Ссылка", ТТОбъект.Владелец.Контрагент);
	Запрос.УстановитьПараметр("Вид", ВидАдресаДоставки);
	
	Адрес = "";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Адрес = Выборка.Наименование;
	КонецЕсли;
	
	//Телефон
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КонтрагентыКонтактнаяИнформация.Представление КАК Наименование
	|ИЗ
	|	Справочник." + ?(ВидПрикладногоРешения = "УТ11", "Партнеры", "Контрагенты") + ".КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	|ГДЕ
	|	КонтрагентыКонтактнаяИнформация.Ссылка = &Ссылка
	|	И КонтрагентыКонтактнаяИнформация.Вид = &Вид";
	
	Запрос.УстановитьПараметр("Ссылка", ТТОбъект.Владелец.Контрагент);
	Запрос.УстановитьПараметр("Вид", ВидТелефонаДоставки);
	
	Телефон = "";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Телефон = Выборка.Наименование;
	КонецЕсли;
	
	Если ПриоритетКонтактнойИнформацииПриСинхронизации = Перечисления.БПАГУчетныеСистемы.ПанАгент Тогда
		Если ТТОбъект.Адрес = "" Тогда
			Если СпецификаПользователя = "NV" Тогда
				ТТОбъект.Адрес = Договор.БПАдресДоставки;
			Иначе
				ТТОбъект.Адрес = Адрес;
			КонецЕсли;
		КонецЕсли;
		
		Если СокрЛП(ТТОбъект.Телефон) = "" Тогда
			ТТОбъект.Телефон = Телефон;
		КонецЕсли;
	Иначе
		Если СпецификаПользователя = "NV" Тогда
			Если СокрЛП(Договор.БПАдресДоставки) <> "" Тогда
				ТТОбъект.Адрес = Договор.БПАдресДоставки;
			КонецЕсли;
		Иначе
			Если СокрЛП(Адрес) <> "" Тогда
				ТТОбъект.Адрес = Адрес;
			КонецЕсли;
		КонецЕсли;
		
		Если СокрЛП(Телефон) <> "" Тогда
			ТТОбъект.Телефон = Телефон;
		КонецЕсли;
	КонецЕсли;
	
	Если ПриоритетКонтактнойИнформацииПриСинхронизации = Перечисления.БПАГУчетныеСистемы.ПанАгент Тогда
		Если СокрЛП(ТТОбъект.КонтактноеЛицо) = "" Тогда
			ТТОбъект.КонтактноеЛицо = Договор.Владелец.КонтактноеЛицо;
		КонецЕсли;
		
		//Если ТТОбъект.РежимКонтроляВзаиморасчетовВЗаявке.Пустая() Тогда
		//	ТТОбъект.РежимКонтроляВзаиморасчетовВЗаявке = РежимКонтроляВзаиморасчетовВЗаявке;
		//КонецЕсли;
		//Если ТТОбъект.РежимКонтроляВзаиморасчетовВРеализации.Пустая() Тогда
		//	ТТОбъект.РежимКонтроляВзаиморасчетовВРеализации = РежимКонтроляВзаиморасчетовВРеализации;
		//КонецЕсли;
	Иначе
		Если СокрЛП(Договор.Владелец.КонтактноеЛицо) <> "" Тогда
			ТТОбъект.КонтактноеЛицо = Договор.Владелец.КонтактноеЛицо;
		КонецЕсли;
		//ТТОбъект.РежимКонтроляВзаиморасчетовВЗаявке = РежимКонтроляВзаиморасчетовВЗаявке;
		//ТТОбъект.РежимКонтроляВзаиморасчетовВРеализации = РежимКонтроляВзаиморасчетовВРеализации;
	КонецЕсли;
	
	Если ТТОбъект.Модифицированность() Тогда
		ТТОбъект.Записать();
	КонецЕсли;

КонецПроцедуры

Процедура ОбновитьТорговыеТочки(Объ, ТекДоговор)
	
	НаличиеСетевыхТорговыхТочек = БПАГ.БПАГПолучитьНастройку("1СНаличиеСетевыхТорговыхТочек");
	
	ВыборкаТТ = Справочники.БПАГТорговыеТочки.Выбрать(, Объ.Ссылка);
	ДоговорНайден = Ложь;
	Пока ВыборкаТТ.Следующий() Цикл
		Если (НаличиеСетевыхТорговыхТочек И (ВыборкаТТ.Договор = ТекДоговор)) ИЛИ ((НЕ НаличиеСетевыхТорговыхТочек) И (ВыборкаТТ.Договор.Пустая())) Тогда
			Если НЕ ВыборкаТТ.ПометкаУдаления Тогда
				ТТОбъект = ВыборкаТТ.ПолучитьОбъект();
				ОбновитьТорговуюТочку(ТТОбъект, ТекДоговор);
				ДоговорНайден = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;	
	
	Если Не ДоговорНайден Тогда
		ТТОбъект = Справочники.БПАГТорговыеТочки.СоздатьЭлемент();
		Объ.Записать();
		ТТОбъект.Владелец = Объ.Ссылка;
		Если НаличиеСетевыхТорговыхТочек Тогда
			ТТОбъект.Договор = ТекДоговор;
		КонецЕсли;
		ОбновитьТорговуюТочку(ТТОбъект, ТекДоговор);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаБПАГКонтрагентовНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаБПАГКонтрагентовПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)	
	Состояние("Перетаскивание контрагентов...");	
	РекурсияПеретаскивания(ПараметрыПеретаскивания.Значение, Элемент.ТекущийРодитель, 0);
	Состояние("Перетаскивание завершено.");
КонецПроцедуры

Процедура РекурсияПеретаскивания(ПараметрыПеретаскивания, Строка, Папа = 0)
	
	НаличиеСетевыхТорговыхТочек = БПАГ.БПАГПолучитьНастройку("1СНаличиеСетевыхТорговыхТочек");
	РучноеУправлениеСоставомТорговыхТочек = БПАГ.БПАГПолучитьНастройку("1СРучноеУправлениеСоставомТТ"); //ПАКЛ
	ВидАдресаДоставки = БПАГ.БПАГПолучитьНастройку("1СВидАдресаДоставки");
	ВидТелефонаДоставки = БПАГ.БПАГПолучитьНастройку("1СВидТелефонаДоставки");
	
	ВидПрикладногоРешения = БПАГ.ПолучитьВидПрикладногоРешения();
	СпецификаПользователя = БПАГ.ПолучитьСпецификуПользователя();
	ПеретаскиваемыеЗначения = ПараметрыПеретаскивания;
	
	ТипСправочникаКлиентов = ?(ВидПрикладногоРешения = "УТ11", Тип("СправочникСсылка.Партнеры"), Тип("СправочникСсылка.Контрагенты"));
	
	Если ТипЗнч(ПеретаскиваемыеЗначения) = ТипСправочникаКлиентов Тогда
		Перетаскиваемое = ПеретаскиваемыеЗначения;
		Если Перетаскиваемое.ПометкаУдаления Тогда
			Возврат;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Партнеры.Ссылка
		|ИЗ
		|	Справочник.Партнеры КАК Партнеры
		|ГДЕ
		|	Партнеры.Родитель = &Родитель";
		
		Если ВидПрикладногоРешения <> "УТ11" Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "Партнер", "Контрагент");
		КонецЕсли;
		
		Запрос.УстановитьПараметр("Родитель", Перетаскиваемое);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда //Это группа или элемент, содержащий другие элементы
			
			Если Строка <> Неопределено Тогда
				Если Строка.ЭтоГруппа Тогда
					Если ВидПрикладногоРешения = "УТ11" Тогда
						Если Перетаскиваемое = Строка.Партнер Тогда
							Возврат;
						КонецЕсли;
					Иначе
						Если Перетаскиваемое = Строка.Контрагент Тогда
							Возврат;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
			СуществующийЭлемент = Справочники.БПАГКонтрагенты.НайтиПоРеквизиту(?(ВидПрикладногоРешения = "УТ11", "Партнер", "Контрагент"), Перетаскиваемое);
			Если СуществующийЭлемент <> Справочники.БПАГКонтрагенты.ПустаяСсылка() Тогда
				Объ = СуществующийЭлемент.ПолучитьОбъект();
			Иначе
				Объ = Справочники.БПАГКонтрагенты.СоздатьГруппу();
			КонецЕсли;
			
			Если Папа = 0 Тогда
				Если Строка <> Неопределено Тогда
					Если Строка.ЭтоГруппа Тогда
						Объ.Родитель = Строка
					КонецЕсли;
				КонецЕсли;
			Иначе
				Объ.Родитель = Папа;
			КонецЕсли;
				
			Если ВидПрикладногоРешения = "УТ11" Тогда
				Объ.Партнер = Перетаскиваемое; 
			Иначе
				Объ.Контрагент = Перетаскиваемое;
			КонецЕсли;
			
			Объ.Наименование = Перетаскиваемое.Наименование;
			Объ.Записать();
			
			Запрос = Новый Запрос();
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	Контрагент.Ссылка
			|ИЗ
			|	Справочник." + ?(ВидПрикладногоРешения = "УТ11", "Партнеры", "Контрагенты") + " КАК Контрагент
			|ГДЕ
			|	Контрагент.Родитель = &Родитель
			|	И (НЕ Контрагент.ПометкаУдаления)
			|
			|УПОРЯДОЧИТЬ ПО
			|	Контрагент.Наименование";
			
			Запрос.УстановитьПараметр("Родитель", Перетаскиваемое);
			ТЗ = Запрос.Выполнить().Выгрузить();
			
			Для Каждого Потомок Из ТЗ Цикл
				ПараметрыПеретаскивания = Потомок.Ссылка;
				РекурсияПеретаскивания(ПараметрыПеретаскивания, Строка, Объ.Ссылка);
			КонецЦикла;
			
		Иначе
			СуществующийЭлемент = Справочники.БПАГКонтрагенты.НайтиПоРеквизиту(?(ВидПрикладногоРешения = "УТ11", "Партнер", "Контрагент"), Перетаскиваемое);
			Если СуществующийЭлемент <> Справочники.БПАГКонтрагенты.ПустаяСсылка() Тогда
				Объ = СуществующийЭлемент.ПолучитьОбъект();
			Иначе
				Объ = Справочники.БПАГКонтрагенты.СоздатьЭлемент();
			КонецЕсли;
			
			Если Папа = 0 Тогда
				Если Строка <> Неопределено Тогда
					Если Строка.ЭтоГруппа Тогда
						Объ.Родитель = Строка
					КонецЕсли;
				КонецЕсли;
			Иначе
				Объ.Родитель = Папа;
			КонецЕсли;

			Если ВидПрикладногоРешения = "УТ11" Тогда
				Объ.Партнер = Перетаскиваемое; 
			Иначе
				Объ.Контрагент = Перетаскиваемое;
			КонецЕсли;
			
			Объ.Наименование = Перетаскиваемое.Наименование;
			
			Попытка
				Объ.Записать();
			Исключение
				БПАГ.ИнформационноеСообщение("Обнаружена проблема с элементом " + Объ.Наименование);
				БПАГ.ИнформационноеСообщение("Проверьте, не является ли родитель данного элемента обычным элементом справочника Пан Агент - Контрагенты. В этом случае очистите в нем поле 'Партнер' и перенесите в группу 'Удаленные'.");
				Возврат;
			КонецПопытки;
			
			Если НаличиеСетевыхТорговыхТочек Тогда
				Если СпецификаПользователя = "FT" Тогда
					//Телефон
					Запрос = Новый Запрос;
					Запрос.Текст =
					"ВЫБРАТЬ
					|	ПартнерыКонтактнаяИнформация.Представление КАК Наименование
					|ИЗ
					|	Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
					|ГДЕ
					|	ПартнерыКонтактнаяИнформация.Ссылка = &Ссылка
					|	И ПартнерыКонтактнаяИнформация.Вид = &Вид";
					
					Запрос.УстановитьПараметр("Ссылка", Перетаскиваемое);
					Запрос.УстановитьПараметр("Вид", ВидТелефонаДоставки);
					
					Телефон = "";
					Выборка = Запрос.Выполнить().Выбрать();
					Если Выборка.Следующий() Тогда
						Телефон = Выборка.Наименование;
					КонецЕсли;
	
					Запрос = Новый Запрос;
					Запрос.Текст =
					"ВЫБРАТЬ
					|	ФорсайТрейд_АдресаДоставок.Ссылка КАК ТТ,
					|	ФорсайТрейд_АдресаДоставок.Наименование КАК Наименование
					|ИЗ
					|	Справочник.ФорсайТрейд_АдресаДоставок КАК ФорсайТрейд_АдресаДоставок
					|ГДЕ
					|	НЕ ФорсайТрейд_АдресаДоставок.ПометкаУдаления
					|	И ФорсайТрейд_АдресаДоставок.Владелец = &Владелец";
					
					Запрос.УстановитьПараметр("Владелец", Перетаскиваемое);
					
					ТЗАдресаДоставок = Запрос.Выполнить().Выгрузить();
					Выборка = Запрос.Выполнить().Выбрать();
					ТТНайдена = Ложь;
					Пока Выборка.Следующий() Цикл
						
						НайденнаяТТ = Справочники.БПАГТорговыеТочки.НайтиПоНаименованию(Выборка.Наименование, Истина, , Объ.Ссылка);
						Если НайденнаяТТ.Пустая() Тогда
							НоваяТТ = Справочники.БПАГТорговыеТочки.СоздатьЭлемент();
							НоваяТТ.Владелец = Объ.Ссылка;
							НоваяТТ.Наименование = Выборка.Наименование;
							НоваяТТ.Адрес = НоваяТТ.Наименование;
							НоваяТТ.Телефон = Телефон;
							НоваяТТ.Записать();
						Иначе
							Если (НайденнаяТТ.Адрес <> НайденнаяТТ.Наименование) ИЛИ (НайденнаяТТ.Телефон <> Телефон) Тогда
								ТТОбъ = НайденнаяТТ.ПолучитьОбъект();
								ТТОбъ.Адрес = ТТОбъ.Наименование;
								ТТОбъ.Телефон = Телефон;
								ТТОбъ.Записать();
							КонецЕсли;
						КонецЕсли;
						
						ТТНайдена = Истина;
					КонецЦикла;
					
					Если Не ТТНайдена Тогда
						//Поищем по типовому адресу
						Запрос = Новый Запрос;
						Запрос.Текст =
						"ВЫБРАТЬ
						|	ПартнерыКонтактнаяИнформация.Представление КАК Наименование
						|ИЗ
						|	Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
						|ГДЕ
						|	ПартнерыКонтактнаяИнформация.Ссылка = &Ссылка
						|	И ПартнерыКонтактнаяИнформация.Вид = &Вид";
						
						Запрос.УстановитьПараметр("Ссылка", Перетаскиваемое);
						Запрос.УстановитьПараметр("Вид", ВидАдресаДоставки);
						
						Выборка = Запрос.Выполнить().Выбрать();
						Если Выборка.Следующий() Тогда
							НовыйАдрес = ТЗАдресаДоставок.Добавить();
							НовыйАдрес.Наименование = Выборка.Наименование;

							НайденнаяТТ = Справочники.БПАГТорговыеТочки.НайтиПоНаименованию(Выборка.Наименование, Истина, , Объ.Ссылка);
							Если НайденнаяТТ.Пустая() Тогда
								НоваяТТ = Справочники.БПАГТорговыеТочки.СоздатьЭлемент();
								НоваяТТ.Владелец = Объ.Ссылка;
								НоваяТТ.Наименование = Выборка.Наименование;
								НоваяТТ.Адрес = НоваяТТ.Наименование;
								НоваяТТ.Телефон = Телефон;
								НоваяТТ.Записать();
							КонецЕсли;
							
							ТТНайдена = Истина;	
						КонецЕсли;
						
						Если Не ТТНайдена Тогда
							БПАГ.ИнформационноеСообщение("Для партнера " + Перетаскиваемое + " не найдено ни одного адреса доставки!");
							Возврат;
						КонецЕсли;
					КонецЕсли;
					
					Запрос = Новый Запрос;
					Запрос.Текст =
					"ВЫБРАТЬ
					|	БПАГТорговыеТочки.Ссылка КАК ТТ,
					|	БПАГТорговыеТочки.Наименование КАК Наименование
					|ИЗ
					|	Справочник.БПАГТорговыеТочки КАК БПАГТорговыеТочки
					|ГДЕ
					|	БПАГТорговыеТочки.Владелец = &Владелец";
					
					Запрос.УстановитьПараметр("Владелец", Объ.Ссылка);
					
					Выборка = Запрос.Выполнить().Выбрать();
					
					Пока Выборка.Следующий() Цикл
						НайденнаяСтрокаАдреса = ТЗАдресаДоставок.Найти(Выборка.Наименование, "Наименование");
						Если НайденнаяСтрокаАдреса = Неопределено Тогда
							БПАГ.ИнформационноеСообщение("Для партнера " + Перетаскиваемое + " удален неиспользуемый адрес доставки: " + Выборка.Наименование);
							ОбъектТТ = Выборка.ТТ.ПолучитьОбъект();
							ОбъектТТ.Удалить();
						КонецЕсли;
				 	КонецЦикла;
					
				Иначе
					
					//Телефон
					Запрос = Новый Запрос;
					Запрос.Текст =
					"ВЫБРАТЬ
					|	ПартнерыКонтактнаяИнформация.Представление КАК Наименование
					|ИЗ
					|	Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
					|ГДЕ
					|	ПартнерыКонтактнаяИнформация.Ссылка = &Ссылка
					|	И ПартнерыКонтактнаяИнформация.Вид = &Вид";
					
					Запрос.УстановитьПараметр("Ссылка", Перетаскиваемое);
					Запрос.УстановитьПараметр("Вид", ВидТелефонаДоставки);
					
					Телефон = "";
					Выборка = Запрос.Выполнить().Выбрать();
					Если Выборка.Следующий() Тогда
						Телефон = Выборка.Наименование;
					КонецЕсли;
	
					//Адрес
					Запрос = Новый Запрос;
					Запрос.Текст =
					"ВЫБРАТЬ
					|	ПартнерыКонтактнаяИнформация.Представление КАК Наименование
					|ИЗ
					|	Справочник.Партнеры.КонтактнаяИнформация КАК ПартнерыКонтактнаяИнформация
					|ГДЕ
					|	ПартнерыКонтактнаяИнформация.Ссылка = &Ссылка
					|	И ПартнерыКонтактнаяИнформация.Вид = &Вид";
					
					Запрос.УстановитьПараметр("Ссылка", Перетаскиваемое);
					Запрос.УстановитьПараметр("Вид", ВидАдресаДоставки);
					
					Выборка = Запрос.Выполнить().Выбрать();
					ТТНайдена = Ложь;
					Пока Выборка.Следующий() Цикл
						НайденнаяТТ = Справочники.БПАГТорговыеТочки.НайтиПоНаименованию(Выборка.Наименование, Истина, , Объ.Ссылка);
						Если РучноеУправлениеСоставомТорговыхТочек Тогда
							Если НайденнаяТТ.Пустая() Тогда
								НоваяТТ = Справочники.БПАГТорговыеТочки.СоздатьЭлемент();
								НоваяТТ.Владелец = Объ.Ссылка;
								НоваяТТ.Наименование = Выборка.Наименование;
								НоваяТТ.Адрес = НоваяТТ.Наименование;
								НоваяТТ.Телефон = Телефон;
								НоваяТТ.Записать();
							Иначе
								Если (НайденнаяТТ.Адрес <> НайденнаяТТ.Наименование) ИЛИ (НайденнаяТТ.Телефон <> Телефон) Тогда
									ТТОбъ = НайденнаяТТ.ПолучитьОбъект();
									ТТОбъ.Адрес = ТТОбъ.Наименование;
									ТТОбъ.Телефон = Телефон;
									ТТОбъ.Записать();
								КонецЕсли;
							КонецЕсли;
							
							ТТНайдена = Истина;
						Иначе
							// не ручное управление ТТ. 
							//Удаляем все введенные ТТ
							ЕстьТакаяТТ = Ложь;
							СправочникТТ = Справочники.БПАГТорговыеТочки.Выбрать( ,Объ.Ссылка); 
							Пока СправочникТТ.Следующий() Цикл
								Если НЕ НайденнаяТТ.Пустая() Тогда
									Если (СправочникТТ.Адрес <> НайденнаяТТ.Наименование) Тогда
										ТекущаяТТ = СправочникТТ.ПолучитьОбъект(); 
									    ТекущаяТТ.Удалить();
									Иначе	
										ЕстьТакаяТТ = Истина;
									КонецЕсли;
								Иначе
									ТекущаяТТ = СправочникТТ.ПолучитьОбъект(); 
								    ТекущаяТТ.Удалить();
								КонецЕсли;
							КонецЦикла; 
							//Создаем Перезаписываем ТТ или создаем новую
							Если ЕстьТакаяТТ Тогда
								ТТОбъ = НайденнаяТТ.ПолучитьОбъект();
								ТТОбъ.Адрес = ТТОбъ.Наименование;
								ТТОбъ.Телефон = Телефон;
								ТТОбъ.Записать();
							Иначе
								НоваяТТ = Справочники.БПАГТорговыеТочки.СоздатьЭлемент();
								НоваяТТ.Владелец = Объ.Ссылка;
								НоваяТТ.Наименование = Выборка.Наименование;
								НоваяТТ.Адрес = НоваяТТ.Наименование;
								НоваяТТ.Телефон = Телефон;
								НоваяТТ.Записать();
							КонецЕсли;
						
							ТТНайдена = Истина;
						КонецЕсли;
					КонецЦикла;
					
					Если Не ТТНайдена Тогда
						БПАГ.ИнформационноеСообщение("Для клиента " + Перетаскиваемое + " не найден адрес!");
					КонецЕсли;
					
				КонецЕсли;				
				
			Иначе
				Если ВидПрикладногоРешения = "УНФ" Тогда
					//Сначала пытаемся работать с основным договором
					ОсновнойДоговор = Перетаскиваемое.ДоговорПоУмолчанию;
					Если ОсновнойДоговор.ВидДоговора = Перечисления.ВидыДоговоров.СПокупателем Тогда
						ОбновитьТорговыеТочки(Объ, ОсновнойДоговор);
					Иначе //Если основной договор не подходит, берем первый подходящий
						Запрос = Новый Запрос;
						Запрос.Текст =
						"ВЫБРАТЬ ПЕРВЫЕ 1
						|	ДоговорыКонтрагентов.Ссылка КАК Договор
						|ИЗ
						|	Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
						|ГДЕ
						|	(НЕ ДоговорыКонтрагентов.ПометкаУдаления)
						|	И ДоговорыКонтрагентов.Владелец = &Владелец
						|	И ДоговорыКонтрагентов.ВидДоговора = &ВидДоговора";
						
						Запрос.УстановитьПараметр("Владелец", Перетаскиваемое);
						Запрос.УстановитьПараметр("ВидДоговора", Перечисления.ВидыДоговоров.СПокупателем);
						
						Выборка = Запрос.Выполнить().Выбрать();
						Если Выборка.Следующий() Тогда
							ОбновитьТорговыеТочки(Объ, Выборка.Договор);
						Иначе
							БПАГ.ИнформационноеСообщение("Для клиента " + Перетаскиваемое + " не найден подходящий договор! Должен присутствовать договор с видом ""С покупателем"", не помеченный на удаление!");
							Возврат;
						КонецЕсли;
						
					КонецЕсли;
				ИначеЕсли ВидПрикладногоРешения = "УТ11" Тогда
					//NIY
					БПАГ.ИнформационноеСообщение("Для УТ11 необходимо установить настройку 'НаличиеСетевыхТорговыхТочек'.  NIY.");
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ПеретаскиваемыеЗначения) = Тип("Массив") Тогда
		Для Каждого Перетаскиваемое Из ПеретаскиваемыеЗначения Цикл
			ПараметрыПеретаскивания = Перетаскиваемое;
			РекурсияПеретаскивания(ПараметрыПеретаскивания, Строка, 0);
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаБПАГКонтрагентовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущаяСтрока);
	Форма = ПолучитьФорму("Обработка.БПАГПанАгентЦентрУправления.Форма.УПФормаКонтрагентов", ПараметрыФормы);	
	Форма.Открыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СписокКонтрагентов.ОсновнаяТаблица = ?(БПАГ.ПолучитьВидПрикладногоРешения() = "УТ11", "Справочник.Партнеры", "Справочник.Контрагенты");
КонецПроцедуры

//*******************************************************************************************************************************
Процедура СправочникСписокПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Колонка)
	
	ВидПрикладногоРешения = БПАГ.ПолучитьВидПрикладногоРешения();
	НаличиеСетевыхТорговыхТочек = БПАГ.БПАГПолучитьНастройку("1СНаличиеСетевыхТорговыхТочек");
	ВидАдресаДоставки = БПАГ.БПАГПолучитьНастройку("1СВидАдресаДоставки");
	ВидТелефонаДоставки = БПАГ.БПАГПолучитьНастройку("1СВидТелефонаДоставки");
	ПриоритетКонтактнойИнформацииПриСинхронизации = БПАГ.БПАГПолучитьНастройку("1СПриоритетКонтактнойИнформацииПриСинхронизации");
	
	НачатьТранзакцию();
	
	ПеретаскиваемыеЗначения = ПараметрыПеретаскивания.Значение;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	
	"ВЫБРАТЬ
	|	1 КАК Счет
	|ИЗ
	|	Справочник." + ?(ВидПрикладногоРешения = "УТ11", "Партнеры", "Контрагенты") + " КАК Партнеры
	|ГДЕ
	|	Партнеры.Ссылка В ИЕРАРХИИ(&Значения)
	|ИТОГИ
	|	СУММА(Счет)
	|ПО
	|	ОБЩИЕ";
	
	Запрос.УстановитьПараметр("Значения", ПеретаскиваемыеЗначения);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ПрогрессорПеретаскиванияВсего = 1;
	Если Выборка.Следующий() Тогда
		ПрогрессорПеретаскиванияВсего = Выборка.Счет;
	КонецЕсли;
	
	СчетПрогрессораПеретаскивания = 0;
	
	РекурсияПеретаскивания(ПараметрыПеретаскивания.Значение, Строка, 0);
	
	ЗафиксироватьТранзакцию();

КонецПроцедуры

&НаСервере
Процедура ДействияФормыСинхронизироватьВсеНаСервере()
	ВидПрикладногоРешения = БПАГ.ПолучитьВидПрикладногоРешения();
	Параметры2 = Новый Структура;
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	БПАГКонтрагенты." + ?(ВидПрикладногоРешения = "УТ11", "Партнер", "Контрагент") + " КАК СсылкаНаРодной
	|ИЗ
	|Справочник.БПАГКонтрагенты КАК БПАГКонтрагенты
	|ГДЕ
	|	БПАГКонтрагенты.Родитель = &ПустаяСсылка
	|   И БПАГКонтрагенты." + ?(ВидПрикладногоРешения = "УТ11", "Партнер", "Контрагент") + " <> &ПустаяСсылка1С
	|	И НЕ БПАГКонтрагенты.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ПустаяСсылка", Справочники.БПАГКонтрагенты.ПустаяСсылка());
	Запрос.УстановитьПараметр("ПустаяСсылка1С", ?(ВидПрикладногоРешения = "УТ11", Справочники.Партнеры.ПустаяСсылка(), Справочники.Контрагенты.ПустаяСсылка()));
	
	Параметры2.Вставить("Значение", Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("СсылкаНаРодной"));
	СправочникСписокПеретаскивание(Неопределено, Параметры2, Ложь, Неопределено, Неопределено);

КонецПроцедуры


&НаКлиенте
Процедура ДействияФормыСинхронизироватьВсе(Команда)
	
	Если Вопрос("Синхронизировать все группы, уже присутствующие в буферном справочнике?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		Параметры2 = Новый Структура;
		Параметры2.Вставить("Значение","1");
		ДействияФормыСинхронизироватьВсеНаСервере();
	КонецЕсли;
	
КонецПроцедуры

