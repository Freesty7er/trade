﻿////////////////////////////////////////////////////////////////////////////////
// Модуль процедур, исполняемых на сервере и на клиенте

// Определяет, можно ли занять файл и, если нет, то формирует строку ошибки
//
Функция МожноЛиЗанятьФайл(ДанныеФайла, СтрокаОшибки = "") Экспорт
	
	Если ДанныеФайла.ПометкаУдаления = Истина Тогда
		СтрокаОшибки =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		  НСтр("ru = 'Нельзя занять файл ""%1"", т.к. он помечен на удаление.'"),
		  Строка(ДанныеФайла.Ссылка));
		Возврат Ложь;
	КонецЕсли;
	
	
	Если ДанныеФайла.Редактирует.Пустая()
		Или ДанныеФайла.РедактируетТекущийПользователь Тогда 
		
		Возврат Истина;
		
	Иначе
		
		СтрокаОшибки =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		  НСтр("ru = 'Файл ""%1"" уже редактируется пользователем ""%2""!'"),
		  Строка(ДанныеФайла.Ссылка), Строка(ДанныеФайла.Редактирует));
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// Возвращает Истина, если в имени папки или файла все символы допустимы
// для файловой системы (т.е. на диске можно создать каталог с таким именем)
//
Функция ИмяПапкиИлиФайлаСостоитИзДопустимыхСимволовДляФайловойСистемы(ИмяПапки) Экспорт
	
	Если Найти(ИмяПапки, "/") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Найти(ИмяПапки, ":") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Если Найти(ИмяПапки, "?") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;

	Если Найти(ИмяПапки, "\") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Если Найти(ИмяПапки, "|") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Если Найти(ИмяПапки, "*") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Если Найти(ИмяПапки, """") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Если Найти(ИмяПапки, "<") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
		
	Если Найти(ИмяПапки, ">") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;

	Если Найти(ИмяПапки, "..\") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;

	Если Найти(ИмяПапки, "../") > 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ИмяПапки = "." Тогда
		Возврат Ложь;
	КонецЕсли;

	Если ИмяПапки = ".." Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;		
КонецФункции	

// создает элемент справочника Файлы
Функция СоздатьЭлементСправочникаФайлы(ВыбранныйФайл, МассивСтруктурВсехФайлов, Владелец, 
	ИдентификаторФормы, Комментарий, ХранитьВерсии, ДобавленныеФайлы,
	АдресВременногоХранилищаФайла, АдресВременногоХранилищаТекста,
	Пользователь = Неопределено) Экспорт
	
	ИмяБезРасширения = ВыбранныйФайл.ИмяБезРасширения;
	Расширение = ВыбранныйФайл.Расширение;
	
	Расширение = ФайловыеФункцииКлиентСервер.РасширениеБезТочки(ВыбранныйФайл.Расширение);
	ВремяИзменения = ВыбранныйФайл.ПолучитьВремяИзменения();
	ВремяИзмененияУниверсальное = ВыбранныйФайл.ПолучитьУниверсальноеВремяИзменения();
	Размер = ВыбранныйФайл.Размер();
	
	// Создадим карточку Файла в БД
	ДокСсылка = РаботаСФайламиВызовСервера.СоздатьФайлСВерсией(
		Владелец,
		ИмяБезРасширения,
		Расширение,
		ВремяИзменения,
		ВремяИзмененияУниверсальное,
		Размер,
		АдресВременногоХранилищаФайла,
		АдресВременногоХранилищаТекста,
		Ложь,  // это не веб клиент
		Пользователь,
		Комментарий);
	
	УдалитьИзВременногоХранилища(АдресВременногоХранилищаФайла);
	Если Не ПустаяСтрока(АдресВременногоХранилищаТекста) Тогда
		УдалитьИзВременногоХранилища(АдресВременногоХранилищаТекста);
	КонецЕсли;
	
	ДобавленныйФайлИПуть = Новый Структура("ФайлСсылка, Путь", ДокСсылка, ВыбранныйФайл.Путь);	
	ДобавленныеФайлы.Добавить(ДобавленныйФайлИПуть);
	
	Запись = Новый Структура;
	Запись.Вставить("ИмяФайла", ВыбранныйФайл.ПолноеИмя);
	Запись.Вставить("Файл", ДокСсылка);
	МассивСтруктурВсехФайлов.Добавить(Запись);

КонецФункции

// Получает имя сканированного файла, вида ДМ-00000012, где ДМ - префикс базы
Функция ПолучитьИмяСканированногоФайла(НомерФайла, ПрефиксБазы) Экспорт
	
	ИмяФайла = "";
	Если НЕ ПустаяСтрока(ПрефиксБазы) Тогда
		ИмяФайла = ПрефиксБазы + "-";
	КонецЕсли;
	
	ИмяФайла = ИмяФайла + Формат(НомерФайла, "ЧЦ=9; ЧВН=; ЧГ=0");
	
	Возврат ИмяФайла;
	
КонецФункции	

Функция СформироватьЭксельТабличныйДокумент(табличныйДокумент,имяФайла) Экспорт
	
	табличныйДокумент.Записать(имяФайла, ТипФайлаТабличногоДокумента.XLS);
	
	//Excel = Новый COMОбъект("Excel.Application");
	//Excel.WorkBooks.Open(имяФайла); 
	//Excel.Visible = 0;
	//Excel.ActiveWindow.DisplayWorkbookTabs = 1; 
	//Excel.ActiveWindow.TabRatio = 0.6; 
	//FullName = Excel.ActiveWorkbook.FullName; 
	//Excel.DisplayAlerts = false;
	//Excel.ActiveWorkbook.SaveAs(FullName, 18); // 18 - xls 97-2003; 51 - xlsx 2007-2013
	Возврат(имяФайла);
	//Excel.Visible = 1; // если нужно поработать дальше с книгой
	//Excel.Application.Quit() // если просто выходим 
	
	//Возврат имя Файла на сервере
КонецФункции