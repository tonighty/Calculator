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

procedure push(var stack: PStack; var newdata: TData);
procedure push(var stack: PESTack; var newdata: EData);
function pop(var stack: PStack): TData;
function pop(var stack: PEStack): EData;
function peek(var stack: PStack): TData;
function peek(var stack: PEStack): EData;
function GetPriority(c: char): byte;
function ToPolandString(s: string): string;
function PolandCalc(s: string): extended;
function fac(n: extended): extended;

var
  Stack: PStack = nil;
  _EStack: PEStack = nil;
  x: TData;
  y: EData;
  DivisionByZero: boolean = False;

implementation

procedure push(var stack: PStack; var newdata: TData);
var
  tmp: PStack;
begin
  new(tmp);
  tmp^.Data := newdata;
  tmp^.Next := stack;
  stack := tmp;
end;

procedure push(var stack: PESTack; var newdata: EData);
var
  tmp: PEStack;
begin
  new(tmp);
  tmp^.Data := newdata;
  tmp^.Next := stack;
  stack := tmp;
end;

function pop(var stack: PStack): TData;
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

function pop(var stack: PEStack): EData;
var
  tmp: PEStack;
begin
  if stack <> nil then
  begin
    tmp := stack;
    Result := stack^.Data;
    stack := stack^.Next;
    dispose(tmp);
  end;
end;

function peek(var stack: PStack): TData;
begin
  if stack <> nil then
    Result := stack^.Data;
end;

function peek(var stack: PEStack): EData;
begin
  if stack <> nil then
    Result := stack^.Data;
end;

function fac(n: extended): extended;
begin
  if (n = 0) or (n = 1) then
    Result := 1
  else
    Result := n * fac(n - 1);
end;

(* Получение приоритета *)
function GetPriority(c: char): byte;
begin
  Result := 0;
  case c of
    '(': Result := 1;
    '+', '-': Result := 2;
    '*', '/': Result := 3;
    '^': Result := 4;
  end;
end;

function ToPolandString(s: string): string;
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
        if not ((stack = nil) or (getpriority(s[i]) > getpriority(peek(stack)))) then
          repeat
            Result := Result + pop(stack) + ' ';
          until (stack = nil) or (getpriority(s[i]) > getpriority(peek(stack)));
        if ((stack = nil) or (getpriority(s[i]) > getpriority(peek(stack)))) then
          push(stack, s[i]);
      end
      else if s[i] = '(' then
        push(stack, s[i])
      else
      begin
        while peek(stack) <> '(' do
          Result := Result + pop(stack) + ' ';
        pop(stack);
      end;
    end;
  end;
  if tempstring <> '' then
    Result := Result + tempstring + ' ';
  if stack <> nil then
  begin
    repeat
      Result := Result + pop(stack) + ' ';
    until stack = nil;
  end;
  while Result[1] = ' ' do
    Delete(Result, 1, 1);
  while Result[length(Result)] = ' ' do
    Delete(Result, length(Result), 1);
end;

function PolandCalc(s: string): extended;
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
        push(_EStack, n1);
      end;
      tempstring := '';
      case s[i] of
        '+':
        begin
          n1 := pop(_Estack);
          n2 := pop(_estack);
          n1 := n2 + n1;
          push(_estack, n1);
        end;
        '-':
        begin
          n1 := pop(_Estack);
          n2 := pop(_Estack);
          n1 := n2 - n1;
          push(_estack, n1);
        end;
        '*':
        begin
          n1 := pop(_Estack);
          n2 := pop(_Estack);
          n1 := n1 * n2;
          push(_estack, n1);
        end;
        '/':
        begin
          n1 := pop(_Estack);
          n2 := pop(_estack);
          if n1 = 0 then
          begin
            DivisionByZero := True;
            exit;
          end;
          n1 := n2 / n1;
          push(_estack, n1);
        end;
        '^':
        begin
          n1 := pop(_estack);
          n2 := pop(_estack);
          n1 := power(n2, n1);
          push(_estack, n1);
        end;
      end;
    end;
  end;
  Result := pop(_estack);
end;


end.
