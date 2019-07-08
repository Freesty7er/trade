﻿Процедура ЗаполнитьСуммуВсегоВСтрокеТабличнойЧастиПлана(СтрокаТаблицы) Экспорт
	
	//КолДней = Объект.РазмерИнтервала;
	Всего = 0;
	Для День = 1 По 31 Цикл
		СтрДень = "Д" + Строка(День);
		Если СтрокаТаблицы[СтрДень] Тогда			
			Всего = Всего + 1;
		КонецЕсли;		
	КонецЦикла; 
	
	СтрокаТаблицы.Всего = Всего;
	
КонецПроцедуры

// Функция производит преобразование цвета из RGB-формата в 
// шестнадцатиричную систему исличсления
//
// Параметры: 
//  НужныйЦвет - Цвет; цвет, который нужно преобразовать
//
// Возвращаемое значение:
//  Строка
//  
Функция ПреобразоватьЦветВRGBСтроку(НужныйЦвет) Экспорт
	
	Если НужныйЦвет = Неопределено Тогда
		Возврат "";
	КонецЕсли;
	
	Если НужныйЦвет.Вид <> ВидЦвета.Абсолютный Тогда
		НужныйЦвет = апСерверМодуль.ПреобразоватьЦветВАбсолютный(НужныйЦвет);
	КонецЕсли;	
		
	Красный = НужныйЦвет.Красный;
	Зеленый = НужныйЦвет.Зеленый;
	Синий   = НужныйЦвет.Синий;
	
	ЗначЦвета = Строка(Красный) + "," + Строка(Зеленый) + "," + Строка(Синий);
	
	Возврат ЗначЦвета;	
	
КонецФункции //ПреобразоватьЦветИзRGBВШестнадцатиричнуюСистему
  
// Функция производит преобразование числа из десятичной системы в шестнадцатиричную
//
Функция ПреобразованиеИзДесятичнойСистемыВШестнадцатиричную(НужноеЧисло) Экспорт
	
	СписокСимволов = Новый СписокЗначений;
	
	СписокСимволов.Добавить("10", "A"); 
	СписокСимволов.Добавить("11", "B"); 
	СписокСимволов.Добавить("12", "C"); 
	СписокСимволов.Добавить("13", "D"); 
	СписокСимволов.Добавить("14", "E"); 
	СписокСимволов.Добавить("15", "F"); 
		
	ЦелЧасть = Цел(НужноеЧисло/16);
	Ост = НужноеЧисло - ЦелЧасть*16;
	
	Рез = "";
	// Целая часть
	ТекЗнач = СписокСимволов.НайтиПоЗначению(Строка(ЦелЧасть));
	Если ТекЗнач <> Неопределено Тогда
    	Рез = ТекЗнач.Представление; 		
	Иначе
		Рез = Строка(ЦелЧасть);   		
	КонецЕсли;
	
	// Остаток
	ТекЗнач = СписокСимволов.НайтиПоЗначению(Строка(Ост)); 
	Если ТекЗнач <> Неопределено Тогда
    	Рез = Рез + ТекЗнач.Представление;
	Иначе
		Рез = Рез + Строка(Ост);
	КонецЕсли;
	
	Возврат Рез;
	
КонецФункции //ПреобразованиеИзДесятичнойСистемыВШестнадцатиричную()
 
// Функция производит преобразование цвета из RGB-формата в 
// шестнадцатиричную систему исличсления
//
// Параметры: 
//  НужныйЦвет - Цвет; цвет, который нужно преобразовать
//
// Возвращаемое значение:
//  Строка
//  
Функция ПреобразоватьЦветИзRGBВШестнадцатиричнуюСистему(НужныйЦвет) Экспорт
	
	Если НужныйЦвет = Неопределено Тогда
		Возврат 0;
	КонецЕсли;
	
	Если НужныйЦвет.Вид <> ВидЦвета.Абсолютный Тогда
		НужныйЦвет = апСерверМодуль.ПреобразоватьЦветВАбсолютный(НужныйЦвет);
	КонецЕсли;	
		
	Красный = НужныйЦвет.Красный;
	Зеленый = НужныйЦвет.Зеленый;
	Синий   = НужныйЦвет.Синий;
	
	ЧислоКрасного = ПреобразованиеИзДесятичнойСистемыВШестнадцатиричную(Красный);
	ЧислоЗеленого = ПреобразованиеИзДесятичнойСистемыВШестнадцатиричную(Зеленый);
	ЧислоСинего   = ПреобразованиеИзДесятичнойСистемыВШестнадцатиричную(Синий);
	
	ЗначЦвета = ЧислоКрасного + ЧислоЗеленого + ЧислоСинего;
	
	Возврат ЗначЦвета;	
	
КонецФункции //ПреобразоватьЦветИзRGBВШестнадцатиричнуюСистему

// Функция проверяет переданное значение идентификатора на пустой
//
// Параметры:
//  ИД - идентификатор
//
//Возвращаемое значение:
//  Булево
//
// Добавлена 14.06.2007
//
Функция ЭтоПустойИдентификатор(ИД) Экспорт
	
	Если (СокрЛП(ИД) = "00000000-0000-0000-0000-000000000000") ИЛИ (СокрЛП(ИД) = "") Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции //ЭтоПустойИдентификатор()
       


