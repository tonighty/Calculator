unit Poland;

{$mode objfpc}{$H+}

interface

uses
  SysUtils, FileUtil, Math;

type


  TData = char;
  PStack = ^TStack;

  TStack = record
    Data: TData;
    Next: PStack;
  end;

  EData = extended;
  PEStack = ^EStack;

  EStack = record
    Data: EData;
    Next: PEStack;
  end;

  { TPolandReverseRecord }

  TPolandReverseRecord = class
  private
    Stack: PStack;
    _EStack: PEStack;
    procedure push(var newdata: TData);
    procedure _EPush(var newdata: EData);
    function pop(): TData;
    function _EPop(): EData;
    function peek(): TData;
    function _EPeek(): EData;
    function GetPriority(c: char): byte;
    function ToPolandString(s: string): string;
    function PolandCalc(s: string): extended;
  public
    DivisionByZero: boolean;
    PolandString: string;
    constructor Create(s: string);
    function Calc(): extended;
    function fac(n: extended): extended;
  end;

implementation

procedure TPolandReverseRecord.push(var newdata: TData);
var
  tmp: PStack;
begin
  new(tmp);
  tmp^.Data := newdata;
  tmp^.Next := stack;
  stack := tmp;
end;

procedure TPolandReverseRecord._EPush(var newdata: EData);
var
  tmp: PEStack;
begin
  new(tmp);
  tmp^.Data := newdata;
  tmp^.Next := _EStack;
  _EStack := tmp;
end;

function TPolandReverseRecord.pop(): TData;
var
  tmp: PStack;
begin
  if stack <> nil then
  begin
    tmp := stack;
    Result := stack^.Data;
    stack := stack^.Next;
    dispose(tmp);
  end;
end;

function TPolandReverseRecord._EPop(): EData;
var
  tmp: PEStack;
begin
  if _EStack <> nil then
  begin
    tmp := _EStack;
    Result := _EStack^.Data;
    _EStack := _EStack^.Next;
    dispose(tmp);
  end;
end;

function TPolandReverseRecord.peek(): TData;
begin
  if stack <> nil then
    Result := stack^.Data;
end;

function TPolandReverseRecord._EPeek(): EData;
begin
  if _EStack <> nil then
    Result := _EStack^.Data;
end;

function TPolandReverseRecord.fac(n: extended): extended;
begin
  if (n = 0) or (n = 1) then
    Result := 1
  else
    Result := n * fac(n - 1);
end;

constructor TPolandReverseRecord.Create(s: string);
begin
  PolandString := ToPolandString(s);
  Stack := nil;
  _EStack := nil;
  DivisionByZero := False;
end;

function TPolandReverseRecord.Calc(): extended;
begin
  Result := PolandCalc(PolandString);
end;

(* Получение приоритета *)
function TPolandReverseRecord.GetPriority(c: char): byte;
begin
  Result := 0;
  case c of
    '(': Result := 1;
    '+', '-': Result := 2;
    '*', '/': Result := 3;
    '^': Result := 4;
  end;
end;

function TPolandReverseRecord.ToPolandString(s: string): string;
var
  TempString: string;
  i: integer;
begin
  Result := '';
  tempstring := '';
  for i := 1 to length(s) do
  begin
    if (s[i] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ',', '.']) or
      ((s[i] = '-') and (i = 1)) or ((s[i] = '-') and (s[i - 1] = '(')) or
      ((s[i] = '-') and (s[i - 1] = '^')) then
    begin
      tempstring := tempstring + s[i];
    end
    else
    begin
      Result := Result + tempstring + ' ';
      tempstring := '';
      if s[i] in ['*', '/', '-', '+', '^'] then
      begin
        if not ((Stack = nil) or (getpriority(s[i]) > getpriority(peek))) then
          repeat
            Result := Result + pop() + ' ';
          until (stack = nil) or (getpriority(s[i]) > getpriority(peek()));
        if ((stack = nil) or (getpriority(s[i]) > getpriority(peek()))) then
          push(s[i]);
      end
      else if s[i] = '(' then
        push(s[i])
      else
      begin
        while peek() <> '(' do
          Result := Result + pop() + ' ';
        pop();
      end;
    end;
  end;
  if tempstring <> '' then
    Result := Result + tempstring + ' ';
  if stack <> nil then
  begin
    repeat
      Result := Result + pop() + ' ';
    until stack = nil;
  end;
  while Result[1] = ' ' do
    Delete(Result, 1, 1);
  while Result[length(Result)] = ' ' do
    Delete(Result, length(Result), 1);
end;

function TPolandReverseRecord.PolandCalc(s: string): extended;
var
  i: integer;
  tempstring: string;
  n1, n2: EData;
begin
  tempstring := '';
  for i := 1 to length(s) do
  begin
    if (s[i] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ',', '.']) or
      ((s[i] = '-') and (i = 1)) or ((s[i] = '-') and
      (s[i + 1] in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ',', '.'])) then
    begin
      tempstring := tempstring + s[i];
    end
    else
    begin
      if tempstring <> '' then
      begin
        n1 := strtofloat(tempstring);
        _EPush(n1);
      end;
      tempstring := '';
      case s[i] of
        '+':
        begin
          n1 := _EPop();
          n2 := _EPop();
          n1 := n2 + n1;
          _EPush(n1);
        end;
        '-':
        begin
          n1 := _EPop();
          n2 := _EPop();
          n1 := n2 - n1;
          _EPush(n1);
        end;
        '*':
        begin
          n1 := _EPop();
          n2 := _EPop();
          n1 := n1 * n2;
          _EPush(n1);
        end;
        '/':
        begin
          n1 := _EPop();
          n2 := _EPop();
          if n1 = 0 then
          begin
            DivisionByZero := True;
            exit;
          end;
          n1 := n2 / n1;
          _EPush(n1);
        end;
        '^':
        begin
          n1 := _EPop();
          n2 := _EPop();
          n1 := power(n2, n1);
          _EPush(n1);
        end;
      end;
    end;
  end;
  Result := _EPop();
end;


end.
