﻿&НаСервере
Функция  НужнаПечатьНалоговыхНакладных(ПараметрКоманды)
	
	СписокНалоговыхНакладных = Новый Массив;
	
	
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	НалоговаяНакладнаяСостав.Ссылка
	|ИЗ
	|	Документ.НалоговаяНакладная.Состав КАК НалоговаяНакладнаяСостав
	|ГДЕ
	|	НалоговаяНакладнаяСостав.РасходняНакладная В(&СписокРасходныхНакладных)");
	
	Запрос.УстановитьПараметр("СписокРасходныхНакладных", ПараметрКоманды);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СписокНалоговыхНакладных.Добавить(Выборка.Ссылка);
		
	КонецЦикла;
	
	Возврат (СписокНалоговыхНакладных);
	
КонецФункции


&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.РасходнаяНакладная", "Накладная", ПараметрКоманды, ПараметрыВыполненияКоманды, Неопределено);

	// проверим необходимость печати НалоговойНакладной
	СписокНалоговыхНакладных = НужнаПечатьНалоговыхНакладных(ПараметрКоманды);
	Если  СписокНалоговыхНакладных.Количество() > 0 Тогда
		УправлениеПечатьюКлиент.ВыполнитьКомандуПечати("Документ.НалоговаяНакладная", "Налоговая", СписокНалоговыхНакладных, ПараметрыВыполненияКоманды, Неопределено);
	КонецЕсли;
	
КонецПроцедуры
