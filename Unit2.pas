unit Unit2;

interface

  uses
    SysUtils, Math, Classes, Controls, Messages, Dialogs;

  type
    Tpostfix = class
    private
      postfix: string;
      num: array [1..100] of real;
      error: boolean;
      errormsg: string;
    public
      constructor mcreate(s:string);
      function eval(x,y,z:real): real;
  end;

implementation

constructor TPostfix.mcreate(s: string);
  var
    Data: array [1..100] of char;
    sp, i, cont: integer;
    ts: boolean;
    t: String;
    n: real;

  Procedure Makenull;
    Begin
      sp:= 0;
    End;

  Procedure Push(cin: char);
    Begin
      if sp=100 then
        showmessage('Overflow')
      else
        begin
          inc(sp);
          data[sp]:= cin;
        end;
    End;

  Function pop: char;
    Begin
      if sp=0 then
        showmessage('Underflow')
      else
        begin
          pop:= data[sp];
          dec(sp);
        end;
    End;

  Function empty: boolean;
    Begin
      if sp=0 then
        empty:= true
      else
        empty:= false;
    End;

  Function stop: char;
    Begin
      if sp=0 then
        showmessage('No elements')
      else
        stop:= data[sp];
    End;

  Function jer(x:char): integer;
    Begin
      jer := pos(x,'(+-*/^~') div 2;
    End;

  Procedure signo(c: char);
    Begin
      while (not empty) and (jer(c)<=jer(stop)) do
        postfix:= postfix + pop;
      push(c);
    End;

  Begin
    postfix:= ''; ts:= false; i:= 1;
    makenull;
    s:= uppercase(s);

    While i <= Length(s) do
      case (s[i]) of
{-------------------Si es un '(' entonces--------------------------------------}
                '(':Begin
                      push(s[i]);
                      inc(i);
                    End;
{-------------------Si es un cierre de parentesis------------------------------}
                ')':Begin
                      while (not empty) and (stop<>'(') do
                        postfix:= postfix+pop;
                      pop;
                      inc(i);
                    End;
{-------------------Va buscando las letras-------------------------------------}
           'X'..'Z':Begin
                      if ts then
                        signo('*');
                      postfix:= postfix+s[i];
                      ts:= true;
                      inc(i);
                    End;
{-------------------Va buscando los numeros------------------------------------}
           '0'..'9':Begin
                      t:= copy(s,i,length(s));
                      val(t,n,cont);
                      if cont<>0 then
                        Begin
                          t:= copy(t,1,cont-1);
                          i:= i+cont-1;
                        End
                      else
                        i:= length(s)+1;
                      postfix:= postfix+'#';
                      num[length(postfix)]:= n;
                      ts := true;
                    End;
{----------------------Jerarquia de operaciones--------------------------------}
'+','-','*','/','^','~':Begin
                          if ts then
                            signo(s[i])
                          else
                            if s[i]='-' then
                              signo('~')
                            else
                              showmessage('Error');
                          ts:= false;
                          inc(i);
                        End;
{--------------------Posicion vacia--------------------------------------------}
                    ' ':Inc(i);
{--------------------Final del case--------------------------------------------}
      else
        begin
        showmessage('Error en la expreción, posición '+IntToStr(i));
        error:= true;
        end
      end;

    if error then
      begin
        postfix:= '#';
        num[1]:= 0;
      end
    else
      while not empty do
        postfix:= postfix+pop;

  End;

function TPostfix.eval(x: Real; y: Real; z: Real):real;
var
data: array[1..100] of real;
sp, i: integer;
temp: real;

  procedure makenull;
    begin
      sp:= 0;
    end;

  Procedure push(x: real);
    begin
      if sp=100 then
        showmessage('Overflow')
      else
        begin
          inc(sp);
          data[sp]:= x;
        end;
    end;

  Function pop: real;
    begin
      if sp=0 then
        showmessage('No elements')
      else
        begin
          pop:= data[sp];
          dec(sp);
        end;
    end;

  Begin
    makenull;

    if error then
      showmessage('Error en la expreción')
    else
      for i := 1 to Length(postfix) do
          case postfix[i] of
            '#': push(num[i]);
            'X': push(x);
            'Y': push(y);
            'Z': push(z);
            '+': push(pop+pop);
            '~': push(-pop);
            '-': push(-pop+pop);
            '*': push(pop*pop);
            '/': Begin if pop=0 then showmessage('Div by cero') else temp:= pop; push(pop/temp); End;
            '^': Begin temp:= pop; push(power(pop, temp)); End;
        end;

    eval:= data[1];
  End;
end.
