unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, LCLType, ExtCtrls, Menus, Math, Poland, LazUtils, LCLProc, IniFiles;

type

  { TMainForm }

  TMainForm = class(TForm)
    DivisionButton: TSpeedButton;
    CButton: TSpeedButton;
    BackspaceButton: TSpeedButton;
    DisplayLabel: TLabel;
    BufferDisplayLabel: TLabel;
    JustLine1: TLabel;
    JustLine2: TLabel;
    MainMenu: TMainMenu;
    Help: TMenuItem;
    Calc: TMenuItem;
    Language: TMenuItem;
    English: TMenuItem;
    Japanese: TMenuItem;
    German: TMenuItem;
    Russian: TMenuItem;
    Mode: TMenuItem;
    MRButton: TSpeedButton;
    MMinusButton: TSpeedButton;
    MPlusButton: TSpeedButton;
    MSButton: TSpeedButton;
    About: TMenuItem;
    My_Creator: TMenuItem;
    MiniDisplayLabel: TLabel;
    NineButton: TSpeedButton;
    FactorialButton: TSpeedButton;
    MultiplyButton: TSpeedButton;
    ConstPiButton: TSpeedButton;
    NaturalLogButton: TSpeedButton;
    CEButton: TSpeedButton;
    SevenButton: TSpeedButton;
    EightButton: TSpeedButton;
    CosButton: TSpeedButton;
    MCButton: TSpeedButton;
    TanButton: TSpeedButton;
    LogButton: TSpeedButton;
    ExpButton: TSpeedButton;
    InversButton: TSpeedButton;
    SixButton: TSpeedButton;
    MinusButton: TSpeedButton;
    FourButton: TSpeedButton;
    FiveButton: TSpeedButton;
    OneButton: TSpeedButton;
    SinButton: TSpeedButton;
    TenInExtentXButton: TSpeedButton;
    XInExtentYButton: TSpeedButton;
    SqrtButton: TSpeedButton;
    SqrButton: TSpeedButton;
    TwoButton: TSpeedButton;
    ThreeButton: TSpeedButton;
    PlusButton: TSpeedButton;
    OpenBracketButton: TSpeedButton;
    CloseBracketButton: TSpeedButton;
    NegativeButton: TSpeedButton;
    ZeroButton: TSpeedButton;
    DotButton: TSpeedButton;
    ResultButton: TSpeedButton;
    procedure BackspaceButtonClick(Sender: TObject);
    procedure CButtonClick(Sender: TObject);
    procedure CEButtonClick(Sender: TObject);
    procedure CloseBracketButtonClick(Sender: TObject);
    procedure EnglishClick(Sender: TObject);
    procedure GermanClick(Sender: TObject);
    procedure JapaneseClick(Sender: TObject);
    procedure OpenBracketButtonClick(Sender: TObject);
    procedure ResultButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure Input(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure ClearDisplay(mini: boolean = True);
    procedure My_CreatorClick(Sender: TObject);
    procedure MSButtonClick(Sender: TObject);
    procedure NegativeButtonClick(Sender: TObject);
    function IsInt(): boolean;
    procedure Error(err_msg: string);
    procedure ConstPiButtonClick(Sender: TObject);
    procedure Operators(Sender: TObject);
    procedure RenderFont();
    procedure Addchar(ch: char; checkzero: boolean = True);
    procedure FunctionsOnClick(Sender: TObject);
    procedure CleanMiniDisplayIfNeed();
    procedure RussianClick(Sender: TObject);
    procedure LocalizateMenu;
  private
    NeedToClean, boolError, NeedToCleanMiniDisplay: boolean;
    Buffer: extended;
    OpenBracketCount, CloseBracketCount: integer;
    PolandString: string;
    LanguageIniFile: TIniFile;
    ReversPoland: TPolandReverseRecord;
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{Посимвольное добавление в главный дисплей}
procedure TMainForm.Addchar(ch: char; checkzero: boolean = True);
begin
  if (boolError) or (DisplayLabel.Caption = '0') and (checkzero = True) or
    ((NeedToClean = True) and (checkzero = True)) then
  begin
    DisplayLabel.Caption := '';
    boolError := False;
  end;
  DisplayLabel.Caption := DisplayLabel.Caption + ch;
end;

{Здесь реализованы все унарные функции}
procedure TMainForm.FunctionsOnClick(Sender: TObject);
begin
  CleanMiniDisplayIfNeed;
  if not boolError then
  begin
    try
      case TButton(Sender).Hint of
        { TODO: надо будет вложенные функции нормально сделать }
        'sqr':
        begin
          MiniDisplayLabel.Caption :=
            MiniDisplayLabel.Caption + 'sqr(' + DisplayLabel.Caption + ')';
          DisplayLabel.Caption := floattostr(sqr(strtofloat(DisplayLabel.Caption)));
          PolandString += DisplayLabel.Caption;
        end;
        'sqrt':
        begin
          MiniDisplayLabel.Caption :=
            MiniDisplayLabel.Caption + 'sqrt(' + DisplayLabel.Caption + ')';
          DisplayLabel.Caption := floattostr(sqrt(strtofloat(DisplayLabel.Caption)));
          PolandString += DisplayLabel.Caption;
        end;
        '10ˣ':
        begin
          MiniDisplayLabel.Caption :=
            MiniDisplayLabel.Caption + '10^(' + DisplayLabel.Caption + ')';
          DisplayLabel.Caption :=
            floattostr(power(10, strtofloat(DisplayLabel.Caption)));
          PolandString += DisplayLabel.Caption;
        end;
        'log':
        begin
          MiniDisplayLabel.Caption :=
            MiniDisplayLabel.Caption + 'log(' + DisplayLabel.Caption + ')';
          DisplayLabel.Caption :=
            floattostr(ln(strtofloat(DisplayLabel.Caption)) / ln(10));
          PolandString += DisplayLabel.Caption;
        end;
        'Exp':
        begin
          MiniDisplayLabel.Caption :=
            MiniDisplayLabel.Caption + 'Epx(' + DisplayLabel.Caption + ')';
          DisplayLabel.Caption := floattostr(exp(strtofloat(DisplayLabel.Caption)));
          PolandString += DisplayLabel.Caption;
        end;
        'sin':
        begin
          MiniDisplayLabel.Caption :=
            MiniDisplayLabel.Caption + 'sin(' + DisplayLabel.Caption + ')';
          DisplayLabel.Caption := floattostr(sin(strtofloat(DisplayLabel.Caption)));
          PolandString += DisplayLabel.Caption;
        end;
        'cos':
        begin
          MiniDisplayLabel.Caption :=
            MiniDisplayLabel.Caption + 'cos(' + DisplayLabel.Caption + ')';
          DisplayLabel.Caption := floattostr(cos(strtofloat(DisplayLabel.Caption)));
          PolandString += DisplayLabel.Caption;
        end;
        'tan':
        begin
          MiniDisplayLabel.Caption :=
            MiniDisplayLabel.Caption + 'tan(' + DisplayLabel.Caption + ')';
          DisplayLabel.Caption := floattostr(tan(strtofloat(DisplayLabel.Caption)));
          PolandString += DisplayLabel.Caption;
        end;
        'n!':
        begin
          if isInt() then
          begin
            MiniDisplayLabel.Caption :=
              MiniDisplayLabel.Caption + DisplayLabel.Caption + '!';
            DisplayLabel.Caption :=
              floattostr(ReversPoland.fac(strtofloat(DisplayLabel.Caption)));
            PolandString += DisplayLabel.Caption;
          end
          else
          begin
            Error('Only Integer');
            exit;
          end;
        end;
        'ln':
        begin
          MiniDisplayLabel.Caption :=
            MiniDisplayLabel.Caption + 'ln(' + DisplayLabel.Caption + ')';
          DisplayLabel.Caption := floattostr(ln(strtofloat(DisplayLabel.Caption)));
          PolandString += DisplayLabel.Caption;
        end;
        'InversX':
        begin
          MiniDisplayLabel.Caption :=
            MiniDisplayLabel.Caption + 'invers(' + DisplayLabel.Caption + ')';
          DisplayLabel.Caption := floattostr(1 / (strtofloat(DisplayLabel.Caption)));
          PolandString += DisplayLabel.Caption;
        end;
      end;
    except
      on Exception do
        Error('Invalid Input');
    end;
    NeedToClean := True;
    RenderFont;
  end;
end;

{Очищает минидисплей когда надо}
procedure TMainForm.CleanMiniDisplayIfNeed;
begin
  if NeedToCleanMiniDisplay then
  begin
    MiniDisplayLabel.Caption := '';
    NeedToCleanMiniDisplay := False;
  end;
end;

procedure TMainForm.RussianClick(Sender: TObject);
begin
  LanguageIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) +
    '\Russian.ini');
  LocalizateMenu;
end;

procedure TMainForm.LocalizateMenu;
begin
  Mode.Caption := LanguageIniFile.ReadString('Menu', 'Mode', 'Mode');
  Calc.Caption := LanguageIniFile.ReadString('Menu', 'Calculator', 'Calculator');
  About.Caption := LanguageIniFile.ReadString('Menu', 'About', 'About');
  My_Creator.Caption := LanguageIniFile.ReadString('Menu', 'Creator', 'Creator');
  Help.Caption := LanguageIniFile.ReadString('Menu', 'Help', 'Help');
  Language.Caption := LanguageIniFile.ReadString('Menu', 'Language', 'Language');
end;

{$R *.lfm}
{Очищение дисплея}
procedure TMainForm.ClearDisplay(mini: boolean = True);
begin
  DisplayLabel.Caption := '0';
  if mini = True then
    MiniDisplayLabel.Caption := '';
end;

{Великий Я}
procedure TMainForm.My_CreatorClick(Sender: TObject);
begin
  ShowMessage(LanguageIniFile.ReadString('Messages', 'Creator', 'Majorov The Great'));
end;

{Работа с буффером 5-го размера}
procedure TMainForm.MSButtonClick(Sender: TObject);
var
  button: TCaption;
begin
  button := TButton(Sender).Caption;
  try
    case button of
      'M-': buffer := buffer - strtofloatdef(DisplayLabel.Caption, 0);
      'M+': buffer := buffer + strtofloatdef(DisplayLabel.Caption, 0);
      'MS': buffer := strtofloatdef(DisplayLabel.Caption, 0);
      'MC': buffer := 0;
      'MR': DisplayLabel.Caption := floattostr(buffer);
    end;
  except
    on Exception do
      Error('Invalid Input');
  end;
  BufferDisplayLabel.Caption := 'Buffer: ' + floattostr(buffer);
end;


{Плюс-Минус}
procedure TMainForm.NegativeButtonClick(Sender: TObject);
begin
  if isInt then
    DisplayLabel.Caption := IntToStr(-1 * StrToInt64(DisplayLabel.Caption))
  else
    DisplayLabel.Caption := floattostr(-1 * strtofloat(DisplayLabel.Caption));
end;

{Проверка на целое число}
function TMainForm.IsInt: boolean;
begin
  if pos(',', DisplayLabel.Caption) = 0 then
    Result := True
  else
    Result := False;
end;

{Получатель ошибок}
procedure TMainForm.Error(err_msg: string);
begin
  ClearDisplay(True);
  DisplayLabel.Caption := LanguageIniFile.ReadString('Errors', err_msg, 'Error');
  NeedToClean := True;
  NeedToCleanMiniDisplay := True;
  boolError := True;
  DisplayLabel.Font.Size := 18;
end;

{Число Пи}
procedure TMainForm.ConstPiButtonClick(Sender: TObject);
begin
  ClearDisplay;
  DisplayLabel.Caption := floattostr(pi);
  RenderFont;
  NeedToClean := True;
end;

{Плюс Минус Умножение Деление Возведение в степень}
procedure TMainForm.Operators(Sender: TObject);
begin
  CleanMiniDisplayIfNeed;
  if not boolError then
  begin
    if TButton(Sender).Hint = '^' then //надо будет сократить эт
    begin
      if (MiniDisplayLabel.Caption = '') or
        ((MiniDisplayLabel.Caption[length(MiniDisplayLabel.Caption)] <> ')') and
        (MiniDisplayLabel.Caption[length(MiniDisplayLabel.Caption)] <> '!')) then
      begin
        MiniDisplayLabel.Caption :=
          MiniDisplayLabel.Caption + DisplayLabel.Caption + ' ' +
          TButton(Sender).Hint + ' ';
        PolandString := PolandString + DisplayLabel.Caption + TButton(Sender).Hint;
      end
      else
      begin
        MiniDisplayLabel.Caption :=
          MiniDisplayLabel.Caption + ' ' + TButton(Sender).Hint + ' ';
        PolandString := PolandString + TButton(Sender).Hint;
      end;
    end
    else
    if (MiniDisplayLabel.Caption = '') or
      ((MiniDisplayLabel.Caption[length(MiniDisplayLabel.Caption)] <> ')') and
      (MiniDisplayLabel.Caption[length(MiniDisplayLabel.Caption)] <> '!')) then
    begin
      MiniDisplayLabel.Caption :=
        MiniDisplayLabel.Caption + DisplayLabel.Caption + ' ' +
        TButton(Sender).Caption + ' ';
      PolandString := PolandString + DisplayLabel.Caption + TButton(Sender).Hint;
    end
    else
    begin
      MiniDisplayLabel.Caption :=
        MiniDisplayLabel.Caption + ' ' + TButton(Sender).Caption + ' ';
      PolandString := PolandString + TButton(Sender).Hint;
    end;
    NeedToClean := True;
  end;
end;

{Меняет размер шрифта}
procedure TMainForm.RenderFont;
begin
  if length(DisplayLabel.Caption) > 16 then
    DisplayLabel.Font.Size := 20
  else
  if length(DisplayLabel.Caption) >= 12 then
    DisplayLabel.Font.Size := 24
  else
  if length(DisplayLabel.Caption) < 12 then
    DisplayLabel.Font.Size := 36;
end;

{Считывание с клавиатуры}
procedure TMainForm.FormKeyPress(Sender: TObject; var Key: char);
begin
  case Key of
    '1': OneButton.Click;
    '2': TwoButton.Click;
    '3': ThreeButton.Click;
    '4': FourButton.Click;
    '5': FiveButton.Click;
    '6': SixButton.Click;
    '7': SevenButton.Click;
    '8': EightButton.Click;
    '9': NineButton.Click;
    '0': ZeroButton.Click;
    '.': DotButton.Click;
    ',': DotButton.Click;
    '+': PlusButton.Click;
    '-': MinusButton.Click;
    '/': DivisionButton.Click;
    '*': MultiplyButton.Click;
    '(': OpenBracketButton.Click;
    ')': CloseBracketButton.Click;
    '^': XInExtentYButton.Click;
    ':': XInExtentYButton.Click;
    's': SinButton.Click;
    'c': CosButton.Click;
    't': TanButton.Click;
    'l': LogButton.Click;
    'e': ExpButton.Click;
    'n': FactorialButton.Click;
    '=': ResultButton.Click;
    '!': FactorialButton.Click;
    chr(VK_RETURN): ResultButton.Click;
    chr(VK_BACK): BackspaceButton.Click;
    chr(VK_ESCAPE): CButton.Click;
  end;
end;

{Ввод в главный дисплей}
procedure TMainForm.Input(Sender: TObject);
var
  check: boolean = True;
begin
  CleanMiniDisplayIfNeed;
  if NeedToClean then
  begin
    DisplayLabel.Caption := '';
    NeedToClean := False;
  end;
  if (TButton(Sender).Caption)[1] = ',' then
    check := False;
  if (((TButton(Sender).Caption)[1] = ',') and (pos(',', DisplayLabel.Caption) <> 0)) or
    ((length(DisplayLabel.Caption) >= 18) and (NeedToClean = False)) then
    exit;
  Addchar((TButton(Sender).Caption)[1], check);
  RenderFont;
  NeedToClean := False;
end;

{Кнопка стиралка}
procedure TMainForm.BackspaceButtonClick(Sender: TObject);
var
  len: integer;
  s: TCaption;
begin
  s := DisplayLabel.Caption;
  len := length(DisplayLabel.Caption);
  if DisplayLabel.Caption <> '0' then
    Delete(s, len, 1);
  DisplayLabel.Caption := s;
  if (DisplayLabel.Caption = '') or boolError then
    ClearDisplay(False);
  RenderFont;
end;

{Полная чистка епт}
procedure TMainForm.CButtonClick(Sender: TObject);
begin
  ClearDisplay;
  RenderFont;
  buffer := 0;
  BufferDisplayLabel.Caption := 'Buffer: 0';
  PolandString := '';
  OpenBracketCount := 0;
  CloseBracketCount := 0;
end;

{Очищение главного дисплея}
procedure TMainForm.CEButtonClick(Sender: TObject);
begin
  ClearDisplay(False);
  RenderFont;
end;

{Закрывающая скобка}
procedure TMainForm.CloseBracketButtonClick(Sender: TObject);
begin
  if CloseBracketCount < OpenBracketCount then
  begin
    if (PolandString <> '') and (PolandString[length(PolandString)] <> ')') then
    begin
      MiniDisplayLabel.Caption := MIniDisplayLabel.Caption + DisplayLabel.Caption + ')';
      PolandString := PolandString + DisplayLabel.Caption + ')';
    end
    else
    begin
      MiniDisplayLabel.Caption := MIniDisplayLabel.Caption + ')';
      PolandString := PolandString + ')';
    end;
    Inc(CloseBracketCount);
    DisplayLabel.Caption := '0';
  end;
end;

procedure TMainForm.EnglishClick(Sender: TObject);
begin
  LanguageIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) +
    '\English.ini');
  LocalizateMenu;
end;

procedure TMainForm.GermanClick(Sender: TObject);
begin
  LanguageIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) +
    '\German.ini');
  LocalizateMenu;
end;

procedure TMainForm.JapaneseClick(Sender: TObject);
begin
  LanguageIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) +
    '\Japanese.ini');
  LocalizateMenu;
end;

{Открывающая скобка}
procedure TMainForm.OpenBracketButtonClick(Sender: TObject);
begin
  if (PolandString <> '') and (PolandString[length(PolandString)] = ')') then
  begin
    ResultButton.Click;
    MiniDisplayLabel.Caption := '';
    PolandString := '';
  end;
  MiniDisplayLabel.Caption := MiniDisplayLabel.Caption + '(';
  PolandString := PolandString + '(';
  Inc(OpenBracketCount);
end;

{Кнопка равно}
procedure TMainForm.ResultButtonClick(Sender: TObject);
begin
  if (pos('*', PolandString) = 0) and (pos('/', PolandString) = 0) and
    (pos('-', PolandString) = 0) and (pos('+', PolandString) = 0) and
    //ммм... быдлокод))00)0
    (pos('^', PolandString) = 0) then
    exit;
  if PolandString = '' then
    exit;
  if OpenBracketCount <> CloseBracketCount then
  begin
    if DisplayLabel.Caption <> '0' then
    begin
      MiniDisplayLabel.Caption := MiniDisplayLabel.Caption + DisplayLabel.Caption + ')';
      PolandString := PolandString + DisplayLabel.Caption + ')';
      Inc(CloseBracketCount);
    end;
    while OpenBracketCount <> CloseBracketCount do
    begin
      MiniDisplayLabel.Caption := MiniDisplayLabel.Caption + ')';
      PolandString := PolandString + ')';
      Inc(CloseBracketCount);
    end;
  end;
  if PolandString[length(PolandString)] in ['*', '/', '-', '+', '^'] then
  begin
    MiniDisplayLabel.Caption := MiniDisplayLabel.Caption + DisplayLabel.Caption;
    PolandString := PolandString + DisplayLabel.Caption;
  end;
  ReversPoland := TPolandReverseRecord.Create(PolandString);
  DisplayLabel.Caption := floattostr(ReversPoland.Calc());
  if ReversPoland.DivisionByZero then
  begin
    Error('Division by zero');
    ReversPoland.DivisionByZero := False;
  end;
  PolandString := '';
  RenderFont;
  NeedToClean := True;
  NeedToCleanMiniDisplay := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  NeedToClean := False;
  boolError := False;
  CButton.Click;
  LanguageIniFile := TIniFile.Create(ExtractFilePath(Application.ExeName) +
    '\English.ini');
end;

procedure TMainForm.HelpClick(Sender: TObject);
begin
  ShowMessage(LanguageIniFile.ReadString('Messages', 'Help',
    'If you dont know how to use calculator then close it'));
end;

end.
