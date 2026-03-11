program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Windows;

const
  // Русский алфавит (33 буквы)
  RussianLow = 'абвгдеёжзийклмнопрстуфхцчшщъыьэюя';
  RussianUp = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ';

  // Английский алфавит (26 букв)
  EnglishLow = 'abcdefghijklmnopqrstuvwxyz';
  EnglishUp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

// Функция шифрования
function Encrypt(const Input: string; Shift: Integer): string;
var
  i, j, NewPos: Integer;
  Ch: Char;
begin
  Result := Input;

  for i := 1 to Length(Result) do
  begin
    Ch := Result[i];

    // Проверяем русские строчные
    for j := 1 to Length(RussianLow) do
    begin
      if Ch = RussianLow[j] then
      begin
        NewPos := j + Shift;
        while NewPos > Length(RussianLow) do
          NewPos := NewPos - Length(RussianLow);
        while NewPos < 1 do
          NewPos := NewPos + Length(RussianLow);
        Result[i] := RussianLow[NewPos];
        Break;
      end;
    end;

    // Проверяем русские заглавные
    for j := 1 to Length(RussianUp) do
    begin
      if Ch = RussianUp[j] then
      begin
        NewPos := j + Shift;
        while NewPos > Length(RussianUp) do
          NewPos := NewPos - Length(RussianUp);
        while NewPos < 1 do
          NewPos := NewPos + Length(RussianUp);
        Result[i] := RussianUp[NewPos];
        Break;
      end;
    end;

    // Проверяем английские строчные
    for j := 1 to Length(EnglishLow) do
    begin
      if Ch = EnglishLow[j] then
      begin
        NewPos := j + Shift;
        while NewPos > Length(EnglishLow) do
          NewPos := NewPos - Length(EnglishLow);
        while NewPos < 1 do
          NewPos := NewPos + Length(EnglishLow);
        Result[i] := EnglishLow[NewPos];
        Break;
      end;
    end;

    // Проверяем английские заглавные
    for j := 1 to Length(EnglishUp) do
    begin
      if Ch = EnglishUp[j] then
      begin
        NewPos := j + Shift;
        while NewPos > Length(EnglishUp) do
          NewPos := NewPos - Length(EnglishUp);
        while NewPos < 1 do
          NewPos := NewPos + Length(EnglishUp);
        Result[i] := EnglishUp[NewPos];
        Break;
      end;
    end;
  end;
end;

// Функция дешифрования (отрицательный сдвиг)
function Decrypt(const Input: string; Shift: Integer): string;
begin
  Result := Encrypt(Input, -Shift);
end;

procedure EncryptFile(const InputFileName, OutputFileName: string; Shift: Integer);
var
  InputFile, OutputFile: TextFile;
  Line: string;
begin
  AssignFile(InputFile, InputFileName);
  Reset(InputFile);
  AssignFile(OutputFile, OutputFileName);
  Rewrite(OutputFile);

  while not Eof(InputFile) do
  begin
    ReadLn(InputFile, Line);
    WriteLn(OutputFile, Encrypt(Line, Shift));
  end;

  CloseFile(InputFile);
  CloseFile(OutputFile);

  WriteLn('Файл успешно зашифрован!');
end;

procedure DecryptFile(const InputFileName, OutputFileName: string; Shift: Integer);
var
  InputFile, OutputFile: TextFile;
  Line: string;
begin
  AssignFile(InputFile, InputFileName);
  Reset(InputFile);
  AssignFile(OutputFile, OutputFileName);
  Rewrite(OutputFile);

  while not Eof(InputFile) do
  begin
    ReadLn(InputFile, Line);
    WriteLn(OutputFile, Decrypt(Line, Shift));
  end;

  CloseFile(InputFile);
  CloseFile(OutputFile);

  WriteLn('Файл успешно расшифрован!');
end;

procedure DemoExample;
var
  OriginalText, EncryptedText, DecryptedText: string;
  Shift: Integer;
begin
  WriteLn('=== ДЕМОНСТРАЦИЯ РАБОТЫ ШИФРА ЦЕЗАРЯ ===');
  WriteLn;

  Write('Введите сдвиг для шифрования (1-32): ');
  ReadLn(Shift);

  OriginalText := 'Привет, мир! Hello, world!';
  WriteLn('Исходный текст: ', OriginalText);
  WriteLn;

  EncryptedText := Encrypt(OriginalText, Shift);
  WriteLn('Зашифрованный текст: ', EncryptedText);

  DecryptedText := Decrypt(EncryptedText, Shift);
  WriteLn('Расшифрованный текст: ', DecryptedText);
  WriteLn;

  if OriginalText = DecryptedText then
    WriteLn('✓ УСПЕХ: текст восстановлен правильно!')
  else
    WriteLn('✗ ОШИБКА: текст не совпадает!');

  // Показываем алфавит для наглядности
  WriteLn;
  WriteLn('Русский алфавит: ', RussianUp);
  WriteLn('Английский алфавит: ', EnglishUp);
  WriteLn;
end;

procedure Main;
var
  Choice: Integer;
  InputFileName, OutputFileName: string;
  Shift: Integer;
begin
  SetConsoleOutputCP(1251);
  SetConsoleCP(1251);

  repeat
    WriteLn;
    WriteLn('========================================');
    WriteLn('    ПРОГРАММА ШИФРОВАНИЯ ЦЕЗАРЯ');
    WriteLn('========================================');
    WriteLn('1. Зашифровать файл');
    WriteLn('2. Расшифровать файл');
    WriteLn('3. Демонстрация работы');
    WriteLn('4. Выход');
    WriteLn('========================================');
    Write('Выберите действие (1-4): ');
    ReadLn(Choice);

    case Choice of
      1:
        begin
          WriteLn;
          WriteLn('--- ШИФРОВАНИЕ ФАЙЛА ---');
          Write('Введите имя исходного файла: ');
          ReadLn(InputFileName);

          if not FileExists(InputFileName) then
          begin
            WriteLn('Ошибка: файл не найден!');
            WriteLn('Нажмите Enter...');
            ReadLn;
            Continue;
          end;

          Write('Введите имя выходного файла: ');
          ReadLn(OutputFileName);

          Write('Введите сдвиг (1-32): ');
          ReadLn(Shift);

          EncryptFile(InputFileName, OutputFileName, Shift);

          WriteLn('Нажмите Enter...');
          ReadLn;
        end;

      2:
        begin
          WriteLn;
          WriteLn('--- ДЕШИФРОВАНИЕ ФАЙЛА ---');
          Write('Введите имя зашифрованного файла: ');
          ReadLn(InputFileName);

          if not FileExists(InputFileName) then
          begin
            WriteLn('Ошибка: файл не найден!');
            WriteLn('Нажмите Enter...');
            ReadLn;
            Continue;
          end;

          Write('Введите имя выходного файла: ');
          ReadLn(OutputFileName);

          Write('Введите сдвиг (1-32): ');
          ReadLn(Shift);

          DecryptFile(InputFileName, OutputFileName, Shift);

          WriteLn('Нажмите Enter...');
          ReadLn;
        end;

      3:
        begin
          DemoExample;
          WriteLn('Нажмите Enter...');
          ReadLn;
        end;
    end;

  until Choice = 4;

  WriteLn('Программа завершена. До свидания!');
end;

begin
  try
    Main;
  except
    on E: Exception do
      WriteLn('Ошибка: ', E.Message);
  end;
end.
