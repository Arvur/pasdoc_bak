{
  @cvs($Date: 2011-08-08 09:32:30 +0200 (pon) $)
  @author(Johannes Berg <johannes@sipsolutions.de>)
  @author(Michalis Kamburelis)
  @abstract(string vector --- based on TStringList)
  The string vector is based on TStringList and simply exports
  a few extra functions - I did this so I didn't have to change
  so much old code, this has only little additional
  functionality
}
unit PasDoc_StringVector;

{$I pasdoc_defines.inc}

interface

uses
  Classes;

type
  TIterateFunc = function(const AString: string): string;
  TStringVector = class(TStringList)
  public
    { This is the same thing as Items[0] }
    function FirstName: string;

    procedure LoadFromTextFileAdd(const AFilename: string); overload;
    procedure LoadFromTextFileAdd(var ATextFile: TextFile); overload;
    procedure RemoveAllNamesCI(const AName: string);
    function ExistsNameCI(const AName: string): boolean;
    function IsEmpty: boolean;
    procedure Iterate(const AItFunc: TIterateFunc);
    function AddNotExisting(const AString: string): Integer;

    { Load from a stream using the binary format.
      
      The binary format is
      @unorderedList(
        @item Count
        @item(followed by each string, loaded using
          @link(TSerializable.LoadStringFromStream).)
      )

      Note that you should never use our Text value to load/save this object 
      from/into a stream, like
      @code(Text := TSerializable.LoadStringFromStream(Stream)).
      Using and assigning to the Text value breaks when some strings have
      newlines inside that should be preserved. }
    procedure LoadFromBinaryStream(Stream: TStream);

    { Save to a stream, in a format readable by
      @link(LoadFromBinaryStream). }
    procedure SaveToBinaryStream(Stream: TStream);
  end;

function NewStringVector: TStringVector;
function IsEmpty(const AOV: TStringVector): boolean; overload;

implementation
uses
  SysUtils, PasDoc_Serialize;

function IsEmpty(const AOV: TStringVector): boolean;
begin
  Result := (not Assigned(AOV)) or (AOV.Count = 0);
end;

function NewStringVector: TStringVector;
begin
  Result := TStringVector.Create;
  Result.Duplicates := dupIgnore;
end;

{ TStringVector }

function TStringVector.AddNotExisting(const AString: string): integer;
begin
  Result := IndexOf(AString);
  if Result < 0 then begin
    Result := Add(AString);
  end;
end;

function TStringVector.ExistsNameCI(const AName: string): boolean;
var
  i: Integer;
  LName: string;
begin
  LName := LowerCase(AName);
  Result := false;
  for i := Count - 1 downto 0 do begin
    if LowerCase(Get(i)) = LName then begin
      Result := True;
      break;
    end;
  end;
end;

function TStringVector.FirstName: string;
begin
  if Count > 0 then
  begin
    Result := Get(0);
  end else
  begin
    Result := '';
  end
end;

function TStringVector.IsEmpty: boolean;
begin
  Result := Count = 0;
end;

procedure TStringVector.Iterate(const AItFunc: TIterateFunc);
var
  i: Integer;
begin
  for i := 0 to count - 1 do begin
    Strings[i] := AItFunc(Strings[i]);
  end;
end;

procedure TStringVector.LoadFromTextFileAdd(
  const AFilename: string);
var
  LCurrent: string;
begin
  LCurrent := Text;
  LoadFromFile(AFilename);
  Add(LCurrent);
end;

procedure TStringVector.LoadFromTextFileAdd(var ATextFile: TextFile);
var S: string;
begin
  while not Eof(ATextFile) do
  begin
    Readln(ATextFile, S);
    S := Trim(S);
    if S <> '' then Append(S);
  end;
end;

procedure TStringVector.RemoveAllNamesCI(const AName: string);
var
  i: Integer;
  LName: string;
begin
  LName := LowerCase(AName);
  for i := Count - 1 downto 0 do begin
    if LowerCase(Get(i)) = LName then begin
      Delete(i);
    end;
  end;
end;

procedure TStringVector.LoadFromBinaryStream(Stream: TStream);
var
  i, n: Integer;
begin
  Clear;
  n := TSerializable.LoadIntegerFromStream(Stream);
  Capacity := n;
  for i := 0 to n - 1 do
    Append(TSerializable.LoadStringFromStream(Stream));
end;

procedure TStringVector.SaveToBinaryStream(Stream: TStream);
var i: Integer;
begin
  TSerializable.SaveIntegerToStream(Count, Stream);
  for i := 0 to Count - 1 do
    TSerializable.SaveStringToStream(Strings[i], Stream);
end;

end.
