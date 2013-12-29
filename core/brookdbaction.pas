(*
  Brook DB Action unit.

  Copyright (C) 2013 Silvio Clecio.

  http://silvioprog.github.io/brookframework

  All contributors:
  Plase see the file CONTRIBUTORS.txt, included in this
  distribution.

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit BrookDBAction;

{$i brook.inc}

interface

uses
  BrookAction, BrookException, BrookDataBase, BrookTable, BrookUtils,
  BrookMessages, BrookConsts, DB, Classes, SysUtils;

type
  TBrookDBAction = class;

  { Handles exceptions for @link(TBrookDBAction). }
  EBrookDBAction = class(EBrook);

  { Is a metaclass for @link(TBrookDBAction) class. }
  TBrookDBActionClass = class of TBrookDBAction;

  { Is a type to @code(*TBrookDBAction) notify event. }
  TBrookDBActionNotifyEvent = procedure(AAction: TBrookDBAction) of object;

  { Custom class for manages HTTP requests and responses when data persistance
    is required. }
  TBrookCustomDBAction = class(TBrookAction)
  strict private class var
    _TableNames: TStrings;
    _IgnoredFields: TStrings;
  protected
    class procedure CheckTableName(const ATableName: string);
    class procedure IgnoreFields(ADataSet: TDataSet; const AFields: string);
    class function TableNames: TStrings;
    class procedure InitTableNames;
    class procedure DoneTableNames;
    class function IgnoredFields: TStrings;
    class procedure InitIgnoredFields;
    class procedure DoneIgnoredFields;
  public
    { Registers an action linking the request to a database table. }
    class procedure Register(const ATableName, APattern: string;
      const ADefault: Boolean = False); overload;
    { Registers an action linking the request to a database table. }
    class procedure Register(const ATableName, APattern: string;
      const AMethod: TBrookRequestMethod;
      const ADefault: Boolean = False); overload;
    { Registers an action linking the request to a database table and defining
      the fields that will be ignored for persistance purposes. }
    class procedure Register(const ATableName, APattern, AIgnoredFields: string;
      const ADefault: Boolean = False); overload;
    { Registers an action linking the request to a database table and defining
      the fields that will be ignored for persistance purposes. }
    class procedure Register(const ATableName, APattern, AIgnoredFields: string;
      const AMethod: TBrookRequestMethod; const ADefault: Boolean = False); overload;
    { Defines the table name. }
    class procedure SetTableName(const ATableName: string);
    { Returns the table name. }
    class function GetTableName: string;
    { Define the fields that will be ignored for persistance purposes. }
    class procedure SetIgnoredFields(const AFields: string);
    { Returns the fields were ignored for persistance purposes. }
    class function GetIgnoredFields: string;
  end;

  { Manages HTTP requests and responses when data persistance is required. }
  TBrookDBAction = class(TBrookCustomDBAction)
  private
    FAfterDelete: TBrookDBActionNotifyEvent;
    FAfterEdit: TBrookDBActionNotifyEvent;
    FAfterInsert: TBrookDBActionNotifyEvent;
    FBeforeDelete: TBrookDBActionNotifyEvent;
    FBeforeEdit: TBrookDBActionNotifyEvent;
    FBeforeInsert: TBrookDBActionNotifyEvent;
    FTable: TBrookTable;
    function GetDataBase: TBrookDataBase;
    function GetTable: TBrookTable;
    procedure SetDataBase(AValue: TBrookDataBase);
    procedure SetTable(AValue: TBrookTable);
  protected
    function CreateTable: TBrookTable; virtual;
    procedure FreeTable; virtual;
    procedure TableAfterOpen(DataSet: TDataSet); virtual;
    procedure TableAfterInsert({%H-}DataSet: TDataSet); virtual;
    procedure TableAfterEdit({%H-}DataSet: TDataSet); virtual;
    procedure TableAfterDelete({%H-}DataSet: TDataSet); virtual;
    procedure TableBeforeInsert(DataSet: TDataSet); virtual;
    procedure TableBeforeEdit(DataSet: TDataSet); virtual;
    procedure TableBeforeDelete(DataSet: TDataSet); virtual;
  public
    { Creates an instance of @code(TBrookDBAction). }
    constructor Create; override;
    { Frees an instance of @link(TBrookDBAction) class. }
    destructor Destroy; override;
    { Defines the current database or return it. }
    property DataBase: TBrookDataBase read GetDataBase write SetDataBase;
    { Get de table linked to the action. }
    property Table: TBrookTable read GetTable write SetTable;
    { Is triggered after insert a record. }
    property AfterInsert: TBrookDBActionNotifyEvent read FAfterInsert
      write FAfterInsert;
    { Is triggered before insert a record. }
    property BeforeInsert: TBrookDBActionNotifyEvent read FBeforeInsert
      write FBeforeInsert;
    { Is triggered after edit a record. }
    property AfterEdit: TBrookDBActionNotifyEvent read FAfterEdit
      write FAfterEdit;
    { Is triggered before edit a record. }
    property BeforeEdit: TBrookDBActionNotifyEvent read FBeforeEdit
      write FBeforeEdit;
    { Is triggered after delete a record. }
    property AfterDelete: TBrookDBActionNotifyEvent read FAfterDelete
      write FAfterDelete;
    { Is triggered before delete a record. }
    property BeforeDelete: TBrookDBActionNotifyEvent read FBeforeDelete
      write FBeforeDelete;
  end;

implementation

{ TBrookCustomDBAction }

class procedure TBrookCustomDBAction.CheckTableName(const ATableName: string);
begin
  if ATableName = ES then
    raise EBrookDBAction.Create(Self, SBrookEmptyTableNameError);
end;

class procedure TBrookCustomDBAction.IgnoreFields(ADataSet: TDataSet;
  const AFields: string);
var
  I: Integer;
  VField: TField;
  VIgnoredFields: TStringList;
begin
  if (not Assigned(_IgnoredFields)) or (_IgnoredFields.Count = 0) or
    (AFields = ES) then
    Exit;
  VIgnoredFields := TStringList.Create;
  try
    VIgnoredFields.CommaText := AFields;
    for I := 0 to Pred(VIgnoredFields.Count) do
    begin
      VField := ADataSet.Fields.FindField(VIgnoredFields[I]);
      if Assigned(VField) then
        VField.Visible := False;
    end;
  finally
    VIgnoredFields.Free;
  end;
end;

class function TBrookCustomDBAction.TableNames: TStrings;
begin
  if not Assigned(_TableNames) then
    TBrookCustomDBAction.InitTableNames;
  Result := TBrookCustomDBAction._TableNames;
end;

class procedure TBrookCustomDBAction.InitTableNames;
begin
  _TableNames := TStringList.Create;
end;

class procedure TBrookCustomDBAction.DoneTableNames;
begin
  FreeAndNil(TBrookCustomDBAction._TableNames);
end;

class function TBrookCustomDBAction.IgnoredFields: TStrings;
begin
  if not Assigned(_IgnoredFields) then
    TBrookCustomDBAction.InitIgnoredFields;
  Result := TBrookCustomDBAction._IgnoredFields;
end;

class procedure TBrookCustomDBAction.InitIgnoredFields;
begin
  _IgnoredFields := TStringList.Create;
end;

class procedure TBrookCustomDBAction.DoneIgnoredFields;
begin
  FreeAndNil(TBrookCustomDBAction._IgnoredFields);
end;

class procedure TBrookCustomDBAction.SetTableName(const ATableName: string);
begin
  CheckTableName(ATableName);
  TBrookCustomDBAction.TableNames.Values[ClassName] := ATableName;
end;

class function TBrookCustomDBAction.GetTableName: string;
begin
  Result := TBrookCustomDBAction.TableNames.Values[ClassName];
  CheckTableName(Result);
end;

class procedure TBrookCustomDBAction.SetIgnoredFields(const AFields: string);
begin
  TBrookCustomDBAction.IgnoredFields.Values[ClassName] := AFields;
end;

class function TBrookCustomDBAction.GetIgnoredFields: string;
begin
  Result := TBrookCustomDBAction.IgnoredFields.Values[ClassName];
end;

class procedure TBrookCustomDBAction.Register(const ATableName,
  APattern: string; const ADefault: Boolean);
begin
  Register(ATableName, APattern, rmAll, ADefault);
end;

class procedure TBrookCustomDBAction.Register(const ATableName,
  APattern: string; const AMethod: TBrookRequestMethod;
  const ADefault: Boolean);
begin
  inherited Register(APattern, AMethod, ADefault);
  Self.SetTableName(ATableName);
end;

class procedure TBrookCustomDBAction.Register(const ATableName, APattern,
  AIgnoredFields: string; const ADefault: Boolean);
begin
  Register(ATableName, APattern, AIgnoredFields, rmAll, ADefault);
end;

class procedure TBrookCustomDBAction.Register(const ATableName, APattern,
  AIgnoredFields: string; const AMethod: TBrookRequestMethod;
  const ADefault: Boolean);
begin
  Register(ATableName, APattern, AMethod, ADefault);
  Self.SetIgnoredFields(AIgnoredFields);
end;

{ TBrookDBAction }

constructor TBrookDBAction.Create;
begin
  inherited Create;
  FTable := CreateTable;
  FTable.DataSet.AfterOpen := @TableAfterOpen;
  FTable.DataSet.AfterInsert := @TableAfterInsert;
  FTable.DataSet.AfterEdit := @TableAfterEdit;
  FTable.DataSet.AfterDelete := @TableAfterDelete;
  FTable.DataSet.BeforeInsert := @TableBeforeInsert;
  FTable.DataSet.BeforeEdit := @TableBeforeEdit;
  FTable.DataSet.BeforeDelete := @TableBeforeDelete;
end;

destructor TBrookDBAction.Destroy;
begin
  FreeTable;
  inherited Destroy;
end;

function TBrookDBAction.CreateTable: TBrookTable;
begin
  Result := TBrookTable.Create;
end;

procedure TBrookDBAction.FreeTable;
begin
  FreeAndNil(FTable);
end;

procedure TBrookDBAction.TableAfterOpen(DataSet: TDataSet);
begin
  TBrookCustomDBAction.IgnoreFields(DataSet, GetIgnoredFields);
end;

procedure TBrookDBAction.TableAfterInsert(DataSet: TDataSet);
begin
  if Assigned(FAfterInsert) then
    FAfterInsert(Self);
end;

procedure TBrookDBAction.TableAfterEdit(DataSet: TDataSet);
begin
  if Assigned(FAfterEdit) then
    FAfterEdit(Self);
end;

procedure TBrookDBAction.TableAfterDelete(DataSet: TDataSet);
begin
  if Assigned(FAfterDelete) then
    FAfterDelete(Self);
end;

procedure TBrookDBAction.TableBeforeInsert(DataSet: TDataSet);
begin
  TBrookCustomDBAction.IgnoreFields(DataSet, GetIgnoredFields);
  if Assigned(FBeforeInsert) then
    FBeforeInsert(Self);
end;

procedure TBrookDBAction.TableBeforeEdit(DataSet: TDataSet);
begin
  TBrookCustomDBAction.IgnoreFields(DataSet, GetIgnoredFields);
  if Assigned(FBeforeEdit) then
    FBeforeEdit(Self);
end;

procedure TBrookDBAction.TableBeforeDelete(DataSet: TDataSet);
begin
  TBrookCustomDBAction.IgnoreFields(DataSet, GetIgnoredFields);
  if Assigned(FBeforeDelete) then
    FBeforeDelete(Self);
end;

function TBrookDBAction.GetDataBase: TBrookDataBase;
begin
  Result := FTable.DataBase;
end;

function TBrookDBAction.GetTable: TBrookTable;
begin
  Result := FTable;
  FTable.Name := GetTableName;
end;

procedure TBrookDBAction.SetDataBase(AValue: TBrookDataBase);
begin
  FTable.DataBase := AValue;
end;

procedure TBrookDBAction.SetTable(AValue: TBrookTable);
begin
  FreeAndNil(FTable);
  FTable := AValue;
end;

finalization
  TBrookCustomDBAction.DoneTableNames;
  TBrookCustomDBAction.DoneIgnoredFields;

end.
